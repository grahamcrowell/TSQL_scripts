$src_server = 'SPDBDECSUP04'
$src_database = 'DQMF'
$src_table = 'MD_Object'

$dst_table = 'gcMD_Object'
$dst_database = 'DQMF'
$dst_server = 'STDBDECSUP01'

.\bulkcopy.ps1 -SrcServer $src_server -SrcDatabase $src_database -SrcTable $src_table -DestServer $dst_server -DestDatabase $dst_database -DestTable $dst_table -Truncate


$src_server = 'SPDBDECSUP04'
$src_database = 'DQMF'
$src_table = 'AuditPkgExecution'

$dst_server = 'STDBDECSUP01'
$dst_table = 'gcAuditPkgExecution'
$dst_database = 'DQMF'

.\bulkcopy.ps1 -SrcServer $src_server -SrcDatabase $src_database -SrcTable $src_table -DestServer $dst_server -DestDatabase $dst_database -DestTable $dst_table -Truncate






$src_server = 'SPDBDECSUP04'
$src_database = 'CommunityMart'
$src_table = 'AssessmentHeaderFact'

$dst_server = 'STDBDECSUP01'
$dst_database = 'CommunityMart'
$dst_table = 'AssessmentHeaderFact'

.\bulkcopy.ps1 -SrcServer $src_server -SrcDatabase $src_database -SrcTable $src_table -DestServer $dst_server -DestDatabase $dst_database -DestTable $dst_table -Truncate



$src_server = 'SPDBDECSUP04'
$src_database = 'CommunityMart'
$src_table = 'AssessmentContactFact'

$dst_server = 'STDBDECSUP01'
$dst_database = 'CommunityMart'
$dst_table = 'AssessmentContactFact'

.\bulkcopy.ps1 -SrcServer $src_server -SrcDatabase $src_database -SrcTable $src_table -DestServer $dst_server -DestDatabase $dst_database -DestTable $dst_table -Truncate

