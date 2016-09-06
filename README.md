# Silent Cron

At noris network AG, we have lots of cron jobs that are crucial to our
operations in the long run, but it's OK if the fail occasionally.

These includes:
 * clearing caches
 * updating configuration from our CMDB
 * synchronizing different data storage systems

And they can occasionally go wrong, be it due to network hiccups, maintenance
or other disturbances.

To make sure we notice when they go wrong, we route the cron emails into our
ticket system, and make sure that mails from the same cron job end up in the
same ticket (as long as the ticket remains open, at least).

But that still leaves us with tickets from the occasional failure, where no
human action is required to fix an issue, but the ticket still must be taken
care of.

This is where Silent Cron enters the scene.

## Usage

`silent-cron` is a wrapper that you can use around cron jobs. Instead of
writing

    */5 * * * * user job-that-fails-occasionally

you write

    */5 * * * * user silent-cron --ok 1/5 -- job-that-fails-occasionally

to say that `jobs-that-fails-occasionally` must succeed at least one out of
five times that it's run. So the first four times it fails (which is defined
as returning an exit status other than 0), `silent-cron` suppresses it output.
Only when it fails 5 times in a row does it reproduce the failing job's
output, causing cron to send an email.

## License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but **without any warranty**; without even the implied warranty of
**merchantability** or **fitness for a particular purpose**.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
