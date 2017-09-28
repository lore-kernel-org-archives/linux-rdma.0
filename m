From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] verbs: fix compilation error with ICC
Date: Thu, 28 Sep 2017 17:02:30 +0300
Message-ID: <20170928140230.GZ2297@mtr-leonro.local>
References: <1506434711-3828-1-git-send-email-nelio.laranjeiro@6wind.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5860PwWXAiuGjz3C"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1506434711-3828-1-git-send-email-nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--5860PwWXAiuGjz3C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 26, 2017 at 04:05:11PM +0200, Nelio Laranjeiro wrote:
> Compiling a program including verbs.h with ICC fails with the following
> error (seen with DPDK):
>
>  /root/development/rdma-core/build/include/infiniband/verbs.h(84):
>  warning #61: integer operation result is out of range
>    static void *__VERBS_ABI_IS_EXTENDED = ((uint8_t *) NULL) - 1;
>
> Fixes: 6be16586e081 ("Infrastructure to support verbs extensions")
> Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
>
> Signed-off-by: Nelio Laranjeiro <nelio.laranjeiro-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
> Acked-by: Adrien Mazarguil <adrien.mazarguil-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
> ---

Thanks, applied.

--5860PwWXAiuGjz3C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnNAPYACgkQ5GN7iDZy
WKcEgBAAhv/Y4W+N60a1/7X4qyXuinXKf5EVQrdeq3+0HtTCgKp8fNDIC06ue4gO
h8FHxOIdwHajRO0kuynEQ/XMOrLIxuTH9Sx77sx27Sn0CX87i38D8OV0n19eo+f7
28peAp5TectoPIP0Ks6/xM3n+pf9dpyrASOVWvmH0tG5wgIYHSwexIlqN7izhP66
wMORQAdq1YkJuKEbmast3z2OMFj073nyoBQRfY7aUSlaO/EYoclxHjloDWQE1Hj3
tbQBRV2eTaTysn01sdBA8ALz9is/zt0ekn32myY+BdbHn0TM3LiD5Bo4niNg6IE/
1mbk3cfJ3UCpWZq/+h6APBnZEDmYD74kboNWYM1OyTn1ZrmjlquL5djjA7WrMt0+
nor/q4AaVrd/S+6Xcji7PfjCcUZE3DSdUGFKww1AhNRjl+HvWxs/LFZMIkLGNXqx
gebApHykpcZc8dibgnEcf7BGzuKoxZS51GYw8DCrt4r5oN9wKld1VX5Bminl/wDX
VKimx0hOMRJPl16c0u4zFPaxrR+uCh7DZT3ccw7d3Vbw6esALkAX3qO//IxOC82u
fYjrp8s3+P+KW9QTsW+joLd+GowriXF/m4Bq7gFSjR7Arm3gxt23lA+NcYC9aLvE
RO9065KJtCCcNNjBut3JjtVsq1cQ9ypJVhXbCSJNwq8OtXL53/E=
=67va
-----END PGP SIGNATURE-----

--5860PwWXAiuGjz3C--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
