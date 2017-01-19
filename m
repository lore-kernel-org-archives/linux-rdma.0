From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/7] IB/mlx5: Assign DSCP for R-RoCE QPs
 Address Path
Date: Thu, 19 Jan 2017 12:45:45 +0200
Message-ID: <20170119104544.GA3749@yuval-lap.uk.oracle.com>
References: <20170118121036.32642-1-leon@kernel.org>
 <20170118121036.32642-7-leon@kernel.org>
 <20170118202343.GC17688@yuval-lap>
 <20170119075454.GL32481@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170119075454.GL32481-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 19, 2017 at 09:54:54AM +0200, Leon Romanovsky wrote:
> On Wed, Jan 18, 2017 at 10:23:44PM +0200, Yuval Shaia wrote:
> > On Wed, Jan 18, 2017 at 02:10:35PM +0200, Leon Romanovsky wrote:
> > > From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > For Routable RoCE QPs, the DSCP should be set in the QP's
> > > address path.
> > >
> > > The DSCP's value is derived from the traffic class.
> > >
> > > Fixes: 2811ba51b049 ("IB/mlx5: Add RoCE fields to Address Vector")
> > > Cc: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/mlx5/main.c    | 21 +++++++++++++++++++++
> > >  drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 ++
> > >  drivers/infiniband/hw/mlx5/qp.c      |  7 +++++++
> > >  3 files changed, 30 insertions(+)
> > >
> > > diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> > > index 1dea407..6a81f027 100644
> > > --- a/drivers/infiniband/hw/mlx5/main.c
> > > +++ b/drivers/infiniband/hw/mlx5/main.c
> > > @@ -325,6 +325,27 @@ __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
> > >  	return cpu_to_be16(MLX5_CAP_ROCE(dev->mdev, r_roce_min_src_udp_port));
> > >  }
> > >
> > > +int mlx5_get_roce_gid_type(struct mlx5_ib_dev *dev, u8 port_num,
> > > +			   int index, enum ib_gid_type *gid_type)
> > > +{
> > > +	struct ib_gid_attr attr;
> > > +	union ib_gid gid;
> > > +	int ret;
> > > +
> > > +	ret = ib_get_cached_gid(&dev->ib_dev, port_num, index, &gid, &attr);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	if (!attr.ndev)
> > > +		return -ENODEV;
> >
> > Two questions:
> > First for my understanding :) I see that this check is already done in
> > __ib_cache_gid_get so why it is not enough?
> > Second: Since this is light test, can we have it before the call to
> > ib_get_cached_gid?
> 
> I don't see such check there, can you point me?

Line 445.
But please ignore this question, i now realized that still there is a need
to check it in mlx5_get_roce_gid_type.

> 
>  428 static int __ib_cache_gid_get(struct ib_device *ib_dev, u8 port, int index,
>  429                               union ib_gid *gid, struct ib_gid_attr *attr)
>  430 {
>  431         struct ib_gid_table **ports_table = ib_dev->cache.gid_cache;
>  432         struct ib_gid_table *table;
>  433
>  434         table = ports_table[port - rdma_start_port(ib_dev)];
>  435
>  436         if (index < 0 || index >= table->sz)
>  437                 return -EINVAL;
>  438
>  439         if (table->data_vec[index].props &GID_TABLE_ENTRY_INVALID)
>  440                 return -EAGAIN;
>  441
>  442         memcpy(gid, &table->data_vec[index].gid, sizeof(*gid));
>  443         if (attr) {
>  444                 memcpy(attr, &table->data_vec[index].attr, sizeof(*attr));
>  445                 if (attr->ndev)
>  446                         dev_hold(attr->ndev);
>  447         }
>  448
>  449         return 0;
> 
> And regarding your second question, as you can see above in line 444, we
> are overwriting attr->ndev, so it can be zero. It requires us to check
> attr->ndev after calling to ib_get_cached_gid too.

Picture looks clear now, thanks.

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

> 
> Thanks


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
