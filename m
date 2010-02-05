From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 5 Feb 2010 14:14:55 -0700
Message-ID: <20100205211455.GT16490@obsidianresearch.com>
References: <ada4olvefl4.fsf@roland-alpha.cisco.com> <324EFA68-12F6-46E9-B876-7F4847B53224@cisco.com> <4B6C6453.9090706@opengridcomputing.com> <20100205185616.GS16490@obsidianresearch.com> <E8FF8BD1-80AC-4AA7-BC2A-CE7547FB9ABA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E8FF8BD1-80AC-4AA7-BC2A-CE7547FB9ABA-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 05, 2010 at 03:08:10PM -0500, Jeff Squyres wrote:
> On Feb 5, 2010, at 1:56 PM, Jason Gunthorpe wrote:
> 
> > > I think we should remove the feature of allowing binds to 127.0.0.1 
> > > altogether based on Jeff's arguments and my assertion that 127.0.0.1 is 
> > > a sw-loopback mechanism anyway...
> > 
> > I don't agree, the kernel should be free to provide a loop back
> > service any way it likes, and if that means using one of the HW
> 
> Ok, fine.  Should we push back OFED 1.5.1 until Open MPI can get 1.4.2 out?  I don't know when that will be.
 
> In short: you're breaking backward compatibility with zero warning.
> There is real software out there that will break if people upgrade
> their kernel/OFED/RDMA CM/whatever (e.g., Open MPI).  Isn't this
> supposed to be the Enterprise distribution (meaning: stability)?
> (trying to keep the frustration out of my voice...)

Well, I think you are right. This kind of change seems appropriate to
me for mainline, but OFED/RHEL should carry a responsibility to manage
an identified incompatibility, either patch their kernel, patch their
OMPI, or publish an errata. That is the role of a distribution.

> How about this: back out the change for now.  Give everyone time to
> upgrade.  If nothing else, ***give those of us who are involved in
> this community*** time to upgrade.  Then put the feature back in
> after adequate time has passed.

I've seen this approach go badly too :( If it isn't actually in a
mainline kernel userspace devs tend to ignore it ..

Sounds like this is taken care for now anyhow, Sean's patch to remove
it for iwarp since it doesn't work today with any iwarp drivers does
obscure the problem.. But it does seem like rdma_cm mode for IB
networks will still be broken in OMPI with the new kernels.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
