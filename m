From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
Date: Thu, 19 May 2016 11:02:36 -0500
Message-ID: <060701d1b1e7$dc7e1ff0$957a5fd0$@opengridcomputing.com>
References: <20160518220302.81260E09E9@smtp.ogc.us> <20160518222857.GB23835@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160518222857.GB23835-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> On Wed, May 18, 2016 at 02:16:39PM -0700, Steve Wise wrote:
> > The default generic barriers are not correct for ARM64. This results in
> > data corruption.  The correct macros are lifted from the linux kernel.
> >
> > Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> > I wonder why the linux kernel doesn't export these?  Also, if the hw
> > platform is unknown, I don't think libibverbs should pick a default
> > implementation that might cause data corruption.  Rather, I think it
> > should just fail a compile on that platform.
> 
> These days, in user space this sort of stuff should be done following
> the C11 atomic memory ordering model and not by trying to shoe-horn in
> the kernel model. Then the compiler takes care of things properly.
> 
> This is using calls like atomic_store, atomic_load and
> atomic_thread_fence to create the same sort of barriers.
> 
> You could probably implement the Xmbs() with variations on
> atomic_thread_fence ??

Looking at the documentation, it is not clear to me which parameter value passed
to atomic_thread_fence() maps to each of the mb services.  Is it correct to
think that if I get it right, the resulting assembly should be what we currently
have for the mb services?

Or perhaps someone else can provide guidance?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
