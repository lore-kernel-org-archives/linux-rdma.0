From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v4 0/3] IB/ipoib: Use dev_port to disambiguate port
 numbers
Date: Thu, 13 Sep 2018 12:50:00 -0400
Message-ID: <5568f0883a4c8a6e09f566ffc17b74b2bee8f4fe.camel@redhat.com>
References: <20180906145112.29245-1-ar@cs.msu.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-HvWxDXLBmcsfo13Ic/hc"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180906145112.29245-1-ar@cs.msu.ru>
Sender: netdev-owner@vger.kernel.org
To: Arseny Maslennikov <ar@cs.msu.ru>, linux-rdma@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-HvWxDXLBmcsfo13Ic/hc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-09-06 at 17:51 +0300, Arseny Maslennikov wrote:
> Pre-3.15 userspace had trouble distinguishing different ports
> of a NIC on a single PCI bus/device/function. To solve this,
> a sysfs field `dev_port' was introduced quite a while ago
> (commit v3.14-rc3-739-g3f85944fe207), and some relevant device
> drivers were fixed to use it, but not in case of IPoIB.
>=20
> The convention for some reason never got documented in the kernel, but
> was immediately adopted by userspace (notably udev[1][2], biosdevname[3])
>=20
> 1/3 documents the sysfs field =E2=80=94 that's why I'm CC-ing netdev.
>=20
> This series was tested on and applies to 4.19-rc2.
>=20
> [1] https://lists.freedesktop.org/archives/systemd-devel/2014-June/020788=
.html
> [2] https://lists.freedesktop.org/archives/systemd-devel/2014-July/020804=
.html
> [3] https://github.com/CloudAutomationNTools/biosdevname/blob/c795d51dd93=
a5309652f0d635f12a3ecfabfaa72/src/eths.c#L38
>=20
> v1->v2: replace a line instead of inserting and then removing.
> v2->v3: restore both attributes, output a notice of deprecation to kmsg.
> v3->v4: style adjustments, join the deprecation notice to single line.
>=20
> Arseny Maslennikov (3):
>   Documentation/ABI: document /sys/class/net/*/dev_port
>   IB/ipoib: Use dev_port to expose network interface port numbers
>   IB/ipoib: Log sysfs 'dev_id' accesses from userspace
>=20
>  Documentation/ABI/testing/sysfs-class-net | 18 +++++++++++++
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 33 +++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
>=20

Series applied to for-next.  But I think we should watch feedback from
people, and if people think the notification about using the wrong
variable is too noisy, then we might want to revert it or modify it to
only print out once per specific executable instead of once per run of
each executable.

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-HvWxDXLBmcsfo13Ic/hc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlualTgACgkQuCajMw5X
L91oag/+JHjOIatHdHos86W7I0xh4oijKEuy6yd8igFDW3aRWuajxqzg53zR+i9M
bmRRO8bOaetjy84jiWypbapfxuAWjZ/TMHsAXstuxbSVQ1eU46sLPlw7qQXy0HAi
qdeBzM6TuU3JByQ5fu1p4l2tAFFSRMB7clVph3c0fzY5DGs7rwz7SIBfCfPXcw05
cQwDMXHt4+9fHFYRz3Aya6uRXHeS91X8en6hmCPPdQMqI75Yxvo4ak4w6J0FgAFm
aGwYnCUKP1Zrac+oupcoddKoz6HhMZ7b8+XUQ4Lng//AvOn/lyTdxApK0yWu5HGH
6IXiagEiZsDkQ4rn01bEWh6PX1VbE18rlCJJJSfhdU5x0NjFzcfd8te+7A4R5yxE
rDpkhyr3BrPWgTxLjrNjUnJmcYXPJTgGFHdmYb/RqAUHVsVUNKK+dcI3tibwaez+
xbKqS5xRdNWzzqupyWT3637QmA5NK0x6M1N8mErhRQ2vA4mHkpWiLUcge2HNTOmC
2xiQn+b9b/MKwHoZT+MqYY0dWseylo1hkrR0CnqBLoi8k7sSpKZ9tRwm4eQcduQj
RASiWETBF/LG1QSRukX5Lv4Sz2x0YdNP+wFem/cUqW/+t/BI9FjKODkV5qZ88OO8
EIugff0bCt+UwpwrCIG7fSy1MAqRqRL1iYgYN2Aw3/Dpg+rxKWc=
=2Ndq
-----END PGP SIGNATURE-----

--=-HvWxDXLBmcsfo13Ic/hc--
