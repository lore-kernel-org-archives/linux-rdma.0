From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] IB/mlx5: Respect mlx5_core reserved GIDs
Date: Thu, 6 Jul 2017 14:10:57 +0300
Message-ID: <20170706111057.vdhnx7agww7j3pcv@mwanda>
References: <20170706093923.4azhres5ymy4vefp@mwanda>
 <20170706103811.GY1528@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170706103811.GY1528-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: ilant-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 06, 2017 at 01:38:11PM +0300, Leon Romanovsky wrote:
> On Thu, Jul 06, 2017 at 12:39:24PM +0300, Dan Carpenter wrote:
> > Hello Ilan Tayari,
> >
> > This is a semi-automatic email about new static checker warnings.
> >
> > The patch 095b0927f0ce: "IB/mlx5: Respect mlx5_core reserved GIDs"
> > from May 14, 2017, leads to the following Smatch complaint:
> >
> > drivers/infiniband/hw/mlx5/main.c:327 set_roce_addr()
> > 	 error: we previously assumed 'gid' could be null (see line 300)
> >
> > drivers/infiniband/hw/mlx5/main.c
> >    299
> >    300		if (gid) {
> >                     ^^^
> > Before we used to return early if gid was NULL.
> 
> Thanks Dan,
> It is bug.
> mlx5_ib_del_gid calls this function with gid == NULL.
> 
>  363 static int mlx5_ib_del_gid(struct ib_device *device, u8 port_num,
>  364                            unsigned int index, __always_unused void **context)
>  365 {
>  366         return set_roce_addr(device, port_num, index, NULL, NULL);
>  367 }
> 

Hm...  You're right.  Btw, that code also generates a static checker
warning, but I just hadn't got around to reporting it yet.

	drivers/infiniband/hw/mlx5/main.c:342 mlx5_ib_del_gid()
	error: NULL dereference inside function.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
