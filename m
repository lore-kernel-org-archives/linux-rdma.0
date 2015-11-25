From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: When does IB Multicast drop?
Date: Wed, 25 Nov 2015 11:23:36 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1511251123040.32381@east.gentwo.org>
References: <5654E056.5050608@gmail.com> <CADPSxAgifjbSP0qL5fvRt8G7-qgTY0YjdFuPnB9WKi7kkUw55Q@mail.gmail.com> <alpine.DEB.2.20.1511251007020.31676@east.gentwo.org> <5655EB96.2090600@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5655EB96.2090600-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Chinetti <peter.chinetti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 25 Nov 2015, Peter Chinetti wrote:

> > Correct. But multicast packets are droped at the QP receive level if the
> > app does not provide enough buffers to accept the data stream. The
> > bufers can easily be overrun if one does not code carefully given that
> > the maximum number of those is 16K or so. These drops occurs silently.
> > Currently there is no accounting for these drops in the upstream kernel.

> How about when one of the destinations for the multicast group has its
> connection to the switch overloaded (because it is subscribing to many
> multicast groups whose combined bandwidth is momentarily greater than the
> bandwidth of the link to the switch). Are the messages destined for that
> endpoint dropped at the switch, or is traffic to the entire multicast group
> delayed?

The entire traffic to the muilticast group will be delayed.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
