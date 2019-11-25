alias KomachiHeartbeat.BeamVitalServer
{:ok, _} = GenServer.start_link(BeamVitalServer, [], name: BeamVitalServer)
ExUnit.start()
