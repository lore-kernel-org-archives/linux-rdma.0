From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 5 Feb 2010 11:56:17 -0700
Message-ID: <20100205185616.GS16490@obsidianresearch.com>
References: <ada4olvefl4.fsf@roland-alpha.cisco.com> <324EFA68-12F6-46E9-B876-7F4847B53224@cisco.com> <4B6C6453.9090706@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B6C6453.9090706-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 05, 2010 at 12:32:51PM -0600, Steve Wise wrote:

> I think we should remove the feature of allowing binds to 127.0.0.1  
> altogether based on Jeff's arguments and my assertion that 127.0.0.1 is  
> a sw-loopback mechanism anyway...

I don't agree, the kernel should be free to provide a loop back
service any way it likes, and if that means using one of the HW
adaptors to accelerate the work, then fine. Consider if we see the
RDMAoE (soft RDMA) patches then it would be reasonable for all
kernels to support RDMA on the loopback.

At a minimum, RDMA CM is an IP service, so whatever logic you use to
determine addresses for TCP must also be done after determining a list
of valid RDMA IPs. Trying to do RDMA CM bind just gives you the list
of candidate addreses, no different than netlink does for TCP.

One of those steps must be at least filtering 127.0.0.0/8. The user
should also be able to have some input into the IP filter - software
RDMAoE for instance really make this important.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
