From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix unaligned accesses
Date: Wed, 29 Apr 2015 15:18:22 -0600
Message-ID: <20150429211822.GA25951@obsidianresearch.com>
References: <1430340983-12538-1-git-send-email-david.ahern@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430340983-12538-1-git-send-email-david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 29, 2015 at 04:56:23PM -0400, David Ahern wrote:

>  static void cm_mask_copy(u8 *dst, u8 *src, u8 *mask)
>  {

Do you know what call site is unaligned? A quick audit suggests that
fixing a few possibly troublesome callers to be guaranteed 32 bit
aligned should be fairly straight foward.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
