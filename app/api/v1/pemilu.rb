module Pemilu
  class APIv1 < Grape::API
    version 'v1', using: :accept_version_header
    prefix 'api'
    format :json

    resource :questions do     
      
      desc "Return all FAQ President"
      get do
        questions = Array.new
        
        # Set default limit
        limit = (params[:limit].to_i == 0 || params[:limit].empty?) ? 50 : params[:limit]
        
        valid_params = {
          tag: "tags.tag"
        }
        
        conditions = Hash.new
        valid_params.each_pair do |key, value|
          conditions[value.to_sym] = params[key.to_sym] unless params[key.to_sym].blank?
        end
        
        search = ["reference_law LIKE ? or excerpt_law LIKE ?", "%#{params[:law]}%", "%#{params[:law]}%"]
        
        Question.includes(:tags)
          .where(conditions)
          .where(search)
          .limit(limit)
          .offset(params[:offset])
          .each do |question|
            questions << {
              id: question.id,
              question: question.question,
              answer: question.answer,
              reference_law: question.reference_law,
              excerpt_law: question.excerpt_law,
              tags: question.tags
            }
          end
          {
          results: {
            count: questions.count,
            total: Question.where(conditions).where(search).count,
            questions: questions
          }
        }
      end
      
      desc "Return a single Question object with all its details"
      params do
        requires :id, type: String, desc: "Question ID."
      end
      route_param :id do
        get do
          question = Question.find_by(id: params[:id])
          {
            results: {
              count: 1,
              total: 1,
              question: [{
                id: question.id,
                question: question.question,
                answer: question.answer,
                reference_law: question.reference_law,
                excerpt_law: question.excerpt_law,
                tags: question.tags
              }]
            }
          }
        end
      end
    end
  end
end