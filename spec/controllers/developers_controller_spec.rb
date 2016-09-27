require "rails_helper"

RSpec.describe DevelopersController, type: :controller do
  subject { described_class.new }

  let(:valid_attributes) {
    {
      name: "Mario Luan",
      age: "26"
    }
  }

  let(:invalid_attributes) {
    {
      name: "",
      age: "-26"
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    let(:developer) { Developer.create! valid_attributes }
    let(:developers) { [developer] }
    let(:params) { nil }

    it "assigns fetched developers to @developers" do
      get :index, params: params, session: valid_session

      expect(assigns(:developers)).to eq developers
    end

    it "paginates the result" do
      expect_any_instance_of(DevelopersController).to receive(:paginate).with(json: developers)

      get :index, params: params, session: valid_session
    end

    context "when search_params are provided" do
      context "with :name" do
        let(:name) { "Mario Luan" }
        let(:params) { {name: name} }
        let(:search_params) { ActionController::Parameters.new(params).permit(:name, :age) }

        before do
          allow(Developer).to receive(:where).with(search_params).and_return(developers)
        end

        it "filters developers by :name" do
          expect(Developer).to receive(:where).with(search_params)

          get :index, params: params, session: valid_session
        end
      end

      context "with :age" do
        let(:age) { "26" }
        let(:params) { {age: age} }
        let(:search_params) { ActionController::Parameters.new(params).permit(:name, :age) }

        before do
          allow(Developer).to receive(:where).with(search_params).and_return(developers)
        end

        it "filters developers by :age" do
          expect(Developer).to receive(:where).with(search_params)

          get :index, params: params, session: valid_session
        end
      end
    end

    context "when search_params are not provided" do
      let(:params) { {} }
      let(:search_params) { ActionController::Parameters.new(params).permit(:name, :age) }

      before do
        allow(Developer).to receive(:where).with(search_params).and_return(developers)
      end

      it "fetches all developers" do
        expect(Developer).to receive(:where).with(search_params)

        get :index, params: params, session: valid_session
      end
    end
  end

  describe "GET #show" do
    let(:developer) { Developer.new valid_attributes }
    let(:id) { "1" }

    before do
      allow(Developer).to receive(:find).with(id).and_return(developer)

      get :show, params: {id: id}, session: valid_session
    end

    after do
      get :show, params: {id: id}, session: valid_session
    end

    it "finds the developer by its :id" do
      expect_any_instance_of(DevelopersController).to receive(:set_developer)
    end

    it "assigns the requested developer as @developer" do
      expect(assigns(:developer)).to eq(developer)
    end

    it "renders the developer as :json" do
      expect_any_instance_of(DevelopersController).to receive(:render).with(json: developer)
    end
  end

  describe "POST #create" do
    let(:developer) { nil }
    let(:developer_params) { nil }

    before do
      allow(Developer).to receive(:new).with(developer_params).and_return(developer)
    end

    context "with valid params" do
      let(:developer) { Developer.new(valid_attributes) }
      let(:developer_params) { ActionController::Parameters.new(valid_attributes).permit(:name, :age) }

      it "assigns a new developer as @developer" do
        expect(Developer).to receive(:new).with(developer_params)

        post :create, params: {developer: valid_attributes}, session: valid_session

        expect(assigns(:developer)).to eq developer
      end

      it "saves the developer" do
        expect(developer).to receive(:save)

        post :create, params: {developer: valid_attributes}, session: valid_session
      end

      it "renders it" do
        expect_any_instance_of(DevelopersController).to receive(:render).with(json: developer, status: :created, location: developer)

        post :create, params: {developer: valid_attributes}, session: valid_session
      end
    end

    context "with invalid params" do
      let(:developer) { Developer.new(invalid_attributes) }
      let(:developer_params) { ActionController::Parameters.new(invalid_attributes).permit(:name, :age) }

      it "assigns a new developer as @developer" do
        expect(Developer).to receive(:new).with(developer_params)

        post :create, params: {developer: invalid_attributes}, session: valid_session

        expect(assigns(:developer)).to eq developer
      end

      it "saves the developer" do
        expect(developer).to receive(:save)

        post :create, params: {developer: invalid_attributes}, session: valid_session
      end

      it "renders the errors found" do
        expect_any_instance_of(DevelopersController).to receive(:render).with(json: developer.errors, status: :unprocessable_entity)

        post :create, params: {developer: invalid_attributes}, session: valid_session
      end
    end
  end

  # TODO - refactor
  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested developer" do
        developer = Developer.create! valid_attributes
        put :update, params: {id: developer.to_param, developer: new_attributes}, session: valid_session
        developer.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested developer as @developer" do
        developer = Developer.create! valid_attributes
        put :update, params: {id: developer.to_param, developer: valid_attributes}, session: valid_session
        expect(assigns(:developer)).to eq(developer)
      end

      it "redirects to the developer" do
        developer = Developer.create! valid_attributes
        put :update, params: {id: developer.to_param, developer: valid_attributes}, session: valid_session
        expect(response).to redirect_to(developer)
      end
    end

    context "with invalid params" do
      it "assigns the developer as @developer" do
        developer = Developer.create! valid_attributes
        put :update, params: {id: developer.to_param, developer: invalid_attributes}, session: valid_session
        expect(assigns(:developer)).to eq(developer)
      end

      it "re-renders the 'edit' template" do
        developer = Developer.create! valid_attributes
        put :update, params: {id: developer.to_param, developer: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  # TODO - refactor
  describe "DELETE #destroy" do
    it "destroys the requested developer" do
      developer = Developer.create! valid_attributes
      expect {
        delete :destroy, params: {id: developer.to_param}, session: valid_session
      }.to change(Developer, :count).by(-1)
    end

    it "redirects to the developers list" do
      developer = Developer.create! valid_attributes
      delete :destroy, params: {id: developer.to_param}, session: valid_session
      expect(response).to redirect_to(developers_url)
    end
  end

end
