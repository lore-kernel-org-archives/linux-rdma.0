From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next] RDMA/hns: Remove unnecessary
 platform_get_resource() error check
Date: Wed, 17 Jan 2018 16:17:00 -0500
Message-ID: <1516223820.3403.288.camel@redhat.com>
References: <1516188518-147200-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-xUO5f7iy9I5X4HV9iRYU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516188518-147200-1-git-send-email-weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-xUO5f7iy9I5X4HV9iRYU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-17 at 11:28 +0000, Wei Yongjun wrote:
> devm_ioremap_resource() already checks if the resource is NULL, so
> remove the unnecessary platform_get_resource() error check.
>=20
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-xUO5f7iy9I5X4HV9iRYU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpfvUwACgkQuCajMw5X
L930SA/9GBgKTyZxZj0bh3WVwZPKAXrbacvqUhHABJ0hB8CXesyzCNmoDvdAJaex
f03+U/woQF64lC8KdOPpyyW37DW1wzMOzOHlLCO/kIO13JqZCLMpCXwlvQ3RiOBG
MKn9mRaoB6s+YzGjiZm5krQQGYLsmYY+CN4RdE28Eo6402XkfTMQIuZuiNrDzpyj
OBRjP5RpRZZm0Y6kHfKxCkCAqTC2e8RZYH7IPHyQE/EBkNbd90hbRqO1VojCxB+V
4B7vVcE5He3oJyX99SImu5LBIIA6Vj0wi7rOQHXQXQGMch91VeDJw6xBDJR1on5h
ugWcLpqa9v518yqXYQVvSg2/lh4ro3Vz2t5MZGQW2zHU1UcPKWg6rZ3mEXUGDkdA
1KgJ0QPLDhF1Y67Bs8jAcGnptAZ0qdDxbtGQzA9/9UIsKsuTKQ+W/lxqk12taQLX
hlSZY98lWT+XoaytrcrU/H7ctMOvHt5g/FpfVn381jf1KF448h6Wzl6YkDjCrk99
h2Cy69Yp3gzTX+Qpdu1tAZzhdUO0ptAUfJusaGQ3cSCk/HO7yZ0Zz7XKXb1EO8tb
z6nS90cC1zaWOv9ObkbUp7zxdFfJLe9aASg/ywhVQfAxnxLPBh7LGtzXkcrYppmP
2bkm6LzbyaP1cVgy66HJnFFvqIXqd+XLaJFh3959dclsPxS5DwU=
=Ac+K
-----END PGP SIGNATURE-----

--=-xUO5f7iy9I5X4HV9iRYU--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
