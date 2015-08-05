From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Tue, 04 Aug 2015 23:41:16 -0700
Message-ID: <1438756876.5698.2.camel@haswell.thedillows.org>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
	 <55BBF4B8.2050700@sandisk.com> <20150803152420.GA24193@infradead.org>
	 <55BFB40F.8000500@sandisk.com> <20150804180933.GB5038@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804180933.GB5038-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2015-08-04 at 12:09 -0600, Jason Gunthorpe wrote:
> On Mon, Aug 03, 2015 at 11:33:51AM -0700, Bart Van Assche wrote:
> > >Bart, do you know what hardware this workaround is for?
> > 
> > I hope the HW vendors can comment on this. Sorry but I'm not sure which HCA
> > models and/or firmware versions do not support FMR mapping with a non-zero
> > offset.
> 
> Perhaps David can remember why he added this:
> 
> commit 8f26c9ff9cd0317ad867bce972f69e0c6c2cbe3c

It's originally from commit 559ce8f150d7d031c79c4d79173860f1bdfe3ce4,
and the list's attempts at code archaeology failed us: 
http://article.gmane.org/gmane.linux.drivers.rdma/7149

> The way it is phrased makes it seem like a target bug, not a HCA bug?

Yes, the original commit is explicit about it being a target issue.
Since it mentioned the boogeyman words "data corruption", I kept the
work around in the FMR work. 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
