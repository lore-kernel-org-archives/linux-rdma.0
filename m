From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Building rdma-core with -Wcast-qual
Date: Thu, 13 Jul 2017 16:41:44 +0300
Message-ID: <20170713134143.GN1528@mtr-leonro.local>
References: <ed258438-d585-d0ee-6c56-0178c589406b@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l3SabBw+jKRRDtnq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ed258438-d585-d0ee-6c56-0178c589406b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--l3SabBw+jKRRDtnq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 13, 2017 at 03:45:16PM +0300, Sagi Grimberg wrote:
> Hi all,
>
> When I compile rdma-core with -Wcast-qual I get all sorts of warnings
> on non following const on casts.
>
> Does/should anyone care?

Yes, at least, everyone listed in MAINTAINERS file should care.

Thanks

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--l3SabBw+jKRRDtnq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllneJcACgkQ5GN7iDZy
WKfd2RAAilkeaEYu3ibi5j7OXPUaJqNYu9pfzCXiJDeKBHFu0UFLHszrrREjxu5I
EvLnhDgo6tprQeubLU9XeYthPxFsa8/04O7brcXu3FW2DFF2697oUabFDfjpusyd
1H2nwze6ad9hO6WRTu9mVAhqaXoMMwFaV/Grr/gzKbHY9c2545Vg2C337M5ma6SQ
v6U3LghRCPA/oygOXQu0FU9yZC/VKCB5NpKcPICQ5D/NJBmV5Er7jZNhQFDYCC4d
8lyrZYFBsse8D6Nk8EkMyHKNmQu8L4s6Og/rUEByJjtw05cuwlM/eJYTZm1RKPco
YbcjL5b09w/SWtaPzzuPWTR568Xdg8pEIYrAmx6pTnY/qnE79W5zKz7bf7ZEa/qX
xxFza2aCvjS6/H9Yd2M1qExIHiuH0rHgqVjMPxVNhReJzNZgtnk88j8tMOYoIACA
0eOEkqpJKlwpyYNJjYt8zQoK1TBKqYq7eOmavcvxdu7tQrjlZC0O8ZCxZ3/eo5Ps
7xFJDi7WqXDgO+4ACvj8W1jDuH3uzb53SoIVC2IY4CRiNdog0yYL3AoRWMF2MwOI
uF2HzEBxo9jAVvV+wxy08JizFKO7IigpTcJK8nxSGBkTC1bzwYsO8k0kPpdOu6FJ
3By+gvfZTtjIUjrgwSzvREP9+dw4qo/3Tu3AddTUz8lJ2VLz5mM=
=Uz+T
-----END PGP SIGNATURE-----

--l3SabBw+jKRRDtnq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
