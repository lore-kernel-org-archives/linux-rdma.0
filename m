From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] ib_ipoib: CSUM support in connected mode
Date: Sun, 5 Oct 2014 16:35:00 -0600
Message-ID: <20141005223500.GB31716@obsidianresearch.com>
References: <1412423147-8402-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412423147-8402-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 04, 2014 at 04:45:47AM -0700, Yuval Shaia wrote:

> +	if (cm_ibcrc_as_csum)
> +		skb->ip_summed = CHECKSUM_UNNECESSARY;
> +

As I said before, I think this scheme should be using CHECKSUM_PARTIAL
so packets can be forwarded correctly.

 *      PARTIAL: identical to the case for output below.  This may occur
 *          on a packet received directly from another Linux OS, e.g.,
 *          a virtualised Linux kernel on the same host.  The packet can
 *          be treated in the same way as UNNECESSARY except that on
 *          output (i.e., forwarding) the checksum must be filled in
 *          by the OS or the hardware.

Which is exactly what we want.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
