From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Avoid crash on pkey enforcement failed in
 received MADs
Date: Fri, 10 Nov 2017 13:26:48 -0500
Message-ID: <1510338408.3735.8.camel@redhat.com>
References: <1509463998-49670-1-git-send-email-parav@mellanox.com>
         <VI1PR0502MB3008E61E5EBFA422FAF52674D15D0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
         <20171103202136.GJ16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-JTai8p+GEwKI1mZN/aOI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171103202136.GJ16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-JTai8p+GEwKI1mZN/aOI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-11-03 at 22:21 +0200, Leon Romanovsky wrote:
> > > Fixes: 47a2b338fe63 ("IB/core: Enforce security on management datagra=
ms")
> > > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Reported-by: Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > ---
> >
> > I think this is needed for 4.13+. I missed to CC stable in this patch.
> > Shall I resend with Cc: or?
>=20
> I believe that Doug will add it.

I did.  Applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-JTai8p+GEwKI1mZN/aOI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloF72gACgkQuCajMw5X
L927Dw//XqktjYWuxFB4NMs8M3jiZfJbpSjnef0MdIbosyWpCVE43bZaqkAJZI5D
zMnobkYP1sHuxZ+NzUA18oOOm8ldI0+4wsw6Q3wOxPI/dPr/D68ZdRG5EBUqyGtZ
HpSuvUNvtyLTkJtfkrYjfISC1+rfFij31ABZaUfGDOSMU3TW8Ng/u9PiKFlElhCp
7T3nnwhksrygnqdaIZRtUjyMf1lpc3GeNDAXP8mGWJ8OsXmOvRhuuAc6zR8DsPUk
wZqYkNO1kg0zQvJ/KzMAJZMG/GWpEdRSNloN77et9nJDwkGJpsi9IWewQatceEFO
g8Aie2dxOlkp1bGcsBgFZsR2bAgVCSMnKyVJ522Gc2sT8xLNc9oytMkYl3Aj67qO
NBZOaG9e1WjJ4k3ncFxqJGXRUtOlOkJ6vo+Ec8ZKtvsa0Oo89mNMD8W2je54x2Ct
kw6Kpzktl+BXLC9Vp6nPQ9G4LyWwa5IfcKcHPNsWO8RmmiD1mGrEQAQJZ/gbhNFO
l/8GQmDf2TNj7IhUkdbrVNj8alLOrnX4P49rI8a/iBCJc9bRT3bc2V59MAQc6Qc4
N8RG8ZgG0kNuDePKFuuIjs+2eeccdcbIEqv02QR4Nc+CDr/2KnKdzYd9axJgb5xf
d3mNTQjd+rhsWWXQCzDLdiQdl+Zb8w/iMtzHt/r7TcrsuPPvN0E=
=nO0Y
-----END PGP SIGNATURE-----

--=-JTai8p+GEwKI1mZN/aOI--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
