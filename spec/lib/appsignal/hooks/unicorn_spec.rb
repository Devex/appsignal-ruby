describe Appsignal::Hooks::UnicornHook do
  context "with unicorn" do
    before :all do
      module Unicorn
        class HttpServer
          def worker_loop(worker)
          end
        end

        class Worker
          def close
          end
        end
      end
      Appsignal::Hooks::UnicornHook.new.install
    end
    after(:all) { Object.send(:remove_const, :Unicorn) }

    its(:dependencies_present?) { should be_true }

    it "adds behavior to Unicorn::HttpServer#worker_loop" do
      server = Unicorn::HttpServer.new
      worker = double

      Appsignal.should_receive(:forked)
      server.should_receive(:worker_loop_without_appsignal).with(worker)

      server.worker_loop(worker)
    end

    it "adds behavior to Unicorn::Worker#close" do
      worker = Unicorn::Worker.new

      Appsignal.should_receive(:stop)
      worker.should_receive(:close_without_appsignal)

      worker.close
    end
  end

  context "without unicorn" do
    its(:dependencies_present?) { should be_false }
  end
end
