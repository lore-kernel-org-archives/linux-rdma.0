From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/mlx5: Expose Q counters groups only
 when they are supported by FW
Date: Tue, 14 Feb 2017 10:29:58 -0500
Message-ID: <1487086198.86943.73.camel@redhat.com>
References: <20170118132510.4586-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-A4swrDT5WGMB/el7B4hi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118132510.4586-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-A4swrDT5WGMB/el7B4hi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-01-18 at 15:25 +0200, Leon Romanovsky wrote:
> From: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> This patch modify the Q counters implementation, so each one of the
> three Q counters groups will be exposed by the driver only if they
> are
> supported by the firmware.
>=20
> Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-A4swrDT5WGMB/el7B4hi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYoyJ2AAoJELgmozMOVy/dNOAP/21Ina96wxFH8uOfXceFGgbQ
8AhtmOvaOrVQSyk+PlfLOz8Vld/ka4BJXsYJOnHX1BO1ySdNYc+iuPykCwNQ5GNq
4Q3L0XGu5AKL35LZkpBDQDWNHZxQ53bnCnkmtCzn8fqI1/IXrgN4n/3q1zU6MEfR
5o4w2wAi9NhPpxhnKR2Q6KxcxJiiUQ6AhvFtrCnKvpIvnjYFQEEp52Rdd/sxAUls
bqbdcVIr+jqClxSZhoeyh1pMqzSW0mp+lHzneyDdU0GMeqtzBxRgaUD1md+8/aey
vb3uN7zJlLKehLC8St5+CmYbWOrdyaWubTjBLy6hn20CDT4huZb8QdUOQxQYoOiC
njd6akL8w/Bsj2+N06wcTaVQfZ+bquHcVxl01TlVcudqvwptdJsAzvYxVm58d5mp
Ojjh8l1O+6lZNbj37zxYkOkiZMDzfSvEF8sdrbwjBT5OPadQlYCv3dXgZn18WI3I
ke1E0o6Wg7mmrRjlYlXnNV1ntIJPl6hjcMGFz8MmY76jd7LWsfkkK5aQ4dgpEysd
fhH6zjEAdk/YZ9WM1ENLeMjBVI+T1yr0UJHuYFmUPZQaSIVZ9n2slzrkAYMao0fk
TAM1/Jrd1zK2AiRhrqGx/LVf9bH5DqRsbxYCb8CwmWUydZ1y3yrQdScRRdkWv/GS
V837UfZn7XgL55rW6FCU
=wbFa
-----END PGP SIGNATURE-----

--=-A4swrDT5WGMB/el7B4hi--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
