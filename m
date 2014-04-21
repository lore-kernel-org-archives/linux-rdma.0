From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Why is Infiniband a "Lossless" medium?
Date: Mon, 21 Apr 2014 11:28:01 -0500 (CDT)
Message-ID: <alpine.DEB.2.10.1404211114490.28094@gentwo.org>
References: <CADPSxAgq1YAY09A46jurpiuXiq4Ohboqnts4a0qt3BE0K_PW7g@mail.gmail.com> <6B2A6E60C06CCC42AE31809BF572352B9ABACD98@MTLDAG01.mtl.com> <alpine.DEB.2.10.1403171149370.12043@nuc> <CAGFOLLetw+jYJBRotyvk8iYyEB+_b8D6KZrcwzxQnneOA5vSmw@mail.gmail.com>
 <alpine.DEB.2.10.1404191223070.16272@gentwo.org> <CAGFOLLcmanOYG-QQ2WNigWWS6aDyj937t3mMT_jWVPCPQMgc7w@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGFOLLcmanOYG-QQ2WNigWWS6aDyj937t3mMT_jWVPCPQMgc7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Carlier <chronidev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 21 Apr 2014, Nicolas Carlier wrote:

> Interresting, I don't see this counter neither on fw/sw release notes nor on the
> systems. What the name of this counter ? On which HCA do you see this
> counter ?

The mlx4 driver supports this counter and its in /sys/class/infiniband/diag_counters/

rq_num_udsdprd

See also the documentation in the ConnectX Family Programmers Reference
Manual.

> > We finally ended up with looking at all the counters in the fabric and if
> > we could not account for it we assumed it was QP overrun.
>
> Yes. Do you have clue how interpret XmitWait and how a port is
> notified to wait when we use UD mode ?

Not an expert. You may want to talk to Mellanox for the details but
AFAICT:

UD packets are not dropped at the switch level unless you reconfigure the
fabric to be lossy. Therefore xmitwaits occur in the same way as for RC
packets. Drops occur in between the HCA on the way to memory if there is
no space in the queue.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
