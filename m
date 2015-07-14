From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Tue, 14 Jul 2015 10:35:06 -0600
Message-ID: <20150714163506.GC7399@obsidianresearch.com>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150713163015.GA23832@obsidianresearch.com>
 <55A4CABC.5050807@dev.mellanox.co.il>
 <20150714153347.GA11026@infradead.org>
 <55A534D1.6030008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A534D1.6030008-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 14, 2015 at 07:12:01PM +0300, Sagi Grimberg wrote:
> >The ULP doesn't care if it needs to reserver the slot, and it generally
> >doesn't care about the notification either unless it needs to handle an
> >error.
> 
> That's generally correct. But the ULP may want to suppress notifications
> of other posts as well (for example a storage initiator may want to
> suppress send completions since it needs to reserve the request context
> until it receives the status anyway - which is a receive completion). It
> needs to take what was posted and what not into account to avoid
> wrapping.

I don't see how this is a concern, API wise. All callers are paring
the MR post with a real op anyhow.

> If I'm not mistaken iWARP requires to ask for a completion once every
> send-queue length and empirically, IB drivers requires it too. So again,
> I don't think implicit posting is a very good idea.

Yes, all proper use of RDMA requires counting SQEs consumed and
freeing them only on completion. Nobody should be using the EAGAIN
scheme. But it is trivial to handle, you don't start an op until you
can post the entire compound SQE, and you must always tag the last SQE
for signal if the # of SQEs left drops below the # required for the
largest compound (or another similar scheme).

But you should never have to signal on the MR post, it should always
be at the end of the compound, on the RDMA, SEND, or invalidate..

That is just basic 'how do you use a SQ properly', every ULP should
do it, wrappering posts in an API doesn't change anything fundamental.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
