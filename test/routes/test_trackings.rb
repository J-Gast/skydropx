# frozen_string_literal: true

require './test/test_helper'
require './test/utils/class_factory'

class TestTrackingRoute < TestRoute
  def setup
    Utils::ClassFactory.create_class('Event', 'event_type', 'event_description', 'arrival_location')
  end

  def test_register_tracking_number
    tracking_number = '020207021381215'
    expected = prepare_tracking(tracking_number)
    expected_events = expected[:expected_events]
    expected_data = expected[:expected_data]
    post 'api/v1/trackings', tracking_number: tracking_number, carrier: 'fedex'
    response = JSON.parse(last_response.body).deep_symbolize_keys
    assert_equal('success', response[:status])
    assert_equal(expected_data[:tracking_information][:tracking_number],
                 response[:data][:tracking_information][:tracking_number])
    assert_equal(expected_events, response[:data][:tracking_information][:event_list])
  end

  def test_not_registered_tracking_number
    tracking_number = '012345'
    exception = Fedex::RateError.new('This tracking number cannot be found. ' \
                                     'Please check the number or contact the sender.')
    stub_parcel_track_exception(tracking_number, exception)
    post 'api/v1/trackings', tracking_number: tracking_number, carrier: 'fedex'
    response = JSON.parse(last_response.body).deep_symbolize_keys
    assert_equal('fail', response[:status])
    assert_equal(response[:data],
                 'This tracking number cannot be found. Please check the number or contact the sender.')
  end

  private

  def prepare_tracking(tracking_number)
    attributes1 = { event_type: 'PU', event_description: 'Picked up', arrival_location: 'PICKUP_LOCATION' }
    attributes2 = { event_type: 'OC', event_description: 'Shipment information sent to FedEx',
                    arrival_location: 'CUSTOMER' }
    event1 = create_event(attributes1)
    event2 = create_event(attributes2)
    mock_tracking_info = Minitest::Mock.new
    mock_tracking_details = Minitest::Mock.new
    mock_tracking_details.expect(:details, status_code: 'OC')
    mock_tracking_details.expect(:events, [event1, event2])
    mock_tracking_info.expect(:first, mock_tracking_details)
    stub_parcel_track(tracking_number, mock_tracking_info)
    expected_events = [Utils.event_to_hash(event1).symbolize_keys, Utils.event_to_hash(event2).symbolize_keys]
    expected_data = { tracking_information: { tracking_number: tracking_number,
                                              carrier: 'fedex',
                                              tracking_status: 'CREATED',
                                              event_list: expected_events } }
    stub_redis(tracking_number, expected_data)
    { expected_events: expected_events, expected_data: expected_data }
  end

  def create_event(attributes)
    event = Event.new
    event.event_type = attributes[:event_type]
    event.event_description = attributes[:event_description]
    event.arrival_location = attributes[:arrival_location]
    event
  end

  def stub_parcel_track(tracking_number, mock_tracking_info)
    Parcels::Fedex
      .any_instance
      .expects(:track)
      .with(tracking_number)
      .returns(mock_tracking_info)
      .once
  end

  def stub_parcel_track_exception(tracking_number, exception)
    Parcels::Fedex
      .any_instance
      .expects(:track)
      .with(tracking_number)
      .raises(exception)
      .once
  end

  def stub_redis(tracking_number, data)
    SystemCache::RedisCache
      .any_instance
      .expects(:set)
      .with(tracking_number, data[:tracking_information].to_json)
      .returns('OK')
      .once
  end
end
