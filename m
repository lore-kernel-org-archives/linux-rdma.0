From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] Documentation: update stable doc about ABI
 reference generation
Date: Wed, 15 Nov 2017 07:53:54 +0200
Message-ID: <20171115055354.GQ18825@mtr-leonro.local>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
 <4bbfedda-eab7-0320-2a37-e3ecbf1093dc@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="o1/0/m+AY5DY8EuM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4bbfedda-eab7-0320-2a37-e3ecbf1093dc-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--o1/0/m+AY5DY8EuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 07:58:12PM +0100, Nicolas Morey-Chaisemartin wrote:
> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
> ---
>  Documentation/stable.md | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/Documentation/stable.md b/Documentation/stable.md
> index d7ea9822..b7d26c98 100644
> --- a/Documentation/stable.md
> +++ b/Documentation/stable.md
> @@ -63,3 +63,20 @@ Note that for Option 3, if the patch deviates from the original upstream patch (
>  ## Versioning
>
>  See versioning.md for setting package version on a stable branch.
> +
> +
> +## Creating a stable branch
> +
> +Stable branch should be created from a release tag of the master branch.
> +The first thing to do on a master branch is to commit the mainstream release ABI infos
> +so that latters patches/fixes can be checked against this reference.

Does it mean that you should rebase your stable-v15 branch?
It doesn't contain ABI infos yet.

> +
> +To do that, the creator of the branch should run
> +```
> +./buildlib/gen-abi
> +mv build-abi/ABI buildlib/ABI
> +git add buildlib/ABI
> +git commit
> +```
> +
> +Note that the ABI must NOT be commited at any point in the master branch.
> --
> 2.15.0.168.g9a51f1b30.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--o1/0/m+AY5DY8EuM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloL1nIACgkQ5GN7iDZy
WKfMahAAyWGiA6fXXSwFBAy2MlkJqMe/2vY7ZvO0OhsZB+pO4qdaY1+ea23nweu3
Z7OgqINsjNBDqg1uVZbl59QH/Go567DiR8b2copGzzFaw5oSYJttfcAE/xdkQpFc
Ed/qLzk32ZUNElkR06T/4QGPVb+qG6izTqqNMXA12ECkE+c46/H0DFjKxWdXhGNZ
eIUPzfJwD6Uwm+vRG8cyOvNKXdzfKjONa6crDHiZXybzp6Ty6Hx6GKCBxMQUUsaT
pFOvCHg8eIDlCyH6ex6Da9Jv7Va3lJcr+VFzX1dlHY7xI3rXN0EKK1CZoShmE7wZ
YNJqqkQIJdIVa0oV0kuMsXIqLgVPsC7NJdTE965bth4U+HwhEw0BAa8xtTeu59Es
+stbyZDzZdogPpzmIt3u3kIWF1QofPQngtxllC6za44l4vi7Pq6OAR889TkO6+bZ
9mFDRwuG/8tMaDduEO6/H5qWuJ3cZ98xURnd8b5CBXJvJ1viTRGL/E3nXN84pX/j
uWJxn1yAaAimOrd1UoyrFhGtSVtLUXMtxYleFwE/D/FxaYuZJcKA9pc97AMSC0KM
kDfdYIDiiYR9UxyYkrNbVvY17SGtXuBCqcgWm0XlNyAmyf6SnNjmOaPh4o22jT9q
7Ya1fUwZn7R2GN//D32bm01tFxicgB6lYhYlfB/4+kMar46pitw=
=s2Ed
-----END PGP SIGNATURE-----

--o1/0/m+AY5DY8EuM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
