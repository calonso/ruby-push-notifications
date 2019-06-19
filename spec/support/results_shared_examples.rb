# frozen_string_literal: true

shared_examples 'right results' do |success, failed, individual_results|
  it 'has the expected success value' do
    expect(notification.success).to eq success
  end

  it 'has the expected failed value' do
    expect(notification.failed).to eq failed
  end

  it 'has the expected individual_results' do
    expect(notification.individual_results).to eq individual_results
  end
end

shared_examples 'a proper results manager' do
  describe 'results management' do
    before { notification.results = results }

    it 'gives the success count' do
      expect(notification.success).to eq success_count
    end

    it 'gives the failures count' do
      expect(notification.failed).to eq failures_count
    end

    it 'gives the individual results' do
      expect(notification.individual_results).to eq individual_results
    end
  end
end
