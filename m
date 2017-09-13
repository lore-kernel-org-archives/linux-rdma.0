From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 11/20] RDMA/hns: Split CQE from MTT in hip08
Date: Wed, 13 Sep 2017 20:52:59 +0300
Message-ID: <20170913175259.GW3405@mtr-leonro.local>
References: <1504084998-64397-1-git-send-email-xavier.huwei@huawei.com>
 <1504084998-64397-12-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZrCu0B0FMx3UnjE2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504084998-64397-12-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-9Onoh4P/yGk@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ZrCu0B0FMx3UnjE2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 30, 2017 at 05:23:09PM +0800, Wei Hu (Xavier) wrote:
> From: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> In hip08, the SQWQE/SGE/RQWQE and CQE have different hop num and
> page size, so we need to manage the base address table of the
> SQWQE/SGE/RQWQE and CQE separately.
>
> This patch is to split CQE from MTT(SQWQE/SGE/RQWQE).
>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/hns/hns_roce_cq.c     | 15 ++++++-
>  drivers/infiniband/hw/hns/hns_roce_device.h | 14 ++++--
>  drivers/infiniband/hw/hns/hns_roce_hem.c    |  3 ++
>  drivers/infiniband/hw/hns/hns_roce_main.c   | 17 ++++++++
>  drivers/infiniband/hw/hns/hns_roce_mr.c     | 66 ++++++++++++++++++++++-------
>  drivers/infiniband/hw/hns/hns_roce_qp.c     |  2 +
>  6 files changed, 98 insertions(+), 19 deletions(-)

<...>

>
> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> @@ -170,6 +170,11 @@ enum {
>  	HNS_ROCE_OPCODE_RDMA_WITH_IMM_RECEIVE	= 0x07,
>  };
>
> +enum hns_roce_mtt_type {
> +	MTT_TYPE_WQE = 0,
> +	MTT_TYPE_CQE,
> +};

No need to initialize enum to zero.
Thanks

--ZrCu0B0FMx3UnjE2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm5cHsACgkQ5GN7iDZy
WKchQBAAxyWLwNQJYJNVKW+YjMgKrbC5mZY7GxBIxzaNjX6q0hR4cx4UAlA6dER6
WAGpk+IZJcdik1/o9IrzLgWKbhkqN/jRLMZ2oFYDW4/qcT6Dl049hYT6u6EdQiCL
DenXJzCakcKJXHT/i4UBvCxbu2zg53fQ8zsYRF56BlgjcOwdFwI03XKH839N8ATH
Th3yEF5ouJQVI0bGRoW6i7Juoen/Fetvu1OLUp/eknDRe3/lt9qk9PTX2hLZLxKO
Hc9By1Ni6ES1+Y8IJyydEA0TOl6tk/+MeamN+Sr0SFNCEeLUG4T5PXwQItilh7R/
AwB0gJkQ4gBCRyoANl7gRw4aauL1ij0+6EglOm5RdqB8aEwAHRvwH1xtwkl7q+PZ
1TlPGpD0Z76dT9CWYpBjYmHVdvymzpFvoUwEa6XpyzY5y1en72/CJkdh6STSxiw/
+XUVITq4VMvB4EbyH4v5aiDlqZWc0X8K8hBOlICRpdNM5CzZUrqmeb1GJVf4SItP
ZDXyoCbxWwREu5AxRTfDAKr7zEAtCPB6KB3S4QHcp1IMbLCQ6mfmOHrUCQgps0gn
KPrKq4fHR/s8eqd0a/9/6bQPEwt0bYGlbZo/0U2ti2z3c1O6yYhxCHNW4GWQpiJe
Xyg1ai3mfmNgabHYZWh923eq3T2NuKFI/Jja0flEhiF1aohGocE=
=UIgO
-----END PGP SIGNATURE-----

--ZrCu0B0FMx3UnjE2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
