From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] IB/cma: Add default RoCE TOS to CMA configfs
Date: Tue, 31 Jan 2017 18:02:02 +0200
Message-ID: <20170131160201.GA20528@yuval-lap.uk.oracle.com>
References: <20170131105929.GA6788@mwanda>
 <01D1013C-F14B-467D-A21E-9EA6214A38F5@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <01D1013C-F14B-467D-A21E-9EA6214A38F5-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 31, 2017 at 03:32:48PM +0000, Majd Dibbiny wrote:
> 
> > On Jan 31, 2017, at 12:59 PM, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > Hello Majd Dibbiny,
> Hello Daniel,
> 
> Thanks for the report.
> I'll fix and send a new revision soon..

Can you re-base it on top of for-next and use the new inline function
rdma_is_port_valid?

> 
> > 
> > The patch eeec11e5c404: "IB/cma: Add default RoCE TOS to CMA
> > configfs" from Dec 19, 2016, leads to the following static checker
> > warning:
> > 
> >    drivers/infiniband/core/cma.c:303 cma_get_default_roce_tos()
> >    warn: signedness bug returning '(-22)'
> > 
> > drivers/infiniband/core/cma.c
> >   298  
> >   299  u8 cma_get_default_roce_tos(struct cma_device *cma_dev, unsigned int port)
> >   300  {
> >   301          if (port < rdma_start_port(cma_dev->device) ||
> >   302              port > rdma_end_port(cma_dev->device))
> >   303                  return -EINVAL;
> > 
> > This is a u8 function so you can't return negative error codes.
> > 
> >   304  
> >   305          return cma_dev->default_roce_tos[port - rdma_start_port(cma_dev->device)];
> >   306  }
> >   307  
> > 
> > regards,
> > dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
