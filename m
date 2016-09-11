From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: RFC: CQ pools and implicit CQ resource allocation
Date: Sun, 11 Sep 2016 09:39:56 +0300
Message-ID: <b033c531-fe14-eded-4162-2ea2c2ccf071@grimberg.me>
References: <1473424587-13818-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473424587-13818-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> One concern Sagi had when reviewing an earlier version of my edits was that
> the over allocation as part of using a pool might be harmful for client side
> driver that only have one (or a few) connections. I played around with iSER
> a bit and could not measure and slowdown, but that doesn't mean there aren't
> any down sides - I'd really like some feedback from the hardware driver
> people on what CQ sizing / allocation preferences their hardware has.

Just to clarify,

I don't expect this will introduce slow downs on the host/client side.
in fact, for the same reason it helps the target/server side it will
help the client side.

What I was talking about is that we can end up over-allocating CQs if a
host/client has a single connection (or a few connections) to the target
and it may not need the pool (it is more common for target/server mode
drivers to have a lot of connections/channels than host/client mode
drivers). But given the benefit, I think we can tolerate it (we do that
in iSER initiator anyhow).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
