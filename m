From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: postpone WR initialization during queue
 drain
Date: Wed, 17 Jan 2018 16:10:51 -0500
Message-ID: <1516223451.3403.286.camel@redhat.com>
References: <1515942470-11461-1-git-send-email-maxg@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-h2P88af0KHsrwZ2ugFgo"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515942470-11461-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-h2P88af0KHsrwZ2ugFgo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2018-01-14 at 17:07 +0200, Max Gurtovoy wrote:
> No need to initialize completion and WR in case we fail
> during QP modification.
>=20
> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Patch 1 and 3 applied, 2 dropped.  Thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-h2P88af0KHsrwZ2ugFgo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpfu9sACgkQuCajMw5X
L913HA//T/SiXsZXKRVlN6Z/30OrRk77FJSUZ1ITenpJlCfIya7oC+I8lMwriiCc
Jul2wMIpLcAz1ISzr2RN+gvZatsKRKgyFGcAUVzqDdeG3H9T40QowbYRuLUWxa3V
gKGsNhyOhTHnLIDYnR8CqCt18OUNEIC1ZzIHCETMviOs4XW9gKa/XOOTsm+Ow7P8
lt14b823Aq8oWh0OPa67BH17T/mHVpZmLZdpvZsFBr6qdOwac0GRGf+3d8YuqR+g
Mvx0vHlF3uvI63POWlgy9In6rG9kOjpbCcj7EUfrxI+N/zN75SD4IFdCV368RtLR
WlOkIwpFzBl+DxVdSF86VlfZdmZ/gsLtBJna8VJ9Weuq+62mvR9w7SsOEn23gFC1
KEBFOHGdaHpgf/+L9LFftC4xb95sM6LnvW90sMezfxZlxOWHpWfClOeVYWonUc0U
61vhEJ+uyDtFzsSfDqdz3bZ0Iwu2MKLK28bTKCesaus1AhuTn7VIWliepUVhE/3u
mD2eWk9RZazF1GnuwUV3UNHYH0GmVVdydRCVcY6md5STBRaiprwWf1a2U+HAekbb
dfVmgiSL9o4mqCRvx63FdWjoNt4oinAZjKXSGf9vQ811A706c5DGtx+mrc4EGZcN
Xke0c4nvsEFbYu/JesXoV9c6FDweMRMy2HXFjqb5EZpeRd/JeRw=
=VkN+
-----END PGP SIGNATURE-----

--=-h2P88af0KHsrwZ2ugFgo--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
