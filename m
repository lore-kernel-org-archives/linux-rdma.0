From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Fix RCU annotations in ipoib_neigh_hash_init()
Date: Tue, 26 May 2015 11:55:21 -0400
Message-ID: <1432655721.28905.116.camel@redhat.com>
References: <55646F34.9010803@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-v42UnGBlGBiPyz2LyUt/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55646F34.9010803-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-v42UnGBlGBiPyz2LyUt/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-05-26 at 15:03 +0200, Bart Van Assche wrote:
> Avoid that sparse complains about ipoib_neigh_hash_init(). This
> patch does not change any functionality. See also patch "IPoIB:
> Fix memory leak in the neigh table deletion flow" (commit ID
> 66172c09938b).
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniba=
nd/ulp/ipoib/ipoib_main.c
> index 9e1b203..fec8207 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1128,7 +1128,7 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_p=
riv *priv)
>  {
>  	struct ipoib_neigh_table *ntbl =3D &priv->ntbl;
>  	struct ipoib_neigh_hash *htbl;
> -	struct ipoib_neigh **buckets;
> +	struct ipoib_neigh __rcu **buckets;
>  	u32 size;
> =20
>  	clear_bit(IPOIB_NEIGH_TBL_FLUSH, &priv->flags);
> @@ -1146,7 +1146,7 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_p=
riv *priv)
>  	htbl->size =3D size;
>  	htbl->mask =3D (size - 1);
>  	htbl->buckets =3D buckets;
> -	ntbl->htbl =3D htbl;
> +	RCU_INIT_POINTER(ntbl->htbl, htbl);
>  	htbl->ntbl =3D ntbl;
>  	atomic_set(&ntbl->entries, 0);
> =20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-v42UnGBlGBiPyz2LyUt/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVZJdpAAoJELgmozMOVy/dop0QAKciY0nBcvrfHvCFp538v4+9
Q3vAPpPC5bGxPREDIU/7j41kx3LeY0mTj7RYmIypwHu1RQ+GKrqZJpNd+WXKW7uk
8W6sQ5d2GDErApKD+MowIFi8JmdLYSHZFi1qZi2MlP4hE6dgxRtqgKW5b9R01Vgp
sKkeCG8Yaw6opI6qtj0oLApXqycDlMIgz1m3Q9J5OeSTHWk71lIg8ot6207uUp5a
QWfe4Wl70jTDKmJ+v4NCSRprrR7oHSiAoz/2DjYMWpkCawAPlnTVeLeCDAhnNcqu
+B8R2xIQ+b5wGnBXeBE8D+5gBet0gyid7NgWgxZVtOr3CnAkl0cp8eRjdeC5Uc4g
sDdBmj+hBWTmNUy9fNsNR2zXlfuVjgwHXzLOAwXY2/4tog1DzC2gAD33lF3Rp/YJ
+cWe7aQSf59b6v4Rih+DQ5Q/tWUBXYkRZDkcyQPr383qVBTbPKXVOlGN+t119sti
nHG/a4FtMVLqh0i4/ZzulPiffoxfBmY6lkk+hOqJmPQtaJdKJX8Nu9uqa8T2IGan
fIr1P+4NN0l1UBWXvrmcpfaBSi688mH6ScGMuHyz4LyslSuuP2pYQUs1iWVgvLxe
pEO8V/PzoqivnXhZb3J1Ho5YYj04ag8qufJrHRv7MJIjEgPOS0p7kAYJl398vOBD
CixIVT+gD9dLwQbJLtFp
=xfHD
-----END PGP SIGNATURE-----

--=-v42UnGBlGBiPyz2LyUt/--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
