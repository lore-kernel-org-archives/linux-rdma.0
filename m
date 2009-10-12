From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Use official names for supported devices
Date: Mon, 12 Oct 2009 07:43:14 -0700
Message-ID: <adaws30hdvh.fsf@cisco.com>
References: <20091012142936.GA27977@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091012142936.GA27977@mtls03> (Eli Cohen's message of "Mon, 12
	Oct 2009 16:29:36 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch doesn't apply since e76d0b67 ("mlx4_core: Add 40GigE device
ID") which adds ID 0x676e for 40GE.

Also if we're going to churn all these comments, I think it would be a
good idea to at least make the names follow a consistent scheme:

 A) choose either "PCIe 2.0" or "PCIe Gen2" and use that everywhere, not:

    > +	{ PCI_VDEVICE(MELLANOX, 0x6372) }, /* MT25458 [ConnectX EN 10GigE 10GBaseT, PCIe 2.0 2.5GT/s] */

    vs.

    > +	{ PCI_VDEVICE(MELLANOX, 0x675a) }, /* MT26458 [ConnectX EN 10GigE 10GBaseT, PCIe Gen2 5GT/s] */

 B) decide whether the external port type goes before or after the PCIe
    speed, use that everywhere, not:

    > +	{ PCI_VDEVICE(MELLANOX, 0x634a) }, /* MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE] */

    vs.

    > +	{ PCI_VDEVICE(MELLANOX, 0x6368) }, /* MT25448 [ConnectX EN 10GigE, PCIe 2.0 2.5GT/s] */

To be honest even if we did that I don't see that much value in this
patch -- it replaces readable comments with longer ones that wrap around
the edge of my terminal, which say pretty much the same thing.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
