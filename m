From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1] net/mlx4_core: VF probe fail when HW support 64-bit
 coherent DMA
Date: Sun, 8 Jan 2017 06:30:32 -0800
Message-ID: <20170108143032.GA22478@infradead.org>
References: <1483866889-10700-1-git-send-email-shamir.rabinovitch@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483866889-10700-1-git-send-email-shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 08, 2017 at 04:14:49AM -0500, Shamir Rabinovitch wrote:
> CX3 firmware is unable to work with 64-bit coherent DMA. If IOMMU
> support 64-bit coherent DMA mlx4_core driver will try to use it
> and VF probe will fail due to firmware error.
> 
> Force all mlx4_core coherent DMA to 32-bit only!

If this is only an issue with VFs it should be limited to VF PCI IDs.
If not the changelog should be updated a bit.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
