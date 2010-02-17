From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: is it possible to avoid syncing after an rdma write?
Date: Tue, 16 Feb 2010 18:12:24 -0700
Message-ID: <20100217011224.GH16490@obsidianresearch.com>
References: <4B7B2A6C.80101@oracle.com> <20100217005827.GF16490@obsidianresearch.com> <002101caaf6d$47bc0180$d7340480$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <002101caaf6d$47bc0180$d7340480$@com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: 'Andy Grover' <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

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
