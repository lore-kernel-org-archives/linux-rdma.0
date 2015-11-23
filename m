From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Mon, 23 Nov 2015 12:41:24 -0700
Message-ID: <20151123194124.GF32085@obsidianresearch.com>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
 <1448214409-7729-11-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448214409-7729-11-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 22, 2015 at 06:46:48PM +0100, Christoph Hellwig wrote:
> While IB supports the notion of returning separate local and remote keys
> from a memory registration, the iWarp spec doesn't and neither does any
> of our in-tree HCA drivers [1] nor consumers.  Consolidate the in-kernel
> API to provide only a single key and make everyones life easier.
> 
> [1] the EHCA driver which is in the staging tree on it's way out can
>     actually return two values from it's thick firmware interface.
>     I doubt they ever were different, though.

I like this too, but, I'm a little worried this makes the API more
confusing - ideally, we'd get rid of all the IB_ACCESS stuff from
within the kernel completely. Then it make sense, the mr is created as
a rkey/lkey mr, the single return is only one kind, and that kind must
go in the lkey/rkey spots in other API places.

Anyhow, for the core stuff:

Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
