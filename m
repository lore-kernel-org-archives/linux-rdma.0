From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/qedr: Fix some error handling
Date: Sun, 19 Feb 2017 08:59:39 -0500
Message-ID: <1487512779.86943.118.camel@redhat.com>
References: <20170218112815.9329-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-UGgB60q0HiriAfa1gEH3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170218112815.9329-1-christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org, Michal.Kalderon-74tsMCuadCbQT0dZR+AlfA@public.gmane.org, rajesh.borundia-74tsMCuadCbQT0dZR+AlfA@public.gmane.org, weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-UGgB60q0HiriAfa1gEH3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2017-02-18 at 12:28 +0100, Christophe JAILLET wrote:
> 'qedr_alloc_pbl_tbl()' can not return NULL.
>=20
> In qedr_init_user_queue():
> =C2=A0- simplify the test for the return value, no need to test for NULL
> =C2=A0- propagate the error pointer if needed, otherwise 0 (success) is
> returned.
> =C2=A0=C2=A0 This is spurious.
>=20
> In init_mr_info():
> =C2=A0- test the return value with IS_ERR
> =C2=A0- propagate the error pointer if needed instead of an exlictit
> -ENOMEM.
> =C2=A0=C2=A0 This is a no-op as the only error pointer that we can have h=
ere is
> =C2=A0=C2=A0 already -ENOMEM
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-UGgB60q0HiriAfa1gEH3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYqaTLAAoJELgmozMOVy/diFEP/10sPSLolkFQ6Q2W5EdSufFD
tRxIx7e3h3/F0kCA1Nxk+Q/nC1p8OQ9cukK1yAtQvWOTy0rylor+jmF22rYqrB/Z
IfEX9pOCYNrPmy1TkuEonT9n3ILaHHXp0kqY2OgAjBV/pSMUl+7FRCM/gObuyXQP
Jr6PlgS2HAqlo5mDSLomrR7a/Nn0JmWa5ETFF9I6UZGKFil+9JS44UV68V1DnrcM
IXd3G5CySlMQP5Mqxq1nEEhvUD2tgDKSg4hgMSuq7ozI0RSNxgfpiM0IYut6nqdq
1CI8nEtswUsTkOIHCtTaKKjjhepUzye/FqwZKcgNqh5mE3CfGc7t2bnQGVT3viaF
f4Y1XicezHDJJ+NM25n0/Bnl5kNtBRWa+pTczQGkW+anFQGAj70XIxNLq9JYoqkT
m73uWIHm5/S72RfeQgOyiRRuxddnphB0J3qWhp43r1GxPPJIc/syBXSNdx2QCs03
Xdl1JmTNI96VUjJeyZekNGzNZxB88j7wSy4h2uSJPOPyxsayMPO++8JZwXdwB8Bv
jUSHeMzB0qkgDNVazQl4oAUZiTDE1SSM84NyHjWYyj9BeJRkJSS7SO8TKyBZPy34
dnH49UYiqxhIVqWK/lny9qkZ/rm27a8ndWmkISD5JVIvImc5tibRXIqQtvp2CYf4
XerV7qyQkJQXKba/zfff
=+CHP
-----END PGP SIGNATURE-----

--=-UGgB60q0HiriAfa1gEH3--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
