From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4: Use official names for supported devices
Date: Mon, 12 Oct 2009 17:03:05 +0200
Message-ID: <20091012150305.GA28596@mtls03>
References: <20091012142936.GA27977@mtls03> <adaws30hdvh.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaws30hdvh.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2009 at 07:43:14AM -0700, Roland Dreier wrote:
> This patch doesn't apply since e76d0b67 ("mlx4_core: Add 40GigE device
> ID") which adds ID 0x676e for 40GE.

I was used your "master" branch to create the patches. I see the
commit you mention on "for-linus" so I'll fix that.

> 
> Also if we're going to churn all these comments, I think it would be a
> good idea to at least make the names follow a consistent scheme:
> 
>  A) choose either "PCIe 2.0" or "PCIe Gen2" and use that everywhere, not:
> 
>     > +	{ PCI_VDEVICE(MELLANOX, 0x6372) }, /* MT25458 [ConnectX EN 10GigE 10GBaseT, PCIe 2.0 2.5GT/s] */
> 
>     vs.
> 
>     > +	{ PCI_VDEVICE(MELLANOX, 0x675a) }, /* MT26458 [ConnectX EN 10GigE 10GBaseT, PCIe Gen2 5GT/s] */
> 
>  B) decide whether the external port type goes before or after the PCIe
>     speed, use that everywhere, not:
> 
>     > +	{ PCI_VDEVICE(MELLANOX, 0x634a) }, /* MT25418 [ConnectX VPI PCIe 2.0 2.5GT/s - IB DDR / 10GigE] */
> 
>     vs.
> 
>     > +	{ PCI_VDEVICE(MELLANOX, 0x6368) }, /* MT25448 [ConnectX EN 10GigE, PCIe 2.0 2.5GT/s] */
> 
> To be honest even if we did that I don't see that much value in this
> patch -- it replaces readable comments with longer ones that wrap around
> the edge of my terminal, which say pretty much the same thing.


I will re-send once I get the correct official phrasing. The patch
fixes inconsistencies in between hex values and decimal values of
device IDs so I think it is needed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
