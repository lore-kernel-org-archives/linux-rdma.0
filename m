From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB - GRO forces memcpy inside __pskb_pull_tail
Date: Tue, 2 Apr 2013 23:01:43 +0300
Message-ID: <CAJZOPZ+7mvjgjhm2d7fpN=PE0ste3jJQyyN0vKdSAG3zWA9yYg@mail.gmail.com>
References: <CD80F4B1.565F%markus.stockhausen@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CD80F4B1.565F%markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org> wrote:
> Hello,
>
> today I did some IPoIB profiling on one of our infiniband servers.
> Environment on server side is
>
> - Kernel:  3.5.0-26-generic #42~precise1-Ubuntu
> - Mellanox Technologies MT26418 (LnkSta: Speed 2.5GT/s, Width x8)
> - Infiniband MTU 2044 (cannot increase to 4K because of old switch)
> - one 4 core Intel(R) Xeon(R) CPU L5420 @ 2.50GHz
>
> With different client machines I executed a netperf load test.
>
> - server side: netserver -p 12345
> - client side: netperf -H <server_ip> -p 12345 -l 120
>
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to ...
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
>
> 87380  16384  16384    120.00   5078.92
>
> Analysis was performed on the server side with
>
> - perf record -a -g sleep 10
> - perf report
>
> The result starts with:
>
> # Overhead                                         Symbol
> # ........  .............................................
> #
>     19.67%  [k] copy_user_generic_string
>             |
>             |--99.74%-- skb_copy_datagram_iovec
>             |          tcp_recvmsg
>             |          inet_recvmsg
>             |          sock_recvmsg
>             |          sys_recvfrom
>             |          system_call_fastpath
>             |          recv
>             |          |
>             |          |--50.17%-- 0x7074656e00667265
>             |          |
>             |           --49.83%-- 0x6672657074656e
>              --0.26%-- [...]
>      7.38%  [k] memcpy
>             |
>             |--84.56%-- __pskb_pull_tail
>             |          |
>             |          |--81.88%-- pskb_may_pull.part.6
>             |          |          skb_gro_header_slow
>             |          |          inet_gro_receive
>             |          |          dev_gro_receive
>             |          |          napi_gro_receive
>             |          |          ipoib_ib_handle_rx_wc
>             |          |          ipoib_poll
>             |          |          net_rx_action
>             |          |          __do_softirq
>
> If I get it right round about 6% (7.38% * 84.56%) of the time the machine does a
> memcpy inside __pskb_pull_tail. The comments on this function reads "...
> it expands
> header moving its tail forward and copying necessary data from fragmented part. ...
> It is pretty complicated. Luckily, it is called only in exceptional cases ...".
> That does not sound good at all. I repeated the test on a normal Intel gigabit
> network without jumbo frames and __pskb_pull_tail was not in the top consumer list.

> Does anyone have an idea if this is normal GRO behaviour for IPOIB. At the moment
> I have a full test environment and could implement and verify some kernel
> corrections if someone could give a helpful hint.

As always, it would be good and helpful if you can re-run the test
with the latest upstream kernel, e.g 3.9-rc, and anyway, I added Eric
who might have some insight on the matter.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
