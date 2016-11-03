Option Compare Database

'This Module creates the changed item driver files so they can be verified against the delivery driver files
'It assumes that the database correctly links to current and previous release item, multipart item, passage, and Spanish reports
'And that the user has loaded current changed item, passage, and rubric reports

Sub CreateChangedDriverFiles()
DoCmd.SetWarnings False
'Make base set of changed items
DoCmd.OpenQuery "qryMakeChangedFullItems"
DoCmd.OpenQuery "qryMakeChangedTEI_Items"
DoCmd.OpenQuery "qryMakeChangedMultipartItems"

'Add changed multipart items based on changes to component items
DoCmd.OpenQuery "qryAddMultipartChangedComponentItems1"
DoCmd.OpenQuery "qryAddMultipartChangedComponentItems2"

'Add changes because of Rubrics
DoCmd.OpenQuery "qryChangedFullFromRubric"
DoCmd.OpenQuery "qryAddMultipartChangedFromRubricComponent1"
DoCmd.OpenQuery "qryAddMultipartChangedFromRubricComponent2"

'Add full items to trigger passage change
DoCmd.OpenQuery "qryPassagesOnChangedFullItemList"
DoCmd.OpenQuery "qryPassagesOnChangedFullItemListPassageCode2"
DoCmd.OpenQuery "qryAddPassagesOnChangedFullItemListPassageCode2"
DoCmd.OpenQuery "qryPassagesNotOnChangedFullItems"
DoCmd.OpenQuery "qryChangedFullItemsPassageAdditionsAllItemsPassageCode1"
DoCmd.OpenQuery "qryUniqueChangedFullItemsPassageAdditionsAllItemsPassageCode1"
DoCmd.OpenQuery "qryAddUniqueChangedFullItemsPassageAdditionsAllItemsPassageCode1"

'Repeat full queries in case need to grab PassageCode2 item
DoCmd.OpenQuery "qryPassagesOnChangedFullItemList"
DoCmd.OpenQuery "qryPassagesOnChangedFullItemListPassageCode2"
DoCmd.OpenQuery "qryAddPassagesOnChangedFullItemListPassageCode2"
DoCmd.OpenQuery "qryPassagesNotOnChangedFullItems"
DoCmd.OpenQuery "qryChangedFullItemsPassageAdditionsAllItemsPassageCode2"
DoCmd.OpenQuery "qryUniqueChangedFullItemsPassageAdditionsAllItemsPassageCode2"
DoCmd.OpenQuery "qryAddUniqueChangedFullItemsPassageAdditionsAllItemsPassageCode2"

'Add TEI items to trigger passage change
DoCmd.OpenQuery "qryPassagesOnChangedTEIItemList"
DoCmd.OpenQuery "qryPassagesOnChangedTEIItemListPassageCode2"
DoCmd.OpenQuery "qryAddPassagesOnChangedTEIItemListPassageCode2"
DoCmd.OpenQuery "qryPassagesNotOnChangedTEIItems"
DoCmd.OpenQuery "qryChangedTEIItemsPassageAdditionsAllItemsPassageCode1"
DoCmd.OpenQuery "qryUniqueChangedTEIItemsPassageAdditionsAllItemsPassageCode1"
DoCmd.OpenQuery "qryAddUniqueChangedTEIItemsPassageAdditionsAllItemsPassageCode1"

'Repeat TEI queries in case need to grab PassageCode2 item
DoCmd.OpenQuery "qryPassagesOnChangedTEIItemList"
DoCmd.OpenQuery "qryPassagesOnChangedTEIItemListPassageCode2"
DoCmd.OpenQuery "qryAddPassagesOnChangedTEIItemListPassageCode2"
DoCmd.OpenQuery "qryPassagesNotOnChangedTEIItems"
DoCmd.OpenQuery "qryChangedTEIItemsPassageAdditionsAllItemsPassageCode2"
DoCmd.OpenQuery "qryUniqueChangedTEIItemsPassageAdditionsAllItemsPassageCode2"
DoCmd.OpenQuery "qryAddUniqueChangedTEIItemsPassageAdditionsAllItemsPassageCode2"

'Add multipart component items to trigger passage change
DoCmd.OpenQuery "qryPassagesOnChangedMultipartItemList"
DoCmd.OpenQuery "qryPassagesOnChangedMultipartItemListPassageCode2"
DoCmd.OpenQuery "qryAddPassagesOnChangedFullItemListPassageCode2"
DoCmd.OpenQuery "qryPassagesNotOnChangedMultipartItems"
DoCmd.OpenQuery "qryChangedMultipartItemsPassageAdditionsPassageCode1Component1"
DoCmd.OpenQuery "qryChangedMultipartItemsPassageAdditionsPassageCode1Component2"
DoCmd.OpenQuery "qryUniqueChangedMultipartItemsPassageAdditionsPassageCode1"
DoCmd.OpenQuery "qryAddUniqueChangedMultipartItemsPassageAdditionsPassageCode1"

'Repeat full queries in case need to grab PassageCode2 item
DoCmd.OpenQuery "qryPassagesOnChangedMultipartItemList"
DoCmd.OpenQuery "qryPassagesOnChangedMultipartItemListPassageCode2"

'QUERIES NOT YET CREATED FOR MULTIPART -- NO PAIRED PASSAGE ITEMS IN FALL 2016 DELIVERY
'DoCmd.OpenQuery "qryAddPassagesOnChangedFullItemListPassageCode2"
'DoCmd.OpenQuery "qryPassagesNotOnChangedItems"
'DoCmd.OpenQuery "qryChangedFullItemsPassageAdditionsAllItemsPassageCode2"
'DoCmd.OpenQuery "qryUniqueChangedFullItemsPassageAdditionsAllItemsPassageCode2"
'DoCmd.OpenQuery "qryAddUniqueChangedFullItemsPassageAdditionsAllItemsPassageCode2"

DoCmd.SetWarnings True
End Sub



