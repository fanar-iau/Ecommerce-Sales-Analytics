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
    TotalSales - LAG(TotalSales) OVER (ORDER BY SalesMonth) AS Difference_From_Previous,

    -- حالة المبيعات (ربح أو خسارة)
    CASE 
        WHEN TotalSales - LAG(TotalSales) OVER (ORDER BY SalesMonth) > 0 THEN 'Profit'
        WHEN TotalSales - LAG(TotalSales) OVER (ORDER BY SalesMonth) < 0 THEN 'Loss'
        WHEN TotalSales - LAG(TotalSales) OVER (ORDER BY SalesMonth) = 0 THEN 'No Change'
        ELSE 'No Previous Month'
    END AS Sales_Status -- اسم العامود 

FROM MonthlySales; -- CTE NAME

WITH MonthlyProductSales AS (
    SELECT 
        DATE_FORMAT(o.OrderDate, '%Y-%m') AS SalesMonth,
        p.ProductName,
        SUM(o.Quantity * p.Price) AS TotalProductSales
    FROM Orders o
    JOIN Products p ON o.ProductID = p.ProductID
    GROUP BY DATE_FORMAT(o.OrderDate, '%Y-%m'), p.ProductName
)
SELECT 
    SalesMonth,
    ProductName,
    TotalProductSales,
    
    -- ترتيب المنتج داخل الشهر المحدد
    DENSE_RANK() OVER (
            PARTITION BY SalesMonth --  يفصل كل شهر عن الثاني كل شهر الحاله يعني ترتيب حسب الشهر ل شهر لوحده 
            ORDER BY TotalProductSales DESC -- اخل كل شهر، رتب المنتجات من أكثر منتج مبيعًا إلى أقل منتج م 
            ) AS Product_Rank_In_Month
FROM MonthlyProductSales;
-- =============================================
-- Customer Ranking & Segmentation Analysis
-- تحليل ترتيب العملاء وتقسيمهم إلى فئات بناءً على المبيعات
-- =============================================

-- 1. إنشاء جدول مؤقت (CTE) لحساب إجمالي مشتريات كل عميل
WITH CustomerSalesSummary AS (
    SELECT 
        c.CustomerID,                           -- رقم العميل الفريد
        SUM(o.Quantity * p.Price) AS TotalSpent -- حساب إجمالي المبلغ المنسوب للعميل (الكمية × السعر)
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID -- ربط جدول الطلبات بجدول العملاء
    JOIN Products p ON o.ProductID = p.ProductID    -- ربط جدول الطلبات بجدول المنتجات للحصول على السعر
    GROUP BY c.CustomerID                      -- تجميع البيانات حسب كل عميل على حدة
)

-- 2. الاستعلام الرئيسي لتطبيق ترتيب وتقسيم العملاء
SELECT 
    CustomerID,
    TotalSpent,
    
    -- ترتيب العملاء تنازلياً حسب إجمالي الإنفاق (الأعلى إنفاقاً يأخذ المركز 1)
    -- استخدام DENSE_RANK يضمن عدم قفز الأرقام في حال وجود تعادل
    DENSE_RANK() OVER (ORDER BY TotalSpent DESC) AS Customer_Rank,
    
    -- تقسيم العملاء إلى شرائح وفئات تسويقية بناءً على حجم إنفاقهم
    CASE 
        WHEN TotalSpent >= 7000 THEN 'VIP'       -- العملاء الأكثر إنفاقاً (فئة VIP)
        WHEN TotalSpent >= 2000 THEN 'Regular'   -- العملاء بإنفاق متوسط (فئة الاعتياديين)
        ELSE 'Basic'                             -- باقي العملاء بإنفاق محدود (الفئة الأساسية)
    END AS Customer_Segment

FROM CustomerSalesSummary -- الاستعلام من الجدول المؤقت الذي أنشأناه بالtop

-- ترتيب المخرجات في الجدول النهائي بداية من العميل صاحب المركز الأول
ORDER BY Customer_Rank;