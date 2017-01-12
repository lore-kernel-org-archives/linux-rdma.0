From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/9] IB/ipoib: Add warning message when
 changing the MTU in UD over the max range
Date: Thu, 12 Jan 2017 13:46:16 -0500
Message-ID: <1484246776.123135.19.camel@redhat.com>
References: <20161228124728.26619-1-leon@kernel.org>
         <20161228124728.26619-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-AN6nfJu+GqxLfy7xklMg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161228124728.26619-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-AN6nfJu+GqxLfy7xklMg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-12-28 at 14:47 +0200, Leon Romanovsky wrote:
> From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> In datagram mode, the IB UD (Unreliable Datagram) transport is used
> so the MTU of the interface is equal to the IB L2 MTU minus the
> IPoIB encapsulation header. Any request to change the MTU value
> above the maximum range will change the MTU to the max allowed, but
> will not show any warning message. An ipoib_warn is issued in such
> cases, letting the user know that even though the value is legal,
> it can't be currently applied.
>=20
> Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++++
> =C2=A01 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 3ce0765..a550cc6 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -229,6 +229,10 @@ static int ipoib_change_mtu(struct net_device
> *dev, int new_mtu)
> =C2=A0
> =C2=A0	priv->admin_mtu =3D new_mtu;
> =C2=A0
> +	if (priv->mcast_mtu < priv->admin_mtu)
> +		ipoib_warn(priv, "MTU must be smaller than mcast_mtu
> (%u)\n",
> +			=C2=A0=C2=A0=C2=A0priv->mcast_mtu);
> +
> =C2=A0	dev->mtu =3D min(priv->mcast_mtu, priv->admin_mtu);
> =C2=A0
> =C2=A0	return 0;

I don't like this patch. =C2=A0First, there's no need for a warning here.
=C2=A0That's entirely too noisy for this issue. =C2=A0Second, the wording o=
f the
message is poor. =C2=A0The user thinks they are setting the MTU, and there
is no means of setting a multicast MTU, so telling them that their new
MTU must be less than the mcast MTU that they can't do anything about
and don't necessarily know how it is generated makes no sense. =C2=A0This
should be no more than ipoib_dbg if we even print anything out at all,
and the message should be more like "MTU must be <=3D the link layer MTU
- 4, use ibv_devinfo on the RDMA device to get the link layer MTU"

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-AN6nfJu+GqxLfy7xklMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd874AAoJELgmozMOVy/du38P/A1Hw7goYxYhx3oTbgbKZejS
RH01GbxxYBvP7mF1O5TBKLZdltrh9PLoLUmJ8NbTZwkroPmuWyY3yjrjDgbkWUnZ
DBXHRXJyFW0HlbO0lEOijUpQGkJlYdblxLDUUOJ7Ne2hzTcXsOBmDqtQuJkvIgaV
7ctZ/vtM3rvIZXfZrGaz4uujOr+m/il9gCp1iF2tCDuVq2JyqkAOe8TI94CcxdeS
5CayyNVQF5oVd6hpnbR2XwILlrd4NPpgOtCc17yORucvZnNj8mSbgYPkMCe6JRKi
DGxDHIYTm0MkInCMJWriOURCf79dbjN4TVVS6d5r1U6Whmag3Xf1rvhUT5BG+CO0
mtbD4ozR9/nvlPo5QGsQHOCTFXAt7eFtgWbH664eOEqUtRFqNQz1qx7qgDaUzoNQ
wzZz23heeA3m8cuHO317LMzyRGU+4I77SMxpWlGhpTavEGrF3wsS7OJPqdo47IGW
aNUaSnk021ZRxTjpKE8Hh1miyCDNJY+5/dS39FErjOQ3P8XZIksIZkJ7ZsiyHWH4
PTJqMr5mEzPvEfW3D/iSfqPrnZQMI4uRINdDKnYDZUjunTs6lBu4Y8al8Wp1tUnr
LOFhvFLKmCZslYPgDlIPb9vsK9mGYuavcBwyhOr5RK/uKn9LXGSq0E3zkt2IxywW
nSmE9QS4gxKySvxbO7Pv
=is+D
-----END PGP SIGNATURE-----

--=-AN6nfJu+GqxLfy7xklMg--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
