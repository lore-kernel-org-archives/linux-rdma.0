From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_ipoib: CSUM support in connected mode
Date: Wed, 8 Oct 2014 13:40:29 +0300
Message-ID: <20141008104028.GA4109@yuval-lab>
References: <1412423147-8402-1-git-send-email-yuval.shaia@oracle.com>
 <20141005223500.GB31716@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141005223500.GB31716-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 05, 2014 at 04:35:00PM -0600, Jason Gunthorpe wrote:
> On Sat, Oct 04, 2014 at 04:45:47AM -0700, Yuval Shaia wrote:
> 
> > +	if (cm_ibcrc_as_csum)
> > +		skb->ip_summed = CHECKSUM_UNNECESSARY;
> > +
> 
> As I said before, I think this scheme should be using CHECKSUM_PARTIAL
> so packets can be forwarded correctly.
> 
>  *      PARTIAL: identical to the case for output below.  This may occur
>  *          on a packet received directly from another Linux OS, e.g.,
>  *          a virtualised Linux kernel on the same host.  The packet can
>  *          be treated in the same way as UNNECESSARY except that on
>  *          output (i.e., forwarding) the checksum must be filled in
>  *          by the OS or the hardware.
> 
> Which is exactly what we want.
Will do, thanks.
This is in case this code runs on bridge, right?
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
