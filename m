From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Kernel fast memory registration API proposal [RFC]
Date: Tue, 14 Jul 2015 09:53:40 -0600
Message-ID: <20150714155340.GA7399@obsidianresearch.com>
References: <559F8BD1.9080308@dev.mellanox.co.il>
 <20150713163015.GA23832@obsidianresearch.com>
 <55A4CABC.5050807@dev.mellanox.co.il>
 <20150714153347.GA11026@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150714153347.GA11026-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 14, 2015 at 08:33:47AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 14, 2015 at 11:39:24AM +0300, Sagi Grimberg wrote:
> > This is exactly what I don't want to do. I don't think that implicit
> > posting is a good idea for reasons that I mentioned earlier:
> > 
> > "This is where I have a problem. Providing an API that may or may not
> > post a work request on my QP is confusing, and I don't understand its
> > semantics at all. Do I need to reserve slots on my QP? should I ask for
> > a completion? If we suppress the completion will I see an error
> > completion? What should I expect to find in the wr_id?"
> > 
> > We're much better off with keeping the post interface in place but
> > have it much simpler.
> 
> The ULP doesn't care if it needs to reserver the slot, and it generally
> doesn't care about the notification either unless it needs to handle an
> error.
> 
> Instead of the ib_device knows if a MR needs a post it can through
> a helper set the right reservation.
> 
> The completions are another mad mightmare in the RDMA stack API.  Every
> other subsystem would just allow submitter to attach a function pointer
> that handles the completion to the posted item.  But no, the RDMA stack
> instead require ID allocators and gigantic boilerplate code in the
> consumer to untangle that gigantic mess again.
> 
> If we sort that out first the ULD doesn't have to care about FR
> notifications.

Right. We need to move away from our past. It was sort of reasonable
when we had brand new hardware and nobody knew what ULPs would look
like to just expose the raw HW primitives, and raw SQEs.

Now, the exercise should be a very simple code refactoring. Take the
duplciate stuff out of Lustre/iSER/SRP/NFS and share it. You can't ask
for a safer world to build an API from:

If all of those do posts w/ temp MR in sleepable contexts, then that
is OK for the shared API to require sleep.

If all those do FRMR setup, then post REG, then post ACT then factor
that three step pattern.

If all those do if (FMR) ... else ... then factor that pattern too.

Ditto for the Warp RDMA READ lkey buisness.

If all those want callbacks from work completions, then factor that.

It isn't even a question of API design, or what people like or don't
like. If those 4 ULPs do the same damn stuff, then factor it.

"It doesn't feel right" is not really a helpful response to an API
factoring excercise. "ULP XYZ cannot do that because of ABC" is a much
more productive reply.

We'd still have the low level API for new ULPs to experiment with, if
they really need.

I'm really disappointed by the negative emails on this subject..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
