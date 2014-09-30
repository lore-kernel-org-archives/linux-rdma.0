From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: ib_ipoib: CSUM support in connected mode
Date: Tue, 30 Sep 2014 11:39:20 +0300
Message-ID: <20140930083920.GA7178@yuval-lab>
References: <20140914184621.GA4283@yuval-lab>
 <CAJ3xEMhEzdyzcAufQU--VbM7aoAzsw7wV2i_i=kjcS9PbdC0Tw@mail.gmail.com>
 <20140915185557.GA17422@yuval-lab>
 <5417DD0F.9090201@mellanox.com>
 <20140922192802.GB3425@yuval-lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140922192802.GB3425@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vadim Makhervaks <vadim.makhervaks-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 22, 2014 at 10:28:02PM +0300, Yuval Shaia wrote:
> On Tue, Sep 16, 2014 at 09:47:43AM +0300, Or Gerlitz wrote:
> > 
> > On 9/15/2014 9:55 PM, Yuval Shaia wrote:
> > >On Mon, Sep 15, 2014 at 05:47:19PM +0300, Or Gerlitz wrote:
> > >>>On Sun, Sep 14, 2014 at 9:46 PM, Yuval Shaia<yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>  wrote:
> > >>>>>By default, IPoIB-CM driver uses 64k MTU. Larger MTU gives better performance.
> > >>>>>This MTU plus overhead puts the memory allocation for IP based packets at 32 4k pages (order 5),
> > >>
> > >>>So if we make sure that the advertized netdevice MTU is 64K minus that
> > >>>over head we're back to order four
> > >>>allocation and problem is solved?   note that RFC 4755 makes sure that
> > >>>the MTU is negotiated in both directions,
> > >>>so it can have any value, specifically 64K - that epsilon which will
> > >>>hopefully make you happy
> > >Interesting point. But please note that in any case, when not using scatter/gather we force the allocation of large contiguous physical memory.
> > 
> > On the post you wrote "[...] resolve the issue by removing the physically contiguous memory requirement using Scatter/Gather feature that exists in Linux".
> > 
> > I assume you refer to NETIF_F_SG, right? so your claim is that Linux will not effectively use the driver ability to serve SG skbs unless the driver also advertizes (say) NETIF_F_IP_CSUM?!
> > 
> > I thought it's the other way around -- that is supporting checksum offloading is useless unless SG is supported. Can you provide pointer into the network stack code/documentation that supports your claim?
> > Or.
> While porting the patch to latest kernel i have learned that this limitation is no longer exist.
> The limitation i was talking about was in older versions of the function netdev_fix_features().
> 	/* Fix illegal SG+CSUM combinations. */
> 	if ((features & NETIF_F_SG) &&
> 	    !(features & NETIF_F_ALL_CSUM)) {
> 		netdev_dbg(dev,
> 			"Dropping NETIF_F_SG since no checksum feature.\n");
> 		features &= ~NETIF_F_SG;
> 	}
> Now, with the removal of this limitation the argument of "...In order to use SG....IPoIB-CM must support IP checksum offload" is no longer applicable.
> We now left with the performance benefit argument only, can we ignore the performance improvement achieved by eliminating the need to calculate checksum in SW?
Another benefit we should take into account is that that IB-CRC is **much more** reliable than checksum!!
> > 
> > 
> > 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
