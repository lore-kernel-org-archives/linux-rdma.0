From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/4] IB/rxe: Fix kernel panic in udp_setup_tunnel
Date: Mon, 5 Sep 2016 09:32:42 -0400
Message-ID: <e0399c1c-567c-4996-a454-4ebefbe6e665@redhat.com>
References: <1473077359-11546-1-git-send-email-leon@kernel.org>
 <1473077359-11546-2-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="e4X9rXkslNb9lxR9h0FlrD5gAPdf50KR0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473077359-11546-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--e4X9rXkslNb9lxR9h0FlrD5gAPdf50KR0
Content-Type: multipart/mixed; boundary="MTRRMwVN1CDWRoUQjfeWijFiCqr5UadGb";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <e0399c1c-567c-4996-a454-4ebefbe6e665-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/4] IB/rxe: Fix kernel panic in udp_setup_tunnel
References: <1473077359-11546-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1473077359-11546-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1473077359-11546-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--MTRRMwVN1CDWRoUQjfeWijFiCqr5UadGb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/5/2016 8:09 AM, Leon Romanovsky wrote:
> From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20

> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/s=
w/rxe/rxe_net.c
> index 0b8d2ea..e0866b4 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -249,8 +249,8 @@ static struct socket *rxe_setup_udp_tunnel(struct n=
et *net, __be16 port,
>  	memset(&udp_cfg, 0, sizeof(udp_cfg));
> =20
>  	if (ipv6) {
> -		udp_cfg.family =3D AF_INET6;
> -		udp_cfg.ipv6_v6only =3D 1;
> +	udp_cfg.family =3D AF_INET6;
> +	udp_cfg.ipv6_v6only =3D 1;
>  	} else {
>  		udp_cfg.family =3D AF_INET;
>  	}

Is my mailer displaying this wrong, or is this hunk just intentionally
introducing indent breakage?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--MTRRMwVN1CDWRoUQjfeWijFiCqr5UadGb--

--e4X9rXkslNb9lxR9h0FlrD5gAPdf50KR0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXzXQGAAoJELgmozMOVy/dEW4P/2cLdvfT+f1b08XfP1iLPMqs
SPA36Yo4QHjSssZag28mR66EhTXcn9uttkeLqv4l7+zRR2/eyTeRDwQONLwJypvx
G7HFupXurSFpwrnA9GxZttEUe8vqVxxNi0UsF/vk4x48kCd6NmDwQFrS+vW7nuX6
m1FfINU6AsDodxvSGUhk1OIKvU0A3koHpRu0WSCOfrKNeqE4jpr9JUka/S48NpKf
v+Z/zbM8neOuY+Ce2L2ECN2UTzn7U1c/GVMIIvBWQ96OQHVaonoX46M3dm4+p33k
U0yEkXSbALItjb29XLKNHexcdtLjB8/Vm4bm5hoMShKjPk38tY2PM6S5Lw/854pa
Oupumdqs5kaR9Xkcqk5QKQRktEBLW1qytiD9RHkCysbOSdEqsaM/Ok6EygaBYJaN
uWxCke/ExeGxp7LUjiOixurJCBqte9HCN0wohCFaVGXpN+0NLC/vRGGdciF4cHbt
6gvdrnJE8IA9I56Hvdj933MNDtBvj2R+x84o/BTztcClfmO/ntmnzHaHARKYGWAr
9YZwI5H6ofT63lrjoIf+pFP93XT1C3pkZzER8+p9XDhgDCeXvGJJZPs7DZLw04fq
6YVhOZ0v9nH27/8pCnWViSe9b0phvlxXpQDPs6NRb26ezTGShwYz6QyTzeqJKCXZ
z0dyxqMBUqbtYLqA0fhn
=xiKY
-----END PGP SIGNATURE-----

--e4X9rXkslNb9lxR9h0FlrD5gAPdf50KR0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
