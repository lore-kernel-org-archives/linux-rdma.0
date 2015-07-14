From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Tue, 14 Jul 2015 10:22:17 -0600
Message-ID: <20150714162217.GB7399@obsidianresearch.com>
References: <20150708190842.GB11740@obsidianresearch.com>
 <559D983D.6000804@talpey.com>
 <20150708233604.GA20765@obsidianresearch.com>
 <559E54AB.2010905@dev.mellanox.co.il>
 <20150709170142.GA21921@obsidianresearch.com>
 <20150711102538.GB14741@infradead.org>
 <55A4134C.2040301@talpey.com>
 <20150713201538.GA11681@obsidianresearch.com>
 <55A4D20C.2000904@dev.mellanox.co.il>
 <20150714153619.GC11026@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150714153619.GC11026-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 14, 2015 at 08:36:19AM -0700, 'Christoph Hellwig' wrote:
> Oh, I had missed that PHYS_MR might sleep.  That might be the reasons
> why everyone is avoiding them despite Tom preferring them over FMR.

Yep, almost certainly.

But even that is just a legacy of the bad API.

Even Sagi's API idea can accommodate this with enough driver effort,
but only if posting is combined:

- alloc_mr: Just set aside any memory the driver needs for PHYS_MR
- set_sg_list_and_post:
  + This would issue the PHYS_MR call to the NIC, but not
    sleep. It would adjust the SQ so that the tail pointer is blocked
    and the NIC doesn't see any more posts. Effectively, the SQ
    stalls. This way the ULP can post more stuff and ordering is preserved.
  + It would then setup a callback for PHYS_MR NIC completion and
    return, having never slept.
  + The callback will unblock the SQ

Yes, this is complicated, but it shows how combing MR setup and post
together lets us do a lot more.

Sadly, we could probably never do this for older drivers due to them
being unmaintained, but it is certainly possible the core could
provide an older driver wrapper that emulates the above with less
efficiency using threads/queues/etc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
