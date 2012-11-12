From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] ib_srp: Infiniband srp fast failover patch.
Date: Tue, 13 Nov 2012 01:10:41 +0200
Message-ID: <CAJZOPZL0cj6Sb_xs7prV0k8HjWkELD7Y89Bxxp-xXnnGqxvXyg@mail.gmail.com>
References: <4FC53AAA.3060203@ddn.com>
	<1338354377.2361.13.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338354377.2361.13.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Karandeep Chahal <kchahal-LfVdkaOWEx8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 30, 2012 at 7:06 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> On Tue, 2012-05-29 at 17:07 -0400, Karandeep Chahal wrote:
>> Subject: [PATCH] Infiniband srp fast failover patch.
>
> This conflicts with Bart's patches to improve failover; it will be much
> better to use his approach to block the target rather than remove it
> wholesale -- we could have lost connectivity as a transient and may get
> it back quickly if someone grabbed the wrong cable, etc.
>
> Also, we should only kill the one target on DREQ, and we already have a
> pointer to it from the CM context -- no need to search.
>
> It is a good idea to hook into the event mechanism;

Dave,

I wonder why this hooking is the correct way to go, if the IB link
went down for very short time, why should we care, what's missing in
relying on probes done by HA SW such as multipath and RC timeouts?

Or.

> this is something I've long wanted to incorporate (as Vu did in OFED). I'm looking at
> getting Bart's series to a point I can merge it, and I'll pull in your
> ideas -- with credit -- there.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
