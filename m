From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: identify the race condition in this code and win the respect
 of linux-rdma developers!
Date: Fri, 16 Sep 2011 13:57:34 -0600
Message-ID: <20110916195734.GA6392@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E5B2B1@ORSMSX101.amr.corp.intel.com>
 <20110916005008.GC6020@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237316E5B320@ORSMSX101.amr.corp.intel.com>
 <20110916155955.GA18548@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237316E5B55E@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E5B55E-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 16, 2011 at 07:36:17PM +0000, Hefty, Sean wrote:

> I was suggesting that there were only 2 states, not 3, with
> ibv_get_cq_event() simply retrieving a queued event from the kernel
> without touching the CQ state.

But that isn't true, as you point out in your next message
ibv_get_cq_event calls mlx4_cq_event which does alter the CQ state,
particularly in how it behaves WRT to mlx4_arm_cq.

Hard to say what the arm_sn does, but my guess is that it is creating
a one-shot that is sensitive to ibv_get_cq_event, eg you will never
get more than one event queued in the kernel queue, which creates the
3 state system I described.. (at least that matches my experience)

Certainly, considering that arm_sn is a 3 bit counter, calling
mlx4_cq_event many times then calling arm_cq will alias the counter
from the point of view of the chip and that can't possibly be good.

> I changed the code to do this:
> 
> 	do {
> 		poll
> 		rearm
> 		poll
> 		get_event
> 	} while (1);
> 
> which I believe fixes the issue.

In the past I looked at all this and concluded this was the only
possible correct way to write the loop. You have to guarentee rearm is
called before every get_event and you have to do a poll after every
rearm.

> Thanks for the help.  You are now the winner of my respect.  :)

NP :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
