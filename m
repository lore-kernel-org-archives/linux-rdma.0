From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: When does IB Multicast drop?
Date: Wed, 25 Nov 2015 10:10:33 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1511251007020.31676@east.gentwo.org>
References: <5654E056.5050608@gmail.com> <CADPSxAgifjbSP0qL5fvRt8G7-qgTY0YjdFuPnB9WKi7kkUw55Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAgifjbSP0qL5fvRt8G7-qgTY0YjdFuPnB9WKi7kkUw55Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Chinetti <peter.chinetti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 24 Nov 2015, Anuj Kalia wrote:

> InfiniBand flow control is done at the link layer, so UD does not drop
> packets due to congestion.

Correct. But multicast packets are droped at the QP receive level if the
app does not provide enough buffers to accept the data stream. The
bufers can easily be overrun if one does not code carefully given that
the maximum number of those is 16K or so. These drops occurs silently.
Currently there is no accounting for these drops in the upstream kernel.

> AFAIK, UD only drops packets due to irrecoverable bit errors and
> network device failures. Mellanox's FDR physical layer has BER less
> than 10^(-15), and forward error correction on top of that, so an
> irrecoverable bit error is extremeley extremely rare.

Yep. These are extremely rare. We rely on reliable delivery of "unreliable
datagrams" here to avoid having messaging layers that request
retransmission on packet drops.

> If the network topology does not have multipath, (Mellanox) UD will
> not reorder packets to a particular destination sent from the same UD
> QP. There is probably some guarantee in multipath topologies, too.

Correct.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
