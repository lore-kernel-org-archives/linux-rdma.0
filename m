From: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Subject: Re: mlx4 fix for 36-bit bus addresses on 32-bit arch
Date: Thu, 13 Jan 2011 12:06:19 -0500
Message-ID: <4D2F310B.2010906@cadence.com>
References: <ig5vl1$j0$1@dough.gmane.org> <adafwt06puj.fsf@cisco.com>	<4D2D5FAD.6030508@cadence.com> <adahbde57r7.fsf_-_@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adahbde57r7.fsf_-_-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Thanks, I'll get the mthca patch upstream.  I think the following is
> also required -- any review is appreciated.

I hadn't realized the newer Mellanox driver had some of its code in drivers/net.  
Yesterday, I had looked at its drivers/infiniband portion and saw that your 
proposed change to hw/mlx4/main.c looked good.

I agree with the changes you've made.    

However, I had a new concern about both the mthca and mlx4 changes so far:  
Are we sure using the phys_addr_t type is the correct thing to do?

I know it is for the PowerPC platform.  When I checked my Linux tree for
phys_addr_t it was only present for PowerPC and Intel architectures.  So,
I was worried that it might not be appropriate for other architectures.

But I now see that the newer trees do define phys_addr_t for all platforms
(defined in linux/types.h).  And, resource_size_t is now defined using
phys_addr_t.  That is the type returned from pci_resource_start(), which 
is where we normally acquire the value to pass to ioremap().

This all happened at 2.6.28, so I'm a victim of running such an old level 
(I'm still at 2.6.26).

I think therefore that all is well with this change.

By the way, the only reason I'm using mthca is because my hardware
has a 4-lane slot.  If I had 8-lanes, I would be trying to use
mlx4.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
