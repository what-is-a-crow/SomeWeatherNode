class PortfolioManager
	constructor: (initialData) ->
		@viewModel.items.push new PortfolioItem item for item in initialData

	init:
		ko.applyBindings @viewModel, document.body
		
	viewModel:
		items: ko.observableArray()
		selectedItem: ko.observable()

		getItems: () ->
			vm = this
			$.get('/get', {},
				(items) ->
					vm.items.push new PortfolioItem item for item in items
					vm.selectedItem null
			)

		newItem: () ->
			@selectedItem new PortfolioItem


class PortfolioItem
	constructor: (item) ->
		item ?=
			id: -1
			title: 'New'
			description: 'New'
			url: 'new.com'
			isActive: 1
			type: 'code'
		
		@id = ko.observable item.id
		@title = ko.observable item.title
		@description = ko.observable item.description
		@url = ko.observable item.url
		@isActive = ko.observable item.isActive
		@type = ko.observable item.type