
::rivet::parse ../parts/checkcookie.rvt
::rivet::upload save MyUpload /var/www/html/images/[::rivet::upload filename MyUpload]
puts <p>[::exec clamscan /var/www/html/images/[::rivet::upload filename MyUpload]]</p>
puts "Saved file [::rivet::upload filename MyUpload] \
	([::rivet::upload size MyUpload] bytes) to server"
