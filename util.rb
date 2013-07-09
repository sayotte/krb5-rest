# ##############################################################################
# Copyright (C) 2013 Stephen Ayotte <stephen.ayotte@gmail.com>
# 
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met: 
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer. 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution. 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# The views and conclusions contained in the software and documentation are those
# of the authors and should not be interpreted as representing official policies, 
# either expressed or implied, of Stephen Ayotte.
# 
# ##############################################################################

require 'json'
require 'json-schema'
require 'config'
require 'logger'

module Krb5REST
  module Util
        include Process
        def self.run(cmdline, input)
                outrd, outwr = IO.pipe
                errrd, errwr = IO.pipe
                stdinrd, stdinwr = IO.pipe
                pid = Process.fork()
                if (pid == nil)
                        outrd.close
                        errrd.close
                        stdinwr.close
                        $stdout.reopen(outwr)
                        $stderr.reopen(errwr)
                        $stdin.reopen(stdinrd)
                        Process.exec(cmdline)
                end
                stdinwr.write(input)
                stdinwr.close
                outwr.close
                errwr.close
                pid, status = Process.waitpid2(pid)
                status = status >> 8
                stdout = outrd.read
                outrd.close
                stderr = errrd.read
                errrd.close

                output = {
                        :status => status,
                        :stdout => stdout,
                        :stderr => stderr
                }

                return output
        end

	def self.validate(mod, json)
		config = Krb5REST::Config.instance
		log = Krb5REST::Logger.instance
		schema = File.open("#{config['spec_path']}/#{mod}.spec", "rb"){|f| JSON.parse(f.read)}
		begin
			JSON::Validator.validate!(schema, json)
			return 0, ''
		rescue JSON::Schema::ValidationError => e
			log.warning("#{__FILE__}:#{__LINE__}: in '#{__method__}': Schema validation failed: $!.message\n")
			return 200, "Schema validation failed: " + e.message + "\n"
		rescue  => e
			log.crit("#{__FILE__}:#{__LINE__}: in '#{__method__}': UNHANDLED EXCEPTION: " + e.message)
			## Debugging code, remove for prod
			return 500, e.message + "\n"
			## Prod code
			#halt 500, "Whoops? See server log for more details.\n"
		end

	end
  end
end
