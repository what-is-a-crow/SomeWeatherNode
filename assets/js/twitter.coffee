isLoading = true

$ ->
	url = 'https://api.twitter.com/1/statuses/user_timeline.json?include_entities=false&include_rts=false&screen_name=someweather&count=1&trim_user=true&callback=?'
	$.getJSON url, (tweets) ->
		processTweets tweets

	# tack on Twitter loader script
	#$('body').append "<script src='#{url}' type='text/javascript'></script>"

	# and while we wait on Twitter, we can watch some pretty ellipses
	loading()

loading = () ->
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

	loading()

processTweets = (tweets) ->
	isLoading = false

	tweet = tweets[0]
	if not tweet
		return

	relativeTime = getRelativeTime tweet.created_at
	# todo: this was a straight conversion from the old code.. let's remove the hard-coded HTML, shall we?
	status = "<div class='tweet'><span>#{tweet.text}</span>&nbsp;&nbsp;<nobr><a target='_blank' href='http://twitter.com/someweather/statuses/#{tweet.id}'>#{relativeTime}</a></nobr></div>"
	
	$('#gatheringupdates').fadeOut () ->
		$('#twitter_updates').html status
		$('.tweet').fadeIn()
	
getRelativeTime = (rawTime) ->
	datePattern = /^\w+ (\w+) (\d+) ([\d:]+) \+0000 (\d+)$/
	dateString = rawTime.replace datePattern, '$1 $2 $4 $3 UTC'
	created = new Date dateString

	now = new Date()
	delta = parseInt (now.getTime() - created) / 1000
	delta += now.getTimezoneOffset() * 60

	relative = ''
	if delta < 60
		relative = 'less than a minute ago'
	else if delta < 120
		relative = 'about a minute ago'
	else if delta < (60 * 60)
		relative = "#{parseInt delta / 60} minutes ago"
	else if delta < (120 + 60)
		relative = 'about an hour ago'
	else if delta < (24 * 60 * 60)
		relative = "about #{parseInt delta / 3600} hours ago"
	else if delta < (48 * 60 * 60)
		relative = '1 day ago'
	else
		relative = "#{parseInt delta / 86400} days ago"
	relative