From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB performance
Date: Wed, 5 Sep 2012 18:20:09 +0000
Message-ID: <0000013997a928ab-36ad5a02-3c82-4daf-8e8a-a86c65e92376-000000@email.amazonses.com>
References: <FFD82983-4A73-4A52-B6BE-C63DA16A507C@ornl.gov> <0000013997217ec3-f6e2593f-2ff8-408d-814e-0345582b31ca-000000@email.amazonses.com> <3F476926-8618-4233-A150-C5D487B55C68@ornl.gov>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F476926-8618-4233-A150-C5D487B55C68-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 5 Sep 2012, Atchley, Scott wrote:

> # ethtool -k ib0
> Offload parameters for ib0:
> rx-checksumming: off
> tx-checksumming: off
> scatter-gather: off
> tcp segmentation offload: off
> udp fragmentation offload: off
> generic segmentation offload: on
> generic-receive-offload: off
>
> There is no checksum support which I would expect to lower performance.
> Since checksums need to be calculated in the host, I would expect faster
> processors to help performance some.

K that is a major problem. Both are on by default here. What NIC is this?

> > A) increase the block size handled by the socket layer
>
> Do you mean altering sysctl with something like:

Nope increase mtu. Connected mode supports up to 64k mtu size I believe.

> or something increasing the SO_SNFBUF and SO_RCVBUF sizes or something else?

That does nothing for performance. The problem is that the handling of the
data by the kernel causes too much latency so that you cannot reach the
full bw of the hardware.

> We actually want to test the socket stack and not bypass it.

AFAICT the network stack is useful up to 1Gbps and
after that more and more band-aid comes into play.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
