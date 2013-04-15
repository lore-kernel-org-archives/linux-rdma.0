From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IPOIB-CM MTU
Date: Mon, 15 Apr 2013 14:10:14 -0700
Message-ID: <CABgxfbGnDbKfHAiUuh=C1WPPa8OG2Sib_dcbvMvhu4zatC7BqQ@mail.gmail.com>
References: <CABgxfbGeRAGMHUwWvHTs4kcoqNyEN3wBRG66n4sHrsKAMTce0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbGeRAGMHUwWvHTs4kcoqNyEN3wBRG66n4sHrsKAMTce0g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 12, 2013 at 1:29 PM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> We're working on a RHEL based system (2.6.32-279.el6.x86_64) that has
> slower CPUs (vs. bigger Xeon boxes). The IB stacks are on top of OFA
> 1.5.4.1 and a mlx adapter (mlx4_0). It is expected that enabling CM
> will boost IPOIB bandwidth (measured by Netpipe) due to larger MTU
> size (65520).  Unfortunately, it does not happen. It, however, does
> show 2x bandwidth gain (CM vs. datagram) on Xeon servers.
>
> While looking around, it is noticed the MTU reported by "ifconfig"
> command correctly shows ipoib_cm_max_mtu number but the socket buffer
> sent down to ipoib_cm_send() never exceed 2048 bytes on both Xeon and
> the new HW platform. Seeing TSO (driver/firmware semgntation) is off
> with CM mode ... intuitively, TCP/IP on Xeon would do better with
> segmentation while the (segmentation) overhead (and other specific
> platform issues) could weigh down the bandwidth on the subject HW.
>
> If the guess is right, the question here is "how to make upper layer,
> i.e. IP, send down a bigger (than 2048 bytes) size of fragment ?".
> Any comment and/or help ? Is there any other knobs that I should turn
> with cm mode (by echo "connected" into /sys/class/net/ib0/mode) ?
>

Thanks for folks who pointed me to the path MTU RFC. Since this is
more of a core networking issue (vs. IB's), I may do follow-on
questions on linux "netdev" instead of linux-rdma. .

Before closing this thread ..... I see there is a clear warning in
IPOIB code that enabling connected mode will cause multicast packet to
drop. I assume this is due to message ordering requirement and the
multicast packet could fall behind the large packet fragment that ends
up causing multicast logic to time out. If my assumption is not
correct, please do kindly correct me.

Thanks,
Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
