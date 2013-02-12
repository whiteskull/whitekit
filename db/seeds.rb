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
User.create({email: 'admin@mail.com', password: 'password', admin: true}, without_protection: true)

# Create root page
Page.delete_all
Page.new({title: 'Main page', link: '/', position: 1}, without_protection: true).save(validate: false)

# Create block position
BlockPosition.delete_all
block_position = BlockPosition.create({name: 'Right column', alias: 'right', hidden: false}, as: :admin)

# Create copyright block
Block.delete_all
block_position.blocks.create({name: 'About WhiteKit', alias: 'whitekit', content: '<strong>WhiteKit</strong> is simple, convenient and safe'}, as: :admin)
Block.create({name: 'Copyright', alias: 'copyright', content: '<p><strong>© WhiteKit</strong>, 2013</p>'}, as: :admin)
