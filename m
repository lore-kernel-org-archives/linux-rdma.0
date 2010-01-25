From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv3] opensm: Add support for optimized SLtoVLMappingTable
 programming
Date: Mon, 25 Jan 2010 19:41:13 +0200
Message-ID: <20100125174113.GV13519@me>
References: <20091201194110.GA26753@comcast.net>
 <20100105111841.GO26940@me>
 <20100105112334.GP26940@me>
 <f0e08f231001070535l382f1d54t7f6290607e52b196@mail.gmail.com>
 <20100112105516.GK26089@me>
 <f0e08f231001131214w790b1f34s46cbbda8b6454ac3@mail.gmail.com>
 <20100116203304.GB574@me>
 <f0e08f231001230426t2e48aa58pbcb2d3f1323c6e56@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f231001230426t2e48aa58pbcb2d3f1323c6e56-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07:26 Sat 23 Jan     , Hal Rosenstock wrote:
> >
> > Yes, and how is this different from the original patch?
> 
> The original patch didn't do this but missed accounting for the switch
> port 0 configuration.

I cannot understand. What do you mean?

> > Remember, that there is a different configuration for switch's port 0
> > (needed or not - this is another question), so we must to take it into
> > account.
> 
> Yes but is there a need for this if they are the same and wildcarding
> is used ? That will save what seems to me to be an unneeded MAD
> request/response pair per switch.

This leads us to switch ports (0 and externals) QoS configuration
unification. Basically I have nothing against this, but this is not
actually related to this patch series. And should be done first as
completely separate change, then we can merge SL2VL setup too.

However, there is some related long time pended task - QoS policy and
QoS port parameters configurations merge. Keeping this in the mind I
would think that finally we will need ability to have "per-port" SL2VL
and VLArb configuration. We can take it into account even now.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
