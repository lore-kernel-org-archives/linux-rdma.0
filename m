From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB: start documenting device capabilities
Date: Tue, 10 Nov 2015 14:46:53 +0200
Message-ID: <5641E73D.3070400@dev.mellanox.co.il>
References: <1447157983-13519-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447157983-13519-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> +
> +	/*
> +	 * This device supports the IB "base memory management extension",
> +	 * which includes support for fast registrations (IB_WR_REG_MR,
> +	 * IB_WR_LOCAL_INV and IB_WR_SEND_WITH_INV verbs).  This flag should
> +	 * also be set by any iWarp device which must support FRs to comply
> +	 * to the iWarp verbs spec.  iWarp devices also support the
> +	 * IB_WR_RDMA_READ_WITH_INV verb for RDMA READs that invalidate the
> +	 * stag.
> +	 */

Kinda weird that READ_WITH_INV came in without a device cap for it.

Looks good,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
