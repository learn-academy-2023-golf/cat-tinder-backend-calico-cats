require 'rails_helper'
#Request Spec
RSpec.describe "Cats", type: :request do
  describe "GET /index" do
    it "gets a list of cats" do
      Cat.create(
        name: 'Samba',
        age: 16,
        enjoys: 'Scratch furniture',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      )

      # Make a request
      get '/cats'

      cat = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(cat.length).to eq 1
    end
  end

  describe "POST /create" do
    it "creates a cat" do
      cat_params = {
        cat: {
          name: 'Samba',
          age: 16,
          enjoys: 'Scratch furniture',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }

      post '/cats', params: cat_params 
      expect(response).to have_http_status(200)
      cat = Cat.first

      expect(cat.name).to eq 'Samba'
      expect(cat.age).to eq 16
      expect(cat.enjoys).to eq 'Scratch furniture'
      expect(cat.image).to eq 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'

    end
  end

  describe 'PATCH /update' do 
    it 'updates a cat' do
      cat_params = {
        cat: {
          name: 'Samba',
          age: 16,
          enjoys: 'Scratch furniture',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }

      post '/cats', params: cat_params
      cat = Cat.first

      updated_cat_params = {
        cat: {
          name: 'Samba',
          age: 13,
          enjoys: 'Scratch furniture and humans',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }

      patch "/cats/#{cat.id}", params: updated_cat_params
      expect(response).to have_http_status(200)
      updated_cat = Cat.find(cat.id)
      expect(updated_cat.age).to eq 13
      expect(updated_cat.enjoys).to eq 'Scratch furniture and humans'
    end
  end

  describe 'DELETES /destroy' do
    it 'deletes a cat' do
        cat_params = {
          cat: {
            name: 'Samba',
            age: 16,
            enjoys: 'Scratch furniture',
            image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
          }
        }

        post '/cats', params: cat_params
        cat = Cat.first
        delete "/cats/#{cat.id}"
        expect(response).to have_http_status(200)
        cats = Cat.all
        expect(cats).to be_empty
    end
  end

  describe "cannot create a cat without valid attributes" do
    it "doesn't create a cat without a valid name" do
        cat_params = {
          cat: {
            age: 16,
            enjoys: 'Scratch furniture',
            image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
          }
        }
        
        post '/cats', params: cat_params
        expect(response.status).to eq 422
        cat = JSON.parse(response.body)
        expect(cat['name']).to include "can't be blank"
    end

    it "doesn't create a cat without a valid age" do
      cat_params = {
        cat: {
          name: 'Tiger',
          enjoys: 'Scratch furniture',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      cat = JSON.parse(response.body)
      expect(cat['age']).to include "can't be blank"
    end

    it "doesn't create a cat without a valid enjoys" do
      cat_params = {
        cat: {
          name: 'Tiger',
          age: 16,
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      cat = JSON.parse(response.body)
      expect(cat['enjoys']).to include "can't be blank"
    end

    it "doesn't create a cat without a valid image" do
      cat_params = {
        cat: {
          name: 'Tiger',
          age: 16,
          enjoys: 'Scratch furniture'
        }
      }
      
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      cat = JSON.parse(response.body)
      expect(cat['image']).to include "can't be blank"
    end
    
    it "doesn't create a cat without a valid enjoys length" do
      cat_params = {
        cat: {
          name: 'Samba',
          age: 16,
          enjoys: 'nothing',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }

      post '/cats', params: cat_params
      expect(response.status).to eq 422
      cat = JSON.parse(response.body)
      expect(cat['enjoys']).to include "is too short (minimum is 10 characters)"
    end
  end
  
  describe "cannot update a cat without valid attributes" do
    it "doesn't update a cat without a valid name" do
      cat_params = {
        cat: {
          name: 'Samba',
          age: 16,
          enjoys: 'Scratch furniture',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }

      post '/cats', params: cat_params
      cat = Cat.first

      updated_cat_params = {
        cat: {
          name: "",
          age: 13,
          enjoys: 'Scratch furniture and humans',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }

      put "/cats/#{cat.id}", params: updated_cat_params
      updated_cat = Cat.find(cat.id)
      expect(response.status).to eq 422
      updated_cat = JSON.parse(response.body)
      expect(updated_cat['name']).to include "can't be blank"
    end
  end

  it "doesn't update a cat without a valid age" do
    cat_params = {
      cat: {
        name: 'Samba',
        age: 16,
        enjoys: 'Scratch furniture',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }

    post '/cats', params: cat_params
    cat = Cat.first

    updated_cat_params = {
      cat: {
        name: "Dark Night",
        age: "",
        enjoys: 'Scratch furniture and humans',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }

    put "/cats/#{cat.id}", params: updated_cat_params
    updated_cat = Cat.find(cat.id)
    expect(response.status).to eq 422
    updated_cat = JSON.parse(response.body)
    expect(updated_cat['age']).to include "can't be blank"
  end

  it "doesn't update a cat without a valid enjoys" do
    cat_params = {
      cat: {
        name: 'Samba',
        age: 16,
        enjoys: 'Scratch furniture',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }

    post '/cats', params: cat_params
    cat = Cat.first

    updated_cat_params = {
      cat: {
        name: "Dark Night",
        age: 13,
        enjoys: '',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }

    put "/cats/#{cat.id}", params: updated_cat_params
    updated_cat = Cat.find(cat.id)
    expect(response.status).to eq 422
    updated_cat = JSON.parse(response.body)
    expect(updated_cat['enjoys']).to include "can't be blank"
  end

  it "doesn't update a cat without a valid image" do
    cat_params = {
      cat: {
        name: 'Samba',
        age: 16,
        enjoys: 'Scratch furniture',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }

    post '/cats', params: cat_params
    cat = Cat.first

    updated_cat_params = {
      cat: {
        name: "Darky",
        age: 13,
        enjoys: 'Scratch furniture and humans',
        image: ''
      }
    }

    put "/cats/#{cat.id}", params: updated_cat_params
    updated_cat = Cat.find(cat.id)
    expect(response.status).to eq 422
    updated_cat = JSON.parse(response.body)
    expect(updated_cat['image']).to include "can't be blank"
  end

  it "doesn't update a cat without a valid enjoys length" do
    cat_params = {
      cat: {
        name: 'Samba',
        age: 16,
        enjoys: 'Scratch furniture',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }

    post '/cats', params: cat_params
    cat = Cat.first

    updated_cat_params = {
      cat: {
        name: "browney",
        age: 13,
        enjoys: 'nothing',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }

    put "/cats/#{cat.id}", params: updated_cat_params
    updated_cat = Cat.find(cat.id)
    expect(response.status).to eq 422
    updated_cat = JSON.parse(response.body)
    expect(updated_cat['enjoys']).to include("is too short (minimum is 10 characters)")
  end
end
