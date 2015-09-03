From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: fix IPv6 address resolution
Date: Thu, 3 Sep 2015 16:03:39 -0400
Message-ID: <55E8A79B.8070201@redhat.com>
References: <1439493550-5958-1-git-send-email-sbaugh@catern.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nigXu8Tg9rqeMCbsnQsMwCXTc6O7NKlKb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439493550-5958-1-git-send-email-sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:INFINIBAND SUBSYSTEM" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Joern Engel <joern-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Spencer Baugh <Spencer.baugh-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nigXu8Tg9rqeMCbsnQsMwCXTc6O7NKlKb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/13/2015 03:19 PM, Spencer Baugh wrote:
> Resolving a link-local IPv6 address with an unspecified source address
> was broken by commit 5462eddd7a, which prevented the IPv6 stack from
> learning the scope id of the link-local IPv6 address, causing random
> failures as the IP stack chose a random link to resolve the address on.=

>=20
> This commit 5462eddd7a made us bail out of cma_check_linklocal early if=

> the address passed in was not an IPv6 link-local address. On the addres=
s
> resolution path, the address passed in is the source address; if the
> source address is the unspecified address, which is not link-local, we
> will bail out early.
>=20
> This is mostly correct, but if the destination address is a link-local
> address, then we will be following a link-local route, and we'll need t=
o
> tell the IPv6 stack what the scope id of the destination address is.
> This used to be done by last line of cma_check_linklocal, which is
> skipped when bailing out early:
>=20
> 	dev_addr->bound_dev_if =3D sin6->sin6_scope_id;
>=20
> (In cma_bind_addr, the sin6_scope_id of the source address is set to th=
e
> sin6_scope_id of the destination address, so this is correct)
> This line is required in turn for the following line, L279 of
> addr6_resolve, to actually inform the IPv6 stack of the scope id:
>=20
>       fl6.flowi6_oif =3D addr->bound_dev_if;
>=20
> Since we can only know we are in this failure case when we have access
> to both the source IPv6 address and destination IPv6 address, we have t=
o
> deal with this further up the stack. So detect this failure case in
> cma_bind_addr, and set bound_dev_if to the destination address scope id=

> to correct it.
>=20
> Signed-off-by: Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cm=
a.c
> index 6a6b60a..3b71154 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -2188,8 +2188,11 @@ static int cma_bind_addr(struct rdma_cm_id *id, =
struct sockaddr *src_addr,
>  		src_addr =3D (struct sockaddr *) &id->route.addr.src_addr;
>  		src_addr->sa_family =3D dst_addr->sa_family;
>  		if (dst_addr->sa_family =3D=3D AF_INET6) {
> -			((struct sockaddr_in6 *) src_addr)->sin6_scope_id =3D
> -				((struct sockaddr_in6 *) dst_addr)->sin6_scope_id;
> +			struct sockaddr_in6 *src_addr6 =3D (struct sockaddr_in6 *) src_addr=
;
> +			struct sockaddr_in6 *dst_addr6 =3D (struct sockaddr_in6 *) dst_addr=
;
> +			src_addr6->sin6_scope_id =3D dst_addr6->sin6_scope_id;
> +			if (ipv6_addr_type(&dst_addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL)
> +				id->route.addr.dev_addr.bound_dev_if =3D dst_addr6->sin6_scope_id;=

>  		} else if (dst_addr->sa_family =3D=3D AF_IB) {
>  			((struct sockaddr_ib *) src_addr)->sib_pkey =3D
>  				((struct sockaddr_ib *) dst_addr)->sib_pkey;
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--nigXu8Tg9rqeMCbsnQsMwCXTc6O7NKlKb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6KebAAoJELgmozMOVy/diSgQALF4kuOTUOuHw2deSzvwVV2M
AovZuKSApqfJXWyZqqCDZHUPpH+msn0Hqnrm3qJDNDKF3kuVVDCR/ulKNVbZ/uNh
6wcTq7DGUBFu4wm5nXi/XM1hOP6tF9gkNjoV69PiYcFmxz+iOd8ESC2GYNsoqSJD
A5Uwoi4EsXpWiG44s0N/4fePk0pHHqqhz+06C64ZF9ujO4O5fVPw+oKw+apsR+g5
tnpttrZL3NWVo2bLIM/QnY3n50qOMjjK3pBXt5YRg0VhEcvGJBnrcSkWCNRdFOXH
hJ7w3bQELuMTwJCO0Iy07/ecSYC9/cm7zaDB/TJCLDfcZGU4LrghdY44oT+jNu4e
r4SOuwI1l6kYn7r2HaOKnFixjQDJowvFQQk821DcM+9R45fcgohDQIANKhABeAUF
ydMROuUDr0WIotGUQkwH6jZQLL9MGdzUy1bmMekBfXFhHdxMdKeDS1XcnTD62WXp
giXoNw+tFvMm8NX5HTCLweXMOHcQCDPaFRRuKjjmAZwdexcbU9HJL6d0Es5+ypd2
ZPhYILnkIv/ZwM9CvbqW+VleQ1H7+T37UZOuQEAA4xkHqHGbuzDgOmUnG0d47Wtz
iAFfNNJfoV2d4rzrXpQDhUrLxo1LUYz7YuGi4Bl9PJxL+UpamUZKzFHoa3AGgwpI
hlyJiCzbyWOOM2RaD/aU
=ZG0D
-----END PGP SIGNATURE-----

--nigXu8Tg9rqeMCbsnQsMwCXTc6O7NKlKb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
