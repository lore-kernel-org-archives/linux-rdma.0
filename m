From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 for-next 2/2] RDMA/hns: Fix alignment problem of the
 doorbell
Date: Fri, 29 Dec 2017 08:48:43 +0200
Message-ID: <20171229064843.GU3494@mtr-leonro.local>
References: <1514470683-6972-1-git-send-email-liuyixian@huawei.com>
 <1514470683-6972-3-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="p7S+EREVcBHk3zUG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514470683-6972-3-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--p7S+EREVcBHk3zUG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 28, 2017 at 10:18:03PM +0800, Yixian Liu wrote:
> The array defined for doorbell is not guaranteed to be 64 bit
> aligned while we write it to the hardware with 64 bit
> alignment required.
>
> This patch fixes this problem by defining a union for doorbell
> to make sure it 64 bit alignment.
>
> v2 -> v3:
> 1. delete the unnecessary assignment for doorbell64.
>
> v2:
> 1. Consider with Leon's comments, make sure it is 64 bit
>    alignment by assigning the expected value to the u64
>    member of the union type, i.e., assign doorbell array
>    to doorbell64.

Please put changelog after "---", so it won't be visible in git log.
See this patch as an example:
https://lkml.org/lkml/2017/8/18/785

Thanks

--p7S+EREVcBHk3zUG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpF5UsACgkQ5GN7iDZy
WKfX7RAAufe3xCkT31yAx6hrUGdrAGDbayH0ct6jfvs/RnM2UJDorNvm5tcPukyJ
ELLYhi7thD+2SH0m2SkbWWcnt7E1V0XuaA9jzb7gXibUnhXOBZzvkIQJTK6tw22f
he9Vt4M1GuCnVZBNH5xOhVgsndkDtQIK+G0wa+nhz8jyc8d1SYuMpgA/SrLyJujM
2+9N3brUNzzxmLrziXI3iy59SgZ/Dla1hCcmc8SNuQGWhU/86BKongWTh9WCoOQG
zxRTtuO4XWczEgNfOGOY4lwS7YbEdUEjY9MpK3ex39nN1wNU0qXMMReC3G/f+ZSe
Fot4lTAHO7qKB+Nd/4VJU97CVyWjPiIQQRLxpZSmSZ+A3zKBnLF57uK2vTXqHrC5
svfGinsI83RdwnSA4XO/oIWo89kEaLJfNNYHDRUr4+z4iVtibwtp7doK75m3Gooe
yDYb5kRwKWtif9PfrdDm5UGNZm4Py/g2Y6gUm+p5kn4kBNThYZPWhjV2pSKgcpK3
/SOAgRNmAD1257XDeYR79z+OVeC3Tb3rRyGT/ITHbwgAQ97hvRioHGxOW+vxG9JE
U99xEnQGpeKsf2pnxxf5N+SS1ij/pGr663F5mm2LorZEhoYqTKIXAzVRrbRmiWEy
FV6yA9rfiKAMp8s1J5MOQ2Xtf38Q82Ljh6EOHXEUL9MvCnRkLS8=
=v4C7
-----END PGP SIGNATURE-----

--p7S+EREVcBHk3zUG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
