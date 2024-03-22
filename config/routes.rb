Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter-opener" if Rails.env.development?

  namespace :admin, path: "/admin" do
    root to: redirect("/admin/schulungen")

    resources :training_courses, path: "schulungen" do
      get :preview_reminder_message, path: "preview-reminder-message", on: :member
      get :export, on: :collection
      patch :batch_update, path: "batch-update", on: :collection

      resources :registrations, only: [:index, :edit, :update, :destroy] do
        get :download_certificate, on: :member, path: "zertifikat/download"
        get :email_certificate, on: :member, path: "zertifikat/email"
        patch :batch_update, path: "batch-update", on: :collection
      end
      resources :repetitions, only: [:new, :create]
    end

    resources :categories, path: "themen" do
      patch :reorder, on: :collection
    end

    resources :target_audiences, path: "zielgruppen" do
      patch :reorder, on: :collection
    end

    resources :institutions, path: "einrichtungen" do
      patch :reorder, on: :collection
    end
  end

  namespace :frontend, path: "/" do
    get "datenschutz", as: :privacy, to: redirect("https://www.ub.uni-paderborn.de/fileadmin/ub/Dokumente_Formulare/DSE_UB_001_Schulungsdatenbank.pdf")
    get "impressum", as: :legal, to: redirect("https://www.ub.uni-paderborn.de/ueber-uns/impressum/")

    resources :cert_checks, path: "validate", only: [:index, :new, :create, :show]

    resources :training_courses, path: "/", only: [:index, :show] do
      resources :registrations, only: [:new, :create]
    end
  end
end
