From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 for-next 7/7] RDMA/hns: Set the guid for hip08 RoCE
 device
Date: Thu, 11 Jan 2018 07:46:24 +0200
Message-ID: <20180111054624.GN7368@mtr-leonro.local>
References: <1515566393-63888-1-git-send-email-oulijun@huawei.com>
 <1515566393-63888-8-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yaPAUYI/0vT2YKpA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515566393-63888-8-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--yaPAUYI/0vT2YKpA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 10, 2018 at 02:39:53PM +0800, Lijun Ou wrote:
> This patch assgin a guid(Global Unique identifer)
> value to the hip08 device.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> V2:
> - Use the correct way to update guid from Leon
>   Romanovsky's review.
>
> V1:
> - The initial submit
> ---
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++++
>  1 file changed, 4 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--yaPAUYI/0vT2YKpA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpW+jAACgkQ5GN7iDZy
WKdSFA/9F3UfhNR3uYYst93/rLMotvYarKTxpp8/gBXQtJSxzgJnFYPhn8jJRnnd
xDG1CqQUh0/FK+nzESlGh8u3wKscMQUJugWiTp4Wu4XpBQVCSbV14ZqbjcbpUSMC
Hbc7bZgAjvRGbpQJxPPtNRwsf4YUVlbE14n61nYTqnab7j9ZxnSKhkyfzd4wu156
l+hmXffuX3B9sfIvT43LMbnuJ7JG7ApQQ7D0jCmT9lbJbPKnpKRA0F+dUFiBkKi5
9iNiuMBf2scIFkL54Bdnm3V7CN83FcadyaSWD2lPN+k2EDtofbzL/RSVeJVqEeZb
yhtBb8s6FzPPBt/77MZU9RhqubNx4g7/yIHBX12LhfHymwqbVm6TJY7sXH0OM+Yf
ZDy9HdZC/JJsNAYSSrPnQiUatSdc3pCjAjtsJ7tgRxBCg1IFv8ry3GbQV7guqwdJ
F0DUJ8N+7DkFxCtHRjIAns1Pe6aivLm5YuJ2DsyAgReGXy185RNnQ2GW1mHdRc1r
Iyb5HDay0x+VhDzalV2DTGLG13zBxzNIx2nd3WDnFOgmr2CUkWOdw3bKUNMKs5/5
x75HDW5cJxcFs9yQYEFc3vho1XCobuHOmv/b9GOWD4js5lEV7p9+qavx4WdK6645
L+PRd6ehOJQbnUE5zEz/ymwybsns5yExZF+l69Hfb6BaR07wWYw=
=Hvqc
-----END PGP SIGNATURE-----

--yaPAUYI/0vT2YKpA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
