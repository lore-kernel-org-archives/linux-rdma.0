From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] RPING: Make sure CQ event thread exits before
	destroying the CQ.
Date: Wed, 20 Oct 2010 14:35:51 -0600
Message-ID: <20101020203551.GO10362@obsidianresearch.com>
References: <20101020192859.1431.68877.stgit@build.ogc.int> <AANLkTi=uAuXT1RMEQ+vsA4FkN2828mZ2q0KPKXxpb6H0@mail.gmail.com> <4CBF4D30.3050500@opengridcomputing.com> <AANLkTimTpM_h7P8tacZic2aP7i=dBiAquDN5S_D881ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimTpM_h7P8tacZic2aP7i=dBiAquDN5S_D881ae-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 20, 2010 at 10:23:25PM +0200, Bart Van Assche wrote:

> Please keep in mind that glibc uses locking internally for many file
> I/O functions, e.g. printf() and fprintf().

POSIX strictly defines what functions are, aren't and could be
cancellation points, yes it is a surprising list. But, glibc won't
break internally if you cancel any of its function calls. It has
cleanup handlers and what not to protect itself.

rping doesn't hold locks, or allocate memory in the cq_thread, so it
seems OK to me. My main question would be what happens internally to
ibverbs, and does it call any possible cancellation point while holding
locks - is it missing cleanup handlers? Etc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
