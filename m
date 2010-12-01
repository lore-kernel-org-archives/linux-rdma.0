From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libibverbs/doc: clarify selective signaling (Re: using
 IBV_SEND_SIGNALED)
Date: Wed, 1 Dec 2010 12:10:46 -0700
Message-ID: <20101201191046.GR16788@obsidianresearch.com>
References: <alpine.LNX.2.00.1011291128190.31687@postal.iol.unh.edu>
 <4CF3DDF0.2070907@opengridcomputing.com>
 <alpine.LNX.2.00.1011291233540.5810@postal.iol.unh.edu>
 <4CF3E5FA.6010308@opengridcomputing.com>
 <4CF4E65D.4070205@Voltaire.com>
 <20101130185744.GK16788@obsidianresearch.com>
 <4CF60ED0.6000502@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CF60ED0.6000502-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Robert D. Russell" <rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 01, 2010 at 11:01:04AM +0200, Or Gerlitz wrote:
> Jason Gunthorpe wrote:
> > Applications which use selective signaling can only assume that
> > unsignaled WRs are complete once a completion for a later signaled WR
> > is received. In practice this means that a signaled WR must be
> > used periodically, and that the send queue should never be filled with unsignaled WRs.
> 
> clarify selective signaling usage
> 
> Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
 
> Jason, how's this?

Sure, but reviewing the original thread makes me think there is a
greater mis-understanding at work about how resource ownership works
in verbs than simply related to the unsignaled WRs.

Maybe this would be a better approach:

RESOURCE OWNERSHIP
 ibv_post_* transfers ownership of the described buffer(s) 
 to the device. While the device is processing the WR the buffer(s)
 should not be changed and a queue entry is
 consumed to hold this WR while it is being processed.

 Callers are required to track how many entries in the queue are
 owned by the device and how many are free for new WRs.
 Attempting to post more WRs that there are free queue entries results
 in E???.

 Ownership of the buffer and queue entry is only passed back to the
 caller once a completion on the associated CQ is retrieved.
 A completion indicates all prior WR are completed, including
 unsignaled WRs.

 Note that receiving a completion for the WR through a CQ is the only
 way to know that the queue entry and WR is passed back to the
 caller. Other implicit means, such as receiving a recv completion,
 observing data change in memory, or the like do not reliably indicate
 that the device is finished with the queue entry and WR.

 When using unsignaled WRs it is necessary to periodically use
 a signaled WR and collect completions so that the available free
 space in the queue can be tracked.

Also, I like your sentence about errors for unsignaled WCs, that
should be kept in the IBV_SEND_SIGNALED section..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
