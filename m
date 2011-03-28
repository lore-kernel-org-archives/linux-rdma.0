From: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Re: Unable to Connect Using Active Speed 2.5 Gbps and Active Width of 1
Date: Mon, 28 Mar 2011 19:26:46 +0000 (UTC)
Message-ID: <loom.20110328T212117-950@post.gmane.org>
References: <loom.20110328T194956-774@post.gmane.org> <4D90D9A2.7000107@dev.mellanox.co.il> <loom.20110328T210350-244@post.gmane.org> <4D90DF38.1060407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock <hal@...> writes:
> 
> LinkWidthEnabled is 1X or 4X and not just 1X. That's because there's no 
> force_link_width option in OpenSM so I think the width you set is 
> getting overwritten much like the speed was earlier until you discovered 
> force_link_speed 0.

But I see LinkWidthActive set to 1X, which as I understood denoted the width
currently being used.  If I set LinkWidthActive to 4X, I am able to transfer
just fine.

Also, I do see LinkWidthEnabled being changed from "1X" to "1X or 4X" (most
likely by OpenSM as you suggest), but only after the link is up and active.

I am able to transfer at 5 Gbps 1X and 10 Gbps 1X, just not 2.5 Gbps 1X.

> 
> Also, is this b2b HCAs or is there a switch in the topology ?
> 

It's b2b HCAs, no switch.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
