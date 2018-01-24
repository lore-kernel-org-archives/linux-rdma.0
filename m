From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] RDMA/hns: Support rq record doorbell for
 kernel space
Date: Wed, 24 Jan 2018 15:21:39 +0200
Message-ID: <20180124132139.GK1393@mtr-leonro.local>
References: <1516242871-154089-1-git-send-email-liuyixian@huawei.com>
 <1516242871-154089-4-git-send-email-liuyixian@huawei.com>
 <20180123110740.GR1393@mtr-leonro.local>
 <c5cfd489-e589-1d01-ef7a-718d3dc6d4e5@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qfesBOB4TKwppX3D"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c5cfd489-e589-1d01-ef7a-718d3dc6d4e5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Liuyixian (Eason)" <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qfesBOB4TKwppX3D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 24, 2018 at 08:40:42PM +0800, Liuyixian (Eason) wrote:
>
>
> On 2018/1/23 19:07, Leon Romanovsky wrote:
> > On Thu, Jan 18, 2018 at 10:34:30AM +0800, Yixian Liu wrote:
> >> This patch updates to support rq record doorbell for
> >> the kernel space.
> >>
> >> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> ---
> >>  drivers/infiniband/hw/hns/hns_roce_db.c     | 112 ++++++++++++++++++++++++++++
> >>  drivers/infiniband/hw/hns/hns_roce_device.h |   6 ++
> >>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  15 +---
> >>  drivers/infiniband/hw/hns/hns_roce_main.c   |   5 ++
> >>  drivers/infiniband/hw/hns/hns_roce_qp.c     |  18 ++++-
> >>  5 files changed, 143 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/hw/hns/hns_roce_db.c b/drivers/infiniband/hw/hns/hns_roce_db.c
> >> index 0908208..de3fa94 100644
> >> --- a/drivers/infiniband/hw/hns/hns_roce_db.c
> >> +++ b/drivers/infiniband/hw/hns/hns_roce_db.c
> >> @@ -92,3 +92,115 @@ void hns_roce_db_unmap_user(struct hns_roce_ucontext *context,
> >>  	mutex_unlock(&context->db_page_mutex);
> >>  }
> >>  EXPORT_SYMBOL(hns_roce_db_unmap_user);
> >> +
> >> +static struct hns_roce_db_pgdir *hns_roce_alloc_db_pgdir(
> >> +					struct device *dma_device, gfp_t gfp)
> >> +{
> >> +	struct hns_roce_db_pgdir *pgdir;
> >> +
> >> +	pgdir = kzalloc(sizeof(*pgdir), gfp);
> >> +	if (!pgdir)
> >> +		return NULL;
> >> +
> >> +	bitmap_fill(pgdir->order1, HNS_ROCE_DB_PER_PAGE / 2);
> >> +	pgdir->bits[0] = pgdir->order0;
> >
> > order0? isn't it equal to zero?
> >
>
> No. Here order0 is the name of a bitmap array and bits[0] points to it.

pgdir was allocated with kzalloc() -> all fields are zero ->
pgdir->order0 == 0 or pgdir->order0 == NULL -> What is the point in such
assignment?

Thanks

--qfesBOB4TKwppX3D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpoiGIACgkQ5GN7iDZy
WKfjDhAAx1YzAZjptda9gtgFCCu2J/eRRnHhU7Kj4fa+NXyAw51kS23WuAXae0Vi
YOBT2AC1eFVjK+SmGD0t6bqOLNPuo1RYGObLMmuFoNHOPN8qklhwJmImjJ+A4A1u
1WIsrFdFLmSYW+1ENe4HafqZnKRh9Sq8asKv7LbKYW2YyNyydMwz4h+QPon266WA
JUcjhYrWgcYtZLRJXQAEtOQlLDRCDO7xEZZuv1mtIXv9Lpuvcv9WbxiKc8YN0Z5h
JK1aUkFFs+uicy8+OXOOUCgoTI9sPGcob+Hfo6w1Xx1j/UGb2plNlr2fSQlqfdOA
bv0w1JR5qI3XpHIZBpSCvqSos8oTu9Dg/d3toXNxuKD6/0whXBixwcANm3TyN5Ke
vsc4VfIJm2ueF604NooTjs5JFWhCPQ4prFzSOhDbZ7JAMZYGZazlji3eKFOYBJ1z
WR3+xX6ZRc6yyUInRIm3vXLA7Fx4jNWXWgnxM3xDgZjXUOdb2q06lbd9rYWsWnsx
zfhAOFE8uzLRvHARAJJKB1dF8ybgnOK8zzisRjIHRFWFVilanDsAZv34C/HEAGGk
Nk+b2nAbgi/B/AmVsJ//bKHA60MtIBxF5bgzLI4OvSXYC/qdl2FAqrl2qXUa3/zC
3FuaSb0G6ZScjOWwynaDUsrNFYyKM40n0ZUBcEHn8L16uQWUX7o=
=yJE5
-----END PGP SIGNATURE-----

--qfesBOB4TKwppX3D--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
