From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2] IB/ipoib: Fix for notify send CQ failure messages
Date: Wed, 3 Jan 2018 10:39:25 -0700
Message-ID: <20180103173925.GF11348@ziepe.ca>
References: <20180103123950.8556.47883.stgit@phlsvlogin03.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180103123950.8556.47883.stgit-u2TXY/5TJkdZ7WVY1cDZ9q2pdiUAq4bhAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 07:39:50AM -0500, Alex Estrin wrote:
> If IB_CQ_REPORT_MISSED_EVENTS flag is passed in ib_req_notify_cq()
> it may return positive value indicating non-empty CQ.
> If return code not verified the log might be flooded with false
> warning messages "request notify on send CQ failed".
> 
> Fixes: 8966e28d2e40 ("IB/ipoib: Use NAPI in UD/TX flows")
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> v2: adjusted Fixes: line format
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c |   10 ++++++----
>  drivers/infiniband/ulp/ipoib/ipoib_ib.c |    2 +-
>  2 files changed, 7 insertions(+), 5 deletions(-)

Applied to for-next

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
