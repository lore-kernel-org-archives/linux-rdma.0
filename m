From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix request completion holes
Date: Thu, 2 Nov 2017 09:12:54 -0600
Message-ID: <20171102151254.GE18874@ziepe.ca>
References: <1509440122-1190-1-git-send-email-sagi@grimberg.me>
 <8abcde91-9150-2982-3900-078619bcdac0@mellanox.com>
 <a950a671-22a1-432c-555e-8309c8a64a88@grimberg.me>
 <d9dcdb05-d001-53d8-7ed7-5fafc1709f4a@mellanox.com>
 <20171101165036.GD1030@ziepe.ca>
 <5f3955d2-9116-5f18-2299-cc697947d599@grimberg.me>
 <20171101175819.GG1030@ziepe.ca>
 <5810bb05-fffd-a0f2-3509-9d9b89a2ef32@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5810bb05-fffd-a0f2-3509-9d9b89a2ef32-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: idanb <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 02, 2017 at 10:06:30AM +0200, Sagi Grimberg wrote:
> 
> >>the default mode utilize remote invalidation, so no, its not valid.
> >
> >Well, usually the ULP design should allow some things to be reaped
> >async, and latency senstive things to be sync.
> >
> >Eg if you have a SEND using a local buffer with a RKEY, then you'd
> >declare the RKEY data completed when SEND_WITH_INVALIDATE is returned.
> >
> >Recycling the lkey command buffer is an async process and can wait
> >unsignaled until something signalled comes to push its completion
> >through.
> 
> Not when using inline data with the send, which is the main issue
> here. if we inline data to the command, we will use the local
> dma lkey, which does not even have a local invalidate following it.

Does nvme use inline data send and RKEY transfer in the same SEND?
Then it would need to signal the SEND if remote invalidate is used,
otherwise it only needs to signal the local invalidate for the RKEY..

> >Local invalidate is defined to always be ordered by the spec, so it
> >is required to guarentee that the SEND is completed.

> So local invalidate completion is guaranteed to come after all the
> completions prior to it in the send queue?

IBA spec says so..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
