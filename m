From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] libibverbs: add ARM64 memory barrier macros
Date: Wed, 18 May 2016 16:28:57 -0600
Message-ID: <20160518222857.GB23835@obsidianresearch.com>
References: <20160518220302.81260E09E9@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160518220302.81260E09E9-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 18, 2016 at 02:16:39PM -0700, Steve Wise wrote:
> The default generic barriers are not correct for ARM64. This results in
> data corruption.  The correct macros are lifted from the linux kernel.
> 
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> 
> I wonder why the linux kernel doesn't export these?  Also, if the hw
> platform is unknown, I don't think libibverbs should pick a default
> implementation that might cause data corruption.  Rather, I think it
> should just fail a compile on that platform.

These days, in user space this sort of stuff should be done following
the C11 atomic memory ordering model and not by trying to shoe-horn in
the kernel model. Then the compiler takes care of things properly.

This is using calls like atomic_store, atomic_load and
atomic_thread_fence to create the same sort of barriers.

You could probably implement the Xmbs() with variations on
atomic_thread_fence ??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
