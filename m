From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/3] Improve symbol version support in ibverbs
 & providers
Date: Sun, 27 Aug 2017 14:58:06 +0300
Message-ID: <20170827115806.GS1724@mtr-leonro.local>
References: <1503612029-19854-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Y4Sc2lTxFPaHyX/6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503612029-19854-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Y4Sc2lTxFPaHyX/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 24, 2017 at 04:00:26PM -0600, Jason Gunthorpe wrote:
> This changes the macros used to delcare symbol versions to something that can
> really safely support static libraries by removing all traces of symbol versioning
> when the static library is built.
>
> This also addresses the uclib problem and solves the need for ugly function prototypes
> in a different way, using a fairly ugly macro to generate all the needed prototypes
> and versions for the different operating modes instead.
>
>

Thanks Jason for doing it.

It looks very good, but I would like to wait till tomorrow, so Yishai
(he is OOO today) will take second look on it and ensure that I didn't
miss anything important.

Also I think that after this series, it will be safe to change default
of "-DENABLE_STATIC" to be on.

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks

--Y4Sc2lTxFPaHyX/6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmis84ACgkQ5GN7iDZy
WKeJJRAAyMb0jH0wGftQ5Yb5RZI9Wc84hCUDwmPwJrHELXrcQdwJUvTbn7hZmweZ
UyHD0vzgXy7+CNZW6VWRxzUNN4cI2KRt+w/RHdBrq/e+9ueWUM2cn8pZm9sp61Tj
20brfVIITYknWG6UZGu1PbTOLftQpFjQwIUQJC6RPUzes219GMi+qgxUiexvqm6/
N7DnskuzKf/FCNnQaUsuLIHf9W+yYBJFhUUh/hYtQtDgucHZNqbOSZoo3+F7BL5p
pMq6rBmZ6RHMIOy6/Mm5a91my3rA2P7eLtfqh14ghdqXbyL5CxjtJX8Iv3CUfK5g
IabXOJDmE3jQS/I2R9RP7n4mzNK+9/u54oRRZoe9TlFblUcyeB8u4+R6+YCP/8eU
2Jq6pkCBSFCKC46ohL2/ak2LO0cktKLrRBiYeMFHwXMafS52Ke3RiSizGZH5d4nV
3UNzMSV0drLk5n0xkzlElBLYA19xwreJuqFhVMehFOgcOpThNYdRPQ0JZa5SAjR6
70TelwdSqHa5rahZ5ZuJb8LCvCkIcTTHTROohdbDBPb5UeTN+67G8/se1LYaFszA
uea+u7WW2A5LhkraT4DyHvJU5smUXFCyYx3u9qgAlYnYI8Ta+/ppW39xg72THHfn
gSGfh92SHt+l/H5yuHlv1oZFJjIgnVYuzjTcUHSYKT7X2HxKz3k=
=0w6F
-----END PGP SIGNATURE-----

--Y4Sc2lTxFPaHyX/6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
