From: "Paul Grun" <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: is it possible to avoid syncing after an rdma write?
Date: Tue, 16 Feb 2010 22:40:45 -0800
Message-ID: <007101caaf9c$2366d060$6a347120$@com>
References: <4B7B2A6C.80101@oracle.com> <20100217005827.GF16490@obsidianresearch.com> <002101caaf6d$47bc0180$d7340480$@com> <20100217011224.GH16490@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100217011224.GH16490-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Andy Grover' <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Two advantages come to mind vs an RDMA Write followed by a SEND:
Using a SEND will consume a second WQE on the send side, and the
synchronizing SEND will cause an entire new transaction, which will consume
a(n infinitesimally) small amount of additional wire bandwidth, as well as
incurring a(infinitesimally) small likelihood of a dropped or lost packets.

Nits?  Yes, probably infinitesimally small ones.   (hardware guys tend to
worry about the small ones.)

To answer Andy's original question, the behavior on the receive side is not
guaranteed until control of the receive buffer has been formally returned to
the receiver.  I expect that most HCAs are pretty well behaved here, as are
most CPU/memory/root complexes...but you never know.  Can anybody guarantee
that the inbound packet gets written to the memory in order?  

If something odd did happen, it seems like one of those places that would
require an incredible stroke of luck to debug.

OTOH, I know that many applications simply poll the receive buffer looking
for a flag everyday and get away with it.

-----Original Message-----
From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org] 
Sent: Tuesday, February 16, 2010 5:12 PM
To: Paul Grun
Cc: 'Andy Grover'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: is it possible to avoid syncing after an rdma write?

On Tue, Feb 16, 2010 at 05:05:21PM -0800, Paul Grun wrote:
> Why not use an RDMA write w/ immed?  That forces the consumption of a
> receive WQE and can be used to create a completion event.  Since the
> immediate data is carried in the last packet of a multi-packet RDMA write,
> you are guaranteed that all data has been placed in the receive buffer, in
> order.

Yes, RDMA WRITE w/ immediate data is perfectly fine. I've even
implemented some protocols that use it to good effect.

Not sure what the performance trade off is like though. The immediate
data pretty much behaves exactly like a SEND WC on the receive side,
but there may be some performance and latency advantages, particularly
on the send side.

Jason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
