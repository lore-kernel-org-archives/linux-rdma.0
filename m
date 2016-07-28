From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/28] IB/hfi1: Fix to fully initialize send context area
Date: Thu, 28 Jul 2016 12:32:09 -0400
Message-ID: <20160728163209.GA28030@phlsvsds.ph.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com> <20160725203759.4800.2358.stgit@scvm10.sc.intel.com> <20160726052657.GD20674@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160726052657.GD20674-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrzej Kacprowski <andrzej.kacprowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 26, 2016 at 08:26:57AM +0300, Leon Romanovsky wrote:
> On Mon, Jul 25, 2016 at 01:38:01PM -0700, Dennis Dalessandro wrote:
> > From: Tymoteusz Kielan <tymoteusz.kielan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> >  
> > -	dd->kernel_send_context = kmalloc_node(dd->num_send_contexts *
> > +	dd->kernel_send_context = kzalloc_node(dd->num_send_contexts *
> >  					sizeof(struct send_context *),
> >  					GFP_KERNEL, dd->node);
> 
> Dennis,
> Don't you want to check kzalloc_node execution success
> prior to use dd->kernel_send_context?

Again thanks for catching this.  Follow on fix was sent which depends on this
patch.

Thanks,
Ira

> 
> >  	dd->kernel_send_context[0] = dd->vld[15].sc;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
