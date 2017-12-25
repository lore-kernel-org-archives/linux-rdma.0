From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] container_of tidy and minor fixes
Date: Mon, 25 Dec 2017 12:32:19 +0200
Message-ID: <20171225103219.GG2942@mtr-leonro.local>
References: <20171214223544.30117-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VxJb6WgA6MoA+arP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171214223544.30117-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--VxJb6WgA6MoA+arP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 14, 2017 at 03:35:38PM -0700, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> There are several places that open code container_of and do it more poorly
> than the ccan version. Replace them all with ccan container_of then fix all
> the compile errors from the additional checking ccan container_of does.
>
> Remove container_of from verbs.h to avoid namespace pollution and to ensure we
> use the ccan version.
>
> Tidy some uses of nested container_of
>
> Remove some pointless assignments and unnecessary function prototypes.
>
> This is PR:
>
> https://github.com/linux-rdma/rdma-core/pull/276
>

Thanks, applied

--VxJb6WgA6MoA+arP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpA07MACgkQ5GN7iDZy
WKedYBAAvBuRtmIHG6StK7tzSgsBpi/SpjT4TjeUy/qdeNotNEBVkoJ6SM02ZhzI
AzIISWOhCChnYOwv4c/G3czBnnzmhTh/afvkgtgN67PUcbYnfNah7valA0m5Kf+g
nk973iWfQgh0y1vUySoY0uC5T0hUSRMjODJ/w+ttRF0a4fNLVfsq/TYvUcbkQHs1
BT2wrJn5vJp+pHVP7xuTydbXVLZ4hUib+OiIbJnZKyRf5UZtws8flwiibvSxxKOu
hRW8ZFGCeIlVIaQ4PiVuttlz4eVoG4pe6hp32Aua/ou7akpMqXPlPK8jOQOH2/jS
9jA5eAMa2qeba73ifsEl5ZLhcL8awiybp6tIoKAcl41dlkP1LHC5p8eA16l8Ev/n
z1lDrlLqbJSwWEohmrktqIJsgE+x2KAAVYjw46S49kxDkdvryJsKvDUq+BPf8Csg
1VwivH3A4b1AJwCjRV1WysyX0cD2OEaEPoDxjDWtMsX6utRgORX3NaJx8gwTWThw
i9S7dIlDSxdRVKhIZt4uJEkhZl4v0RThsgQrFhPFaYKnhR2HQHE0/GhtmzELG1Zn
3iogJiG80TiKJDS0R1kBzRwnY4zOuim9oZq6DaCxg/eEF8yYpbkbI+C9HescC5Tj
W1pHVzVw/noxZLBKpxCf3ouxDik1K926A+7xHk7KjlPjkJ8r8Q4=
=N9IH
-----END PGP SIGNATURE-----

--VxJb6WgA6MoA+arP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
