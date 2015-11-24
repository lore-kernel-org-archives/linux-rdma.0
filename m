From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Future of FMR support, was: Re: [PATCH v1 5/9] xprtrdma: Add
 ro_unmap_sync method for FMR
Date: Mon, 23 Nov 2015 22:52:26 -0800
Message-ID: <20151124065225.GB29141@infradead.org>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
 <20151123221430.32702.86114.stgit@manet.1015granger.net>
 <5653B606.3070700@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5653B606.3070700-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2015 at 07:57:42PM -0500, Tom Talpey wrote:
> On 11/23/2015 5:14 PM, Chuck Lever wrote:
> >FMR's ro_unmap method is already synchronous because ib_unmap_fmr()
> >is a synchronous verb. However, some improvements can be made here.
> 
> I thought FMR support was about to be removed in the core.

Seems like everyone would love to kill it, but no one dares to do
it just yet.  Reasons to keep FMRs:

 - mthca doesn't support FRs but haven't been staged out
 - RDS only supports FRMs for the IB transports (it does support FRs for
   an entirely separate iWarp transports.  I'd love to know why we can't
   just use that iWarp transport for IB as well).
 - mlx4 hardware might be slower with FRs than FRMs (Or mentioned this
   in reply to the iSER remote invalidation series).

So at lest for 4.5 we're unlikely to be able to get rid of it alone
due to the RDS issue.  We'll then need performance numbers for mlx4,
and figure out how much we care about mthca.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
