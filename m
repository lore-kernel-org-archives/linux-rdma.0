From: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: IPoIB - GRO forces memcpy inside __pskb_pull_tail
Date: Wed, 03 Apr 2013 21:03:08 +0200
Message-ID: <CD8245B7.5691%markus.stockhausen@gmx.de>
References: <CAJZOPZ+7mvjgjhm2d7fpN=PE0ste3jJQyyN0vKdSAG3zWA9yYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+7mvjgjhm2d7fpN=PE0ste3jJQyyN0vKdSAG3zWA9yYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,

>>
>>...
>> If I get it right round about 6% (7.38% * 84.56%) of the time the
>>machine does a
>> memcpy inside __pskb_pull_tail. The comments on this function reads "...
>> it expands
>> header moving its tail forward and copying necessary data from
>>fragmented part. ...
>> It is pretty complicated. Luckily, it is called only in exceptional
>>cases ...".
>> That does not sound good at all. I repeated the test on a normal Intel
>>gigabit
>> network without jumbo frames and __pskb_pull_tail was not in the top
>>consumer list.
>
>> Does anyone have an idea if this is normal GRO behaviour for IPOIB. At
>>the moment
>> I have a full test environment and could implement and verify some
>>kernel
>> corrections if someone could give a helpful hint.
>
>As always, it would be good and helpful if you can re-run the test
>with the latest upstream kernel, e.g 3.9-rc, and anyway, I added Eric
>who might have some insight on the matter.
>
>Or.


going through hard lessons to understand the SKBs maybe I finally
found the reason for the unnecessary memcpy commands. Even with
newest 3.9-rc5 kernel the problem persists. IPoIB creates only
fragmented SKBs without any single bit in the normal data part. Some
debug messages during GRO handling showed

skb->len         = 1988 (total data)
skb->data_len    = 1988 (paged data)
skb_headlen(skb) = 0    (non paged data)

inet_gro_receive() requires the IP header inside the SKB. So it
pulls missing data from fragments. This process requires extra
memcpy operations. 

It all comes from ipoib_ud_need_sg() that determines if a
receive block will fit into a single page. Whenever this
function is called the one and only parameter is max_ib_mtu
of the device. In my case with a ConnectX card this defaults
to 4K no matter what MTU is really set. As a result IPoIB will
always create a separate SKB fragment for the incoming data.

My old but nicely working switch only allows a MTU of 2044 bytes.
So I assumed that I do not need to care about fragments and
modifed the priv->max_ib_mtu hardcoded to 3072. Pages are sufficient
large for this MTU. A quick test afterwards without claim of
perfectionism showed the expected effects.

1) no more additional memcpy operations
2) netperf throughput raised from ~ 5.3GBit to ~ 5.8GBit

I hope that I'm not totally wrong with this finding and my
simple explanation is conclusive. Maybe someone with more
knowledge about this all can assist me to get an offical
patch into the RDMA development tree?

Thanks in advance.

Markus


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
