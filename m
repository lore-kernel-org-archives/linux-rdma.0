From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix request completion holes
Date: Wed, 1 Nov 2017 11:58:19 -0600
Message-ID: <20171101175819.GG1030@ziepe.ca>
References: <1509440122-1190-1-git-send-email-sagi@grimberg.me>
 <8abcde91-9150-2982-3900-078619bcdac0@mellanox.com>
 <a950a671-22a1-432c-555e-8309c8a64a88@grimberg.me>
 <d9dcdb05-d001-53d8-7ed7-5fafc1709f4a@mellanox.com>
 <20171101165036.GD1030@ziepe.ca>
 <5f3955d2-9116-5f18-2299-cc697947d599@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5f3955d2-9116-5f18-2299-cc697947d599-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: idanb <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 01, 2017 at 07:31:39PM +0200, Sagi Grimberg wrote:

> the default mode utilize remote invalidation, so no, its not valid.

Well, usually the ULP design should allow some things to be reaped
async, and latency senstive things to be sync.

Eg if you have a SEND using a local buffer with a RKEY, then you'd
declare the RKEY data completed when SEND_WITH_INVALIDATE is returned.

Recycling the lkey command buffer is an async process and can wait
unsignaled until something signalled comes to push its completion
through.

This approach reduces the # of CQEs required at the expense of
delaying reaping the lkey buffer.

> Without remote invalidate I'm not sure, don't remember the ordering
> rules from the top of my head. Idan, does a local invalidate completion
> guarantee a prior send completion (of a non-related buffer)? I vaguely
> remember that explicit fencing is required to guarantee that.

This was the case I thought Idan was testing..

Local invalidate is defined to always be ordered by the spec, so it
is required to guarentee that the SEND is completed.

> I guess we could not signal send completions if we are in a local
> invalidate mode, but I'm liking this less and less...

If the SEND reaping can be defered as above, then the local invalidate
completion becomes the signaled CQE that allows the SEND to be reaped.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
