From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Allow for non-double word multiple message sizes for user SDMA
Date: Thu, 28 Jul 2016 12:35:37 -0400
Message-ID: <20160728163536.GB28030@phlsvsds.ph.intel.com>
References: <20160728010842.GC3158@phlsvsds.ph.intel.com> <20160728075840.GN4628@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160728075840.GN4628-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 28, 2016 at 10:58:40AM +0300, Leon Romanovsky wrote:
> On Wed, Jul 27, 2016 at 09:08:42PM -0400, ira.weiny wrote:
> > 
> > The driver pads non-double word multiple message sizes but it doesn't
> > account for this padding when the packet length is calculated. Also, the
> > data length is miscalculated for message sizes less than 4 bytes due to
> > the bit representation in LRH. And there's a check for non-double word
> > multiple message sizes that prevents these messages from being sent.
> > This patch fixes length miscalculations and enables the functionality to
> > send non-double word multiple message sizes.
> > 
> > Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> 
> Ira,
> Is this sizeof(u32) really necessary? It is always the same 4 bytes in
> all architectures.

Yes, using the magic number 4 would work but I don't think it really matters
either way.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
