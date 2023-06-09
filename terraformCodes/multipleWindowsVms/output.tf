output "multipleWindowsVmsDetails" { 
  value = {for name, details in module.multipleWinVms: name=>details} 
} 