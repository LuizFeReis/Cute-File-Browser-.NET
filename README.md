# Cute-File-Browser-.NET
Backend side in C# for Nick Anastasov's Cute File Browser (http://tutorialzine.com/)

# How To Use

First you need to go and install Nick Anastasov's Cute File Browser, you can find it right here: http://tutorialzine.com/2014/09/cute-file-browser-jquery-ajax-php/

After adding it to your page (.aspx, .html, etc) you need to change the script.js

Where it says:

"..........
	// Start by fetching the file data from scan.php with an AJAX request

	$.get('scan.php', function(data) {

		var response = [data],
			currentPath = '',
			breadcrumbsUrls = [];
..........."

You need to change to:

"..........
  // Start by fetching the file data from scan.php with an AJAX request

	$.get('cuteFileBrowserScan.ashx', function(data) {

		var response = [data],
			currentPath = '',
			breadcrumbsUrls = [];
..........."

Now, inside the cuteFileBrowserScan.ashx you need to change the "rootDirectory" string to the folder you want to browse. And that's it, you are ready to go!

# Free to use and upgrade
Please, feel free to use and upgrade this!!
