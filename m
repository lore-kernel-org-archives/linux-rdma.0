From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libibverbs/doc: clarify selective signaling (Re: using
 IBV_SEND_SIGNALED)
Date: Tue, 30 Nov 2010 11:57:44 -0700
Message-ID: <20101130185744.GK16788@obsidianresearch.com>
References: <alpine.LNX.2.00.1011291128190.31687@postal.iol.unh.edu>
 <4CF3DDF0.2070907@opengridcomputing.com>
 <alpine.LNX.2.00.1011291233540.5810@postal.iol.unh.edu>
 <4CF3E5FA.6010308@opengridcomputing.com>
 <4CF4E65D.4070205@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CF4E65D.4070205-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Robert D. Russell" <rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 30, 2010 at 01:56:13PM +0200, Or Gerlitz wrote:
> Steve Wise wrote:
> > On 11/29/2010 11:34 AM, Robert D. Russell wrote:
> > See section 8.2.1 of the iWARP Verbs draft at:
> > http://tools.ietf.org/html/draft-hilland-rddp-verbs-00#section-8.2.1.
> > The last big paragraph in 8.2.1 spells it all out.
> > There should be a similar requirement in the IBTA IB Verbs specification...
> 
> Yes, I think the below patch to the man page can help people
> understand how to work with the thing

I think the subtly here is that remote completion of a local WR does
not indiciate local completion. This is the only operational case I
can think of that might break the rules.

For instance a protocol that had remote acks for all SENDs might be
tempted to not ever use signaled WR's on the local side - since
receiving the remote ACK SEND must indicate the local SEND WR is
complete. This is the incorrect assumption.

So, I'd suggest this language:

Applications which use selective signaling can only assume that
unsignaled WRs are complete once a completion for a later signaled WR
is received. In practice this means that a signaled WR must be
used periodically, and that the send queue should never be filled with
unsignaled WRs.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
