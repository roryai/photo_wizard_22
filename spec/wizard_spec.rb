require_relative 'spec_helper'
require_relative '../wizard'

RSpec.describe do

it 'says hello' do
  wiz = Wizard.new

  expect(wiz.hello).to eq "Hello, world!"
end

end
