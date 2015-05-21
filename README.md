An exporter for David Dollar's [Foreman](https://github.com/ddollar/foreman)
that outputs service directories that can be managed by a per-user `svscan`,
with additional configuration which makes it
[allah](https://github.com/mpalmer/allah)-compatible.


# Prerequisites

* Ruby 2.0.0 or later
* Foreman


# Installation

    $ gem install foreman-export-allah


# Usage

To export your Procfile to a `~/service` directory:

    $ foreman export allah ~/service

This will create a `~/service/<app>-<proc>` directory for each `Procfile`
process. If you have the concurrency set to something > 1 for any of them it
will create an individual numbered service directory for each one in the
format: `~/service/<app>-<proc>-<num>`.

Each directory will be generated with a `down` file, which will prevent
supervise from automatically starting it before you have a chance to look it over.
After you confirm that everything looks okay, you can start them up just by
removing `down` on each service, or running `allah start <app>`.


# License

Copyright (c) 2012, Michael Granger
Copyright (c) 2015, Matt Palmer
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the author/s, nor the names of the project's
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


