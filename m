From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 1/2] libhns: Support rq record doorbell
Date: Fri, 9 Feb 2018 18:52:43 +0200
Message-ID: <20180209165243.GQ2197@mtr-leonro.local>
References: <1518176724-126991-1-git-send-email-liuyixian@huawei.com>
 <1518176724-126991-2-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rV8arf8D5Dod9UkK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518176724-126991-2-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--rV8arf8D5Dod9UkK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 09, 2018 at 07:45:23PM +0800, Yixian Liu wrote:
> This patch updates to support rq record doorbell in the
> user space driver.
>
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  providers/hns/CMakeLists.txt     |   1 +
>  providers/hns/hns_roce_u.h       |  26 ++++++
>  providers/hns/hns_roce_u_abi.h   |   4 +
>  providers/hns/hns_roce_u_db.c    | 196 +++++++++++++++++++++++++++++++++++++++
>  providers/hns/hns_roce_u_db.h    |   5 +
>  providers/hns/hns_roce_u_hw_v2.c |  11 ++-
>  providers/hns/hns_roce_u_hw_v2.h |   4 +
>  providers/hns/hns_roce_u_verbs.c |  22 ++++-
>  8 files changed, 265 insertions(+), 4 deletions(-)
>  create mode 100644 providers/hns/hns_roce_u_db.c
>
> diff --git a/providers/hns/CMakeLists.txt b/providers/hns/CMakeLists.txt
> index f136151..697dbd7 100644
> --- a/providers/hns/CMakeLists.txt
> +++ b/providers/hns/CMakeLists.txt
> @@ -1,6 +1,7 @@
>  rdma_provider(hns
>    hns_roce_u.c
>    hns_roce_u_buf.c
> +  hns_roce_u_db.c
>    hns_roce_u_hw_v1.c
>    hns_roce_u_hw_v2.c
>    hns_roce_u_verbs.c
> diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
> index 0291246..95440e9 100644
> --- a/providers/hns/hns_roce_u.h
> +++ b/providers/hns/hns_roce_u.h
> @@ -93,6 +93,26 @@ struct hns_roce_buf {
>  	unsigned int			length;
>  };
>
> +#define BIT_CNT_PER_BYTE       8
> +
> +/* the sw db length, on behalf of the qp/cq/srq length from left to right; */
> +static const unsigned int db_size[] = {4, 4};
> +
> +/* the sw doorbell type; */
> +enum hns_roce_db_type {
> +	HNS_ROCE_QP_TYPE_DB,
> +	HNS_ROCE_CQ_TYPE_DB,
> +	HNS_ROCE_DB_TYPE_NUM
> +};
> +
> +struct hns_roce_db_page {
> +	struct hns_roce_db_page	*prev, *next;
> +	struct hns_roce_buf	buf;
> +	unsigned int		num_db;
> +	unsigned int		use_cnt;
> +	unsigned long		*bitmap;
> +};
> +
>  struct hns_roce_context {
>  	struct verbs_context		ibv_ctx;
>  	void				*uar;
> @@ -110,6 +130,10 @@ struct hns_roce_context {
>  	int				num_qps;
>  	int				qp_table_shift;
>  	int				qp_table_mask;
> +
> +	struct hns_roce_db_page		*db_list[HNS_ROCE_DB_TYPE_NUM];
> +	pthread_mutex_t			db_list_mutex;
> +
>  	unsigned int			max_qp_wr;
>  	unsigned int			max_sge;
>  	int				max_cqe;
> @@ -188,12 +212,14 @@ struct hns_roce_qp {
>  	unsigned int			sq_signal_bits;
>  	struct hns_roce_wq		sq;
>  	struct hns_roce_wq		rq;
> +	unsigned int			*rdb;
>  	struct hns_roce_sge_ex		sge;
>  	unsigned int			next_sge;
>  	int				port_num;
>  	int				sl;
>
>  	struct hns_roce_rinl_buf	rq_rinl_buf;
> +	unsigned int			flags;
>  };
>
>  struct hns_roce_u_hw {
> diff --git a/providers/hns/hns_roce_u_abi.h b/providers/hns/hns_roce_u_abi.h
> index 251a5c9..d67e4fc 100644
> --- a/providers/hns/hns_roce_u_abi.h
> +++ b/providers/hns/hns_roce_u_abi.h
> @@ -68,4 +68,8 @@ struct hns_roce_create_qp {
>  	__u8				reserved[5];
>  };
>
> +struct hns_roce_create_qp_resp {
> +	struct ib_uverbs_create_qp_resp	base;
> +	__u32				cap_flags;
> +};
>  #endif /* _HNS_ROCE_U_ABI_H */
> diff --git a/providers/hns/hns_roce_u_db.c b/providers/hns/hns_roce_u_db.c
> new file mode 100644
> index 0000000..770f1ec
> --- /dev/null
> +++ b/providers/hns/hns_roce_u_db.c
> @@ -0,0 +1,196 @@
> +/*
> + * Copyright (c) 2017 Hisilicon Limited.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#define _GNU_SOURCE

I see that it exists in mlx4 and mlx5 too, but why do you need this define?

Thanks

--rV8arf8D5Dod9UkK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp90dsACgkQ5GN7iDZy
WKfIWw//T6JcEqv8PKTqlKIv9p0S9qThiPOOgrelpkR/RCFXDHt38N+GHIqphRk4
PAWPUXWaerwXRpO3f0Dgz82Ji+jFfiAm8LWZ+QdSvSjmQzQeZsCesQpfYijn+nTL
0z4EbENNQUaD1BX5dg2DrMUcGfECt0YfCEVcDmQeFfFe0VJ0pfXXPNAVJGcATdPz
o9qtCe/nfGnYcxUW471c0yb/ZpZq9WDMkxjL5Rzr7+hm1z7POaTI/Kh/H+8wVJUv
dH5NtrX2kTZTX2+4nePyzLKGED76icfPc6nVlsbaAc0xQkUwWzvmfQmP3L+SHDAl
f6L0J4iPb9MX0GEEDn8DkcqTZYKGb+bj4FvmKQlPMoc1RKw8Q/UD9x54mQrk5zUO
65nhTgnW9XXN7KLL/k7cxOTs+3y0Fc+LqO6OwKwSICs4mlmktMI4TukhsQ+pp3xE
4QRpJ9Tf7lzFQz8u4vPmMxLtoXnc3Z48stLBIDlYPyWphYe9WpPO2r+mCOxmK7S/
OVT17gIRb1L/lbg7DEU0LRQxnW2fqOnzsqytPDwXihQrPfpRyfKRsFxxxu2fQRvf
sA2e0tEArVUjUNPupEe7SJRP+kUK7mblvZyQckOZcUeK5SBVw2q4GqiLCFkgH6nG
X+4JKhin0RC7sIJeiZIllU0dkPdTrAe7Dygz2QUbBWT3fiPdC7k=
=/+z8
-----END PGP SIGNATURE-----

--rV8arf8D5Dod9UkK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
