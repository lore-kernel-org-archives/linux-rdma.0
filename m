From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v4 1/9] IB/cma: pass the port number to ib_create_qp
Date: Tue, 8 Mar 2016 21:55:14 +0200
Message-ID: <20160308195514.GK13396@leon.nu>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-2-git-send-email-hch@lst.de>
 <20160308192709.GJ13396@leon.nu>
 <017b01d17972$11e5a3b0$35b0eb10$@opengridcomputing.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <017b01d17972$11e5a3b0$35b0eb10$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 08, 2016 at 01:38:20PM -0600, Steve Wise wrote:
> > On Tue, Mar 08, 2016 at 07:16:32PM +0100, Christoph Hellwig wrote:
> > > The new RW API will need this.
> > >
> > > Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > > Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > > ---
> > >  drivers/infiniband/core/cma.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> > > index 9729639..a791522 100644
> > > --- a/drivers/infiniband/core/cma.c
> > > +++ b/drivers/infiniband/core/cma.c
> > > @@ -800,6 +800,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ib_pd *pd,
> > >  	if (id->device != pd->device)
> > >  		return -EINVAL;
> > >
> > > +	qp_init_attr->port_num = id->port_num;
> > 
> > I doubt whether this is the right place to update qp_init_attr structure.
> > Maybe the better solution will be to update the callers of rdma_create_qp?
> > It will place all qp_init_attr assignments in one place.
> 
> At the expense of replicating this code and forcing all users to remember to set this.

There are no much such users to update, these users need to set
qp_init_attr structure anyway.

> 
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
