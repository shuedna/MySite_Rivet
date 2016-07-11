#check Username data

package require sqlite3
package require sha256



set checklist ""

proc check {Lmin Lmax name } { 
global checklist
 if {[string length [::rivet::var get $name]] > 4 && [string length [::rivet::var get $name]] < 11} {
   #puts "<p>$name length ok [string length [::rivet::var get $name]]</p>"
   lappend checklist Y
 } else {
   puts "<p>Error: $name length incorrect, Must be longer than $Lmin char and less than $Lmax </p>"
   lappend checklist N
 }

 if {[regexp {[][$^\?\+\*\(\)\|\\={}.]} [::rivet::var get $name]] == 0 } {
   #puts "<p>Char Ok</p>"
   lappend checklist Y
 } else {
   puts "<p>Error: Invalid char in $name</p>"
   lappend checklist N
 }
 
  if {[regexp { } [::rivet::var get $name]] == 0 } {
   #puts "<p>No spaces Ok</p>"
   lappend checklist Y
 } else {
   puts "<p>Error: Space in $name</p>"
   lappend checklist N
 }
 #puts $checklist
 
}


proc checkUsernameExist {name} {
        global checklist
	if {[db exists "SELECT 1 FROM users WHERE username=\'[::rivet::var get $name]\'"] == 1 } {
		puts "<p> Error: Username Already Exists</p>"
		lappend checklist N
	} else {
		#puts "<p>Username Available</P>"
		lappend checklist Y
	}
}
proc emailcheck {name} {
	global checklist
	#puts "<p>[::rivet::var get $name]</p>"
	if {[regexp {[][$^\?\+\*\(\)\|\\={}]} [::rivet::var get $name]] == 0 } {
			#puts "<p>Char Ok</p>"
			lappend checklist Y
		} else {
			puts "<p>Error: Invalid char in $name</p>"
			lappend checklist N
		}
	if {[regexp {[@]} [::rivet::var get $name]] == 1 && [regexp {[.]}  [::rivet::var get $name]] == 1}  {
			#puts "<p>Char Ok</p>"
			lappend checklist Y
		} else {
			puts "<p>Error: Invalid $name</p>"
			lappend checklist N
		}
	#puts $checklist
}
  

proc Addusr {} {

	db eval "INSERT INTO users (username,pw,email) VALUES (\'[::rivet::var get Username]\',\'[::sha2::sha256 [::rivet::var get Password]]\',\'[::rivet::var get Email]\')"
	puts "<p>OK</p>"
}

sqlite db /var/www/html/data/test.db
check 4 11 Username
checkUsernameExist Username
check 8 15 Password
emailcheck Email 

#puts $checklist

if {[regexp {N} $checklist] == 1 } {
		puts "<p> Connot Add User Due to submission Errors, Please Correct and resubmit</p>"
	} else {
		Addusr
	}
	
db close