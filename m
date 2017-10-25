From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] Introduce Multi-Packet receive work queue
Date: Wed, 25 Oct 2017 14:04:32 -0400
Message-ID: <1508954672.3325.48.camel@redhat.com>
References: <20171017150113.8544-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171017150113.8544-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-17 at 18:01 +0300, Leon Romanovsky wrote:
> A Multi-Packet receive WQ comes to improve performance and memory
> footprint. It is comprised of work requests that can be consumed by
> multiple packets. Buffers pointed by SGEs of each work request in a
> multi packet WQ are divided into strides. Both buffer size and stride
> size must be identical in all work requests of the same multi packet
> WQ and are set during WQ creation.
> 
> A single WR in a Multi-Packet WQ can generate multiple completions,
> depends on the number of packets consumed. Each packet starts at the
> beginning of a stride and is written in stride granularity.
> 
> Here is an example of a work request comprised of 3 strides. Packet 1
> is larger than a stride so it occupies 2 strides. Packet 2 fits in a
> single stride. Each packet will generate its own completion.
> 
> >          |         |[packet2]|
> >     [packet1]      |         |
> > _________|_________|_________|
> 
>  stride      stride     stride
>  <--      work request     -->
> 
> A Multi-Packet WQ reduces the number of needed post-recv operations
> thus increasing performance: In the example above, a single post-recv
> operation was performed instead of 2.

Nice.  Resolves some of the issues the basic recv queue model has.  As
you said to Sagi, this is just being exposed in your DV interface right
now, so I'm fine with it.  Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
