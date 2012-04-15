require "test_helper"
require "remote_printer"
require "print_processor"

describe RemotePrinter do
  describe "updating" do
    it "stores the printer data" do
      DataStore.redis.expects(:hset).with("printers:1", "type", "printer-type")
      RemotePrinter.update(id: "1", type: "printer-type")
    end

    it "stores the remote IP for a short time" do
      Time.stubs(:now).returns(stub('time', to_i: 1000))
      DataStore.redis.expects(:zadd).with("ip:192.168.1.1", 1000, "printer-id")
      RemotePrinter.update(id: "printer-id", ip: "192.168.1.1")
    end
  end

  describe "retrieving" do
    it "returns the type for the stored printer" do
      DataStore.redis.stubs(:hget).with("printers:1", "type").returns("printer-type")
      RemotePrinter.find("1").type.must_equal "printer-type"
    end

    it "returns the width for the printer according to its type" do
      DataStore.redis.stubs(:hget).with("printers:1", "type").returns("printer-type")
      PrintProcessor.stubs(:for).with("printer-type").returns(stub('print_processor', width: 123))
      RemotePrinter.find("1").width.must_equal 123
    end
  end

  describe "finding by ip" do
    it "clears out expired printer IDs for that IP" do
      Time.stubs(:now).returns(stub('time', to_i: 2000))
      DataStore.redis.expects(:zremrangebyscore).with("ip:192.168.1.1", 0, 2000-60)
      RemotePrinter.find_by_ip("192.168.1.1")
    end

    it "returns the printer instances which most recently checked in from that IP" do
      Time.stubs(:now).returns(stub('time', to_i: 3000))
      DataStore.redis.expects(:zrangebyscore).with("ip:192.168.1.1", 3000-60, 3000).returns(["printer-id", "printer-id-2"])
      RemotePrinter.expects(:find).with("printer-id")
      RemotePrinter.expects(:find).with("printer-id-2")
      RemotePrinter.find_by_ip("192.168.1.1")
    end

    it "returns an empty array if no matching IP was found" do
      DataStore.redis.expects(:zrangebyscore).with("ip:192.168.1.1", anything, anything).returns([])
      RemotePrinter.find_by_ip("192.168.1.1").must_equal []
    end
  end
end