From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] [IPOIB] Check for a MTU overflow on the GSO path
Date: Wed, 15 Sep 2010 16:33:57 -0600
Message-ID: <20100915223356.GA14549@obsidianresearch.com>
References: <20100902231140.GW24971@obsidianresearch.com> <4C90BBBB.6040503@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4C90BBBB.6040503-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 15, 2010 at 02:27:39PM +0200, Or Gerlitz wrote:
> Jason Gunthorpe wrote:
> >The code to check that the send packet size is less than the MTU is only 
> >invoked in the non-GSO case. This lets packets which are too large pass 
> >through. 
> Jason,
> 
> Did you get here following code inspection or during debugging? if the 
> latter, what does it take to reproduce that?

I noticed it when I was working on the code for the patch after, IPoIB
was still causing MTU discards in my network and that was why. I
didn't try it with CM mode, but I can't see that it would be any
different.

In my testing what I noticed was that the first few packets of a TCP
session triggered the PMTU stuff, but immediately after were a few
GSO packets that tried to go through with the larger MTU. They were
resent fairly quickly with the correct MTU due to the PMTU fixup that
happened.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
