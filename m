From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Why is Infiniband a "Lossless" medium?
Date: Sat, 19 Apr 2014 12:25:02 -0500 (CDT)
Message-ID: <alpine.DEB.2.10.1404191223070.16272@gentwo.org>
References: <CADPSxAgq1YAY09A46jurpiuXiq4Ohboqnts4a0qt3BE0K_PW7g@mail.gmail.com> <6B2A6E60C06CCC42AE31809BF572352B9ABACD98@MTLDAG01.mtl.com> <alpine.DEB.2.10.1403171149370.12043@nuc> <CAGFOLLetw+jYJBRotyvk8iYyEB+_b8D6KZrcwzxQnneOA5vSmw@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGFOLLetw+jYJBRotyvk8iYyEB+_b8D6KZrcwzxQnneOA5vSmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Carlier <chronidev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 18 Apr 2014, Nicolas Carlier wrote:

> > If the receiving QP does not have buffers available then the HCA will
> > silently drop UD packets. This is somethig that tripped us up initialy. So
> > its lossless only from HCA to HCA not QP to QP.
> >
> >     Christoph, I'm very interesting by this. Do you have any documentation
> related to this mechanisms? I'm troubleshooting an infiniband fabric where
> I use heavily ipoib to collect multicast traffic. I see lot of gaps on the
> application, but I can't map any of this gaps to drop counters or dropwatch
> output.

There was a promise that MOFED 2.1 or 2.2 should support a counter for QP
overrun but I have never seen that work. The counter is there but does not
increment.

> I'm sure drops don't occur upstream because I'm able to dump traffic before
> the Infiniband Fabric without observing them.
> I'm also able to dump traffic on another server inside the Infiniband Fabric
> connected to the same leaf switch without observing them.

Well looks like silent drops to me. One way to check is to verify the
sequence ids in each multicast packet.

We finally ended up with looking at all the counters in the fabric and if
we could not account for it we assumed it was QP overrun.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
