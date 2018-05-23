From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 2/5] RDMA/hns: Modify uar allocation algorithm
 to avoid bitmap exhaust
Date: Wed, 23 May 2018 10:00:55 +0300
Message-ID: <20180523070055.GD5729@mtr-leonro.mtl.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-3-git-send-email-xavier.huwei@huawei.com>
 <20180523060515.GD2933@mtr-leonro.mtl.com>
 <5B050EFF.4040908@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B050EFF.4040908@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2018 at 02:49:35PM +0800, Wei Hu (Xavier) wrote:
>
>
> On 2018/5/23 14:05, Leon Romanovsky wrote:
> > On Thu, May 17, 2018 at 04:02:50PM +0800, Wei Hu (Xavier) wrote:
> >> This patch modified uar allocation algorithm in hns_roce_uar_alloc
> >> function to avoid bitmap exhaust.
> >>
> >> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
> >> ---
> >>  drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
> >>  drivers/infiniband/hw/hns/hns_roce_pd.c     | 10 ++++++----
> >>  2 files changed, 7 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
> >> index 53c2f1b..412297d4 100644
> >> --- a/drivers/infiniband/hw/hns/hns_roce_device.h
> >> +++ b/drivers/infiniband/hw/hns/hns_roce_device.h
> >> @@ -214,6 +214,7 @@ enum {
> >>  struct hns_roce_uar {
> >>  	u64		pfn;
> >>  	unsigned long	index;
> >> +	unsigned long	logic_idx;
> >>  };
> >>
> >>  struct hns_roce_ucontext {
> >> diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
> >> index 4b41e04..b9f2c87 100644
> >> --- a/drivers/infiniband/hw/hns/hns_roce_pd.c
> >> +++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
> >> @@ -107,13 +107,15 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
> >>  	int ret = 0;
> >>
> >>  	/* Using bitmap to manager UAR index */
> >> -	ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->index);
> >> +	ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap, &uar->logic_idx);
> >>  	if (ret == -1)
> >>  		return -ENOMEM;
> >>
> >> -	if (uar->index > 0)
> >> -		uar->index = (uar->index - 1) %
> >> +	if (uar->logic_idx > 0 && hr_dev->caps.phy_num_uars > 1)
> >> +		uar->index = (uar->logic_idx - 1) %
> >>  			     (hr_dev->caps.phy_num_uars - 1) + 1;
> >> +	else
> >> +		uar->index = 0;
> >>
> > Sorry, but maybe I didn't understand this change fully, but logic_idx is
> > not initialized at all and one of two (needs to check your uar
> > allocation): the logic_idx is always zero -> index will be zero too,
> > or logic_idx is random variable -> index will be random too.
> >
> > What did you want to do?
> >
> Hi, Leon
>
>     The prototype of hns_roce_bitmap_alloc as belows:
>         int hns_roce_bitmap_alloc(struct hns_roce_bitmap *bitmap,
> unsigned long *obj);
>     In this statement,  we evaluate uar->logic_idx.
>         ret = hns_roce_bitmap_alloc(&hr_dev->uar_table.bitmap,
> &uar->logic_idx);
>
>     In hip06,  hr_dev->caps.phy_num_uars equals 8,
>         if (uar->logic_idx > 0)
>              uar-> index = 0;
>        else
>              uar-> index =(uar->logic_idx - 1) %
> (hr_dev->caps.phy_num_uars - 1) + 1;
>     In hip08,  hr_dev->caps.phy_num_uars equals 1,  uar-> index = 0;
>
>    Regards

Where did you change/set logic_idx?

Thanks


> Wei Hu
> >>  	if (!dev_is_pci(hr_dev->dev)) {
> >>  		res = platform_get_resource(hr_dev->pdev, IORESOURCE_MEM, 0);
> >> @@ -132,7 +134,7 @@ int hns_roce_uar_alloc(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
> >>
> >>  void hns_roce_uar_free(struct hns_roce_dev *hr_dev, struct hns_roce_uar *uar)
> >>  {
> >> -	hns_roce_bitmap_free(&hr_dev->uar_table.bitmap, uar->index,
> >> +	hns_roce_bitmap_free(&hr_dev->uar_table.bitmap, uar->logic_idx,
> >>  			     BITMAP_NO_RR);
> >>  }
> >>
> >> --
> >> 1.9.1
> >>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbBRGnAAoJEORje4g2clinoCQQALOZMjsG4VDXY8nh7+tjVajm
MDAiisWUEqXlQ3xKPkMeBVdMPsutd99Yd/NcCH8SiUaNAmEDLInWn87pQ6j8o9ij
01wuWhiRwQ09Bc+LTU3ssvNGxf+hsUPfYBY970T9amHu9zNEo9SJlZRwC4Y26kKG
aQrIvGWD67NcFSYQ4QyjtBePWvIfJzmOt33DVCQX00+j34WgUaHNDZLSZNiyCK7s
oTfY2N99C0oBhnbdWLvrW5aQvHbBMBzySDswe1TQORR5sW+keSWWLtoIXlVmxWhv
jAOLRj2c+j6g8CRHFi11PcinvoybcHb2mWZAFdud+O3siehJF954qw/Os1sU4k6r
iY2OaJ+Onll9v2ya1IntUj77a5Za5vuEl0Cs3GBPCcdhU1tZcf18jWztT0V7tYP0
h6tj0CX5quInDk9pPTyzNQKllqzG+yeBbuWDRlC36o8w8TwbOXL2WQxX6Dsk4YkI
YFGQnEnYPP2D+YeAsupej5L+mxVdQBuCkSc+7J7YMIYPUocw+0k/qLox2Y5ezv39
ATLjvPqOx04WQlLooW5aDqGLK32ia/flXCOYQh8ZBMyEXu1fCGOOSwDIZ3WsN3r3
QpNaZx/S+iCcOi2NkCN7nG/TdSy7nVzsGk/xpzcRF5BPtz3jgXNcLebF+Ajpaigr
7+wOj3jgizpXg73FhtEu
=3yqn
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
