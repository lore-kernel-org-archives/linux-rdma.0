From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ACK behaviour difference LRO/GRO
Date: Tue, 29 Oct 2013 00:21:12 -0700
Message-ID: <CABgxfbEqT_TVa5h7DDObpmUwB+S7qW=L2Kk+yQE_v2XaP1ip_g@mail.gmail.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173585A080F-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 28, 2013 at 12:34 PM, Markus Stockhausen
<stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org> wrote:
> Hello,
>
> about two month we had some problems with IPoIB transfer speeds .
> See more http://marc.info/?l=linux-rdma&m=137823326109158&w=2
> After some quite hard test iterations the problem seems to come from the
> IPoIB switch from LRO to GRO between kernels 2.6.37 and 2.6.38.
>
> I built a test setup with a 2.6.38 kernel and additionaly compiled a 2.6.37
> ib_ipoib module against it. This way I can run a direct comparison
> between the old and new module. The major difference between the
> two version is inside the ipoib_ib_handle_rx_wc() function:
>
> 2.6.37: lro_receive_skb(&priv->lro.lro_mgr, skb, NULL);
> 2.6.38: napi_gro_receive(&priv->napi, skb);
>
> As in the last post we use ConnectX cards in datagram mode with a
> 2044 MTU.  We read a file sequentially from a NFS server into /dev/null.
> We just want to get the wire speed neglecting hard drives. The
> hardware is slightly newer so we get different transfer speeds but
> the overall effect should be evident. The server uses a 3.5 kernel and
> is not changed during the tests.
>
> With 2.6.37 IPoIB module on the client side and LRO enabled the
> speed is 950 MByte/sec. On the NFS server side a tcpdump trace
> reads like:
>
> 19:51:51.432630 IP 10.10.30.251.nfs > 10.10.30.1.781:
>   Flags [P.], seq 1008434065:1008497161, ack 617432,
>   win 688, options [nop,nop,TS val 133047292 ecr 429568],
>   length 63096
> 19:51:51.432672 IP 10.10.30.1.781 > 10.10.30.251.nfs:
>   Flags [.], ack 1008241041, win 24576, options
>   [nop,nop,TS val 429568 ecr 133047292], length 0
> 19:51:51.432677 IP 10.10.30.251.nfs > 10.10.30.1.781:
>   Flags [.], seq 1008497161:1008560905, ack 617432,
>   win 688, options [nop,nop,TS val 133047292 ecr 429568],
>   length 63744
> 19:51:51.432725 IP 10.10.30.1.781 > 10.10.30.251.nfs:
>   Flags [.], ack 1008304585, win 24576, options
>   [nop,nop,TS val 429568 ecr 133047292], length 0
> 19:51:51.432729 IP 10.10.30.251.nfs > 10.10.30.1.781:
>   Flags [.], seq 1008560905:1008624649, ack 617432,
>   win 688, options [nop,nop,TS val 133047292 ecr 429568],
> length 63744
>
> With some slight differences here and there the client sends only
> 1 ack for about 60k of transferred data. With 2.6.38 module and
> onwards (GRO enabled) the speed drops down to 380 MByte/sec
> and a different transfer pattern.
>
> 19:58:14.631430 IP 10.10.30.251.nfs > 10.10.30.1.ircs:
>   Flags [.], seq 722492293:722502253, ack 442312, win 537,
>   options [nop,nop,TS val 133143092 ecr 467889], length 9960
> 19:58:14.631460 IP 10.10.30.1.ircs > 10.10.30.251.nfs:
>   Flags [.], ack 722478181, win 24562, options
>   [nop,nop,TS val 467889 ecr 133143092], length 0
> 19:58:14.631485 IP 10.10.30.1.ircs > 10.10.30.251.nfs:
>   Flags [.], ack 722478181, win 24562, options
>   [nop,nop,TS val 467889 ecr 133143092,nop,nop,sack 1
>   {722480117:722482333}], length 0
> 19:58:14.631510 IP 10.10.30.1.ircs > 10.10.30.251.nfs:
>   Flags [.], ack 722488197, win 24562, options [nop,nop,TS
>   val 467889 ecr 133143092], length 0
> 19:58:14.631534 IP 10.10.30.1.ircs > 10.10.30.251.nfs:
>   Flags [.], ack 722494229, win 24562, options
>   [nop,nop,TS val 467889 ecr 133143092], length 0
>
> It seems as if the NFS client acknowledges every 2K packet
> separately. I thought that it may come from missing
> coalescing parameters and tried a  "ethtool -C ib0 rx-usecs 5"
> on both machines but without success.
>
> I'm quite lost now maybe someone can give a tip if I'm
> missing something.
>

Nice work! Look like napi_gro_receive() does not do the work it is
supposed to do ?! My (embedded NFS client) system was on 2.6.38 kernel
but we use ipoib kmod from OFED 1.5.4.1 - so we're still on
lro_receive_skb() path that does not have this issue.

I'll try it out later this week to see what is going on. Mellanox
folks or Roland may have more to say.

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
