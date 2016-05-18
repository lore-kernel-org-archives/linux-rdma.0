From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
 resolution module into core
Date: Wed, 18 May 2016 07:47:09 +0300
Message-ID: <20160518044709.GI4662@leon.nu>
References: <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516185434.GC4662@leon.nu>
 <82b21da8-8bec-a7ed-fc48-b7570c0aa4ce@redhat.com>
 <20160517054834.GD4662@leon.nu>
 <910c3e4c-2427-34c4-cc42-f8e951c7d157@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N8NGGaQn1mzfvaPg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <910c3e4c-2427-34c4-cc42-f8e951c7d157-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--N8NGGaQn1mzfvaPg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 17, 2016 at 10:58:19AM -0400, Doug Ledford wrote:
> On 05/17/2016 01:48 AM, Leon Romanovsky wrote:
> > On Mon, May 16, 2016 at 04:27:05PM -0400, Doug Ledford wrote:
>=20
> >> It's not removing two lines.  If someone wants to be able to boot both
> >> kernels prior to this change and kernel post this change, they have to
> >> now write their script to handle both conditions sanely.  And they have
> >> to know to do so, where as very often they simply get caught off guard
> >> and things are broken for some period of time.  If the change to ib_ad=
dr
> >> actually solved a problem that couldn't be solved otherwise, that would
> >> be one thing.  But it doesn't.  It's a complete no-op.
> >=20
> > I think that your position is too tight for not allowing modules
> > restructure. It looks like that this complexity doesn't exist outside
> > testing scripts.
>=20
> No, they were/are production scripts.
>=20
> > For my testings, I'm using Debian Sid with inbox scripts/packages and i=
t handles
> > correctly IB stack with different kernels and different set of modules.
>=20
> Does it support reloading the stack and have you tried it if it does?

It is RedHat specific, from my understanding in other distribution there is=
 no
special script to reload RDMA, I wrote for myself module reload script
for debug.

>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--N8NGGaQn1mzfvaPg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXO/PNAAoJEORje4g2clin6SkP/12QLC2kEcuFSeZV74yEYURR
cJ515NIU4RMmcnWwsJbw+32TB1tK8hYodZ71yPWLp9FjhqlJR0aMU5aFXqAABCiA
GdYoyh89WpWRAtYH1n/6GBNC1a6g0io2JSke7boBc30F8QwW404cwEepSYT2iaK7
FBmw8iejSZ0zQPyOAPmXSPyXQyfZUnv3XGXUo94fJ7LtN9yCynEEj9Val0rdiDsY
r5mStpIxYJ6on7O2VBCpP5h1p53UrdUaHR/MLryzpgO+FBoNSolDVVLafwTg46XN
/qXWEMWUZJ+fjw+UIZQlgLqhPU6wYlz8MRRE/dLzThscyUKyeFylRazTRAdFMA+t
ARu07yuEM6JNX6pt/RpFfBICmIF0bAOCPcy0GdWiKLSlphVl4xfcRR/gEjlu4Syz
t9i4SBsPKXRYjNQg+ycJGNLP8T3YP2UVHROxNq9tG7Igb4EFpQSduxsKidwwGbMN
pRlETS/vEftyIkJR9gYnPVtEv54APczO4wsWA7km02yUgia95K/OLOhwhip6sKq2
5a/zWtQZZO85PTJDTzABLGU+sYVmbBMO98AeCilrRm+EFFjpqXPj7KvSYN3of/yR
gJbwLjdC1iOO33Vp8NeLDIobKL19yCNt4OgRrrsW1f8Yn8fshsnevz9lyi4SHxLw
s0QjaZpnlO7EeAchOgyk
=7i62
-----END PGP SIGNATURE-----

--N8NGGaQn1mzfvaPg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
