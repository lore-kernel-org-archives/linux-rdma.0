From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 13:09:47 -0600
Message-ID: <20150715190947.GE23588@obsidianresearch.com>
References: <20150713163015.GA23832@obsidianresearch.com>
 <55A4CABC.5050807@dev.mellanox.co.il>
 <20150714153347.GA11026@infradead.org>
 <55A534D1.6030008@dev.mellanox.co.il>
 <20150714163506.GC7399@obsidianresearch.com>
 <55A53F0B.5050009@dev.mellanox.co.il>
 <20150714170859.GB19814@obsidianresearch.com>
 <55A6136A.8010204@dev.mellanox.co.il>
 <20150715183129.GC23588@obsidianresearch.com>
 <005201d0bf2f$0e5e3ed0$2b1abc70$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <005201d0bf2f$0e5e3ed0$2b1abc70$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >   - ULP calls a 'rdma_post_close_rkey' helper
> >      * For FRWR this posts the INVALIDATE
> 
> Note: Some send operations automatically invalidate an rkey (and the
> lkey for IB?).  This is intended to avoid having to post the
> invalidate WR explicitly.  Namely IB_WR_READ_WITH_INV and
> IB_WR_SEND_WITH_INV.

IB_WR_RDMA_READ_WITH_INV is only meaningful/implemented for iWarp. Can
you confirm what it does?

 wc.opcode = IB_WR_RDMA_READ_WITH_INV
 wc.sg_list[0].lkey = LKEY;
 wc.rdma.rkey = RKEY;

Does it locally invalidate LKEY or remotely invalidate RKEY? I'm
feeling pretty confident to guess it invalidates LKEY..

'rdma_post_close_rkey' wouldn't work with lkeys, hence the name :)

IB_WR_SEND_WITH_INV is sadly never used in the kernel. It does
invalidate an rkey, and would have to interact with a
'rdma_post_close_rkey'.

A generic flow could be something like:

  if (rdma_post_close_rkey_wc(qp,rkey,wc,...) ..)
    // invalidate triggred by the peer, all done.
  else
    // Peer didn't invalidate, func queued it locally, ULP waits for the next completion, then all done.
  else
    // Error

Where the _wc varient checks the wc to confirm that the requested rkey
has been invalidated.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
