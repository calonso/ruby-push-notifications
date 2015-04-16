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
