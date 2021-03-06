module Api
  module V1
    class MembershipsController < ApplicationController
      before_filter :ensure_authenticated_user
      
      # curl 'http://localhost:3000/api/v1/memberships' -H 'Authorization: Bearer 40a3d4f1f54bc2f90068242b826d08c4'
      def index
        memberships = Membership.order(:id)
        memberships = memberships.where(organization_id: params[:organization_id]) if params[:organization_id].present?
        memberships = memberships.where(user_id: params[:user_id]) if params[:user_id].present?
        memberships = memberships.limit(params[:limit]) if params[:limit].present?
        render json: memberships.load
      end

      def show
        membership = Membership.where(id: params[:id]).first
        if membership
          if current_user.is_member?(membership.organization)
            render json: membership, status: 200
          else
            render json: {}, status: 401
          end
        else
          render json: {}, status: 404
        end
      end

      def create_organization
        user = current_user
        organization = user.organizations.build(name: params[:name])
        if organization.save
          membership = Membership.create!(user_id: user.id, organization_id: organization.id, is_admin: true)
          render json: { membership: membership, organization: organization }, status: 201
        else
          render json: { errors: organization.errors.messages }, status: 422
        end
      end

      def destroy
        user = current_user
        target_membership = Membership.find(params[:id])
        organization = target_membership.organization
        
        # Determine if current user is admin of this organization
        user_membership = user.memberships.where(organization_id: organization.id).first
        is_admin = user_membership.is_admin?

        if target_membership.user_id == user.id || is_admin
          target_membership.destroy
            
          # Delete the organization if it's not associated with anyone
          if organization.memberships.empty? && is_admin
            organization.destroy
          end

          render json: {}, status: 200
        else
          render json: {}, status: 401
        end
      end
      
    end
  end
end
