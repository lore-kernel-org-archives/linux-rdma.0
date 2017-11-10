From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/rxe: don't crash, if allocation of crc algorithm
 failed
Date: Fri, 10 Nov 2017 13:44:05 -0500
Message-ID: <1510339445.3735.10.camel@redhat.com>
References: <20171031101647.45111-1-tbogendoerfer@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-6CjJ57iJDD11Ajmy9odq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171031101647.45111-1-tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-6CjJ57iJDD11Ajmy9odq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-10-31 at 11:16 +0100, Thomas Bogendoerfer wrote:
> Following crash happens, if crc algorithm couldn't be allocated:
>=20
> [ 1087.989072] rdma_rxe: loaded
> [ 1097.855397] PCLMULQDQ-NI instructions are not detected.
> [ 1097.901220] rdma_rxe: failed to allocate crc algorithmi err:-2
> [ 1097.901248] BUG: unable to handle kernel
> [ 1097.901249] NULL pointer dereference
> [ 1097.901250]  at 0000000000000046
> [...]
>=20
> Reason is that rxe->tfm is assigned the error return, which will then
> be used for crypto_free_shash() in rxe_cleanup. Fix by using a
> temporary variable and assigning it rxe->tfm after allocation succeeded.
>=20
> Fixes: cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-6CjJ57iJDD11Ajmy9odq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloF83UACgkQuCajMw5X
L93QWQ/+NLb1x14qZ7/0XQuqG88NziQFzOC6FSF0qdApIawCIngxeRg18E396LHd
8QChevGeVxoUYwp/9zUrHuiwigBgzw2xg9p3X/ezjdHGDWlN07n46fKeBb6B2qik
7+Ffnxe1SZti4AxdMmCEB4mqxcShWrGiPgHvWHIzq4Ghh4jGrKHn6GOcSjjc0GdA
aYss9y6gYzwl65dCeUQgoFEyRDbRmNIatLfMhQCLxox3fYBSUwK5AJXmjaQYAqP4
xOvyqgdTojK/67spmRduRWjQt+ch1m5asvmGLfhCkDugH8HQeISw2Gur5U5yjPAJ
9pE1teaeT4rK18PjmU0n7dVc3aRbHVRNTMhfIC/MfoVz5ch/hnnWnwRMnfqJpzTH
zN1G9N5urCpvb2YZ4S/qrf+hBAkgcB7VHdAq4o8lppvlo2VCk0YQ9N5r/38KnaJF
Dwy9xJDHWIOoOfrEOECV7j8U9Q9g4YxMMwPnb2DnJUZ8LCBOtyS9B3cIaWXJAMd+
8SZJnn3sfCBs5b9HxBRiF/sDaGWJyB9TclQ9KNjNSgjWlVa0vZ31uT6g1y3okNWV
8jfq0x8B7r2pahZkgQq5SSFrH/laIT6C63UfBWRu7RfpG6N3aziXnIStfbeNmgVt
kZS8sFDXn9ZuYLc78qNd6raMk0ptI4sNxQpL551FCzLr3yrPJeA=
=WUg9
-----END PGP SIGNATURE-----

--=-6CjJ57iJDD11Ajmy9odq--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
