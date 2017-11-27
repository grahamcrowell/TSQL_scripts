Sub SavePDFs()
    Dim oSitm As SlicerItem
    Dim oSlvl As SlicerCacheLevel
    Dim i As Integer
    
    ActiveWorkbook.SlicerCaches("Slicer_Paris_Team_Name").ClearManualFilter

   For Each oSlvl In ActiveWorkbook.SlicerCaches("Slicer_Paris_Team_Name").SlicerCacheLevels
        For i = 1 To oSlvl.SlicerItems.Count
            ActiveWorkbook.SlicerCaches("Slicer_Paris_Team_Name").VisibleSlicerItemsList = Array(oSlvl.SlicerItems(i).Name)
            ActiveSheet.ExportAsFixedFormat Type:=xlTypePDF, Filename:="G:\QUIST\Production\eCommunityNext\Mental Health & Addictions\HoNOS\Hono2Pager\ReportPDFs\" + Replace(oSlvl.SlicerItems(i).Value, "/", " ") + ".pdf", Quality:=xlQualityMedium, IncludeDocProperties:=False, From:=1, To:=2, IgnorePrintAreas:=False, OpenAfterPublish:=False
        Next i
    Next oSlvl
End Sub
