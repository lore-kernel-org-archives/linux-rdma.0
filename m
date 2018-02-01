From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] RDMA/nldev: missing error code in nldev_res_get_doit()
Date: Thu, 1 Feb 2018 12:34:34 +0200
Message-ID: <20180201103434.GJ2055@mtr-leonro.local>
References: <20180201100148.GA8959@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="83Y2sXKo4f/n2njO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180201100148.GA8959@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--83Y2sXKo4f/n2njO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 01, 2018 at 01:01:48PM +0300, Dan Carpenter wrote:
> We should return -ENOMEM if the allocation fails.  The current code
> accidentally returns success.
>
> Fixes: bf3c5a93c523 ("RDMA/nldev: Provide global resource utilization")
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>

Thanks Dan,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--83Y2sXKo4f/n2njO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpy7ToACgkQ5GN7iDZy
WKeEXw//ZHhPOSj9DVKEK+lS+U98W5w9yHxsZ/ZEh66kPDFKXzQ4x2d9YI6g7Zwo
lpptYVeyxvvrFY2g17EGwXXafnmp7RcclcHIBNeFMjlJXuTEWBI1r1gBjgc5DnqK
WeZkPqRxYeaI+rkNOO9OGhKiZfdjGd8z5HXW1bHEPoYQyRzQ4TGIqqbJ1uZkUjXQ
FlAS7NdaAj6xR8U6onuRuUPN93w36JyWEUmcZVNZLp9BOeAimrKop0qv6uGaz1c7
JdEYeax/NgOWswXivYKfCzYFLahNduSvjqLbZp1bLFttqaG9+zaXMn1fjaLSgZst
xYrLBXrK6rqa2oZxGbFz3+fU4O0/d7cfcYph2xN5aTZBPQnNojh3Ec3ZzjMc3Q86
scMCv+EIc72sE/iud+cut3FrjcEguh59m8LK9wDVdKWYLQgzKyPVVDjgw+VuGjEi
w+Wuibt6Z2hVRO7RwBMw21Zct7+gxIq4kpP3gdRmtL9tw8muhwgsmw0F2R8aS6Oo
7OhzjildXZoBHEUZ/qq/vm1L2EFbk7RNjvMH8mK7a2+lm1jBHvm0LgRciecGmFs/
imcHkGUtLXQpkWDT8vrxgRuYeR2oaThFobhaEpNt5zMjyE9pm0Q1a0Nv8Tr7k5Q6
pgqOGNT75WD2W+6Aw7Ox6t9dOHq7xsVHIO9V30ZMah7NtnzTIac=
=aoeZ
-----END PGP SIGNATURE-----

--83Y2sXKo4f/n2njO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
