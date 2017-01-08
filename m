From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1] net/mlx4_core: VF probe fail when HW support 64-bit
 coherent DMA
Date: Sun, 8 Jan 2017 17:08:39 +0200
Message-ID: <20170108150838.GA2106@shamir-linux.uk.oracle.com>
References: <1483866889-10700-1-git-send-email-shamir.rabinovitch@oracle.com>
 <20170108143032.GA22478@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170108143032.GA22478-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 08, 2017 at 06:30:32AM -0800, Christoph Hellwig wrote:
> On Sun, Jan 08, 2017 at 04:14:49AM -0500, Shamir Rabinovitch wrote:
> > CX3 firmware is unable to work with 64-bit coherent DMA. If IOMMU
> > support 64-bit coherent DMA mlx4_core driver will try to use it
> > and VF probe will fail due to firmware error.
> > 
> > Force all mlx4_core coherent DMA to 32-bit only!
> 
> If this is only an issue with VFs it should be limited to VF PCI IDs.
> If not the changelog should be updated a bit.

Agree. Thanks for the comment.

I will do that once Mellanox review the patch and say how wide is
this issue. Is this issue limited to specific Mellanox firmware ? Is 
this issue limited to specific HW ? I have asked Mellanox all those 
question via our support channel and still have not got any answers.

BR, Shamir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
