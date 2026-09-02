-- 6. تقرير المبيعات التفصيلي (الذي سيتم استخدامه في Power BI)
SELECT 
    o.OrderID AS 'Order_Ref',  --      Orders.OrderID  -- جيب OrderID من جدول Orders.
-- Orders.Quantity
-- Orders.CustomerID
    c.FirstName AS 'Customer_Name',
    p.ProductName AS 'Product',
    o.Quantity AS 'Qty',
    p.Price AS 'Unit_Price',
    (o.Quantity * p.Price) AS 'Total_Sales' -- 
FROM Orders o -- بدل ما اكتب اوردرز اكتب O بس 
JOIN Customers c ON o.CustomerID = c.CustomerID -- customer ID  to first name 
JOIN Products p ON o.ProductID = p.ProductID; -- productname and price 