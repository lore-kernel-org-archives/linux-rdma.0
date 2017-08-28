From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v3 02/24] IB/uverbs: Introduce and use helper
 functions to copy ah attributes
Date: Mon, 28 Aug 2017 11:15:14 -0400
Message-ID: <1503933314.78641.82.camel@redhat.com>
References: <20170817125055.31424-1-leon@kernel.org>
         <20170817125055.31424-3-leon@kernel.org>
         <1503607242.78641.48.camel@redhat.com>
         <20170827111059.GQ1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170827111059.GQ1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-08-27 at 14:10 +0300, Leon Romanovsky wrote:
> On Thu, Aug 24, 2017 at 04:40:42PM -0400, Doug Ledford wrote:
> > On Thu, 2017-08-17 at 15:50 +0300, Leon Romanovsky wrote:
> > > From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > 
> > > This patch introduces two helper functions to copy ah attributes
> > > from uverbs to internal ib_ah_attr structure and the other way
> > > during modify qp and query qp respectively.
> > > 
> > > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/uverbs_cmd.c | 124 ++++++++++++++-------
> > > ----
> > > ----------
> > >  1 file changed, 49 insertions(+), 75 deletions(-)
> > 
> > I had to fix this patch up considerably...
> > 
> > > diff --git a/drivers/infiniband/core/uverbs_cmd.c
> > > b/drivers/infiniband/core/uverbs_cmd.c
> > > index 670176b670a0..515425a50059 100644
> > > --- a/drivers/infiniband/core/uverbs_cmd.c
> > > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > > 
> > > @@ -1936,6 +1926,28 @@ static int modify_qp_mask(enum ib_qp_type
> > > qp_type, int mask)
> > >  	}
> > >  }
> > > 
> > > +static void copy_ah_attr_from_uverbs(struct ib_device *dev,
                                             ^^^^^^^^^^^^^^^^^^^^
>From your patch...

> > > +				     struct rdma_ah_attr
> > > *rdma_attr,
> > > +				     struct ib_uverbs_qp_dest
> > > 
> > And we had a fix here where we only copy the ah attributes if the
> > user
> > set the flag for it, so what I ended up with looks like this:
> > 
> >         if (cmd->base.attr_mask & IB_QP_AV)
> >                 copy_ah_attr_from_uverbs(qp->device, &attr-
> > >ah_attr,
> >                                          &cmd->base.dest);
> > 
> >         if (cmd->base.attr_mask & IB_QP_ALT_PATH)
> >                 copy_ah_attr_from_uverbs(qp->device, &attr-
> > > alt_ah_attr,
> > 
> >                                          &cmd->base.alt_dest);
> 
> Doug,
> 
> It should be "qp" and not "qp->device" in copy_ah_attr_from_uverbs().
> 
> 1998         if (cmd->base.attr_mask & IB_QP_AV)
> 1999                 copy_ah_attr_from_uverbs(qp, &attr->ah_attr,
> &cmd->base.dest);
> 2000         if (cmd->base.attr_mask & IB_QP_ALT_PATH)
> 2001                 copy_ah_attr_from_uverbs(qp, &attr->alt_ah_attr,
> 2002                                          &cmd->base.alt_dest);
> 2003         ret = ib_modify_qp_with_udata(qp, attr,
> 2004                                       modify_qp_mask(qp-
> >qp_type,
> 2005                                                      cmd-
> >base.attr_mask),
> 2006                                       udata);

I'm pretty sure you need to re-read your own patch Leon ;-).  The
helper you added uses struct ib_device, so a pointer to the qp would
not work.  And it wouldn't have even compiled if I had that wrong.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
