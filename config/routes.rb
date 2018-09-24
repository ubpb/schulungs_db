Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter-opener" if Rails.env.development?

  namespace :admin, path: "/admin" do
    root to: redirect("/admin/schulungen")

    resources :training_courses, path: "schulungen" do
      resources :registrations, only: [:index, :edit, :update, :destroy]
      resources :repetitions, only: [:new, :create]

      collection do
        patch :batch_update, path: "batch-update"
      end
    end

    resources :categories, path: "themen" do
      patch :reorder, on: :collection
    end

    resources :target_audiences, path: "zielgruppen" do
      patch :reorder, on: :collection
    end
  end

  namespace :frontend, path: "/" do
    get "datenschutz", as: :privacy, to: redirect("https://www.ub.uni-paderborn.de/fileadmin/ub/Dokumente_Formulare/Datenschutzerklaerung-Schulungen.pdf")
    get "impressum", as: :legal, to: redirect("https://www.ub.uni-paderborn.de/ueber-uns/impressum/")

    resources :training_courses, path: "/", only: [:index, :show] do
      resources :registrations, only: [:new, :create]
    end
  end
end
