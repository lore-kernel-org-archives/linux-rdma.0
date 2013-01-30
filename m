From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] opensm/configure.in: Remove Default-Start from opensmd
 init script
Date: Wed, 30 Jan 2013 12:48:05 -0500
Message-ID: <51095CD5.80503@redhat.com>
References: <20130129171850.GB2961@calypso.mtl.com> <5108E0F6.3060602@acm.org> <51093F8E.10905@redhat.com> <51094393.1060102@acm.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2TDTXLXBSTUBWPIOPHWDT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51094393.1060102-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2TDTXLXBSTUBWPIOPHWDT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 1/30/2013 11:00 AM, Bart Van Assche wrote:
> On 01/30/13 16:43, Doug Ledford wrote:
>> On 01/30/13 03:59, Bart Van Assche wrote:
>>> On 01/29/13 18:18, Alex Netes wrote:
>>>> During opensm RPM packaging, `chkconfig --add opensmd` is called.
>>>> `chkconfig --add` creates the appropriate entry as specified by the
>>>> default values in the init script. Having opensmd run by default on
>>>> boot
>>>> isn't desired.
>>>>
>>>> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>>    configure.in | 5 +++--
>>>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/configure.in b/configure.in
>>>> index 4515ae2..f798be2 100644
>>>> --- a/configure.in
>>>> +++ b/configure.in
>>>> @@ -18,12 +18,13 @@ AC_ARG_WITH([rdma_service],
>>>>    AC_SUBST(RDMA_SERVICE,
>>>> ${with_rdma_service:-${default_rdma_service}})
>>>>
>>>>    if { rpm -q sles-release || rpm -q openSUSE-release; } >/dev/null=

>>>> 2>&1; then
>>>> -   default_start=3D"2 3 5"
>>>>       default_stop=3D"0 1 4 6"
>>>>    else
>>>> -   default_start=3D"2 3 4 5"
>>>>       default_stop=3D"0 1 6"
>>>>    fi
>>>> +
>>>> +default_start=3D"null"
>>>> +
>>>>    AC_SUBST(DEFAULT_START, $default_start)
>>>>    AC_SUBST(DEFAULT_STOP, $default_stop)
>>>
>>> Sorry but this patch doesn't make sense to me. This patch will preven=
t
>>> anyone to enable opensm to run during boot via chkconfig.
>>
>> It does not.  It means that chkconfig add does not create any start
>> links, just all kill links.  To actually enabled it, chkconfig --level=

>> 2345 opensmd on will still work.  Which was the intent: leave it off b=
y
>> default, enabled by the admin.
>>
>>> How about
>>> replacing the above by the (untested) patch below ?
>>>
>>> iff --git a/opensm.spec.in b/opensm.spec.in
>>> index 6ae525b..2325b70 100644
>>> --- a/opensm.spec.in
>>> +++ b/opensm.spec.in
>>> @@ -107,13 +107,6 @@ rm -rf $RPM_BUILD_ROOT
>>>
>>>   %post
>>>   if [ $1 =3D 1 ]; then
>>> -    if [ -e /sbin/chkconfig ]; then
>>> -        /sbin/chkconfig --add opensmd
>>> -    elif [ -e /usr/sbin/update-rc.d ]; then
>>> -        /usr/sbin/update-rc.d opensmd defaults
>>> -    else
>>> -        /usr/lib/lsb/install_initd /etc/init.d/opensmd
>>> -    fi
>>>       if type systemctl >/dev/null 2>&1; then
>>>           systemctl --system daemon-reload
>>>       fi
>>
>> This is not the correct fix.  It leaves the init script unadded to the=

>> system, which means chkconfig --list will not show it properly until t=
he
>> user manually adds it later.
>=20
> Which convention is followed for other packages ? This is what I found =
in
> the Fedora 18 iscsi-initiator-utils package
> (http://be.mirror.eurid.eu/fedora/linux/releases/18/Fedora/source/SRPMS=
/i/iscsi-initiator-utils-6.2.0.872-19.fc18.src.rpm):
>=20
> * iscsid.init: Default-Start: 3 4 5
> * iscsi-initiator-utils.spec:

Okay, first off, any package that still uses the SysV initscripts as of
Fedora 18 is not what I would call a package that is keeping up with the
Fedora packaging guidelines or Fedora technologies.  As such, I'm not
really sure you want to use it as an example of a good package.
However, that being said, you will note in this spec file that the iSCSI
initiator package does exactly what you removed, or suggested be
removed, from the opensmd spec file.  It unilaterally adds the
initscript to the system.  The default start/stop settings are
different, but the add action is the same.

All initscripts should be added to the system, regardless of their
default start/stop settings, and the default-start and default-stop
should be used to control *how* they are added by default, and chkconfig
--level .* <scriptname> [on|off] should be used to control whether or
not they are on or off differently than their default settings.

> %post
> /sbin/ldconfig
> if [ "$1" -eq "1" ]; then
>         if [ ! -f %{_sysconfdir}/iscsi/initiatorname.iscsi ]; then
>                 echo "InitiatorName=3D`/sbin/iscsi-iname`" >
> %{_sysconfdir}/iscsi/initiatorname.iscsi
>         fi
>         /sbin/chkconfig --add iscsid
>         /sbin/chkconfig --add iscsi
> fi
>=20
> Bart.



------enig2TDTXLXBSTUBWPIOPHWDT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRCVzVAAoJELgmozMOVy/dMTAQAJqdsljZi4cHdTEeoJOMp6zB
6ujUijo4g8cWUcprVXUWUZTipi5/tYiZrBco332oJZE1bePxxTGNnKt2kM71sin8
f7u8H1Q6HhbSxI5KIN8GfKOG1C7lbAzyhVBuHATSkjNS6tAVgxcAnzaCWO61OnRX
75in/CuDZjMQn+j0b8V1hrxP2GsdXAS3xfuj5PLC3xaxo0izG21FFzCHxlNCeZKF
ZEpyViCecf6/NcXu4E1W0eT18rLMnhiUvv24+F+lCdW7rPbuixnQRPd+I57n4/06
A7FcDJf0rXfPm5teLluqZ2OmEVixvVRgYzq1BAraxwN5Cu0hisx/Xbjz78MXkRZh
Mqyelt5CrfPBZ2lm5QpPbkPSwoHJg618T22YFi0UeMs4o8vhJ75BgvXfWZkXQdho
SiRPJBg1VFD33XH6alSuCeqpQ7N3GXnN/BJgLJuqMssAeH6Qa2bgi0G/05WN7qN0
6jVIlLxZ1R1tfnK+YdrSqvlPQqbr0Gz/xJYvHR/vPNpgBgU8pyENkSCIdoqePkxT
qiEOX0NmR9ke3j1HUhPZQJdsgJsq168pulJ+n0CYMmfXDX5muD9pSkcVGgGLw1Vd
E4kit6VqVG5OrK+JtWbTSgRju83RK0lHsGLiwkTzbYN6NHlm2WsVWyNACaF4zQCq
zcb4RdI2a58PqWG4dmTN
=y4X5
-----END PGP SIGNATURE-----

------enig2TDTXLXBSTUBWPIOPHWDT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
