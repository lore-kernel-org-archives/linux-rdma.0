From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] mlx4: Non-xrc SRQs need an xrcd which will never be
 used by xrc
Date: Wed, 22 Jun 2011 16:05:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373029A79@ORSMSX101.amr.corp.intel.com>
References: <201106221533.41053.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106221533.41053.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Non-xrc SRQs should be created with a domain number which will never
> be assigned to an XRC TGT QP. This is so there is no possibility of such
> an SRQ
> inadvertently receiving an XRC transmission.
> 
> XRC Domain number allocations begin with (dev->dev->caps.reserved_xrcds +
> 1);
> Domain number (dev->dev->caps.reserved_xrcds) has been set aside to be
> used
> for this purpose.
> 
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
> 
> ---
> Sean,
> This was a little "glitch" that I noticed during my code review.

Thanks - If it's okay, I'll merge this change into the existing patches.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
