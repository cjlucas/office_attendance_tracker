require 'rails_helper'

RSpec.describe 'Api::Attendances', type: :request do
  include ActiveSupport::Testing::TimeHelpers
  describe 'POST /api/attendances' do
    around do |example|
      travel_to Time.zone.local(2025, 1, 15, 12, 0, 0) do
        example.run
      end
    end

    context 'when attendance does not exist for today' do
      it 'creates a new attendance record' do
        expect {
          post '/api/attendances'
        }.to change(Attendance, :count).by(1)
      end

      it 'returns 201 Created status' do
        post '/api/attendances'
        expect(response).to have_http_status(:created)
      end

      it 'returns no response body' do
        post '/api/attendances'
        expect(response.body).to be_empty
      end

      it 'sets the date to today' do
        post '/api/attendances'
        expect(Attendance.last.date).to eq(Date.new(2025, 1, 15))
      end
    end

    context 'when attendance already exists for today' do
      before do
        Attendance.create!(date: Date.new(2025, 1, 15))
      end

      it 'does not create a new attendance record' do
        expect {
          post '/api/attendances'
        }.not_to change(Attendance, :count)
      end

      it 'returns 200 OK status (idempotent)' do
        post '/api/attendances'
        expect(response).to have_http_status(:ok)
      end

      it 'returns no response body' do
        post '/api/attendances'
        expect(response.body).to be_empty
      end
    end
  end
end
