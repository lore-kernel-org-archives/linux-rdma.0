From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: ib_ipoib: CSUM support in connected mode
Date: Mon, 15 Sep 2014 22:03:51 +0300
Message-ID: <20140915190351.GB17422@yuval-lab>
References: <20140914184621.GA4283@yuval-lab>
 <CAJ3xEMhEzdyzcAufQU--VbM7aoAzsw7wV2i_i=kjcS9PbdC0Tw@mail.gmail.com>
 <20140915165820.GB12397@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140915165820.GB12397-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 15, 2014 at 10:58:20AM -0600, Jason Gunthorpe wrote:
> On Mon, Sep 15, 2014 at 05:47:19PM +0300, Or Gerlitz wrote:
> 
> > > [...] The proposal is to tell to network stack that IPoIB-CM supports IP
> > > Checksum offload. This enables Linux IPoIB-CM driver to use Scatter/Gather feature. Network
> > > sends the IP packet without adding the IP Checksum to the header.
> > 
> > AFAIK, on the TX side, Linux will always compute the IP checksum,
> > but with this suggestion, not the TCP checksum which is assumed to
> > be computed by the card... so we will have a TCP packet on the wire
> > without checksum. And if this packet goes through gateway it will be
> > dropped at some point, agree?
> 
> I remember this was discussed a few years ago on this list.
> 
> To do this, you need to transfer the offload state across the wire, so
> on receive you inject the packet with the proper tag that the csum is
> not computed but ready for offload. A node receiving a packet like
> this would have to compute the csum before sending it onwards, so no,
> if done properly it will not break gateways.
> 
> All the core infrastructure is there, all the virtualization drivers
> work like this - the guest side does not compute the csum, and the
> hyperviser side receives the packet with that flag, and the csum
> ultimately is offloaded to the physical NIC. Look at the xen net
> driver for an example.
> 
> The main thing is to negotiate this and other features at RC
> connection time. Be sure to leave room for other optimizations, for
> instance IPOIB could forward a GSO packet unbroken to the remote side.
Correct, driver must support the case of peer does not support this feature.
Currently i have defined a 16 bits capability field that exchanged during 
RC setup time.
struct ipoib_cm_data {
	__be32 qpn; /* High byte MUST be ignored on receive */
	__be32 mtu;
+	__be16 sig; /* must be IPOIB_CM_PROTO_SIG */
+	__be16 caps; /* 4 bits proto ver and 12 bits capabilities */
};
This enactment breaks RFC but we will get to it as soon as the idea will 
be accepted here.
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
