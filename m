From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] RDMA/hns: Support rq record doorbell for
 kernel space
Date: Mon, 29 Jan 2018 13:29:10 +0200
Message-ID: <20180129112910.GG1771@mtr-leonro.local>
References: <1516242871-154089-1-git-send-email-liuyixian@huawei.com>
 <1516242871-154089-4-git-send-email-liuyixian@huawei.com>
 <20180123110740.GR1393@mtr-leonro.local>
 <c5cfd489-e589-1d01-ef7a-718d3dc6d4e5@huawei.com>
 <20180124132139.GK1393@mtr-leonro.local>
 <443225ea-5a6a-5d7f-8136-b061e087f271@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <443225ea-5a6a-5d7f-8136-b061e087f271-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 25, 2018 at 08:57:36PM +0800, Liuyixian (Eason) wrote:
>
>
> On 2018/1/24 21:21, Leon Romanovsky wrote:
> > On Wed, Jan 24, 2018 at 08:40:42PM +0800, Liuyixian (Eason) wrote:
> >>
> >>
> >> On 2018/1/23 19:07, Leon Romanovsky wrote:
> >>> On Thu, Jan 18, 2018 at 10:34:30AM +0800, Yixian Liu wrote:
> >>>> This patch updates to support rq record doorbell for
> >>>> the kernel space.
> >>>>
> >>>> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >>>> ---
> >>>>  drivers/infiniband/hw/hns/hns_roce_db.c     | 112 ++++++++++++++++++++++++++++
> >>>>  drivers/infiniband/hw/hns/hns_roce_device.h |   6 ++
> >>>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  15 +---
> >>>>  drivers/infiniband/hw/hns/hns_roce_main.c   |   5 ++
> >>>>  drivers/infiniband/hw/hns/hns_roce_qp.c     |  18 ++++-
> >>>>  5 files changed, 143 insertions(+), 13 deletions(-)
> >>>>
> >>>> diff --git a/drivers/infiniband/hw/hns/hns_roce_db.c b/drivers/infiniband/hw/hns/hns_roce_db.c
> >>>> index 0908208..de3fa94 100644
> >>>> --- a/drivers/infiniband/hw/hns/hns_roce_db.c
> >>>> +++ b/drivers/infiniband/hw/hns/hns_roce_db.c
> >>>> @@ -92,3 +92,115 @@ void hns_roce_db_unmap_user(struct hns_roce_ucontext *context,
> >>>>  	mutex_unlock(&context->db_page_mutex);
> >>>>  }
> >>>>  EXPORT_SYMBOL(hns_roce_db_unmap_user);
> >>>> +
> >>>> +static struct hns_roce_db_pgdir *hns_roce_alloc_db_pgdir(
> >>>> +					struct device *dma_device, gfp_t gfp)
> >>>> +{
> >>>> +	struct hns_roce_db_pgdir *pgdir;
> >>>> +
> >>>> +	pgdir = kzalloc(sizeof(*pgdir), gfp);
> >>>> +	if (!pgdir)
> >>>> +		return NULL;
> >>>> +
> >>>> +	bitmap_fill(pgdir->order1, HNS_ROCE_DB_PER_PAGE / 2);
> >>>> +	pgdir->bits[0] = pgdir->order0;
> >>>
> >>> order0? isn't it equal to zero?
> >>>
> >>
> >> No. Here order0 is the name of a bitmap array and bits[0] points to it.
> >
> > pgdir was allocated with kzalloc() -> all fields are zero ->
> > pgdir->order0 == 0 or pgdir->order0 == NULL -> What is the point in such
> > assignment?
>
> The definition of hns_roce_db_pgdir is in patch [1/4] as following:
>
> 	struct hns_roce_db_pgdir {
> 		struct list_head	list;
> 		DECLARE_BITMAP(order0, HNS_ROCE_DB_PER_PAGE);
> 		DECLARE_BITMAP(order1, HNS_ROCE_DB_PER_PAGE / 2);
> 		unsigned long		*bits[2];
> 		u32			*db_page;
> 		dma_addr_t		db_dma;
> 	};
>
> and,
>
> 	#define DECLARE_BITMAP(name,bits) \
> 		unsigned long name[BITS_TO_LONGS(bits)]
>
> Therefore, pgdir->order0 is the base address of an array, not NULL.

Right, thanks.

>
> Thanks.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpvBYYACgkQ5GN7iDZy
WKeFSg//eI1VEClY10Mk8PIE9/LJGq8TXaEgpph+LswwZjsqnDCvlnMLoRubwuGi
EOGL3C2IGHTVdXiMBIpGYlZISD9D6R6Zp1pkrpJFJfqEG2gbiYogJc2puqRU5zRD
3Ar6yJM3Jlcfpdrx+cjJEUW23JJtU+8r+Shu9abTTFZzzkauYpDVYuOXdZ724Gjw
a7OZ600o8DIc+VQAPEcetH05qKY3yuaLvMQwPtxhm+g4BxwCs57yV5n4RjKdyuyK
QuUFUOPgIbIXV0f9lpIyxez7+Kica5xB6Fbtdbkso1Z6B93rf0HpQIRss+u2oA5L
28IafHif5voYsQWnq6nCC/jBbJZpPqKhXLT02mp9DdeOXtR6eu4Ci5ZpS+WOC4ti
qRvaDX/ORmK6Vh19II3MJxp4s/YupDrsdNzQCgnbWLIHs4UBZ7BOUAjMawWur4i8
qjyfWr2e4B4t+joy1PC8EIZ0Wk4xwu9cOECjgmIICgi+yppFk7W/gFf0BDPKe6c1
tsrZhZTmvZwSjgtN50x7O/kDLlR+DP5suVO8NzZxDa1sWtFUiyHPeUwWHjwFnioI
8JHVFfKzOUY6bKBbgsEknf54k3loHZ9I8mnd/9LrhhU35/tsHIYHbDZdXe4x9YvC
TtZGMiDmWkrjrIJmgy/QBMFl3sWJVWjbYLsM/MDwdZvyuYXB8N0=
=z8HE
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
