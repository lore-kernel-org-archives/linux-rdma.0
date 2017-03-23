From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 6/6] Bump version and update debian
Date: Thu, 23 Mar 2017 21:11:55 +0200
Message-ID: <20170323191155.GC20443@mtr-leonro.local>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
 <1490277329-8738-7-git-send-email-yishaih@mellanox.com>
 <20170323171916.GB5840@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mojUlQ0s9EVzWg2t"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170323171916.GB5840-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--mojUlQ0s9EVzWg2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 23, 2017 at 11:19:16AM -0600, Jason Gunthorpe wrote:
> There are still more places that need updating, see
>
> Documentation/versioning.md
>
> Or ec419980a7890b57ceaf6fefa797a365f2f5fed3
>
> Please follow the commit message pattern from that example..
>
> > index 3defc05..f47fcec 100644
> > +++ b/debian/changelog
> > @@ -1,5 +1,8 @@
> > -rdma-core (13-1) unstable; urgency=low
> > +rdma-core (14-1) unstable; urgency=low
> > +
> > +  * Bump version.
>
> I haven't been adding new change log entires in the past, this is just
> a standin file - Debian will maintain their own in their .diff. Same
> with rpm.

It was more convenient for me to bump version in this file too,
so new symbols in debian/*.symbol will have more clear minimal
version (14-1), which is close to rdma-core-14.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--mojUlQ0s9EVzWg2t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljUHfoACgkQ5GN7iDZy
WKdp2Q/+KHzgBqtR8D49/P1S1YQZwTdgg3zDZizVY+DPvlKAuK75eAd/nXAhMJV/
XoGpjT0kZxAbyGjLYq3K6169XYvWZY+MILQJqqm97HRifex5ipIJExT0uBnBfBX9
9JK0IiHkkXxYjmhteMKtyZZdeAftSgSXV1yEeleQbB35CStCfPfJqjUyOSWjoQjA
STBXz17mtg5b5oaV+kihsOeV7mXlABeWH7/sSsKPeXkKBc9LzM+aZPuI+Nf1qnCU
CqdJzNCSv+pa5yHhupwoCT/alcf9y7z0mzrMMVLn6yzCDoOjt34SSwtVyIFDrmfO
kzu+cGpcdETz2tbB9zgXJTo2kzsRfZ/ZhvusrictZQIFwVHdkLw3W36+sQ3dKec9
Gr+g0PYCqkSZuAWIvQIDuEXz5yZrOhJvZGbN37DMtldBowsr+Y81SZPv6ptv8miT
OPJ3jXRcQ5dXxea0V+YfWkvIeejmzwqJO6lqsDy9TVsL0lNnUOEtMeeyg28ebDwH
PyUAxq2gV7eV1qdnKujAupgQWydY+6ReQDDXJ7GoD6i2FEnKT+37Meg1Ty5gpVo2
nNrP6IGXhLE9ZjcvaEPzMehtSgNh6SqA4WYo1hM5z27xFJ/xJI5MmRAwOXafgSZl
/vhejGatOQYXPS3CgpKIMA69Y9pMa9X5MY0d2gO8LPmQgcRtA6Q=
=gcMC
-----END PGP SIGNATURE-----

--mojUlQ0s9EVzWg2t--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
