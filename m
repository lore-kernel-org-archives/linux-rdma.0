From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 7/9] ib/pma: add include file for IBA performance counters
 definitions
Date: Wed, 06 Jul 2011 12:57:46 -0400
Message-ID: <4E14940A.9080700@dev.mellanox.co.il>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com> <alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com> <alpine.LRH.2.00.1106161119120.12552@ogerlitz.voltaire.com> <4DFA10CC.5080002@mellanox.com> <35AAF1E4A771E142979F27B51793A4888838E71F03@AVEXMB1.qlogic.org> <BANLkTikpMWYaXB8Ne+FaLGHi2L5TUCNDkQ@mail.gmail.com> <35AAF1E4A771E142979F27B51793A4888838FEE740@AVEXMB1.qlogic.org> <4E133575.8040105@mellanox.com> <CAL1RGDX7U=PMjWadeS3Gp+xST56xJiK=qydwu1PMcvkfb7DcnA@mail.gmail.com> <CAJZOPZK3tT9gXP46ek-tO3xyvj7=eKyGJXBoim9uOMbJc4BtfQ@mail.gmail.com> <35AAF1E4A771E142979F27B51793A4888838FEE894@AVEXMB1.qlogic.org> <CAL1RGDWHYMQHbZWwkysqZ7TLrB_ZDJWSTC4YCqk1wpme_3+BrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWHYMQHbZWwkysqZ7TLrB_ZDJWSTC4YCqk1wpme_3+BrQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/6/2011 11:51 AM, Roland Dreier wrote:
>> The patch that is not yet approved is https://patchwork.kernel.org/patch/523041/
>>
>> The objections to date for the patch center on the use of reserved bits to key the existence of some vendor specific queries.
> 
> Hmm, I'm not a huge fan of that patch since as you say it uses bits
> that the IB spec says are reserved.  I'd be more inclined to take Or's
> patches which have gotten positive feedback from Sean, if we have to
> choose.  Hal (and/or anyone else who has more insight into the IBTA
> intentions for management architecture), what do you think of the
> patch linked above?

When the patch was originally issued, I had commented on this issue
(http://www.spinics.net/lists/linux-rdma/msg07020.html). There were two
issues I saw:

1. Two CapabilityMask2 bits are set for congestion statistics which
appears to be a proprietary feature.

#define IB_PMA_CLASS_CAP_PORT_CONGS     cpu_to_be32(3 << 30)

In general, it's dangerous to use IBA reserved bits as they may be
claimed by errata to support new features. Should this feature be taken
forward to the IBTA ?

2. A reserved field in some structure was being set for xmit wait rather
than updating the structure for the spec errata for this.

I think this has been fixed in the latest version of the patch.

You had originally commented on this issue in
http://www.spinics.net/lists/linux-rdma/msg07058.html

I can rereview the patch intoto if this is needed.

-- Hal

> 
>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
