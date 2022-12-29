CREATE OR ALTER PROCEDURE [sa_macsanom].[OrderItem_Merge]
@StagingTable nvarchar(50),
@StagingArea nvarchar(50),
@PipelineName nvarchar(50)
AS
DECLARE @squery nvarchar(max)
SET @squery = '
    MERGE [dbo].[OrderItem] AS Target
        USING (Select * FROM '+@StagingTable+' WHERE SideID<> NULL or SideID<>'''') AS Source
        ON Source.SourcePlatformID = Target.SourcePlatformID
        
        -- For Inserts
        WHEN NOT MATCHED BY Target THEN
            INSERT (
                    OrderID,
                    SideID,
                    SourceMetadataID,
                    ProductID,
                    SerialNumber,
                    --WarrantyID,
                    Price,
                    SourcePlatformID,
                    CreatedBy,
                    UpdatedBy,
                    CreatedAt,
                    UpdatedAt,
                    IsDeleted,
                    Quantity,
                    Tax,
                    Total,
                    Discount)
                    
                VALUES (
                    Source.OrderID,
                    Source.SideID,
                    Source.SourceMetadataID,
                    Source.ProductID,
                    Source.SerialNumber,
                    --Source.WarrantyID,
                    Source.Price,
                    Source.SourcePlatformID,
                    Source.CreatedBy,
                    Source.UpdatedBy,
                    CURRENT_TIMESTAMP,
                    CURRENT_TIMESTAMP,
                    Source.IsDeleted,
                    1,
                    Source.Tax,
                    Source.Total,
                    Source.Discount)
        
        -- For Updates
        WHEN MATCHED THEN UPDATE SET
            Target.Discount	  = Source.Discount,
            Target.Quantity	  = Source.Quantity,
            Target.UpdatedAt      = CURRENT_TIMESTAMP;
            
    MERGE [dbo].[OrderItem] AS Target
        USING (Select * FROM '+@StagingTable+' WHERE SideID is NULL or SideID='''') AS Source
        ON Source.SourcePlatformID = Target.SourcePlatformID
        
        -- For Inserts
        WHEN NOT MATCHED BY Target THEN
            INSERT (
                    OrderID,
                    SourceMetadataID,
                    ProductID,
                    SerialNumber,
                    --WarrantyID,
                    Price,
                    SourcePlatformID,
                    CreatedBy,
                    UpdatedBy,
                    CreatedAt,
                    UpdatedAt,
                    IsDeleted,
                    Quantity,
                    Tax,
                    Total,
                    Discount)
                    
                VALUES (
                    Source.OrderID,
                    Source.SourceMetadataID,
                    Source.ProductID,
                    Source.SerialNumber,
                    --Source.WarrantyID,
                    Source.Price,
                    Source.SourcePlatformID,
                    Source.CreatedBy,
                    Source.UpdatedBy,
                    CURRENT_TIMESTAMP,
                    CURRENT_TIMESTAMP,
                    Source.IsDeleted,
                    1,
                    Source.Tax,
                    Source.Total,
                    Source.Discount)
        
        -- For Updates
        WHEN MATCHED THEN UPDATE SET
            Target.Discount	  = Source.Discount,
            Target.Quantity	  = Source.Quantity,
            Target.UpdatedAt      = CURRENT_TIMESTAMP;
    '
Execute sp_executesql @squery;
