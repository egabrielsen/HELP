module Main
  class ClubsController < Volt::ModelController
    before_action :require_login
    before_action :setup_club_table, only: :index

    def index
      # Add code for when the index view is loaded
      page._club ||= store.clubs.buffer
      page._competencies = []
    end

    def about
      # Add code for when the about view is loaded
    end

    def clubs
      params._type_filter ||= "all"
      puts params._type_filter
    end

    def setup_club_table
      params._sort_field ||= "name"
      params._sort_direction ||= 1
      page._table = {
        default_click_event: 'club_click',
        columns: [
        {title: "Club/Org Name", search_field: 'name', field_name: 'name', sort_name: 'name', shown: true},
        {title: "Description", search_field: 'desc', field_name: 'description', shown: true},
        {title: "More Information", search_field: 'more_info', field_name: 'more_info', shown: false},
        ]
      }
    end

    def new_club
      page._club = store._clubs.buffer
      page._competencies = []
    end

    def taken?
      Volt.current_user._survey_status.then do |status|
        if status == 'taken'
          true
        else
          false
        end
      end
    end

    def has_competency?
      Volt.current_user._competency.then do |comp|
        if comp == '' || comp == nil
          false
        else
          true
        end
      end
    end

    def club_competencies(id)
      store._competencies.where(club_id: id).all
    end

    def toggle(item)
      if selected?
        page._competencies.delete(item)
      else
        page._competencies << item
      end
    end

    def info_is_link?
      model._more_info.include?('http')
    end

    def user_clubs
      Volt.current_user._competency.then do |one|
        store.competencies.where(name: "#{one}").all
      end
    end

    def all_clubs
      if params._type_filter == 'all'
        store._clubs.order(:name => 1).skip(((params._page || 1).to_i - 1) * 10).limit(10).all
      else
        clubs = []
        store.competencies.where(name: params._type_filter).all.each do |comp|
          unless clubs.include?(comp.club_id)
            store.clubs.where(id: comp.club_id).first.then do |club|
              clubs << {id: comp.club_id, name: "#{club.name}"}
            end
          end
        end
        sorted_clubs = clubs.sort_by{ |hash| hash['name'] }
        sorted_clubs.drop(((params._page || 1).to_i - 1) * 10).take(10)
      end
    end

    def all_clubs_size
      if params._type_filter == 'all'
        store._clubs.order(:name => 1).all.size
      else
        clubs = []
        store.competencies.where(name: params._type_filter).all.each do |comp|
          unless clubs.include?(comp.club_id)
            store.clubs.where(id: comp.club_id).first.then do |club|
              clubs << {id: comp.club_id, name: "#{club.name}"}
            end
          end
        end
        clubs.size
      end
    end

    def the_club(club_id)
      store.clubs.where(id: club_id).first
    end

    def selected?
      page._competencies.include?(attrs.item)
    end

    def show_more(club_id = nil)
      page._competencies = []
      store.clubs.where(id: club_id).first.then do |club|
        page._club = club.buffer
      end
      club_competencies(club_id).each do |comp|
        page._competencies << "#{comp.name}"
      end
      `$('#ClubModal').modal('show');`
    end

    def save_club
      model.save!.then do |m|
        page._competencies.each do |c|
          m._competencies << {name: "#{c}"}
        end
        `swal("Success", "Club was created!", "success");`
        `$('#ClubModal').modal('hide');`
      end.fail do |er|
        `swal("Error", "Please make sure required fields are completed", "error");`
      end
    end

    def update_club
      model.save!.then do |m|
        `swal("Success", "Club was saved!", "success");`
        `$('#ClubModal').modal('hide');`
      end.fail do |er|
        `swal("Error", "Please make sure required fields are completed", "error");`
      end
      index
    end

    def delete_and_close
      `swal({   title: "Are you sure?",
        text: "Are you sure that you want to delete this club? You will lose all data!",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#d43f3a",
        confirmButtonText: "Delete!",
        closeOnConfirm: false }, function(){`
          store._competencies.where(club_id: model.id).all.each do |comp|
            comp.destroy
          end
          store.clubs.where(id: model.id).first.then do |club|
            store.clubs.delete(club)
          end
          `swal("Deleted", "Club has been deleted", "success");`
          `$('#ClubModal').modal('hide');`
        `});`
    end

  end
end
