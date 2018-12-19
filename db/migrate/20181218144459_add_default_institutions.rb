class AddDefaultInstitutions < ActiveRecord::Migration[5.2]
  def up
    Institution.create(title: "Fakultät für Kulturwissenschaften", position: 1)
    Institution.create(title: "Fakultät für Wirtschaftswissenschaften", position: 2)
    Institution.create(title: "Fakultät für Naturwissenschaften", position: 3)
    Institution.create(title: "Fakultät für Maschinenbau", position: 4)
    Institution.create(title: "Fakultät für Elektrotechnik, Informatik und Mathematik", position: 5)
    Institution.create(title: "Sonstige Einrichtung der Universität Paderborn", position: 6)
    Institution.create(title: "Extern", position: 7)
  end

  def down
    Institution.delete_all
  end
end
