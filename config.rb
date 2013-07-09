# ##############################################################################
# SOME PORTIONS OF THIS FILE (particularly the to_hash() subroutine, 
# found here: https://github.com/puppetlabs/Razor/blob/0.9.0/lib/project_razor/utility.rb):
#
# Copyright (C) 2012 Puppet Labs Inc
# Copyright (C) 2012 EMC Corporation
# Puppet Labs can be contacted at: info@puppetlabs.com
# 
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use or distribute Project Razor except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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

require 'yaml'
require 'singleton'
module Krb5REST
  class Config
	include Singleton

	attr_accessor	:keytab_registry
	attr_accessor	:listen_port
	attr_accessor	:log_use_stderr
	attr_accessor	:log_use_stdout
	attr_accessor	:log_use_syslog
	attr_accessor	:principal_delete_enable
	attr_accessor	:princnames_rules
	attr_accessor	:spec_path
	attr_accessor	:sinatra_raise_errors
	attr_accessor	:sinatra_show_exceptions
	attr_accessor	:ssl_certfile
	attr_accessor	:ssl_keyfile
	attr_accessor	:ssl_verifypeer
	attr_accessor	:ssl_enable
	attr_accessor	:static_path
	attr_accessor	:syslog_ident

	def defaults
		defaults = {
			'keytab_registry'		=> './keytab_registry.txt',
			'listen_port'			=> 6789,
			'log_use_stderr'		=> true,
			'log_use_stdout'		=> false,
			'log_use_syslog'		=> true,
			'principal_delete_enable'	=> false,
			'princnames_rules'		=> './principal-names-rules.txt',
			'sinatra_raise_errors'		=> true,
			'sinatra_show_exceptions' 	=> false,
			'spec_path'			=> './apispec',
			'ssl_certfile'			=> './ssl/server.pem',
			'ssl_keyfile'			=> './ssl/privkey.pem',
			'ssl_verifypeer'		=> false,
			'ssl_enable'			=> true,
			'syslog_ident'			=> 'krb5_rest',
		}
		return defaults
	end
 
        def initialize()
		## Slurp values from YAML, if the file is present
		if(FileTest.readable?('config.yaml'))
			config = YAML.load_file('config.yaml')
			config.each_pair do |key, value|
				# FIXME if they specify a key we don't have a corresponding attribute for, it'll throw an exception
				self[key] = value
			end
		end
		## Load defaults for any un-specified attributes
		defaults.each_pair do |key, value| 
			if(self[key] == nil)
				self[key] = value 
			end
		end
        end

	## Convenience methods to let us treat the object like a hash, mostly
	def [](key)
		self.send(key)
	end

	def []=(key, value)
		self.send("#{key}=", value)
		
	end
	
	def keys
		self.to_hash.keys.map { |k| k.sub("@","") }
	end

	### XXX lifted wholesale from puppetlabs/Razor/blob/master/lib/project_razor/utility.rb
    # Returns a hash array of instance variable symbol and instance variable value for self
    # will ignore instance variables that start with '_'
    def to_hash
      hash = {}
      self.instance_variables.each do |iv|
        if !iv.to_s.start_with?("@_") 
          if self.instance_variable_get(iv).class == Array
            new_array = []
            self.instance_variable_get(iv).each do
            |val|
              if val.respond_to?(:to_hash)
                new_array << val.to_hash
              else
                new_array << val
              end
            end
            hash[iv.to_s] = new_array
          else
            if self.instance_variable_get(iv).respond_to?(:to_hash)
              hash[iv.to_s] = self.instance_variable_get(iv).to_hash
            else
              hash[iv.to_s] = self.instance_variable_get(iv)
            end
          end
        end
      end
      hash
    end
  end
end

