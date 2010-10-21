From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address resolution
Date: Thu, 21 Oct 2010 12:48:00 -0700
Message-ID: <adazku78gzz.fsf@cisco.com>
References: <20100826141851.GI8795@mtldesk30> <adazku85dcf.fsf@cisco.com>
	<20101021072703.GA1912@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101021072703.GA1912@mtldesk30> (Eli Cohen's message of "Thu,
	21 Oct 2010 09:27:03 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > Just curious -- what's up with this change here?  Is this connected to
 > > IBoE support, or is this an independent fix?
 > 
 > It is required for proper distribution of IBoE multicast packets while
 > still not hurting the mlx4_en driver's operation.

OK, I split this into a separate patch for clarity.

 > > Finally this patch would have been easier to review without extraneous
 > > whitespace noise like
 > 
 > Sorry about that. I pass them through checkpatch but this must have
 > been hiden within the "line over ..." messages.

It's not a checkpatch issue.  It's just that you made random formatting
changes to parts of the code that weren't otherwise touched.

 > Roland, would you like me to send patches 8-12 again with this fixed?

I think I can still handle it.

However I notice one other thing that looks like a bug.

You add a function that starts:

int mlx4_ib_resolve_grh(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah_attr,
			u8 *mac, int *is_mcast, u8 port)
{
	struct mlx4_ib_iboe *iboe = &dev->iboe;
	struct in6_addr in6;

	*is_mcast = 0;
	spin_lock(&iboe->lock);

which is called from create_iboe_ah() which is called from
mlx4_ib_create_ah(), which can be called from both interrupt and process
context.  So as far as I can tell, this spin_lock() needs to actually do
spin_lock_irqsave()?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
