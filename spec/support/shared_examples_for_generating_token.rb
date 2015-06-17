shared_examples "tokenable" do
  it "generates random token when object is created" do
    expect(object.token).to be_present
  end
end