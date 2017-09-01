From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] util: Fix check_snprintf to use __rc__ for
 local
Date: Fri, 1 Sep 2017 07:56:32 +0300
Message-ID: <20170901045632.GJ10539@mtr-leonro.local>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1504212659-9674-3-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HkMjoL2LAeBLhbFV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504212659-9674-3-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--HkMjoL2LAeBLhbFV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 31, 2017 at 02:50:56PM -0600, Jason Gunthorpe wrote:
> To avoid clashing with user variables.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  util/util.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/util/util.h b/util/util.h
> index cbf0deca2dde7b..30d32ee6b51e24 100644
> --- a/util/util.h
> +++ b/util/util.h
> @@ -8,8 +8,8 @@
>   * error */
>  #define check_snprintf(buf, len, fmt, ...)                                     \
>  	({                                                                     \
> -		int rc = snprintf(buf, len, fmt, ##__VA_ARGS__);               \
> -		(rc < len && rc >= 0);                                         \
> +		int __rc__ = snprintf(buf, len, fmt, ##__VA_ARGS__);           \

It can't clash, because it is declared in the scope {..} of that define and
it is local to check_snprintf macro.

> +		(__rc__ < len && __rc__ >= 0);                                 \
>  	})
>
>  /* a CMP b. See also the BSD macro timercmp(). */
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--HkMjoL2LAeBLhbFV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmo6HUACgkQ5GN7iDZy
WKeGCQ/+NEzrDrvkmJztBeBZ9ycrHOhr2PPDVC1U0+1kZJBMCDeWBrp8W0hS2+XX
G/uKNvNaw2I1cQq/GjRWD8o+U5038Kq26N42sDSxr0DfseOlQ1460h6HzixZ9sFB
jhEg+Bvf4ZzWt7JyZjHw2bAzGoWt6G8ruX62hKSPpNUuUJ1a1DDdxDkl77hQxg3+
OMoAyQERjFG6mRiRZwI/lrWvrye0GmQmq75uMDlXEPqSeSuRsKhTU3ErFcnZtEgU
g0NuOq+aDeEd6joZeAkz+8vn0gY6RwVmQXlm2x4gY6C9+84OtIKwyQRPcyhuabbp
GRb2kWKb51ENbW5tEdtfhoLTV8S+JrghESvCucFGtz4tH9BVPyIWl7b3w1bY7Eyd
jB7tAUt4lXQ3aAAvJ0H9pWSginetiXYPu6WVy6V5KDQPKh5KewXbjr33oWtyooNQ
hvEWMX9D4mJ15wCRac+aTPIYpZmOWV5XOBhuXdI7qLmM0CLwOKPXE2qfe8gZc7Cp
F1II3nRsAPjyw5gJH46g7YY5DHP/9tMt1eV4kgJXsEKDglNkLieoHDqiZ5yiwy5N
ClZg8WwLmx/DW99abxNYaeC1saZe5xME99RPNBm47NAn8oDKrMbUD/5u0OXzCqRa
6yAFyoCDzhYq7VhP9ebRwVDLERkt8Jx3hGR9Rl3ScPhvUiFxTy8=
=kfkm
-----END PGP SIGNATURE-----

--HkMjoL2LAeBLhbFV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
