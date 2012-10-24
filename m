From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4 for opensm] /etc/init.d/opensmd: Improve systemd integration
Date: Wed, 24 Oct 2012 10:33:13 -0400
Message-ID: <5087FC29.4030303@redhat.com>
References: <505C7D44.9060500@acm.org> <20121024132726.GB18591@calypso>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig75070FA9F62EDDBD8469C28A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121024132726.GB18591@calypso>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig75070FA9F62EDDBD8469C28A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/24/2012 9:27 AM, Alex Netes wrote:
> Hi Bart,
>=20
> On 16:44 Fri 21 Sep     , Bart Van Assche wrote:
>> On recent SLES and openSUSE systems it is necessary to read the
>> file /lib/lsb/init-functions instead of /etc/rc.status for proper
>> integration with systemd. Certain implementations of killproc
>> need a pidfile so make sure that one gets created. Also, correct
>> the opensm service dependency list.
>>
>> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
>> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  configure.in                  |    6 ++++++
>>  scripts/opensm.init.in        |   26 ++++++++++++++++++--------
>>  scripts/redhat-opensm.init.in |    2 ++
>>  3 files changed, 26 insertions(+), 8 deletions(-)
>>
>> diff --git a/configure.in b/configure.in
>> index f660a5b..4515ae2 100644
>> --- a/configure.in
>> +++ b/configure.in
>> @@ -11,6 +11,12 @@ AM_INIT_AUTOMAKE
>>  AC_SUBST(RELEASE, ${RELEASE:-unknown})
>>  AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
>> =20
>> +default_rdma_service=3Dopenibd
>> +AC_ARG_WITH([rdma_service],
>> +    AC_HELP_STRING([--with-rdma-service=3Dname],
>> +                   [name of the RDMA service: "rdma" when using /etc/=
init.d/rdma to start RDMA services; "openibd" when using /etc/init.d/open=
ibd to start RDMA services [default=3D${default_rdma_service}]]))
>> +AC_SUBST(RDMA_SERVICE, ${with_rdma_service:-${default_rdma_service}})=

>> +
>=20
> There is also an option to run opensm with ibsim. In that case neither =
rdma
> nor openibd should run.

ibsim is unlikely to be used by end users or system administrators in a
normal startup environment.  I doubt it needs to be accounted for in the
init script.  Most users simply don't even know enough about ibsim to be
able to use it at all.

>>  if { rpm -q sles-release || rpm -q openSUSE-release; } >/dev/null 2>&=
1; then
>>     default_start=3D"2 3 5"
>>     default_stop=3D"0 1 4 6"
>> diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
>> index 007dae4..ddd1d6b 100644
>> --- a/scripts/opensm.init.in
>> +++ b/scripts/opensm.init.in
>> @@ -7,8 +7,8 @@
>>  #
>>  ### BEGIN INIT INFO
>>  # Provides: opensm
>> -# Required-Start: $syslog
>> -# Required-Stop:
>> +# Required-Start: $syslog @RDMA_SERVICE@
>> +# Required-Stop: $syslog @RDMA_SERVICE@
>>  # Default-Start: @DEFAULT_START@
>>  # Default-Stop: @DEFAULT_STOP@
>>  # Description:  Manage OpenSM
>> @@ -42,14 +42,22 @@
>> =20
>>  prefix=3D@prefix@
>>  exec_prefix=3D@exec_prefix@
>> +pidfile=3D/var/run/opensm.pid
>> =20
>>  # Source function library.
>>  if [[ -s /etc/init.d/functions ]]; then
>> +    # RHEL / CentOS / SL / Fedora.
>>      . /etc/init.d/functions
>>      rc_status() { :; }
>>      rc_exit() { exit $RETVAL; }
>> -fi
>> -if [[ -s /etc/rc.status ]]; then
>> +elif [[ -s /lib/lsb/init-functions ]]; then
>> +    # SLES / openSuSE / Debian.
>> +    . /lib/lsb/init-functions
>> +    rc_exit() { exit $RETVAL; }
>> +    success() { log_success_msg; }
>> +    failure() { log_failure_msg; }
>> +elif [[ -s /etc/rc.status ]]; then
>> +    # Older SuSE systems.
>>      . /etc/rc.status
>>      failure() { rc_status -v; }
>>      success() { rc_status -v; }
>> @@ -61,10 +69,13 @@ if [[ -s $CONFIG ]]; then
>>  fi
>> =20
>>  start () {
>> +    if [ -e $pidfile ]; then
>=20
> On opensm segfault (happens one in a while :), pidfile won't be removed=
, so
> you won't be able to start the opensm again. I guess that same thing ca=
n
> happen on warm reboot.

The stop action in the script should handle cleanup for you.  If it's
called, and a pid file exists, but the pid is not running, it should
remove the pid file and the subsystem lock file so that a clean start wor=
ks.

>> +	echo Already started
>> +	return 1
>> +    fi
>=20
> -- Alex
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig75070FA9F62EDDBD8469C28A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQh/w9AAoJELgmozMOVy/dnfgQAKbhMzDUkMHtXFoUGaWe1zQQ
DON3hoM2IfWbMK2Aovu8DkEkZALKUnyrD1gs3Ks76iD92l1DiIFGjwqH7lDMn9kB
nizGkiQpVsdeUWxH3kpltxMgRpwpeHkuS82FYGrDlUIcjY+IqEQ/psm07D8bj4xG
zvUfVpIHR3mfY7tbFRzMTGZU4U2xnpKV1DTn76vkPGDfHNLOg+7YdFhWIE6SWXZV
3eJsrqZFFMMxyn5XcxvC+Yn6GVDmNQo1w6kL+zgAhdpB4n5/db5FnRtdDVTB9cVc
7I50su+zoPlDimv267tJ6AWbpt0zx4XcIRjYIfoHVM/u/D06l87LC/TzdFUG7qQ8
3X57xRhXcUt6+oCHY/SciPcz646CaXWxu2oFdyyFi0q9PnbKK6zv4ZBgImwciAUf
yUpkLuv0DMbB9K+7o5IcK9gGC9oTsOFS/kNAt3XtI5DKEwniwKbJkyDMPgBJnpYV
hbMpumtUAi33LkhMCCYWHokLWc7Zjqzkklu5tTMTrtX/flraW+CcR5w8l5Z8icSJ
SJddSgZsQk6VggcVdBE8XRyzo8a6g1BPY/3s7vSje1RfxkjvdVRvrTi395gjYIWj
wL5hQRkaSqBklHfbVKyToBP1mOacAepksW/qt2R8PVK/AXXgSnuqOchmhi8Yn/lL
0BXvG2vHLr1yHsGTDUI0
=WU7I
-----END PGP SIGNATURE-----

--------------enig75070FA9F62EDDBD8469C28A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
