From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] i40iw: add main, hdr, status
Date: Wed, 18 Jan 2017 13:24:09 +0200
Message-ID: <20170118112408.GC7544@yuval-lap.uk.oracle.com>
References: <20170117135850.GB6353@mwanda>
 <20170117185247.GA63212@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170117185247.GA63212-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 17, 2017 at 12:52:48PM -0600, Shiraz Saleem wrote:
> On Tue, Jan 17, 2017 at 04:58:50PM +0300, Dan Carpenter wrote:
> > Hello Faisal Latif,
> > 
> > The patch 8e06af711bf2: "i40iw: add main, hdr, status" from Jan 20,
> > 2016, leads to the following static checker warning:
> > 
> > 	drivers/infiniband/hw/i40iw/i40iw_main.c:606 i40iw_create_cqp()
> > 	error: uninitialized symbol 'maj_err'.
> > 
> > drivers/infiniband/hw/i40iw/i40iw_main.c
> >    599          status = dev->cqp_ops->cqp_init(dev->cqp, &cqp_init_info);
> >    600          if (status) {
> >    601                  i40iw_pr_err("cqp init status %d\n", status);
> >    602                  goto exit;
> >    603          }
> >    604          status = dev->cqp_ops->cqp_create(dev->cqp, &maj_err, &min_err);
> >    605          if (status) {
> >    606                  i40iw_pr_err("cqp create status %d maj_err %d min_err %d\n",
> >    607                               status, maj_err, min_err);
> > 
> > Not all error paths in i40iw_sc_cqp_create() initialized maj_err and
> > min_err.   Can't we just delete this printk?
> 
> We would like to keep maj_err and min_err prints  
> 
> In i40iw_create_cqp, can we initialize the locals maj_err and min_err to 
> 0 instead of deleting the printk. 

Don't you think it is the job of cqp_create to set maj_err and min_err when
replying with an error?

> 
> > 
> >    608                  goto exit;
> >    609          }
> > 
> > regards,
> > dan carpenter
> > --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
