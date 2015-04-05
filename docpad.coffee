# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://prox.imity.io"

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				''
			]

			# The default title of our website
			title: "PROX.IMITY.IO"

			# The website description (for SEO)
			description: """
				PROX.IMITY.IO is an experimental research project for astrological inquiry into modern satellite technology and its quotidian geopolitical ramifications. 
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				satellite technology, astrology, history, cold war, satellite communications, space race, satellites, omenology, ephemeris, lens, grand narratives, microchimeras, serenity
				"""

			# The website author's name
			author: "Mt. Blisset"

			# The website author's email
			email: "prox@imity.io"

			# Styles
			styles: [
				"//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"
				"/styles/twitter-bootstrap.css"
				"//api.tiles.mapbox.com/mapbox.js/v2.1.0/mapbox.css"
				"/styles/custom.css"
			]

			# Scripts
			scripts: [
				"//cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2/jquery.min.js"
				"//cdnjs.cloudflare.com/ajax/libs/modernizr/2.6.2/modernizr.min.js"
				"//api.tiles.mapbox.com/mapbox.js/v2.0.1/mapbox.js"
				"//maps.stamen.com/js/tile.stamen.js?v1.3.0"
				"/vendor/js/leaflet.ajax.min.js"
				"/scripts/bootstrap-custom.js"
				"/scripts/modal.js"
				"/scripts/script.js"
				"//d3js.org/d3.v3.min.js"
			]


		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

		posts: (database) ->
			database.findAllLive({isPost: $exists: true}, [date:-1])

		satellites: (database) ->
			database.findAllLive({tags:$has:'satellites'}, [date:-1])

		astrologies: (database) ->
			database.findAllLive({tags:$has:'astrologies'}, [date:-1])

		fictions: (database) ->
			database.findAllLive({tags:$has:'fictions'}, [date:-1])

	# =================================
	# Plugins

	plugins:
		downloader:
			downloads: [
				{
					name: 'Twitter Bootstrap'
					path: 'src/files/vendor/twitter-bootstrap'
					url: 'https://codeload.github.com/twbs/bootstrap/tar.gz/master'
					tarExtractClean: true
				}
			]


	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()
}


# Export our DocPad Configuration
module.exports = docpadConfig
