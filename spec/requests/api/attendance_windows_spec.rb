require 'rails_helper'

RSpec.describe 'Api::AttendanceWindows', type: :request do
  include ActiveSupport::Testing::TimeHelpers

  describe 'GET /api/attendance_windows/active' do
    around do |example|
      travel_to Time.zone.local(2025, 1, 15, 12, 0, 0) do
        example.run
      end
    end

    context 'when there are no attendance windows' do
      it 'returns an empty array' do
        get '/api/attendance_windows/active'
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when there are active windows' do
      let!(:active_window) do
        AttendanceWindow.create!(
          start_date: Date.new(2025, 1, 1),
          end_date: Date.new(2025, 1, 31)
        )
      end

      it 'returns 200 OK status' do
        get '/api/attendance_windows/active'
        expect(response).to have_http_status(:ok)
      end

      it 'returns the active window' do
        get '/api/attendance_windows/active'
        json = JSON.parse(response.body)

        expect(json.length).to eq(1)
        expect(json.first['id']).to eq(active_window.id)
        expect(json.first['start_date']).to eq('2025-01-01')
        expect(json.first['end_date']).to eq('2025-01-31')
      end
    end

    context 'when there are multiple active windows' do
      let!(:window1) do
        AttendanceWindow.create!(
          start_date: Date.new(2025, 1, 1),
          end_date: Date.new(2025, 1, 31)
        )
      end

      let!(:window2) do
        AttendanceWindow.create!(
          start_date: Date.new(2025, 1, 10),
          end_date: Date.new(2025, 1, 20)
        )
      end

      it 'returns all active windows' do
        get '/api/attendance_windows/active'
        json = JSON.parse(response.body)

        expect(json.length).to eq(2)
        expect(json.map { |w| w['id'] }).to contain_exactly(window1.id, window2.id)
      end
    end

    context 'when there are windows that have not started yet' do
      let!(:future_window) do
        AttendanceWindow.create!(
          start_date: Date.new(2025, 2, 1),
          end_date: Date.new(2025, 2, 28)
        )
      end

      it 'does not return future windows' do
        get '/api/attendance_windows/active'
        json = JSON.parse(response.body)

        expect(json).to be_empty
      end
    end

    context 'when there are windows that have already ended' do
      let!(:past_window) do
        AttendanceWindow.create!(
          start_date: Date.new(2024, 12, 1),
          end_date: Date.new(2024, 12, 31)
        )
      end

      it 'does not return past windows' do
        get '/api/attendance_windows/active'
        json = JSON.parse(response.body)

        expect(json).to be_empty
      end
    end

    context 'when there are mixed active, future, and past windows' do
      let!(:past_window) do
        AttendanceWindow.create!(
          start_date: Date.new(2024, 12, 1),
          end_date: Date.new(2024, 12, 31)
        )
      end

      let!(:active_window) do
        AttendanceWindow.create!(
          start_date: Date.new(2025, 1, 1),
          end_date: Date.new(2025, 1, 31)
        )
      end

      let!(:future_window) do
        AttendanceWindow.create!(
          start_date: Date.new(2025, 2, 1),
          end_date: Date.new(2025, 2, 28)
        )
      end

      it 'returns only active windows' do
        get '/api/attendance_windows/active'
        json = JSON.parse(response.body)

        expect(json.length).to eq(1)
        expect(json.first['id']).to eq(active_window.id)
      end
    end

    context 'when a window starts today' do
      let!(:starts_today) do
        AttendanceWindow.create!(
          start_date: Date.new(2025, 1, 15),
          end_date: Date.new(2025, 1, 31)
        )
      end

      it 'includes the window' do
        get '/api/attendance_windows/active'
        json = JSON.parse(response.body)

        expect(json.length).to eq(1)
        expect(json.first['id']).to eq(starts_today.id)
      end
    end

    context 'when a window ends today' do
      let!(:ends_today) do
        AttendanceWindow.create!(
          start_date: Date.new(2025, 1, 1),
          end_date: Date.new(2025, 1, 15)
        )
      end

      it 'includes the window' do
        get '/api/attendance_windows/active'
        json = JSON.parse(response.body)

        expect(json.length).to eq(1)
        expect(json.first['id']).to eq(ends_today.id)
      end
    end
  end
end
