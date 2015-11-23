From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: CSUM support in connected mode
Date: Mon, 23 Nov 2015 11:29:57 -0700
Message-ID: <20151123182957.GC32085@obsidianresearch.com>
References: <1438256764-9077-1-git-send-email-yuval.shaia@oracle.com>
 <1438264693.9344.19.camel@opteya.com>
 <20150730152049.GA29102@yuval-lab>
 <55BA47F0.5080504@redhat.com>
 <20150730171538.GA25282@obsidianresearch.com>
 <20150730204635.GC3487@yuval-lab>
 <20150730210018.GA32451@obsidianresearch.com>
 <20151118202740.GA3262@yuval-lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151118202740.GA3262@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 18, 2015 at 10:27:41PM +0200, Yuval Shaia wrote:
> > You need private-data exchange to negotiate the feature.
> > 
> > The feature should be a per-packet csum status header.
> > 
> > When sending a skb that is already fully csumed the receiver sets
> > CHECKSUM_UNNECESSARY.
> > 
> > When sending a skb that has CHECKSUM_PARTIAL then the
> > receiver needs to call skb_partial_csum_set.
> > 
> > Look at how something like VIRTIO_NET_HDR_F_NEEDS_CSUM works and copy
> > that scheme.

> Correct me if i'm wrong here but isn't this protocol assume both parties
> are aware of this special header?

Yes.

No matter what you do both sides must be aware of the change in
protocol, doing it correctly requires adding a small wire header to
flow through the checksum state. This would be enabled once
negotiation confirms both sides will support this.

> My case is a bit different, driver must support backward
> computability in a way that peer maybe a driver that do not support
> this feature and expect packet to be full checksummed.

This is why negotiation is mandatory.

> > DO NOT EVER set CHECKSUM_UNNECESSARY on packets that do not have valid
> > csums - that breaks the net stack.
> The entire idea here is to fake csum offload so how would i tell the stack
> not to run csum on incoming packet?

I already explained this, call skb_partial_csum_set and the stack will
avoid csum work.

> > Yes, you need to add a header to all packets to support this scheme,
> > that is what the private-data negotiation is for.
> > 
> > While you are at it, I'd make room for something like
> > VIRTIO_NET_HDR_GSO_* in the RC protocol too. Implementing GSO
> > forwarding is probably another big performance win.
> If i understood you correctly and you mean exchange of
> "driver-capabilities", then yes, it is there with the extends of
> ipoib_cm_data structure.

You need to dig into how the things I referenced above work, fully
understand them and then adapt them to IPoIB.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
