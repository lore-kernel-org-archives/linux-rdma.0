From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/5] buildlib: add script to dump ABI
Date: Wed, 15 Nov 2017 07:56:32 +0200
Message-ID: <20171115055632.GR18825@mtr-leonro.local>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
 <8bcdf747-5613-8990-5742-8a9b6e552ac9@morey-chaisemartin.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bCdOcaDGF7gDEeiN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8bcdf747-5613-8990-5742-8a9b6e552ac9-PVCUbA2IIkVH1sytvemUSjhD77mM7E+b@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <nicolas-PVCUbA2IIkVH1sytvemUSjhD77mM7E+b@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bCdOcaDGF7gDEeiN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 07:57:55PM +0100, Nicolas Morey-Chaisemartin wrote:
> Builds rdma-core in -Og/Debug mode and use abi-dumper to generate 1 xml
>  per .so.*.* file.
> Do not use .so file directly. Providers have no symbol exported
>  and cause abi-dumer to exit with an error.

mlx4/mlx5 do export.

Thanks

>
> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
> Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v15
> ---
>  buildlib/gen-abi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>  create mode 100755 buildlib/gen-abi
>
> diff --git a/buildlib/gen-abi b/buildlib/gen-abi
> new file mode 100755
> index 00000000..6dff8ddb
> --- /dev/null
> +++ b/buildlib/gen-abi
> @@ -0,0 +1,18 @@
> +#!/bin/bash
> +
> +# Stop on error
> +set -e
> +# Echo all commands to Travis log
> +set -x
> +
> +mkdir build-abi
> +cd build-abi
> +CFLAGS="-g -Og" cmake -GNinja -DCMAKE_BUILD_TYPE=Debug ..
> +ninja
> +
> +mkdir ABI
> +for FILE in $(find lib -name "*.so.*.*"); do
> +	LIB=$(basename $FILE)
> +	MODULE_VER=$(echo $LIB | sed -e 's/.*.so\.\(.*\)/\1/')
> +	../buildlib/abi-checker/abi-dumper.pl  -lver $MODULE_VER $FILE -o ABI/$LIB.dump
> +done
> --
> 2.15.0.168.g9a51f1b30.dirty
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--bCdOcaDGF7gDEeiN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloL1xAACgkQ5GN7iDZy
WKdg7g/7BhED0qlf68FzXeTPozDnttzYUmXqLrAjzJd/sM6Dn9c6YPzcfbD0KqK/
Vwu2e8Hvz9RGAcldubayMnaok9ytWcLTFoAd7VH6w36lMiej85r1gXSjuCHHi+4W
/jc5NQaN2vBdd8MmfNDc/VIoylpkth6bvoG9v4kJXpZrupSsWgakXQXxYSMonMLp
vT9H/rXhsHqZZOoa4YinHNF/DTuY3Kre/FIuRRy5NJs9qrOAo44qO3lRN6gt0tLY
drFt01mbqfxbHkxL1jUkxYc4lvx0rKvvT4IlYK1CE/0UxmYbHdiZg5pazp78Xwp9
7cFmtziIfUM6zY7iHQQ4TuGshoKtNrXIXvdJjp+hUaXVJWWOvbOEAasgboFZDIvt
mPRdItZ03f+D8BtQa4qfm97yRI+xIcaYOgvqglGaj+O54pG9jqArnX4qro8Xxdwv
//1VbRTFLEo0xi6vPjlsdEWk9vsZrlEVDlbPxueJSfGHqdKNAAhtr5S/je6iMeIf
nWQBLAevkhtShzgqY/DUFarBPIrgcBmPjklh6CfKS+YXBvrCiUcHm6YwE97QbZpX
B4jt/Y5Zgteb/6g+JzAgWebT9u+dPFe74NA9t0z8vrYP7XiA9AhuHyIEnJRIonJx
36Opkq5H7L9zQg3qCNMCv4ojO1HHclhCw0Qdl7E8yIJCaP9CiY8=
=FxKL
-----END PGP SIGNATURE-----

--bCdOcaDGF7gDEeiN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
