From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] RPING: Make sure CQ event thread exits before
	destroying the CQ.
Date: Wed, 20 Oct 2010 15:16:17 -0600
Message-ID: <20101020211617.GP10362@obsidianresearch.com>
References: <20101020192859.1431.68877.stgit@build.ogc.int> <AANLkTi=uAuXT1RMEQ+vsA4FkN2828mZ2q0KPKXxpb6H0@mail.gmail.com> <4CBF4D30.3050500@opengridcomputing.com> <AANLkTimTpM_h7P8tacZic2aP7i=dBiAquDN5S_D881ae@mail.gmail.com> <20101020203551.GO10362@obsidianresearch.com> <4CBF5786.2020203@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CBF5786.2020203-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 20, 2010 at 03:56:38PM -0500, Steve Wise wrote:

> Hey Jason, do you have a pointer to the list of pthread cancellation  
> points for Linux?

Sure do

http://www.kernel.org/doc/man-pages/online/pages/man7/pthreads.7.html

POSIX:2008 is a more authoritative source, the above is cribbed from
there. You can see the list of cancelation points is pretty wild :(

IMHO, it would be a useful job for someone to sort this out for
verbs and the drivers - document what ibv interfaces are not
cancelation points and make all the ibv apis cancelation-safe.
I bet there isn't much coding, just lots of auditing. Just now I
looked through all the functions cq_thread called and decided
everything but ibv_poll_cq was certainly not a cancelation point for
mlx4/mtcha, while ibv_poll_cq was too complex to tell right away.

In glibc if a function is not cancelable it will be marked with __THROW.
I wonder if gcc (or sparse?) could check that functions
marked __THROW don't call other functions not marked __THROW ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
