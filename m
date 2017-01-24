From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cma: Fix unknown symbol when CONFIG_IPV6 is not
 enabled
Date: Tue, 24 Jan 2017 16:28:50 -0500
Message-ID: <1485293330.43764.80.camel@redhat.com>
References: <20170115181500.4465-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-jbkmanSfjChmdKYpiH1F"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170115181500.4465-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-jbkmanSfjChmdKYpiH1F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2017-01-15 at 20:15 +0200, Leon Romanovsky wrote:
> From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>=20
> If IPV6 has not been enabled in the underlying kernel, we must avoid
> calling IPV6 procedures in rdma_cm.ko.
>=20
> This requires using "IS_ENABLED(CONFIG_IPV6)" in "if" statements
> surrounding any code which calls external IPV6 procedures.

This seems strange....

> In the instance fixed here, procedure cma_bind_addr() called
> ipv6_addr_type() -- which resulted in calling external procedure
> __ipv6_addr_type().
>=20
> Fixes: 6c26a77124ff ("RDMA/cma: fix IPv6 address resolution")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.2+
> Cc: Spencer Baugh <sbaugh-n2IX9UM++eDQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
> =C2=A0drivers/infiniband/core/cma.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/cma.c
> b/drivers/infiniband/core/cma.c
> index bd8d051..e19f19c 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -2822,7 +2822,8 @@ static int cma_bind_addr(struct rdma_cm_id *id,
> struct sockaddr *src_addr,
> =C2=A0	if (!src_addr || !src_addr->sa_family) {
> =C2=A0		src_addr =3D (struct sockaddr *) &id-
> >route.addr.src_addr;
> =C2=A0		src_addr->sa_family =3D dst_addr->sa_family;
> -		if (dst_addr->sa_family =3D=3D AF_INET6) {

Why this construct? =C2=A0Isn't the norm to simply surround the entire if
statement with
#if IS_ENABLED(CONFIG_IPV6)
...
#endif

> +		if (IS_ENABLED(CONFIG_IPV6) &&
> +		=C2=A0=C2=A0=C2=A0=C2=A0dst_addr->sa_family =3D=3D AF_INET6) {
> =C2=A0			struct sockaddr_in6 *src_addr6 =3D (struct
> sockaddr_in6 *) src_addr;
> =C2=A0			struct sockaddr_in6 *dst_addr6 =3D (struct
> sockaddr_in6 *) dst_addr;
> =C2=A0			src_addr6->sin6_scope_id =3D dst_addr6-
> >sin6_scope_id;
> --
> 2.10.2
>=20
--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-jbkmanSfjChmdKYpiH1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8cSAAoJELgmozMOVy/dIPEQALsuAwRMYA17F+Yab82I8YxO
MFtJfENgSru6Js2ktTVEYaUaOwWnVZ8BwEdon7TrmBjKHl+gWtUFlZB2fm82OruK
OmphyiIgNWR5p8SrhwwFKtuseivPC0XYDGyfX/5EUyprNKQYn9i9wDbg7kyT89nP
UGp0X2XUfrzMmALqlhfWhqSthNFh7LeiVrwB9IgrN+wygHxoVVd0f/Fn8EGH/uSl
5mrOqVgb5l0oz5gesWWxshSOhI1O6+0SpM3aKI7fb9VfNDJ/WA+bK3h6QM73h5sl
i4+mDByXyw0/aXkSSuG4AgdsKUAcRCvLB1+cdUcnsMJ7UHA/q/NrE3gxq9dMUMSM
ESrjP2gZcJOtcAEUhqKmYvFHToKC8KOwtuefbRId3IYkIbILJPoTZAXMOAtGHa3G
ncH3VKYJP3b9TcllYU/u9KZ99BAjLrkQgVjMrTSQtyZmINnzd8Pw2uoss4iwZP7W
c7SCoPqQgMQcqC4nd8po+7QqpLhqfr4RUedt2y8XncueZaKkdXmATTc5dWE56uFn
F+7+pBLfhWxRf0QKS/dJGHsLCTNXfCG1PyZJdBq6npdhCRzsU96v4FjWIfmi5yss
75lxbmWb/Wcnk0vJfb9wcQDC7ogS8kW5KnXxyQb9bGKtOHq/s0dctXrrFMZJb6pZ
CIYCjlZFGNvUnF6yTS55
=vLtY
-----END PGP SIGNATURE-----

--=-jbkmanSfjChmdKYpiH1F--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
