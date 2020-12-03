# frozen_string_literal: true

require './test/test_helper'
require './test/utils/class_factory'
require './updater/updater'

class TestUpdater < Minitest::Test # rubocop:disable Metrics/ClassLength
  def setup
    @updater = Updater::Updater.new
    Utils::ClassFactory.create_class('Event', 'event_type', 'event_description', 'arrival_location')
  end

  def test_not_update_information
    tracking_number = '1234'
    list_attributes = []
    attributes1 = { event_type: 'PU', event_description: 'Picked up', arrival_location: 'PICKUP_LOCATION' }
    attributes2 = { event_type: 'OC', event_description: 'Shipment information sent to FedEx',
                    arrival_location: 'CUSTOMER' }
    list_attributes << attributes1
    list_attributes << attributes2
    prepare_tracking(tracking_number, list_attributes)
    stub_redis(tracking_number)
    Notifier::Notifier
      .any_instance
      .expects(:notify)
      .never
    @updater.update_tracking_information(tracking_number)
  end

  def test_update_information
    tracking_number = '1234'
    list_attributes = []
    attributes1 = { event_type: 'PU', event_description: 'Picked up', arrival_location: 'PICKUP_LOCATION' }
    attributes2 = { event_type: 'OC', event_description: 'Shipment information sent to FedEx',
                    arrival_location: 'CUSTOMER' }
    list_attributes << attributes1
    list_attributes << attributes2
    prepare_tracking(tracking_number, list_attributes)
    stub_redis2(tracking_number)
    Notifier::Notifier
      .any_instance
      .expects(:notify)
      .once
    @updater.update_tracking_information(tracking_number)
  end

  def test_delivered_package
    tracking_number = '1234'
    list_attributes = []
    attributes1 = { event_type: 'PU', event_description: 'Picked up', arrival_location: 'PICKUP_LOCATION' }
    attributes2 = { event_type: 'DL', event_description: 'DELIVERED', arrival_location: 'LOCATION' }
    list_attributes << attributes1
    list_attributes << attributes2
    prepare_tracking(tracking_number, list_attributes)
    stub_redis2(tracking_number)
    Updater::Updater
      .any_instance
      .expects(:delete_tracking_information)
      .once
    @updater.update_tracking_information(tracking_number)
  end

  private

  def prepare_tracking(tracking_number, list_attributes)
    event_list = []
    list_attributes.each do |attributes|
      event_list << attributes
    end
    mock_tracking_info = Minitest::Mock.new
    mock_tracking_details = Minitest::Mock.new
    mock_tracking_details.expect(:details, status_code: 'OC')
    mock_tracking_details.expect(:events, event_list)
    mock_tracking_info.expect(:first, mock_tracking_details)
    stub_parcel_track(tracking_number, mock_tracking_info)
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

  def stub_redis(tracking_number)
    SystemCache::RedisCache
      .any_instance
      .expects(:get)
      .with(tracking_number)
      .returns('{"tracking_number":"020207021381215","carrier":"fedex","tracking_status":"CREATED",' \
               '"event_list":[{"event_type":"PU","event_description":"Picked up",' \
               '"arrival_location":"PICKUP_LOCATION"},{"event_type":"OC",' \
               '"event_description":"Shipment information sent to FedEx","arrival_location":"CUSTOMER"}]}')
      .once
  end

  def stub_redis2(tracking_number)
    stub_redis_set
    SystemCache::RedisCache
      .any_instance
      .expects(:get)
      .with(tracking_number)
      .returns('{"tracking_number":"020207021381215","carrier":"fedex","tracking_status":"CREATED",' \
               '"event_list":[{"event_type":"PU","event_description":"Picked up",' \
               '"arrival_location":"PICKUP_LOCATION"}]}')
      .once
  end

  def stub_redis_set
    SystemCache::RedisCache
      .any_instance
      .expects(:set)
      .returns('OK')
      .once
  end
end
