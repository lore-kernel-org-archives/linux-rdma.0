From: Markus Stockhausen <markus.stockhausen-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [RFC/PATCH v4] IPoIB: Leave space in skb linear buffer for IP
 headers
Date: Tue, 16 Apr 2013 19:44:14 +0200
Message-ID: <CD935857.5873%markus.stockhausen@gmx.de>
References: <CANn89iK9Z7i59+pHXAXJzgYZxKB6OptR-+TRwfjTqNwHMLDOow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANn89iK9Z7i59+pHXAXJzgYZxKB6OptR-+TRwfjTqNwHMLDOow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>I am afraid I don't understand what the issue is.
>
>the pull_tail() in itself is not a performance issue : Intel guys only
>fixed last gays ago fact that IGB/IXGBE drivers were not pulling tcp
>headers in skb->head , and nobody noticed.
>
>Real cost is the cache line miss.
>
>Now, if you pull too many bytes in skb->head, say part of TCP payload,
>you lose opportunities in TCP coalescing or splice().

With patch v4 netperf and NFS receive performance raises to the
expected values. As I'm no expert in this I can only repost the
initial performance report that started the whole discussion.
__pskb_pull_tail consumes a lot time on our XEON L5420 test
server.


...

- server side: netserver -p 12345
- client side: netperf -H <server_ip> -p 12345 -l 120

Analysis was performed on the server side with
- perf record -a -g sleep 10
- perf report

# Overhead                                         Symbol
# ........  .............................................
#
    19.67%  [k] copy_user_generic_string
            |
            |--99.74%-- skb_copy_datagram_iovec
            |          tcp_recvmsg
            |          inet_recvmsg
            |          sock_recvmsg
            |          sys_recvfrom
            |          system_call_fastpath
            |          recv
            |          |
            |          |--50.17%-- 0x7074656e00667265
            |          |
            |           --49.83%-- 0x6672657074656e
             --0.26%-- [...]
     7.38%  [k] memcpy
            |
            |--84.56%-- __pskb_pull_tail
            |          |
            |          |--81.88%-- pskb_may_pull.part.6
            |          |          skb_gro_header_slow
            |          |          inet_gro_receive
            |          |          dev_gro_receive
            |          |          napi_gro_receive
            |          |          ipoib_ib_handle_rx_wc
            |          |          ipoib_poll
            |          |          net_rx_action
            |          |          __do_softirq


Markus


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
