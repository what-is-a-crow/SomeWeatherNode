isLoading = true

$ ->
	# tack on Twitter loader script
	$('body').append '<script src="http://twitter.com/statuses/user_timeline/someweather.json?callback=twitterCallback2&amp;count=3" type="text/javascript"></script>'

	# and while we wait on Twitter, we can watch some pretty ellipses
	callback = -> loadingTick 'ellipsesTwitter', isLoading
	setTimeout callback, 1000

loadingTick = (divId) ->
	if not isLoading
		return
	ellipses = $('#' + divId)
	numberOfDots = ellipses.text().length


	if numberOfDots is 3
		ellipses.html ''
	else
		ellipses.append '.'

	callback = -> loadingTick 'ellipsesTwitter', isLoading
	setTimeout callback, 1000