# frozen_string_literal: true

require './api/routes/api'
require './updater/updater'

Updater::Updater.new.look_for_updates
run TrackingsService::API

