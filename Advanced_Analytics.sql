USE mystoreproject;

-- 1. تجهيز الـ CTE للتجميع  
WITH CustomerSalesSummary AS (    -- ملخص مبيعات العملاء   
    SELECT  -- وش البيانات اللي أبغاها داخل الـ CTE؟
        c.CustomerID,
        c.FirstName AS Customer_Name,
        c.City,
        COUNT(o.OrderID) AS Total_Orders, -- حساب عدد الطلبات 
        SUM(o.Quantity * p.Price) AS Total_Spent -- حساب التوتل 
    FROM customers c 
    JOIN orders o ON c.CustomerID = o.CustomerID -- نبرط  ال CUS مع ال orders عن طريق CustomerIDعشان نعرف الطلب هذا لاي عميل   ليه ؟ 
    JOIN products p ON o.ProductID = p.ProductID 
    GROUP BY c.CustomerID, c.FirstName, c.City --          ، خذ الصفوف اللي لها نفس العميل وحطها في مجموعة وحدة يعني كل مثلا السرات مع يعض   بدونه بيحسب مبيعات الجميع 
)

-- 2. استعلام النهائي واستخدام الـ Window Function للترتيب
SELECT 
    Customer_Name,
    City,
    Total_Orders,
    Total_Spent,
    
    -- تطبيق الـ Window Function   لترتيب العملاء حسب إجمالي مشترياتهم من الي دفع اكقر الى الاقل 
    DENSE_RANK() OVER (ORDER BY Total_Spent DESC) AS Customer_Rank,
   
   
    CASE  -- شرط 
        WHEN Total_Spent >= 1000 THEN 'VIP Customer'
        ELSE 'Regular Customer'
    END AS Customer_Segment  -- الاسم 

FROM CustomerSalesSummary  
ORDER BY Customer_Rank; -- ترتيب النتيجة النهائية حسب المركز

WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(o.OrderDate, '%Y-%m') AS SalesMonth, -- year and month only
        SUM(o.Quantity * p.Price) AS TotalSales
    FROM Orders o
    JOIN Products p ON o.ProductID = p.ProductID 
    GROUP BY DATE_FORMAT(o.OrderDate, '%Y-%m')
)
SELECT 
    SalesMonth,
    
    -- مبيعات الشهر السابق
    LAG(TotalSales) OVER (ORDER BY SalesMonth) AS Previous_Month_Sales,
    
    -- مبيعات الشهر الحالي
    TotalSales AS Current_Month_Sales,
    
    -- مبيعات الشهر القادم
    LEAD(TotalSales) OVER (ORDER BY SalesMonth) AS Next_Month_Sales,
    
    -- فارق المبيعات مع الشهر السابق
    TotalSales - LAG(TotalSales) OVER (ORDER BY SalesMonth) AS Difference_From_Previous 

FROM MonthlySales; -- CTE NAME