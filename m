From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ib_ipoib: CSUM support in connected mode
Date: Wed, 8 Oct 2014 11:14:57 -0600
Message-ID: <20141008171457.GE4153@obsidianresearch.com>
References: <1412423147-8402-1-git-send-email-yuval.shaia@oracle.com>
 <20141005223500.GB31716@obsidianresearch.com>
 <20141008104028.GA4109@yuval-lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141008104028.GA4109@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 08, 2014 at 01:40:29PM +0300, Yuval Shaia wrote:
> > Which is exactly what we want.

> Will do, thanks.
> This is in case this code runs on bridge, right?

It covers many cases, including linux briding and routing functions,
as well as packet dumping.

I don't know if any special actions are needed to support
CHECKSUM_PARTIAL, you should probably check the other drivers that use
it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
