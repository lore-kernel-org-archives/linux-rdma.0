From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 5 Sep 2012 15:51:58 +0000
Message-ID: <0000013997217ec3-f6e2593f-2ff8-408d-814e-0345582b31ca-000000@email.amazonses.com>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <FFD82983-4A73-4A52-B6BE-C63DA16A507C-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 29 Aug 2012, Atchley, Scott wrote:

> I am benchmarking a sockets based application and I want a sanity check
> on IPoIB performance expectations when using connected mode (65520 MTU).
> I am using the tuning tips in Documentation/infiniband/ipoib.txt. The
> machines have Mellanox QDR cards (see below for the verbose ibv_devinfo
> output). I am using a 2.6.36 kernel. The hosts have single socket Intel
> E5520 (4 core with hyper-threading on) at 2.27 GHz.
>
> I am using netperf's TCP_STREAM and binding cores. The best I have seen
> is ~13 Gbps. Is this the best I can expect from these cards?

Sounds about right, This is not a hardware limitation but
a limitation of the socket I/O layer / PCI-E bus. The cards generally can
process more data than the PCI bus and the OS can handle.

PCI-E on PCI 2.0 should give you up to about 2.3 Gbytes/sec with these
nics. So there is like something that the network layer does to you that
limits the bandwidth.

> What should I expect as a max for ipoib with FDR cards?

More of the same. You may want to

A) increase the block size handled by the socket layer

B) Increase the bandwidth by using PCI-E 3 or more PCI-E lanes.

C) Bypass the socket layer. Look at Sean's rsockets layer f.e.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
