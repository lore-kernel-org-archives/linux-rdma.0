From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Wed, 15 Jul 2015 02:07:10 -0700
Message-ID: <20150715090710.GA12220@infradead.org>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150715073233.GA11535@infradead.org>
 <55A61AE3.8020609@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55A61AE3.8020609-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 15, 2015 at 11:33:39AM +0300, Sagi Grimberg wrote:
> Umm, I think this can become weird given all other primitives have
> ib_ prefix. I'd prefer to keep that prefix to stay consistent, and have
> an incremental change to do it for all the primitives (structs & verbs).

Fine with me, we're getting into bikeshedding here anyway..

> >I'd also get rid of the horrible style of using structs even for simple
> >attributes.
> 
> The reason I thought an attr struct would benefit is that it can be
> easily extended without changing every single caller (we might have
> more attributes in the future?). Plus, it is consistent with QP and
> CQ creation.
> 
> If you feel strongly about it, I can change it.

It's a very hard to follow API, and extending callers for new features
is not an issue but actually a "feature" as it requires / encurages
a review of the caller to check how the new feature fits in for them.

> >To support FRMs if we care enough we'd create a purely in-memory MR
> >in rdma_create_mr and then map it to ib_fmr_pool_map_phys with a helper
> >that the driver can call instead of rdma_init_mr_wr.
> >
> 
> Lets take it at a later stage.

For the API to be useful it should cover the existing users.  I think
the FMR pool support is fairly trivial, so if you come up with he FR
version I'll volunteer to add it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
