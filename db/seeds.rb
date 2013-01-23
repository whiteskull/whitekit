# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create admin
User.delete_all
User.create({email: 'admin@mail.ru', password: 'password', admin: true}, without_protection: true)

# Create root page
Page.delete_all
Page.create({title: 'Main page', link: '/'})

# Create copyright block
Block.delete_all
Block.create({name: 'Copyright', alias: 'copyright', content: '<p><strong>© WhiteCMS</strong>, 2013</p>'})
