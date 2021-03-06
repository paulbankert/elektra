module KeyManager

  class ApplicationController < ::DashboardController
    rescue_and_render_exception_page [
      {
       "KeyManager::ApiError" => {
         header_title: "Monsoon Key-Manager",
         title: -> e, c { e.title},
         description: -> e, c { e.description},
         details: -> e, c { e.details.html_safe}
       }
      }
     ]

     private

     def release_state
       "experimental"
     end


  end

end
