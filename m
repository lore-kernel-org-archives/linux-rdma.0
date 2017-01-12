From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/9] IPoIB fixes for 4.11
Date: Thu, 12 Jan 2017 14:02:17 -0500
Message-ID: <1484247737.123135.21.camel@redhat.com>
References: <20161228124728.26619-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-tnC0/4Ot94WoeNcAWtD2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161228124728.26619-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-tnC0/4Ot94WoeNcAWtD2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-12-28 at 14:47 +0200, Leon Romanovsky wrote:
> Hi Doug,
>=20
> This is secnd version of 8 patches from Feras for IPoIB.
>=20
> The patchset was generated against v4.10-rc1 and targeted for 4.11.
>=20
> The patch "IB/ipoib: Fix deadlock between rmmod and set_mode" which
> fix kernel panic
> is marked as candidate for stable tree inclusion.
>=20
> Available in the "topic/ipoib-fixes-4.11" topic branch of this git
> repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/
> ?h=3Dtopic/ipoib-fixes-4.11
>=20
> Thanks
>=20
> Changelog v0 -> v1:
> =C2=A0* Patch 2,5,6 - add Yuval Shaia's ROB tags
> =C2=A0* Patch 7 - remove __func__ prints
>=20
> Feras Daoud (9):
> =C2=A0 IB/ipoib: Add warning message when changing the MTU in UD over the
> max
> =C2=A0=C2=A0=C2=A0=C2=A0range
> =C2=A0 IB/ipoib: Set device connection mode only when needed

I fixed up both of these patches according to my comments.

> =C2=A0 IB/ipoib: Fix deadlock over vlan_mutex
> =C2=A0 IB/ipoib: Fix deadlock between rmmod and set_mode
> =C2=A0 IB/ipoib: rtnl_unlock can not come after free_netdev
> =C2=A0 IB/ipoib: Add detailed error message to dev_queue_xmit call
> =C2=A0 IB/ipoib: Use debug prints instead of warnings in RNR WC status
> =C2=A0 IB/ipoib: Replace list_del of the neigh->list with list_del_init
> =C2=A0 IB/ipoib: Change list_del to list_del_init in the tx object
>=20
> =C2=A0drivers/infiniband/ulp/ipoib/ipoib_cm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0| 30 ++++++++++++++
> ---------
> =C2=A0drivers/infiniband/ulp/ipoib/ipoib_main.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 34
> +++++++++++++++++---------
> =C2=A0drivers/infiniband/ulp/ipoib/ipoib_multicast.c |=C2=A0=C2=A06 +++--
> =C2=A0drivers/infiniband/ulp/ipoib/ipoib_vlan.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 10 +++++---
> =C2=A04 files changed, 52 insertions(+), 28 deletions(-)

Thanks, series (after modifications) applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-tnC0/4Ot94WoeNcAWtD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd9K5AAoJELgmozMOVy/dpyYP/1dkOjGwd7zVdHAY/dCfxXMH
fwxrh0lL5/vZTMXet2aPwl2H2zk9Ly+Uy9KrSFf4N8ACGJVuW6xby/ZshqIv/090
xHs5m9mCW4WXp4qK6UyTZW1QzeGPFeybHPa5fnsZ6++fdjUXMIOzlqTYsZ+GSLAW
FyXm39ZKo6axLb/K22TYthe1g3fQE5M4d5qIPWMd1S3/qycMymqb7F4d/QyfkxB6
bueZ1j4z5SWNTSkCkcyo0jQwlF+GY48GkyWDpiYd7hKm6Tbtg1XoPwubsAWnLJp5
ly2batZajDQTU83RL+ZmbWauuOVoQlybus4fBRWDCZLScpx5JpoUI4SVAeJbmgrM
vH4kgQLnRGzoO4osRfZI+KQaJpv2ooDQPgqL/a+JnujaAo2vYVK4k1Y2OeV0u22B
eBt+JpzXi+Lj00i03A08Ic6/oxuPRnuJGZp3tiPJ+UnuWrCld7eLDKdQf2awJjvF
YJlYJjAaMbnkM5VU+ld0MGy3LwDbLoNFTZBRMDDkDmC3e105ZIRVv5Zze3jfKThK
TgGVzAtGMR9OFg/h55Ml57WLCVcSL5uqgdL9v4SzctJcPDJggPwMQdYGNbygyMw/
t4TM0MpP/XFP/x1ExNdM4y02DLr+kAjHOb6EHqw1i7GmvqShdXHgzYvQVojsVedt
IoAzJoK0nsiCd4J/Svm+
=RwHt
-----END PGP SIGNATURE-----

--=-tnC0/4Ot94WoeNcAWtD2--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
