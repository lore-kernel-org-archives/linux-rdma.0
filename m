From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: is it possible to avoid syncing after an rdma write?
Date: Wed, 17 Feb 2010 11:59:32 -0700
Message-ID: <20100217185932.GI16490@obsidianresearch.com>
References: <4B7B2A6C.80101@oracle.com> <20100217005827.GF16490@obsidianresearch.com> <002101caaf6d$47bc0180$d7340480$@com> <20100217011224.GH16490@obsidianresearch.com> <007101caaf9c$2366d060$6a347120$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <007101caaf9c$2366d060$6a347120$@com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: 'Andy Grover' <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 16, 2010 at 10:40:45PM -0800, Paul Grun wrote:

> Two advantages come to mind vs an RDMA Write followed by a SEND:
> Using a SEND will consume a second WQE on the send side, and the
> synchronizing SEND will cause an entire new transaction, which will
> consume a(n infinitesimally) small amount of additional wire
> bandwidth, as well as incurring a(infinitesimally) small likelihood
> of a dropped or lost packets.

The practical reason I've used it is because it doesn't consume an
unack'd message slot. My apps can exceed the max unacked messages in
flight ...

> To answer Andy's original question, the behavior on the receive side
> is not guaranteed until control of the receive buffer has been
> formally returned to the receiver.  I expect that most HCAs are
> pretty well behaved here, as are most CPU/memory/root
> complexes...but you never know.  Can anybody guarantee that the
> inbound packet gets written to the memory in order?

The HCA could guarentee this. It needs to issue the PCI-E transaction
that contains the last byte with relaxed ordering cleared, after all
other transactions have been issued. In this case it would have
identical synchronizing properties to the WCE write. PCI-E requires
that the host observe the writes in a transaction in-order and that a
host observe multiple transactions according to PCI-E rules.

Presumably common HCAs do all this to support MPI.

Andy, I think if want to do poll on completion in the kernel then
maybe introducing a new ib_dma_poll call for that purpose is a good
idea? First crack could just fail if there is bounce buffering,
non-coherent caching, etc.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
