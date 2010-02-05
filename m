From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 5 Feb 2010 15:08:10 -0500
Message-ID: <E8FF8BD1-80AC-4AA7-BC2A-CE7547FB9ABA@cisco.com>
References: <ada4olvefl4.fsf@roland-alpha.cisco.com> <324EFA68-12F6-46E9-B876-7F4847B53224@cisco.com> <4B6C6453.9090706@opengridcomputing.com> <20100205185616.GS16490@obsidianresearch.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100205185616.GS16490-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Feb 5, 2010, at 1:56 PM, Jason Gunthorpe wrote:

> > I think we should remove the feature of allowing binds to 127.0.0.1 
> > altogether based on Jeff's arguments and my assertion that 127.0.0.1 is 
> > a sw-loopback mechanism anyway...
> 
> I don't agree, the kernel should be free to provide a loop back
> service any way it likes, and if that means using one of the HW

Ok, fine.  Should we push back OFED 1.5.1 until Open MPI can get 1.4.2 out?  I don't know when that will be.

In short: you're breaking backward compatibility with zero warning.  There is real software out there that will break if people upgrade their kernel/OFED/RDMA CM/whatever (e.g., Open MPI).  Isn't this supposed to be the Enterprise distribution (meaning: stability)?  (trying to keep the frustration out of my voice...)

This is a terrible, terrible idea.

How about this: back out the change for now.  Give everyone time to upgrade.  If nothing else, ***give those of us who are involved in this community*** time to upgrade.  Then put the feature back in after adequate time has passed.

-- 
Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cisco.com - http://www.cisco.com

For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
