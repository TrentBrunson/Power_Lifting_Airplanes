SELECT VendorName, COUNT(*) as InvoiceQty,
    AVG(InvoiceTotal) as InvoiceAvg
  FROM Vendors JOIN Invoices
    ON Vendors.VendorID = Invoices.VendorID
	WHERE InvoiceTotal > 500
  GROUP BY VendorName
  ORDER BY InvoiceQty DESC;

