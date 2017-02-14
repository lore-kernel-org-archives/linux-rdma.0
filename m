From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v1] IB/mlx5: Fix blue flame buffer size
 calculation
Date: Tue, 14 Feb 2017 13:40:29 -0500
Message-ID: <1487097629.86943.83.camel@redhat.com>
References: <20170209173147.20528-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-VDnBNFU26ebdl77gl8Mt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170209173147.20528-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-VDnBNFU26ebdl77gl8Mt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-02-09 at 19:31 +0200, Leon Romanovsky wrote:
> From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> A blue flame register is comprised of two buffers of equal size.
>=20
> Fixes: 5fe9dec0d0454 ("IB/mlx5: Use blue flame register allocator in
> mlx5_ib")
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> =C2=A0Chanelog v0->v1:
> =C2=A0* Add brackets to ensure proper calculation order.

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-VDnBNFU26ebdl77gl8Mt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYo08dAAoJELgmozMOVy/dlo0QAKs6bwfBVoAW1Yw5TdeOvy0m
lBavemhdU/yv+HWi7KU9RXsDDzhTTfUNXs/a9vjzf/C/tybTGeIIFQawRXRqLpDs
XuPMUkOyYLzjfW0aLAJUvFFMkC2XLqexIQ7wT6qXWoR3+MavLM3RrZEHv317LC0f
fQOh0Q2P8m/YD0hRyW1+4m0yq8T8DrIkx7anWoB81y7/fKrGtwIig7FlT7OkbuGq
e1A7CFEix7IPiMsHg6H8790/WEDXF7QWM6hj++PPdrWd9BCDQ/22RTZ2KwaIILKa
Ktg8Awfap/ko1SyuPDmgkL2bC0irMfcYF7MtYdy7ZiLO81WYaHA82taLEhwXdsxl
b3paCUI2Mc6a131bZSiJBanKNsmf/elgXWUge9VmhqYSlQeNPZyAM731+6qyQdAD
6UgH6VFmrQInGfSSVFe5VjvOggzieO7aSVx6Ey5BQUo5leDxLf/Dh2Xs6dPy/vgQ
b6ZP1E+2/Lgj8YEwS8fkuN3yxa7gMP7rw6aqoMPRrHO/04v34t4T9swTeWlc4Xej
6D83eD1bdgmtpl2IO3X+TSuUus6mXNNXY4ru4nIEOcKoCIluz+nSURk9r98dn+cV
VMX4zJNREXpEHw6IV80ERl9D+ixE3RpTNexthtjjrq+WEDKavuosu+LaO+Sm982E
oYBD6xKWXvZJJnf2mZAk
=GrZb
-----END PGP SIGNATURE-----

--=-VDnBNFU26ebdl77gl8Mt--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
