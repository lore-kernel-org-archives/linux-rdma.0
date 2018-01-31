From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] rc_pingpong: Fix getopt processing of -t
Date: Wed, 31 Jan 2018 07:58:27 +0200
Message-ID: <20180131055827.GO2055@mtr-leonro.local>
References: <20180131000415.GA29879@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="++alDQ2ROsODg1x+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180131000415.GA29879-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--++alDQ2ROsODg1x+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 30, 2018 at 05:04:15PM -0700, Jason Gunthorpe wrote:
> The -t option never had an argument, a : was erroneously added when
> the -c option was added
>
> Fixes: 099c5aa50bc8 ("libibverb/examples: Add command line option to enable buffer validation")
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  libibverbs/examples/rc_pingpong.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks, applied.

--++alDQ2ROsODg1x+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpxWwIACgkQ5GN7iDZy
WKd8LBAAp9caUalMn1jgX6VrtuIHe5dxp3YebyWWek4UMT2ZkUwWC45AKeTDqscK
emxRaEPAy7rHiWmOKkBMnQ6aGVEnao86YX2Q7UwnXjibxh0zlLcjYjNptCNepV+B
mtedEekPr3KF804gjVr+TpUr9UDOHEoXMJ6++gok6HnGW0TbgLQ7O1DN1hGMzQvC
4z24raH9GnEVOO7ZC8rSVaS5o055JO2kcYl3xloYscbEl+CbubVaI0bvM8xGEBn6
eJsdfxablaOMD+p7yat48BJRtVBNa0+aD175Axssr37140+nZz43ichZ3F45OGUJ
Fe4XWLE4937KCg9uxzq7WAZeG3Z5nMhVF8+ehLt9hteJ4CuLvl+aSjokFz1IwJ7+
AvOXi3Qw6uArNNPppCR7LbY83wUYxltWqSvv9l42i96pV98YZZZCHVzddr4JqMOG
jOAV2NxA8XXk1v66d4NukL86OAWJRvzEroL99KlTwL7M3XQZXqFUFKl9EKYFkOcE
7n9rFLgSnrJq96Gmvyji2wzf3FkW5f5INO1/sWJMFgCL7q/yjgk7d5T0Ns+bZc6B
yuLQh4KRSUVk5EYWf1wKG6gIZIZRuuUgTAK39azB3/DFRqsQpj384OKUVR9Vmo7f
MMlXYDy+TNQK1qo9WaqJ1tyZ3kaB23Z/60z6ht/i5i1M1n7PP+o=
=Ifcd
-----END PGP SIGNATURE-----

--++alDQ2ROsODg1x+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
