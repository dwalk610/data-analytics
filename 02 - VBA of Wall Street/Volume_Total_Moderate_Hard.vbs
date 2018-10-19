Sub VolumeTotalPOnlyModerateHard()

    ' ------------------------
    ' Loop through all sheets
    ' ------------------------
    For Each Sheet In Worksheets
    
        ' Define variable to hold Stock Volume, Opening Stock Price and Closing Stock Price
            Dim StockVolume As Double
            Dim StockOpen As Double
            Dim StockClose As Double
            
             ' Set initial Stock Volume to 0
             StockVolume = 0
        
            ' Define the opening price of the initial stock
            StockOpen = Sheet.Cells(2, 3)
        
        ' Set a variable that will keep track of the number of individual stocks on each sheet and set initial value to 0
          Dim StockNumber As Long
          StockNumber = 0
        
        ' Set up a summary table that will be used to store the stock names along with their total stock volumes
        
            ' Set up headers for the summary table which will read "Ticker", "Yearly Change", "Percent Change" and "Stock Volume"
            Sheet.Cells(1, 9) = "Ticker"
            Sheet.Cells(1, 10) = "Yearly Change"
            Sheet.Cells(1, 11) = "Percent Change"
            Sheet.Cells(1, 12) = "Total Stock Volume"
            
        ' Set the first row of the summary table to the 2nd row of the worksheet
            Dim StockNameRow As Integer
            StockNameRow = 2
        
        ' Define last row containing data
            Dim lastrow As Long
            lastrow = Sheet.Cells(Rows.Count, 1).End(xlUp).Row
            
        ' ------------------------------------------------------------
        ' Loop through rows to begin calculating Stock Volume for each stock
        ' ------------------------------------------------------------
            For Row = 2 To lastrow
            
            ' Check if stock in current row is NOT the same as stock in the next row
                If Sheet.Cells(Row, 1) <> Sheet.Cells(Row + 1, 1) Then
                
                ' Set the Stock Name in summary table to the Stock Name (ticker) of current row
                    Sheet.Cells(StockNameRow, 9) = Sheet.Cells(Row, 1)
                
                ' PRINT FINAL STOCK VOLUME FOR CURRENT STOCK
                
                    ' Add stock volume in current row to stock volume total
                        StockVolume = StockVolume + Sheet.Cells(Row, 7)
                    
                    'Print Stock Volume in summary table to current total
                        Sheet.Cells(StockNameRow, 12) = StockVolume
                        
                    ' Reset StockVolume to 0 to prepare for totaling volume of next stock
                    StockVolume = 0
                 
                ' Set StockName in next row of summary table to stock name of Next row in ticker column (column A)
                    Sheet.Cells(StockNameRow, 9) = Sheet.Cells(Row, 1)
                    
                ' Set closing stock price to closing stock price of current row
                    StockClose = Sheet.Cells(Row, 6)
                    
                ' Calculate and Print yearly change of current stock to summary table
                   Sheet.Cells(StockNameRow, 10) = (StockClose - StockOpen)
                   
                ' Calculate and Print yearly % change from opening price to closing price of current stock to summary table
                   ' Prior to calculating % change, first confirm if stock open price is greater than 0
                        ' This will avoid Div/0 errors
                   If StockOpen <> 0 Then
                        Sheet.Cells(StockNameRow, 11) = (StockClose - StockOpen) / StockOpen
                   
                   ' If opening stock price is 0, then automatically set yearly % change column in summary table to 0
                   Else
                        Sheet.Cells(StockNameRow, 11) = 0
                        
                   End If
                   
                  ' Change cell format of yearly % change column in summary table to % "0.00%"
                  Sheet.Cells(StockNameRow, 11).NumberFormat = "0.00%"
                   
                ' Move down to the next row of the summary table
                StockNameRow = StockNameRow + 1
                
                ' Reset opening stock price to opening price of stock in next row of column A (ticker column)
                StockOpen = Sheet.Cells(Row + 1, 3)
                    
            'If stock in current row IS the same as stock in the next row
            Else
            
                'Add stock volume in current row to stock volume total
                StockVolume = StockVolume + Sheet.Cells(Row, 7)
        
             End If
        
        Next Row
    
       '----------------------------------------------------------------------------------------------------------
       'Loop through yearly change column of summary table to format red and green for positive and negative overall yearly change
       '----------------------------------------------------------------------------------------------------------
           For Stock = 2 To StockNameRow
           
            ' If yearly change of stock is positive, then apply green color to yearly change cell in summary table
             If Sheet.Cells(Stock, 10) > 0 Then
             Sheet.Cells(Stock, 10).Interior.ColorIndex = 4
             
            ' If yearly change of stock is negative, then apply red color to yearly change cell in summary table
            Else
            Sheet.Cells(Stock, 10).Interior.ColorIndex = 3
                
            End If
         
          Next Stock
         
      '----------------------------------------------------------------------------------------------------------
      'Find stock with greatest percent increase, decrease and total volume
      '----------------------------------------------------------------------------------------------------------
       'Set up summary table with row names of "Greatest % Increase" "Greatest % Decrease" and "Greatest % Total Volume"to hold
       Sheet.Cells(2, 15) = "Greatest % Increase"
       Sheet.Cells(3, 15) = "Greatest % Decrease"
       Sheet.Cells(4, 15) = "Greatest % Total Volume"
       
       'Set up summary table column names to read "Ticker" and "Value"
       Sheet.Cells(1, 16) = "Ticker"
       Sheet.Cells(1, 17) = "Value"
       
       'Define variables to hold values and names of stocks with maximum and minimum percentage change and highest volume
       
       Dim MaxPerChange As Double
       Dim MaxPerStock As String
       
       Dim MinPerChange As Double
       Dim MinPerStock As String
       
       Dim MaxVol As Double
       Dim MaVolStock As String
         
       'Set Initial stock name of max and min percentage change and total volume to stock in 1st row of summary column
       MaxPerChange = Sheet.Cells(2, 11)
       MaxPerStock = Sheet.Cells(2, 9)
       
       MinPerChange = Sheet.Cells(2, 11)
       MinPerStock = Sheet.Cells(2, 9)
       
       MaxVol = Sheet.Cells(2, 12)
       MaxVolStock = Sheet.Cells(2, 9)
       
       '-------------------------------------------------------------------------------
       'GREATEST % INCREASE
       '-------------------------------------------------------------------------------
       'Loop through percent change column of summary row to find stock with greatest % increase
        For PerChange = 2 To StockNameRow
       
            If MaxPerChange <= Sheet.Cells(PerChange + 1, 11) Then
        
          'Change current maximum % change value to value of next stock
            MaxPerChange = Sheet.Cells(PerChange + 1, 11)
            MaxPerStock = Sheet.Cells(PerChange + 1, 9)
            
            Else
            
            End If
        
        Next PerChange
      
       '-------------------------------------------------------------------------------
       'GREATEST % DECREASE
       '-------------------------------------------------------------------------------
       'Loop through percent change column of summary row to find stock with greatest % decrease
        For PerChangeMin = 2 To StockNameRow
       
            If MinPerChange >= Sheet.Cells(PerChangeMin + 1, 11) Then
        
          'Change current minimum % change value to value of next stock
            MinPerChange = Sheet.Cells(PerChangeMin + 1, 11)
            MinPerStock = Sheet.Cells(PerChangeMin + 1, 9)
            
            Else
            
            End If
        
        Next PerChangeMin
      
      '-------------------------------------------------------------------------------
       'GREATEST TOTAL VOLUME
       '-------------------------------------------------------------------------------
       'Loop through total volume column of summary row to find stock with greatest total volume
        For TotVol = 2 To StockNameRow
       
            If MaxVol <= Sheet.Cells(TotVol + 1, 12) Then
        
          'Change name and current maximum volume to value of next stock in summary row
            MaxVol = Sheet.Cells(TotVol + 1, 12)
            MaxVolStock = Sheet.Cells(TotVol + 1, 9)
            
            Else
            
            End If
        
        Next TotVol
      
      'Print stock names and values of stock with greatest % increase and decrease and greatest volume in summary table
        Sheet.Cells(2, 17) = MaxPerChange
        Sheet.Cells(2, 16) = MaxPerStock
        
        Sheet.Cells(3, 17) = MinPerChange
        Sheet.Cells(3, 16) = MinPerStock
        
            'Change cell format of greatest increase and decrease cells  to % "0.00%"
                  Sheet.Cells(2, 17).NumberFormat = "0.00%"
                  Sheet.Cells(3, 17).NumberFormat = "0.00%"
                  
        Sheet.Cells(4, 17) = MaxVol
        Sheet.Cells(4, 16) = MaxVolStock
        
    Next Sheet
    
End Sub

