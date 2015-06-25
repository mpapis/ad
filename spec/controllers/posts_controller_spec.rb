require "rails_helper"

describe PostsController do
  let(:user) { User.create(email: "foo@bar.zone", password: "foofoofoo", password_confirmation: "foofoofoo") }
  let(:wrong_user) { User.create(email: "bad@foo.bar", password: "badbadbad", password_confirmation: "badbadbad") }

  describe "GET index" do
    let(:post) { Post.create(title: "foo", body: "bar", user: user) }

    subject { get :index }

    it "assigns @posts" do
      subject
      expect(assigns(:posts)).to eq([post])
    end

    it "renders the index template" do
      subject
      expect(response).to render_template("index")
    end
  end

  describe "GET new" do
    subject { get :new }

    context "when signed in" do
      let(:post) { Post.new }

      before do
        sign_in user
      end

      it "assigns @post" do
        subject
        expect(assigns(:post)).to be_instance_of Post
      end

      it "renders the new template" do
        subject
        expect(response).to render_template("new")
      end
    end

    context "when NOT signed in" do
      it "returns status 302 and alert message" do
        subject
        expect(response.status).to eql 302
        expect(response.request.env["action_dispatch.request.flash_hash"].alert).to eql "You need to sign in or sign up before continuing."
      end
    end
  end

  describe "GET edit" do
    let(:post) { Post.create(title: "foo", body: "bar", user: user) }

    subject { get :edit, id: post.id }

    context "when signed in" do
      context "as post author" do
        before do
          sign_in user
        end

        it "assigns @post" do
          subject
          expect(assigns(:post)).to eq post
        end

        it "renders the index template" do
          subject
          expect(response).to render_template("edit")
        end
      end

      context "as a different user than post author" do
        before do
          sign_in wrong_user
        end

        it "renders the index template" do
          subject
          expect(response.status).to eql 302
          expect(response.request.env["action_dispatch.request.flash_hash"].alert).to eql "You are not allowed to update that resource!"
        end
      end
    end

    context "when NOT signed in" do
      it "returns status 302 and alert message" do
        get :edit, id: post.id
        expect(response.status).to eql 302
        expect(response.request.env["action_dispatch.request.flash_hash"].alert).to eql "You need to sign in or sign up before continuing."
      end
    end
  end

  describe "POST create" do
    subject { post :create, post: { title: "foo", body: "bar" } }

    context "when signed in" do
      before do
        sign_in user
      end

      it "creates a post" do
        expect{ subject }.to change{ Post.count }.from(0).to(1)
      end
    end

    context "when NOT signed in" do
      it "returns status 302 and alert message" do
        subject
        expect(response.status).to eql 302
        expect(response.request.env["action_dispatch.request.flash_hash"].alert).to eql "You need to sign in or sign up before continuing."
      end
    end
  end

  describe "PUT update" do
    let!(:post) { Post.create(title: "foo", body: "bar", user: user) }

    subject { put :update, post: { title: "foo", body: "zone" }, id: post.id }

    context "when signed in" do
      context "as post author" do
        before do
          sign_in user
        end

        it "updates a post" do
          expect{ subject }.to change{ Post.first.body }.from("bar").to("zone")
        end
      end

      context "as a different user than post author" do
        before do
          sign_in wrong_user
        end

        it "renders the index template" do
          subject
          expect(response.status).to eql 302
          expect(response.request.env["action_dispatch.request.flash_hash"].alert).to eql "You are not allowed to update that resource!"
        end
      end
    end

    context "when NOT signed in" do
      it "returns status 302 and alert message" do
        subject
        expect(response.status).to eql 302
        expect(response.request.env["action_dispatch.request.flash_hash"].alert).to eql "You need to sign in or sign up before continuing."
      end
    end
  end

  describe "delete destroy" do

    let!(:post) { Post.create(title: "foo", body: "bar", user: user) }

    subject { delete :destroy, id: post.id }

    context "when signed in" do
      context "as post author" do
        before do
          sign_in user
        end

        it "deletes a post" do
          expect{ subject }.to change{ Post.count }.from(1).to(0)
        end
      end

      context "as a different user than post author" do
        before do
          sign_in wrong_user
        end

        it "renders the index template" do
          subject
          expect(response.status).to eql 302
          expect(response.request.env["action_dispatch.request.flash_hash"].alert).to eql "You are not allowed to update that resource!"
        end
      end
    end

    context "when NOT signed in" do
      it "returns status 302 and alert message" do
        subject
        expect(response.status).to eql 302
        expect(response.request.env["action_dispatch.request.flash_hash"].alert).to eql "You need to sign in or sign up before continuing."
      end
    end
  end
end