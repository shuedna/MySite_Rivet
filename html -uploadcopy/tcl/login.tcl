#user login script

package require sqlite3
package require sha256

set checklist ""

proc rndpassword len {
	#create random pw (not my code http://www.codecodex.com/wiki/Generate_a_random_password_or_random_string#Tcl )
	set s "abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789"
	for {set i 0} {$i <= $len} {incr i} {
	append p [string index $s [expr {int([string length $s]*rand())}]]
	}
	return $p
	}
proc check {Lmin Lmax name } { 
	#check if value has proper lenght and does not include special char & spaces
	global checklist
	if {[string length [::rivet::var get $name]] > 4 && [string length [::rivet::var get $name]] < 11} {
		#puts "<p>$name length ok [string length [::rivet::var get $name]]</p>"
		lappend checklist Y
	} else {
		puts "<p style=\"color: red;\">Error: $name length incorrect, Must be longer than $Lmin char and less than $Lmax </p>"
		lappend checklist N
	}

	if {[regexp {[][$^\?\+\*\(\)\|\\={}.]} [::rivet::var get $name]] == 0 } {
		#puts "<p>Char Ok</p>"
		lappend checklist Y
	} else {
		puts "<p style=\"color: red;\">Error: Invalid char in $name</p>"
	lappend checklist N
	}
 
	if {[regexp { } [::rivet::var get $name]] == 0 } {
		#puts "<p>No spaces Ok</p>"
		lappend checklist Y
	} else {
		puts "<p style=\"color: red;\">Error: Space in $name</p>"
	lappend checklist N
	}
 #puts $checklist
 
}
proc checkUsernameExist {name} {
	#check if user name exist
        global checklist
	if {[db exists "SELECT 1 FROM users WHERE username=\'[::rivet::var get $name]\'"] == 0 } {
		puts "<p style=\"color: red;\"> Error: Username Does Not Exist</p>"
		lappend checklist N
	} else {
		#puts "<p>Username Ok</P>"
		lappend checklist Y
	}
}
proc Login {} {
	if {[db  eval "SELECT pw FROM users WHERE username=\'[::rivet::var get Username]\'"] == [::sha2::sha256 [::rivet::var get Password]]} {
		puts "<p> Login OK</p>"
		set date \'[clock format [clock seconds] -format %D:%H:%M:%S]\'
		db eval "UPDATE users SET date=$date WHERE username=\'[::rivet::var get Username]\'"
		set exp [expr [clock seconds] + 900]
		db eval "UPDATE users SET exp=$exp WHERE username=\'[::rivet::var get Username]\'"
		set session [rndpassword 56]
		db eval "UPDATE users SET session=\'$session\' WHERE username=\'[::rivet::var get Username]\'"
		#puts [db eval "SELECT * FROM users WHERE username=\'[::rivet::var get Username]\'"]
		db close
		::rivet::cookie set TclRivetCMS "$session" -minutes 55
		::rivet::redirect index.rvt
	} else {
		puts "<p> password incorrect </p>"
	}
}

sqlite db /var/www/html/data/test.db
check 4 11 Username
checkUsernameExist Username
check 8 15 Password

puts $checklist


if {[regexp {N} $checklist] == 1 } {
		puts "<p> Connot Login Due to submission Errors, Please Correct and resubmit</p>"
	} else {
		Login
	}
	
db close