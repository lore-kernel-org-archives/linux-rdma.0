From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] buildlib: run ABI check in travis-build
Date: Wed, 15 Nov 2017 07:58:25 +0200
Message-ID: <20171115055825.GS18825@mtr-leonro.local>
References: <8306e0d4-3f4f-1d06-74e1-c971fc63f7b8@suse.de>
 <866df5d4-2a54-2014-a180-1fd0dc43d0fa@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YtYWfCPO8ILWk+jM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <866df5d4-2a54-2014-a180-1fd0dc43d0fa-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--YtYWfCPO8ILWk+jM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 07:58:06PM +0100, Nicolas Morey-Chaisemartin wrote:
> Run travis-checkabi during travis build
>
> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
> Cc: stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org # v15
> ---
>  buildlib/travis-build | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/buildlib/travis-build b/buildlib/travis-build
> index bf86baa7..f8e5ee05 100755
> --- a/buildlib/travis-build
> +++ b/buildlib/travis-build
> @@ -5,6 +5,10 @@ set -e
>  # Echo all commands to Travis log
>  set -x
>
> +
> +# Build in debug mode and check the ABI against the ref
> +./buildlib/travis-checkabi

Will it run for all commits, including master?


> +
>  mkdir build-clang build32 build-sparse build-aarch64
>
>  # Build with latest clang first
> --
> 2.15.0.168.g9a51f1b30.dirty
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--YtYWfCPO8ILWk+jM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloL14AACgkQ5GN7iDZy
WKdN7hAAoIwhbFLymkd8OMw76twQuZIPXX2ZCb+UM07srVg5jFWaqTcJpDpSRYOu
ahlAVdCmnf18ZF4+PMAZZlDANcArg/B7agdqQSouHJnzLvIEn3KJwmeB8uK9an36
3LwD2puZb3fLL8j4r+a/v/fHhDw/U4UXwtJ6RrGc5p/7dhmqa8xD/k7oZklTWBW7
IB4enfzbNCXrio5C5vRQxtwXTuTWtpo9qDw/j08/TS2Qg/FaTt8baDXR2TNU3y5C
bnKtjW9K7czqfovFeixI2EvrMwzYKJemEYew7g5Z0IHQ8dbpfFFXCnef1veVoHoV
gOqreoNHLwEqsga6QogBj4UeGubEytmNFkb7DTDXxE7MRxsr7JBmHGC9bGG+3hr5
A0AXCJ8Wh1oqfU3DDiXxxMg5SHVk2M3bKtfP17wv458yOJBSnEqsxOkrQcRZMPPf
Qk5zZyKZrsOjjdPBF0jp9mkTh+HsdmlewSjTBJYQT9ICIGdB04gPkNzYQi7UTgY9
pC8i1COlvRTYYideqIXjWBSqsHPb0GfOhdqKL1ycXGcUpkCfVN2b+0h8Z30VqZYi
+OJjrN4nmpqeVITXIt7ObmZ4pfV02g3XLb1Q4Xh/V0Qc2wkHCSBcwv0VIjSlhR8S
e/FQ5aTevTRR8+o0VAalo7RAYAl2xMXn7/ix3tQfd2e7EdIV45Q=
=ksQg
-----END PGP SIGNATURE-----

--YtYWfCPO8ILWk+jM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
