From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V5 for-next 1/6] RDMA/hns: Add rq inline data support for
 hip08 RoCE
Date: Wed, 3 Jan 2018 11:02:40 +0200
Message-ID: <20180103090240.GP10145@mtr-leonro.local>
References: <1514947448-40475-1-git-send-email-oulijun@huawei.com>
 <1514947448-40475-2-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j3zO+32zXj6UcJCE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514947448-40475-2-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--j3zO+32zXj6UcJCE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 03, 2018 at 10:44:03AM +0800, Lijun Ou wrote:
> This patch mainly implement rq inline data feature for hip08
> RoCE in kernel mode.
>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
> V4->V5:
> - Return the error code when allocate wqe_list and
>   sg_list
> - Delete unnecessary judgement when kfreeing wqe_list
>
> V3->V4:
> - Fix the comment given by Jason Gunthorpe
>
> V2->V3:
> - Delete unnessary judgment after kfree.
> - Use kcalloc instead of kmalloc_array
>
> V1->V2
> - Fix the comments according to Leon Romanovsky's reviews
> - Add two signed-off
>
> V1:
> - The initial submit
> ---
>  drivers/infiniband/hw/hns/hns_roce_device.h | 18 ++++++++
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 64 ++++++++++++++++++++++++++++-
>  drivers/infiniband/hw/hns/hns_roce_qp.c     | 53 ++++++++++++++++++++----
>  3 files changed, 127 insertions(+), 8 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--j3zO+32zXj6UcJCE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpMnDAACgkQ5GN7iDZy
WKdUTxAAl1eVqLYY2YRsOUg9MQvR0HT1JQTOg4Ku4zFIPjZ2BQuKUCKiXIuLiQqj
koE1mbcDpwxyq7viqGqoNaQbVPPUwwPSJj2gPgVkj1Rujx/3ROcwm2MisVvn91Fd
NoMghZiDg/vlsdiCBp68sjd43yPeYDNO4AWkPJVCDtHMEkDoAq/K+1xYdHMM0KUt
ZAj9xBP3m9X2exli2ru6Ze5cELzhEPmcqiVjpyat4Yw7lmiqHQ6A9et1KtHVg8k/
yD3M6TH8Am0l7e3TW/xrUwaiRbLm8Z1F/HkhbiLFv9Daz0gyuTEoB6rN4QvmXyHp
Rx/cdzKhu5U5+2r8q2HyrAcmRRWTpbUv4wGO1b8kPnFXp3Hb+dHeQT2WAI2lHKXU
KxUtxUuuvUtMlBaX9dEQAU1BtG+UvXhAZXwmIbyOhPINDxP1Z2Ieq7ERJOBkLA+C
Xvv3F/iQV1BAYctLWqapjORMjVJu5VIRHg7/bUtyKIvk4ZdprxTPv+SngE7f84H9
ogYE8xdJC6Xge/r7uicN2HL7OL8qb0/quoSP41fe1kVuzSLEZQHpjGC0T0Txuxgn
nv29kKBCFpivet0h92HM9sE9Xs7JCbkNd5t9ZRVD0qdZ1p3zrz4kc6BoeKaOSI9T
K6WzTUgHDdeVRcWiTcdzGbSdZor63tCzYNE130V0bwTRwF0lNnE=
=vBOS
-----END PGP SIGNATURE-----

--j3zO+32zXj6UcJCE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
