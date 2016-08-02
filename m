From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/ipoib: Report SG feature regardless of HW UD CSUM
 capability
Date: Tue, 02 Aug 2016 15:11:19 -0400
Message-ID: <1470165079.18081.31.camel@redhat.com>
References: <1469003406-1540-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-KhuojAjd1eZpmZOcga7W"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469003406-1540-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-KhuojAjd1eZpmZOcga7W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-07-20 at 01:30 -0700, Yuval Shaia wrote:
> Decouple SG support from HW ability to do UD checksum.
> This coupling is for historical reasons and removed with 'commit
> ec5f06156423 ("net: Kill link between CSUM and SG features.")'
>=20
> During driver load it is assumed that device does not supports SG.
> The
> final decision is taken after creating UD QP based on device
> capability.
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
> 	* Fix patch title
> 	* Move settings to ipoib_setup instead of ipoib_set_dev_feature
> v1 -> v2:
> 	* Move settings to ipoib_transport_dev_init
> ---
> =C2=A0drivers/infiniband/ulp/ipoib/ipoib_main.c=C2=A0=C2=A0|=C2=A0=C2=A0=
=C2=A0=C2=A03 +--
> =C2=A0drivers/infiniband/ulp/ipoib/ipoib_verbs.c |=C2=A0=C2=A0=C2=A010 ++=
+++-----
> =C2=A02 files changed, 6 insertions(+), 7 deletions(-)
>=C2=A0

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-KhuojAjd1eZpmZOcga7W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoPBXAAoJELgmozMOVy/dHCgQAI7lTkX3tchg1O5Q3bnheR0f
5h3iNBzkggFlwUUCewm2rsezYsPr7cdSMZ7t+ekwwt4NvEm9VQybZarZuqHGVC2n
pytNPn4fMyG+vBb+QNxpS5hm6bs3legiA94mtgcdm4v+RHzrXAs0DkhauXgGXi5J
6EQljZDCQxuDLy0nk8wWnAja6VM7IP6JuqYWeugsME15g2guPVz9eKDIahjxsSvh
HYQphnCddiTFDAOFRlBW+k5N42bZxf0DUOF3ZS+KT6s6rRwlm31rKgriJZBhSGts
AB/bO2uNTjzZjga6mp1NKBJZ6IFLznlb6O7ktuNonywHlUertwtxuFjDyGLlcldS
emv7vfBtpes0YkOAMICidCSEvfBvx3csJAj+2RhgtSbnXMQhVXHm+pB6eM/YqRRF
U9g7eZIb5vkjVeZU40K6GcYc5X18x06E7iDzz4fWs+wGsRWr9FUryeL/+sYARKpk
uIZ6Hr9AEoJV+gDWmcMckUDkswE2712rn6TSzQG5RiiqNdA5ExxnzahoT9rTLnmx
xcHfeaH0+pYv5RdQKw62wdtN6qr5i2Zur+JelhodXBY7A3IjljmfGHA7/HdobM3+
qk6ZFiJUW+jY7LAyFDCGEys/z4X+NPE41UPdItRlQL8zB4wkokPEQO3KgLQQUzQ1
CuK5M6aDgn6ngV1tGaXB
=4JmD
-----END PGP SIGNATURE-----

--=-KhuojAjd1eZpmZOcga7W--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
