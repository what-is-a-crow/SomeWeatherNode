mongoose 	= require 'mongoose'

module.exports = new mongoose.Schema
	title: 	String
	description: String
	url: String
	isActive: Boolean
	sortOrder:
		type: Number
		min: 0
	type:
		type: String
		enum: ['design', 'code', 'designcode']