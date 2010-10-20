From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] RPING: Make sure CQ event thread exits before
	destroying the CQ.
Date: Wed, 20 Oct 2010 14:31:52 -0600
Message-ID: <20101020203152.GN10362@obsidianresearch.com>
References: <20101020192859.1431.68877.stgit@build.ogc.int> <AANLkTi=uAuXT1RMEQ+vsA4FkN2828mZ2q0KPKXxpb6H0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=uAuXT1RMEQ+vsA4FkN2828mZ2q0KPKXxpb6H0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 20, 2010 at 10:05:36PM +0200, Bart Van Assche wrote:
> Are you aware that in general it is easy to trigger a deadlock or
> other undesired behavior by invoking pthread_cancel() ? If a thread
> e.g. gets canceled after having obtained a mutex lock and before that
> mutex is unlocked, this will cause trouble for any other thread that
> tries to grab the mutex.

Steve's specific case looks OK to me, at least considering how mlx4
and ibverbs operates, but I'm not sure that verbs and all of the
drivers have been carefully designed with cancellation safety in mind?

ie what happens to a ibv_poll_cq version that calls out to the kernel
like soft-iwarp? That will probably embed a cancelation point. Should
ibv_poll_cq be a cancellation point? etc..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
