From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Question on mlx5-ib auto load
Date: Sun, 24 Sep 2017 21:55:59 +0300
Message-ID: <20170924185559.GI25094@mtr-leonro.local>
References: <daab19a4-98c8-3115-065d-2c40c5843121@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v2/QI0iRXglpx0hK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <daab19a4-98c8-3115-065d-2c40c5843121-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--v2/QI0iRXglpx0hK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 24, 2017 at 04:43:58PM +0300, Sagi Grimberg wrote:
> Did anyone notice that mlx5_ib does not auto load at boot time?
>
> While mlx5_core requests mlx5_ib, mlx5_ib still does not load
> at boot time (only when reloading mlx5_core).
>
> I noticed it today, and could only get around it by adding
> mlx5_ib to /etc/modules-load.d/modules.conf

It is supposed to work automatically without need to add anything
(except rxe) in the modules-load.d.

>
> Is there something I'm missing?

We had an opposite bug - the removal didn't work.
https://lkml.org/lkml/2017/9/9/123

What is your OS, rdma-core version and kernel version?

Thanks

>
> Cheers,
> Sagi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--v2/QI0iRXglpx0hK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnH/78ACgkQ5GN7iDZy
WKf7BQ/+ImCBmxXdKcYdTsitghKWWuSyVwWsiUeKJBKvrLM46v/LpLmrpI0FTZxj
3siCAHNhlJ6UZt98UB2ziZeJ0D9nW+Q3EicdEzoFEW0Wssni1Jwr2UuS12otbC9N
n75eX7WvmxQWrIqBMEJHS3PjatFBbwxTQT/+IRVA+puIqjBq1z3ovUs5cj22Kttj
QKMe7aMFc1wlluCxVqTcfBrY7t5TFhOU9aSxd2mYHIGQ4jup2ZhOV1RhtE0cn8QY
DXBgOM7YG6glLZovPsRgftFSpxzGYQQoCmhGMaJs/dmdPtGGNBEI4EatdRqm52HN
1bb4bpuPILFVSTievCByB3FQO590+YW3WLJqIbKqv9AHmwBaMuDwcoNJ5WhmNtla
x88JJxlyblQFNfZTuZ/639Iff5fg9Ft+HmP+EjkBxUuwy2LOvGjZ5f4ss/mq1u4t
Hst/wq3Jut7hP0okJUuC5O/CyK+vMOq8vSX/SIz/Im1gpvZoGFG4v6Ph4/B70rHy
TqwWwI2lSMvIqTNkcobfP4VRRkhgwj85JsZnDzhEebtK2nvnHcszkpDNLE87VRC9
HZnmjuj6OEgfQB9cJUlqxIIKEKJ0UNGLttWJbXLjBcSU907KxEAWVUnzIxucdeo8
Y17iZ8bmxQoj3FiIgz3GKvNTUtoVERPqk30LSnAsZyJd3otweEc=
=w3Qb
-----END PGP SIGNATURE-----

--v2/QI0iRXglpx0hK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
