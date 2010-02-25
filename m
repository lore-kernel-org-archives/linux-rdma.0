From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] Add new device IDs for ConnectX VPI HCAs
Date: Thu, 25 Feb 2010 23:08:50 +0200
Message-ID: <20100225210850.GA26139@mtldesk030.lab.mtl.com>
References: <20100208140455.GA24593@vlad-laptop>
 <adazl2yxp7r.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adazl2yxp7r.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 24, 2010 at 02:07:20PM -0800, Roland Dreier wrote:
>  > +	HCA(MELLANOX, 0x6746),	/* MT26438 ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE Virt+ */
> 
> The kernel calls this device ID "MT26438 ConnectX EN 40GigE PCIe gen2
> 5GT/s".  Maybe we should just delete these comments, since we can't seem
> to get them right?

I guess it would be best if we take the description from
http://pciids.sourceforge.net/v2.2/pci.ids
> 
>  > +	HCA(MELLANOX, 0x6778),	/* MT26488 ConnectX VPI PCIe 2.0 5GT/s - IB DDR / 10GigE Virt+ */
> 
> Are we missing a kernel patch?  I don't see this device ID in the kernel
> driver.

Looks like it is missing.

If we agree on this, we'll send two patches - one for kernel and one
for libmlx4 to sync all device IDs with descriptions from the
mentioned url.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
