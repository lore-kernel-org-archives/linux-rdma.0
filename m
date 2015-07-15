From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 11:19:26 -0600
Message-ID: <20150715171926.GB23588@obsidianresearch.com>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150713163015.GA23832@obsidianresearch.com>
 <55A4CABC.5050807@dev.mellanox.co.il>
 <20150714153347.GA11026@infradead.org>
 <55A534D1.6030008@dev.mellanox.co.il>
 <20150714163506.GC7399@obsidianresearch.com>
 <55A53F0B.5050009@dev.mellanox.co.il>
 <20150714170859.GB19814@obsidianresearch.com>
 <55A6136A.8010204@dev.mellanox.co.il>
 <A9EF2F26-E737-4E80-B2E3-F8D6406F9893@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <A9EF2F26-E737-4E80-B2E3-F8D6406F9893-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 15, 2015 at 10:32:55AM -0400, Chuck Lever wrote:

> I would rather not build a non-deterministic delay into the
> unmap interface. Using a pool or having map do an implicit
> unmap are both solutions I=E2=80=99d rather avoid.

Can you explain how NFS is using FMR today? When does it unmap a FMR
rkey and lkey?

If NFS/etc currently have a hole on rkey invalidation when using FMR,
and that hole simply cannot reasonably be solved, I'm actually mildly O=
K
with enshrining that in a new MR API..

So, it would seem to me, the only major addition we'd need to Sagi's
draft to support FMR, would be a way to catch the completion (the
rdma_unreg_mr) and trigger async MR recycling async in a work queue.

Sagi, how does cleanup of the temporary FRMR work in your draft
proposal? What does the ULP do upon completion?

[Also, just mildly curious, how do we get into an unsleepable
 context anyhow? is the IB completion pending callback called in a
 sleepable context?]

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
