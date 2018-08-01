class Subgenre < ApplicationRecord
	validates	:name, uniqueness: true
end
