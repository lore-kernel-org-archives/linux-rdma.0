From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Wed, 5 Aug 2015 13:51:22 -0600
Message-ID: <20150805195122.GA31595@obsidianresearch.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com>
 <20150803152420.GA24193@infradead.org>
 <55BFB40F.8000500@sandisk.com>
 <20150804180933.GB5038@obsidianresearch.com>
 <1438756876.5698.2.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438756876.5698.2.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 04, 2015 at 11:41:16PM -0700, David Dillow wrote:
> On Tue, 2015-08-04 at 12:09 -0600, Jason Gunthorpe wrote:
> > On Mon, Aug 03, 2015 at 11:33:51AM -0700, Bart Van Assche wrote:
> > > >Bart, do you know what hardware this workaround is for?
> > > 
> > > I hope the HW vendors can comment on this. Sorry but I'm not sure which HCA
> > > models and/or firmware versions do not support FMR mapping with a non-zero
> > > offset.
> > 
> > Perhaps David can remember why he added this:
> > 
> > commit 8f26c9ff9cd0317ad867bce972f69e0c6c2cbe3c
> 
> It's originally from commit 559ce8f150d7d031c79c4d79173860f1bdfe3ce4,
> and the list's attempts at code archaeology failed us: 
> http://article.gmane.org/gmane.linux.drivers.rdma/7149

Okay.. So over time we went from a clear target specific bug described
9 years ago in 559ce through chinese whispers to a general unspecific
fear of non-zero offset FMR?

But nobody has described FMR failure in this way in the past 9 years
with any specificity?

My random guesses would be broken mthca firmware at the start of the
FMR feature (long since fixed) or a wonky target that is now 10 years
obsolete..

If it was an HCA bug, I strongly have to think it is fixed now. We use
FMR all over the place and SRP is the only area I've noticed this
restriction..

If it is a target bug, then FRWR should trigger it as wel, so we are
already about to revert that workaround.

I'm inclined to drop this entirely.. What do you think Bart?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
