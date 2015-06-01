require 'spec_helper'

describe User do
	it { should validate_presence_of :full_name}
	it { should validate_presence_of :email}
	it { should validate_uniqueness_of(:email).case_insensitive }
	it { should validate_length_of(:email).is_at_most(255) }
	it { should allow_value('ben@example.com').for(:email) }
	it { should_not allow_value('ben.com').for(:email) }
end
