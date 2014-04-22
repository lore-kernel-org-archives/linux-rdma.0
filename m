From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Allow to always block UD multicast loopback
Date: Mon, 21 Apr 2014 19:26:28 -0500 (CDT)
Message-ID: <alpine.DEB.2.10.1404211926050.31858@gentwo.org>
References: <alpine.DEB.2.10.1404211308140.29240@gentwo.org> <CAJZOPZJfdaZ7QzgffzY9Ps-1aUCU+q_dSrj4XfekyfxNa-k+hg@mail.gmail.com> <alpine.DEB.2.10.1404211605390.29907@gentwo.org> <CAJZOPZ+FwPc3OSVyvk0i4=gX-x0zf_+M8zL1_t9HWmEKi5397Q@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+FwPc3OSVyvk0i4=gX-x0zf_+M8zL1_t9HWmEKi5397Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 22 Apr 2014, Or Gerlitz wrote:

> > Urgh. So we have all these flags and we cannot use them?
>
> Christoph, the support (kernel IB core API and HW drivers e.g mlx4 and
> now also mlx5) is there for **kernel** consumers (e.g IPoIB). and
> missing for **user-space** consumers whose calls are tunneled through
> uverbs. The uverbs piece is the missing one.

Could you please post an updated patch? We will test.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
