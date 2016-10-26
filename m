From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [For help] rdma-roce build quesiton
Date: Wed, 26 Oct 2016 10:09:02 -0600
Message-ID: <20161026160902.GD24898@obsidianresearch.com>
References: <581059FA.6070507@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <581059FA.6070507-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2016 at 03:23:38PM +0800, oulijun wrote:

> the build is fail and the print log as follows:
> 
> error: size of unnamed array is negative
> attr->cap.max_recv_wr = min(context->max_qp_wr, attr->cap.max_recv_wr);

It is telling you the types are not the same, and this is a source of bugs
as C has some counter intuitive rules regarding type promotion.

1) Audit max_qp_wr and max_recv_wr to see if they really should be
   different types, if not fix context->max_qp_wr to match

2) If they are legitimately different then use

  min_t(<desired type>, context->max_qp_wr, attr->cap.max_recv_wr);

Think carefully about what common type is used because both arguments
will be casted, and the goal is to avoid a loss of precision or
signdedness in the cast.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
