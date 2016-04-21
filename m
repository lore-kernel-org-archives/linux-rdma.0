From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared Topic Branch For ABI Changes
Date: Thu, 21 Apr 2016 11:38:15 -0600
Message-ID: <20160421173815.GB5102@obsidianresearch.com>
References: <20160420055221.GT6349@leon.nu>
 <20160420152924.GA25424@obsidianresearch.com>
 <20160421065847.GC12730@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160421065847.GC12730-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 21, 2016 at 09:58:47AM +0300, Leon Romanovsky wrote:
> On Wed, Apr 20, 2016 at 09:29:24AM -0600, Jason Gunthorpe wrote:
> > On Wed, Apr 20, 2016 at 08:52:21AM +0300, Leon Romanovsky wrote:
> > 
> > > The supplementary user space (libibverbs) repository will be set a
> > > little bit later.
> > 
> > We should also re-consider the idea that has been floated a few times
> > over the years:
> > 
> >  Combine all the RMDA plumbing libraries into one git repository.
> > 
> > This is librdmacm, libibverbs, libucm, libumad, libmad,
> > libmlx4/5/mtcha/ipath/cxgb/etc/etc
> 
> Can you point me to relevant discussion?

I couldn't find it in the archive quickly. Doug, myself and Steve Wise
were talking about it after Doug started.

Doug was ambivalent, Steve was against. There was a concern the natual
release schedual of the parts was different, so why link them.

My counter was that isn't really important, the goal is is to reduce
developer time when working on this mess.

Since we are looking at changing *everything* developer time seems
more important right now.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
