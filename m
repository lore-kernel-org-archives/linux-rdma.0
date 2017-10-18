From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/2] Introduce Multi-Packet receive work queue
Date: Wed, 18 Oct 2017 12:55:21 +0300
Message-ID: <090b4257-daf4-4f90-555c-b048764d1cda@grimberg.me>
References: <20171017150113.8544-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171017150113.8544-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


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
> |         |         |[packet2]|
> |    [packet1]      |         |
> |_________|_________|_________|
>   stride      stride     stride
>   <--      work request     -->
> 
> A Multi-Packet WQ reduces the number of needed post-recv operations
> thus increasing performance: In the example above, a single post-recv
> operation was performed instead of 2.

Looks like a nice feature, would be nice if we could use it... The
problem is that adding a different logic in case this feature exists is
messy and difficult. Is there any way we can come up with a verbs API
that will utilize this feature but hide the implementation details from
the ULPs?

Maybe something that wraps post_recv?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
