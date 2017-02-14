From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Remove unused variable from function
 declaration
Date: Tue, 14 Feb 2017 11:50:29 -0500
Message-ID: <1487091029.86943.82.camel@redhat.com>
References: <20170125182618.24899-1-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-ogU9aLjal6AofWN8FSHv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170125182618.24899-1-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-ogU9aLjal6AofWN8FSHv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-25 at 20:26 +0200, Leon Romanovsky wrote:
> Remove unused netw_view parameter from eth_link_query_port()
> function.
>=20
> Reported-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Hi Doug,
>=20
> This patch was generated on top of Or's patch series.
>=20
> Thanks

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-ogU9aLjal6AofWN8FSHv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYozVVAAoJELgmozMOVy/duisQAJsifysu0VdUhdylqgg7GC6S
ZbHr+rqTPE2Y4lnHpkdTo6+nQRALQX2x95tkGHndm6TAEROmMNTdLTkT8F88nWHb
kmX5JhenrYlZ7nHfmc4uIDyQb+iBaeCoYYZw6Yhl7C0XdZeSxcekXSFd4nzjET9Q
YB8qDsJ0B/1wKqfRR1L2hPsriMf9XXben84N9c2yqERx7zXAF+svcl2zm3BiRped
TpUTJXIOtRx1a55uLT0IS1c5Xt5zkeAbZQ98JTyT96UXSNweNpGdo8MreVkJbzLH
QL/UieD4UC3zWmTuiXVb4K7VdcgN3ykfkGFrdkwq02/dmXt65sPgr9DweoAAiwwV
cdOkTqQrIOak+PfTTl0cyiFRoRLRx5Jy6I5ohtg0n7Uz9JfkidvEtXg6PBXnEMcg
QKPpWiy9+sN3sxJWcvFzEUgHszgAdUy0FgQW/hTs/gTc7Nr5CSwxcNf4Iwgb89EH
Ko3Rh31HfBQpqZwP/zur1QvRKjjIXMHYlJ5ImEEdJT+0m1GYDwM8rAkDm0bJ4jz0
oXo/iuzMeC1S027kF/7vfq/SJQDdHC/QYMQ9qt5do4floSHU2UMmPUytNfPFJ4iv
xmPXzxbNGHFiOCZqv/Ub9etEKBX8Kgtlv3o/HvT/rdcKbciybgOsTlWGuD2zkWoc
BBSManv3m+wX8YBKHpMP
=029O
-----END PGP SIGNATURE-----

--=-ogU9aLjal6AofWN8FSHv--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
