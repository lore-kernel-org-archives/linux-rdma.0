From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4/IB: Add set_4k_mtu module parameter.
Date: Tue, 12 Jan 2010 09:05:06 -0800
Message-ID: <adabpgzp83h.fsf@roland-alpha.cisco.com>
References: <20100112120901.GA7161@vlad-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100112120901.GA7161@vlad-laptop> (Vladimir Sokolovsky's
	message of "Tue, 12 Jan 2010 14:09:02 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm not thrilled about this patch.

 > +module_param_named(set_4k_mtu, mlx4_ib_set_4k_mtu, int, 0444);
 > +MODULE_PARM_DESC(set_4k_mtu, "attempt to set 4K MTU to all ConnectX ports");

What does "attempt to set 4K MTU" mean?  Try to set the MTU cap to 4K?
What happens if it fails?  Is there any reason not to just let the MTU
cap be 4K all time?

Having this be a module parameter really seems like a bad idea for the
future....

 > +	if (mlx4_ib_set_4k_mtu)
 > +		((__be32 *) mailbox->buf)[0] |= cpu_to_be32((1 << 22) |
 > +							    (1 << 21) |
 > +							    (5 << 12) |
 > +							    (2 << 4));

Is there any way for this to write this with fewer unexplained magic numbers?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
