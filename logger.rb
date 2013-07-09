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

require 'syslog'
require 'singleton'
require 'config'

module Krb5REST
  class Logger
	include Singleton
        @@syslog = nil
 
        def initialize()
		@@config = Krb5REST::Config.instance
		@@syslog = Syslog.open(@@config['syslog_ident'], Syslog::LOG_PID, Syslog::LOG_DAEMON)
        end

	def console_print(msg)
		if(@@config['log_use_stdout'])
			$stdout.puts msg
		end
		if(@@config['log_use_stderr'])
			$stderr.puts msg
		end
	end

	def emerg(msg)
		msg2 = "emerg: #{msg}"
		console_print(msg2)
		if(@@config['log_use_syslog'])
			@@syslog.emerg(msg2)
		end
	end

	def alert(msg)
		msg2 = "alert: #{msg}"
		console_print(msg2)
		if(@@config['log_use_syslog'])
			@@syslog.alert(msg2)
		end
	end

	def crit(msg)
		msg2 = "crit: #{msg}"
		console_print(msg2)
		if(@@config['log_use_syslog'])
			@@syslog.crit(msg2)
		end
	end

	def err(msg)
		msg2 = "err: #{msg}"
		console_print(msg2)
		if(@@config['log_use_syslog'])
			@@syslog.err(msg2)
		end
	end

	def warning(msg)
		msg2 = "warning: #{msg}"
		console_print(msg2)
		if(@@config['log_use_syslog'])
			@@syslog.warning(msg2)
		end
	end

	def notice(msg)
		msg2 = "notice: #{msg}"
		console_print(msg2)
		if(@@config['log_use_syslog'])
			@@syslog.notice(msg2)
		end
	end
 
        def info(msg)
		msg2 = "info: #{msg}"
		console_print(msg2)
		if(@@config['log_use_syslog'])
			@@syslog.info(msg2)
		end
        end

	def debug(msg)
		msg2 = "debug: #{msg}"
		console_print(msg2)
		if(@@config['log_use_syslog'])
			@@syslog.debug(msg2)
		end
	end
  end
end
 
