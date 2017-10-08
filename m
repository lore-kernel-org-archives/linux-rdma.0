From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 12/13] SoftiWarp debugging code
Date: Sun, 8 Oct 2017 15:39:50 +0300
Message-ID: <20171008123950.GU25829@mtr-leonro.local>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-13-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DOQx4ubtbYINM/to"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006122853.16310-13-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--DOQx4ubtbYINM/to
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 08:28:52AM -0400, Bernard Metzler wrote:
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/siw_debug.c | 442 ++++++++++++++++++++++++++++++++++
>  drivers/infiniband/sw/siw/siw_debug.h | 178 ++++++++++++++
>  2 files changed, 620 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/siw_debug.c
>  create mode 100644 drivers/infiniband/sw/siw/siw_debug.h
>

NACK to all this code.
It is general to all iWARP devices and it is going to be part of RDMAtool, in this and/or next kernel cycle.

Thanks

--DOQx4ubtbYINM/to
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnaHJYACgkQ5GN7iDZy
WKfh9w//cTpR8pas9T7TrCHXqIWS3mudkc1ABgeKoGCoh+VhLLXEIYp+5calgSh2
xtQN6/sRN8GDTE8uN9oCMbXY5whgDOaL+2RRbVa9qD01YAe6jUJ0lZCL/AFMTp/7
cAwU6040zoNU6CYRylQn3SVGN2q4sLJw3pABOPTdGWvkZ/6KwSktapwdC3o+eDrV
PL0/dS7tNbh+R7Iksy3pqMUtTpCnKRhD6Pj0zeI7keZwTLiSLZN3l4PW9uvfadEd
ENrLYSphQmn2d7LpBzYPfnBhxsXDCf/cpsFdfAnnLxNKewIuqSlQ+vXhA9bWRWBg
Gtti0ydyP6pXpam85gROE3my6JJRa3Lp0583Tv0seyM79C3C58jZOmYjf1zHo3Nn
gjH+6nk0rYPRnBgJADcgIv4gtPW0NUN7rnNvfl9d6mBuxgKDKvCvIU1+4c9ypOvb
9PQVYrIatIMsSLCUbO04wHu/ggkKfS0mVyYnX7jtCjsup5ecYN3TKbMPdRLoPfXI
BQycirA0sPiX21RnL5ZgvvPGKGUkB/2YExcsTMb+xINTlmFdwRGuPmy+zMKKkDn0
y8dGeuSZplD9oveQPSpu0N6Mv1dQBu03s/BSUsP4HVB96Rk53SGnfRWwNFelSwp8
Kr3Farzc2ZmuHjOEHE1iN7iMJ2y71sxoDmWLH756lkmfCHY4FXw=
=vlsh
-----END PGP SIGNATURE-----

--DOQx4ubtbYINM/to--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
