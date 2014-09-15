From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: ib_ipoib: CSUM support in connected mode
Date: Mon, 15 Sep 2014 21:55:58 +0300
Message-ID: <20140915185557.GA17422@yuval-lab>
References: <20140914184621.GA4283@yuval-lab>
 <CAJ3xEMhEzdyzcAufQU--VbM7aoAzsw7wV2i_i=kjcS9PbdC0Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhEzdyzcAufQU--VbM7aoAzsw7wV2i_i=kjcS9PbdC0Tw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 15, 2014 at 05:47:19PM +0300, Or Gerlitz wrote:
> On Sun, Sep 14, 2014 at 9:46 PM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > By default, IPoIB-CM driver uses 64k MTU. Larger MTU gives better performance.
> > This MTU plus overhead puts the memory allocation for IP based packets at 32 4k pages
> > (order 5),
> 
> So if we make sure that the advertized netdevice MTU is 64K minus that
> over head we're back to order four
> allocation and problem is solved?   note that RFC 4755 makes sure that
> the MTU is negotiated in both directions,
> so it can have any value, specifically 64K - that epsilon which will
> hopefully make you happy
Interesting point.
But please note that in any case, when not using scatter/gather we force the 
allocation of large contiguous physical memory.
> 
> 
> > [...] The proposal is to tell to network stack that IPoIB-CM supports IP
> > Checksum offload. This enables Linux IPoIB-CM driver to use Scatter/Gather feature. Network
> > sends the IP packet without adding the IP Checksum to the header.
> 
> AFAIK, on the TX side, Linux will always compute the IP checksum, but
> with this suggestion,
> not the TCP checksum which is assumed to be computed by the card... so
> we will have a TCP
> packet on the wire without checksum. And if this packet goes through
> gateway it will be dropped at
> some point, agree?
Agree.
This is why driver must expose interface to system administrator to 
disable/enable this feature according to his network topology.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
