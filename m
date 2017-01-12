From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 2/9] IB/ipoib: Set device connection mode
 only when needed
Date: Thu, 12 Jan 2017 13:47:06 -0500
Message-ID: <1484246826.123135.20.camel@redhat.com>
References: <20161228124728.26619-1-leon@kernel.org>
         <20161228124728.26619-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-w0xfDkU33xzuiP3vCPQb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161228124728.26619-3-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-w0xfDkU33xzuiP3vCPQb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-12-28 at 14:47 +0200, Leon Romanovsky wrote:
> From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> When changing the connection mode, the ipoib_set_mode function
> did not check if the previous connection mode equals to the
> new one. This commit adds the required check and return 0 if the new
> mode equals to the previous one.
>=20
> Fixes: 839fcaba355a ("IPoIB: Connected mode experimental support")
> Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/ulp/ipoib/ipoib_main.c | 8 ++++++++
> =C2=A01 file changed, 8 insertions(+)
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index a550cc6..1787f6b 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -474,6 +474,14 @@ int ipoib_set_mode(struct net_device *dev, const
> char *buf)
> =C2=A0{
> =C2=A0	struct ipoib_dev_priv *priv =3D netdev_priv(dev);
>=20
> +	if ((test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0!strcmp(buf, "connected\n")) ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0(!test_bit(IPOIB_FLAG_ADMIN_CM, &priv->fl=
ags) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0!strcmp(buf, "datagram\n"))) {
> +		ipoib_dbg(priv, "already in that mode, goes
> out.\n");

There is no need for any message here. =C2=A0Nothing unexpected is
happening.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-w0xfDkU33xzuiP3vCPQb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYd88rAAoJELgmozMOVy/dc+0QAKpE/u1AUE5hbg69fcShGkPh
k91HMPwYINb4fkUniO+wXiJ4XqC/R5c0qXv+Vhc0+3LO21/GS1l2Pyizgjp2bf1v
HBREhLQadU2jIFjyoHBP2yd3nj+OVHHKnJJgnKaXCH8AkRRQZqTLXRBiWjOzJI3E
NWImtPpNk0s3AmuX+ezFuT97lFmgyqFTmTdRahtbWh9y88IRfhVvDjnvG+OxEwiY
eRLHtC1E1Yui0dLTXCrb6A1x+tbK7T6Lp4jGiDuNOngKzccmlWAt1s/R46GXmWHT
vH/RvbpT/cctX64YlVdsrhzszTz7+aQTEiMbWYVysAT7gdG+BAbd5oAVU1b0N0Gv
J5TUn3BfieD2up/w9qxJhtaOoN8UbfaLQ19o0C/4EAY9UQVhubfARlxxjoa2KbUF
HTP8hWOzOVOdzqDrje1qgF3V78urTDe9wmrbNbyLjQ+9GpYilC5rgj28g8Dss7RM
rp08zqkB/RFk0+Ro8RwnZal4YBeIJUd3EHwsG6XOMI/pPeS81QYcdQdtvWq9lvRt
UyqI6c7lGfyqFLJn2ZaVgBesBFxOlE3C4eommTnhNdhXqaAHjJie+dHMAiTP4Xtw
mkO2LGrmckyTvQVHucpJN7DXwRKfnW1VyXXAA7ujxtkU3ZzvXdVLrv4xQk8XhAN4
pXCyxoGdFxH06B52HGRJ
=WZKV
-----END PGP SIGNATURE-----

--=-w0xfDkU33xzuiP3vCPQb--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
