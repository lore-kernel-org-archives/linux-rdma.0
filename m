From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v4 1/9] IB/cma: pass the port number to ib_create_qp
Date: Wed, 9 Mar 2016 16:43:12 +0200
Message-ID: <20160309144312.GB1977@leon.nu>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-2-git-send-email-hch@lst.de>
 <20160308192709.GJ13396@leon.nu>
 <017b01d17972$11e5a3b0$35b0eb10$@opengridcomputing.com>
 <20160308195514.GK13396@leon.nu>
 <20160309135804.GA32315@lst.de>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160309135804.GA32315-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2016 at 02:58:04PM +0100, 'Christoph Hellwig' wrote:
> On Tue, Mar 08, 2016 at 09:55:14PM +0200, Leon Romanovsky wrote:
> > > At the expense of replicating this code and forcing all users to remember to set this.
> > 
> > There are no much such users to update, these users need to set
> > qp_init_attr structure anyway.
> 
> But they need to extract the port_num first, while we already get
> the cm_id that has the right port_id passed to this function.  Not
> setting it in the qp_init_attr changes the interface from one that
> just works to one that is arcane, and prone to generate hard to
> detect errors (passing a 0 port_num will just work for all current
> drivers, but if someone at some point actually introduces different
> capabilities for differnet ports it will break for just that case!)

I understand your points and my claim is similar to yours, but from
different side. I think that setting qp_init_attr field separately
from the place there all variables were set is prone to errors.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
