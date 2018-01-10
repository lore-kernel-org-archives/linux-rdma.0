From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] librdmacm: Set errno correctly if status is positive
Date: Wed, 10 Jan 2018 20:33:18 +0200
Message-ID: <20180110183318.GA14534@yuvallap>
References: <20180110160721.14469-1-yuval.shaia@oracle.com>
 <20180110182932.GJ4518@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180110182932.GJ4518-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 10, 2018 at 11:29:32AM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 10, 2018 at 06:07:21PM +0200, Yuval Shaia wrote:
> > No need to convert to positive if status is already positive.
> > 
> > Fixes: 1ef5c3a84 ("librdmacm: Set errno correctly in ucma_complete")
> > 
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >  librdmacm/cma.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/librdmacm/cma.c b/librdmacm/cma.c
> > index 25ebaaee..fb2dc5e4 100644
> > +++ b/librdmacm/cma.c
> > @@ -866,7 +866,7 @@ int ucma_complete(struct rdma_cm_id *id)
> >  		else if (id_priv->id.event->status < 0)
> >  			ret = ERR(-id_priv->id.event->status);
> >  		else
> > -			ret = ERR(-id_priv->id.event->status);
> > +			ret = ERR(id_priv->id.event->status);
> 
> This code hurts my brain - why is status sometimes a possitive errno
> and sometimes a negative errno?

Have no idea :)
But since current code ask "if (id_priv->id.event->status < 0)" i assume it
can.

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
