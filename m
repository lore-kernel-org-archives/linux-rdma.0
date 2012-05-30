From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
Date: Wed, 30 May 2012 01:06:17 -0400
Message-ID: <1338354377.2361.13.camel@obelisk.thedillows.org>
References: <4FC53AAA.3060203@ddn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC53AAA.3060203-LfVdkaOWEx8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2012-05-29 at 17:07 -0400, Karandeep Chahal wrote:
> Subject: [PATCH] Infiniband srp fast failover patch.

This conflicts with Bart's patches to improve failover; it will be much
better to use his approach to block the target rather than remove it
wholesale -- we could have lost connectivity as a transient and may get
it back quickly if someone grabbed the wrong cable, etc.

Also, we should only kill the one target on DREQ, and we already have a
pointer to it from the CM context -- no need to search.

It is a good idea to hook into the event mechanism; this is something
I've long wanted to incorporate (as Vu did in OFED). I'm looking at
getting Bart's series to a point I can merge it, and I'll pull in your
ideas -- with credit -- there.

Thanks,
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
