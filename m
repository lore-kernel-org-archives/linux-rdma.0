From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: Why is Infiniband a "Lossless" medium?
Date: Mon, 17 Mar 2014 11:56:32 -0500 (CDT)
Message-ID: <alpine.DEB.2.10.1403171149370.12043@nuc>
References: <CADPSxAgq1YAY09A46jurpiuXiq4Ohboqnts4a0qt3BE0K_PW7g@mail.gmail.com> <6B2A6E60C06CCC42AE31809BF572352B9ABACD98@MTLDAG01.mtl.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6B2A6E60C06CCC42AE31809BF572352B9ABACD98-fViJhHBwANKuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 16 Mar 2014, Shachar Raindel wrote:

> Infiniband is a lossless medium in the aspect of the switches and L2 buffering.
> This means that if the switch or HCA does not have buffer space to receive a packet, the remote side will not send it.

If the receiving QP does not have buffers available then the HCA will
silently drop UD packets. This is somethig that tripped us up initialy. So
its lossless only from HCA to HCA not QP to QP.

> Packet loss can still occur if there is physical level signal issue, or
> if the receiver did not post a receive WQE for the incoming message.

Exactly. If the Os interrupts your receiving thread and you do not
replenish the receive buffers then you will be overrun and loose packets.

> However, the first event is relatively rare, and the second will not
> happen if you are using RDMA writes over UC.

The loss can be frequent because one is limited to 16k or so buffers
and those can be exhausted easily if sending lots of small packets over a
40G or 56G link.

F.e. 16000 buffers* 100 bytes each = 1.6MB. The NIC can send 4-5GB per
second so it takes only a fraction of a millisecond for the QP buffers to
be overrun. The scheduling interval is in the milliseconds. If the
scheduler takes you out during a packet burst then loss will occur.

The nasty thing with the Mellanox HCAs is that the loss occurs silently.
No counters no nothing accounts for the packet loss. You still believe
that there was no loss because there is nothing there that could tell you
that an overrun occurred.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
