shared_examples "user with unsuccessful charge" do
  it "sets the flash error message" do
    expect(flash[:danger]).to eq "Your card was declined"
  end

  it "render :new template" do
    expect(response).to render_template :new
  end
end