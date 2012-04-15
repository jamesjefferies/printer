require "backend_server/base"
require "remote_printer"
require "print_queue"

class BackendServer::Polling < BackendServer::Base
  get "/:printer_id" do
    RemotePrinter.update(remote_printer_params(params))
    PrintQueue.new(params['printer_id']).archive_and_return_print_data
  end

  private

  def remote_printer_params(params)
    type = env["HTTP_ACCEPT"] ? env["HTTP_ACCEPT"].split("application/vnd.freerange.printer.").last : nil
    {id: params['printer_id'], type: type, ip: request.ip}
  end
end