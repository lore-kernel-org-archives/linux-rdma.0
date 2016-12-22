From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: further cleanups to depdendencies,
 descriptions, formatting
Date: Thu, 22 Dec 2016 13:41:59 -0500
Message-ID: <f5f043f3-a396-ee44-6f7f-ef3b14daae15@redhat.com>
References: <20161222180220.49558-1-jarod@redhat.com>
 <20161222181323.GA5053@obsidianresearch.com>
 <bf346322-4ef4-032d-9ea2-5a63ae7737e5@redhat.com>
 <20161222183536.GB5660@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ewi1QTUdg3qkwJAtttGEojpLbEloRXOr0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161222183536.GB5660-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ewi1QTUdg3qkwJAtttGEojpLbEloRXOr0
Content-Type: multipart/mixed; boundary="gckTToxP5j7fmBn25NJoFNv7t6Op9pL8n";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <f5f043f3-a396-ee44-6f7f-ef3b14daae15-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat/spec: further cleanups to depdendencies,
 descriptions, formatting
References: <20161222180220.49558-1-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222181323.GA5053-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <bf346322-4ef4-032d-9ea2-5a63ae7737e5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161222183536.GB5660-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161222183536.GB5660-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--gckTToxP5j7fmBn25NJoFNv7t6Op9pL8n
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/22/2016 1:35 PM, Jason Gunthorpe wrote:
> On Thu, Dec 22, 2016 at 01:17:00PM -0500, Jarod Wilson wrote:
>=20
>>>> - Add explicit dependencies on kmod, initscripts and systemd, as the=
re
>>>>  are container and vm cases where there might not be a kernel
>>>>  installed
>>>
>>> Do we need initscripts?
>>
>> Not really sure, the Fedora package reviewer insists we do.
>=20
> Hm, no idea what for. We don't provide any LSB init scripts any more,
> right?

I think this is a distro specific thing.  Last I knew, there might still
be one or two things that haven't been migrated from initscripts to
systemd, or maybe they want the functions that the initscripts package
provides?

>>>> Requires: %{name}%{?_isa} =3D %{version}-%{release}
>>>> +Requires: logrotate
>>>
>>> I don't think we use logrotate for anything unless the srp rsyslog
>>> examples are being used? Maybe it would be better to move the logrota=
te
>>> and rsyslog stuff to doc/examples or something?
>>
>> This is another one where the package reviewer seems insistent.
>=20
> By default "journald -u srp_daemon" does the same job, so I view
> these files as obsolete for pre-systemd distros.
>=20
> I think we should just not include the rsyslog and logrotate config
> files at all. Sophisticated users that need that stuff can install
> rsyslog and setup their own filtering. I assume that is the FC policy?
> That avoids the reviewer comment.
>=20
> It certainly makes 0 sense to Require logrotate without also requiring
> rsyslog because rsyslog is the thing that writes the file being
> rotated...
>=20
> Forcing rsyslog is *really* not desirable, most people don't want/need
> that overhead. Forcing logrotate is not desirable because it forces a
> useless cron job to run and folks in this world are sensitive to that
> jitter..

Agreed.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--gckTToxP5j7fmBn25NJoFNv7t6Op9pL8n--

--ewi1QTUdg3qkwJAtttGEojpLbEloRXOr0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYXB53AAoJELgmozMOVy/dKIwP/1CASVE7irR9apEeO0msFbzo
eYPo5gtF5zIziNyy6RAfmM6UHViimajhVgFkGc3/k9lNFrHwazyXUT5kq67h+wq+
2kKNXOKYgAYBp3u2WEvgnIdUGQ7zZ5XEfDB5O3tltNmh4ExXId8Cqw+26DvXRHIs
RZXSVrP4p04VQLOWvvFjZNDXBj86FT9tfqBDF0gfzQC02Dvia8ycYcPPB9XLRKeX
JzQA7gIYXWs6OaoYylMUx3c/0/uti2zs6Ww60GbVql03TANk2y1mi2zdEnZTkqkv
SGs7hj3JsUXXI1X3m/vCKv/Op5OwkHIH1MOvvoMrjAEbtV8FGf1GX2WJw22Ja/rh
7jnPNEtKNO+r9H49orEaTu1DBC5RTq9+q/Xz1F3CwH4Gv2RuBY83ituGc5ax0ncZ
RWWN0WQnM0kP8g3X4ORMnfntjqAPAc7E4E0Vee3ZWy3/rL7nvbIQsSImAWAJ1RBC
vTRlLpCFNodBhmT1q2zHZwCTlAb6XMQ0BMAwMkGbQ6QBAX8vXEb+N5OEsHyn7ee4
MbzPEFtM1HPGo75/0kPFs3TJNGqEJKbrz8X+VZAf5o1GU6kyNM699jdNbQRwhF7v
U8p/atmIiPRRNU5LaxeVovpp/GpHIcgstU+V+ZYCQ5kC/mqB6c6KKM8MP4HEXoxM
AHRiT1tbay1ZvV1pNxaL
=gt/C
-----END PGP SIGNATURE-----

--ewi1QTUdg3qkwJAtttGEojpLbEloRXOr0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
