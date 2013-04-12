From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: IPOIB-CM MTU
Date: Fri, 12 Apr 2013 13:29:51 -0700
Message-ID: <CABgxfbGeRAGMHUwWvHTs4kcoqNyEN3wBRG66n4sHrsKAMTce0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We're working on a RHEL based system (2.6.32-279.el6.x86_64) that has
slower CPUs (vs. bigger Xeon boxes). The IB stacks are on top of OFA
1.5.4.1 and a mlx adapter (mlx4_0). It is expected that enabling CM
will boost IPOIB bandwidth (measured by Netpipe) due to larger MTU
size (65520).  Unfortunately, it does not happen. It, however, does
show 2x bandwidth gain (CM vs. datagram) on Xeon servers.

While looking around, it is noticed the MTU reported by "ifconfig"
command correctly shows ipoib_cm_max_mtu number but the socket buffer
sent down to ipoib_cm_send() never exceed 2048 bytes on both Xeon and
the new HW platform. Seeing TSO (driver/firmware semgntation) is off
with CM mode ... intuitively, TCP/IP on Xeon would do better with
segmentation while the (segmentation) overhead (and other specific
platform issues) could weigh down the bandwidth on the subject HW.

If the guess is right, the question here is "how to make upper layer,
i.e. IP, send down a bigger (than 2048 bytes) size of fragment ?".
Any comment and/or help ? Is there any other knobs that I should turn
with cm mode (by echo "connected" into /sys/class/net/ib0/mode) ?

Thanks,
Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
