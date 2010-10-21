From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address
 resolution
Date: Fri, 22 Oct 2010 00:51:33 +0200
Message-ID: <20101021225133.GA6367@mtldesk30>
References: <20100826141851.GI8795@mtldesk30>
 <adazku85dcf.fsf@cisco.com>
 <20101021072703.GA1912@mtldesk30>
 <adazku78gzz.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adazku78gzz.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 21, 2010 at 12:48:00PM -0700, Roland Dreier wrote:
> int mlx4_ib_resolve_grh(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah_attr,
> 			u8 *mac, int *is_mcast, u8 port)
> {
> 	struct mlx4_ib_iboe *iboe = &dev->iboe;
> 	struct in6_addr in6;
> 
> 	*is_mcast = 0;
> 	spin_lock(&iboe->lock);
> 
> which is called from create_iboe_ah() which is called from
> mlx4_ib_create_ah(), which can be called from both interrupt and process
> context.  So as far as I can tell, this spin_lock() needs to actually do
> spin_lock_irqsave()?
> 
This was added in the past when I wanted to use the pointer to the net
device to resolve any IPv6 address. Since we only resolve link local
addresses, why don't we just remove the spinlocks and the check inside
it?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
