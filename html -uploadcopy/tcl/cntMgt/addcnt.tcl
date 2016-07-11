

proc createFile {} {
global filePath
if {[::rivet::var get date] == 1} {
        set filePath "[::rivet::var get dirs]/[clock seconds][::rivet::var get filename].rvt"
        set file [open $filePath w+]
} else {
	set filePath "[::rivet::var get dirs]/[::rivet::var get filename].rvt"
	set file [open $filePath  w+]
}

puts $file "<!--[::rivet::var get title] -->"
puts $file "<!--[::rivet::var get descript]-->"
puts $file "[::rivet::var get cnt]"

close $file
}

::rivet::parse ../parts/checkcookie.rvt
createFile

set title "The Admin Tool Add Content"
::rivet::parse ../../parts/topbars.rvt
puts "<div style=\"overflow: auto; position: relative; top: 125px; width: 100%; background-color: white; color: black; padding: 10px; max-width: 980px\">"
puts "<b> The File $filePath Was Created</b>"
::rivet::parse $filePath
