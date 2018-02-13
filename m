From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc] RDMA/restrack: don't use uaccess_kernel()
Date: Tue, 13 Feb 2018 11:01:22 +0200
Message-ID: <20180213090122.GT2197@mtr-leonro.local>
References: <eac01039be8c0518e37928e5b003a911c32e53a7.1518468700.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YrQNB5Deg1WGKZi3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <eac01039be8c0518e37928e5b003a911c32e53a7.1518468700.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--YrQNB5Deg1WGKZi3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 08, 2018 at 12:09:43PM -0800, Steve Wise wrote:
> uaccess_kernel() isn't sufficient to determine if an rdma resource is
> user-mode or not.  For example, resources allocated in the add_one()
> function of an ib_client get falsely labeled as user mode, when they
> are kernel mode allocations.  EG: mad qps.

I found the reason.

It is due to the difference between code compiled as
a module (=m) or compiled in as monolith (=y). The "add_one()" runs in user
space contexts in first scenario and as kernel space context in second
scenario. I'm not using modules so it worked for me.

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--YrQNB5Deg1WGKZi3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqCqWIACgkQ5GN7iDZy
WKcwkRAA0Wp+yAh3pE2x+ZOIVzdGySJfXE4T4Lpj7qK4k7DsK9zfaPvDRA9V7So3
62HNGZPdxAerylvRuttWEolrcMhXb99NS/vU+r/NXiV0GYXWeVIg7AkPmZmp5JQ8
Dw75ZfXJjkq03GakQq1vzLmpr9UQ2PxghNPPWNB+FSTNZF8T2Fgol9HJrvHOp8FE
lj+uXtKzKgM6zxKY885mTp4zd6tQEqB0RDyFpmX/RI4+XfFPPwTJU/QJwZoqobfF
90PNOfqdBzt0wXosRowQSV4rb6Or6XHaMYKlyeyo0Ew+IOGxtQDlzQO8m1W5xTTo
STrrBM3H8Kx3QCXTeEC6DiDbokB3g8wqSYsGlpwLWvxOhQ5FpZ22X0NRSFz4qEJH
kn55aH7NXkbcZVeGUmrkc1z6VCgu+o7/0gmd6ZIE8dsUB2RgsN7gD9abQSrjyOHj
wxYvY/QXQNr2/daLhr/N+c/twt6wMzGhqojhQfBCmD/RPIWrOL1QLCv50xAns3VH
DigHknsUgp3Gu+ies9I377ZATXiIicVK428VRruJr+2T/EGep3xfmV2RBA83M9Qk
c6Y8tHkhP6gaC5tQZSRpZ4VNYkPD8qDXUVv6TbdFlAGzA4qS1+49GcLsNC0GisBT
tY+MwpZbvi3GhkT41p8Uhs9she55dTgB2ua9dPrvx8SytD40ox8=
=ZJy1
-----END PGP SIGNATURE-----

--YrQNB5Deg1WGKZi3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
