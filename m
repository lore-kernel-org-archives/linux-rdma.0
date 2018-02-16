From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2 rdma-rc] RDMA/restrack: don't use uaccess_kernel()
Date: Fri, 16 Feb 2018 10:25:37 -0700
Message-ID: <20180216172537.GA10123@ziepe.ca>
References: <20180216165919.997D72BB6D@smtp.opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180216165919.997D72BB6D-ff04S8wfc4plDsoTORJclLwze2ij/50Q0E9HWUfgJXw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 14, 2018 at 06:43:36PM -0800, Steve Wise wrote:
> uaccess_kernel() isn't sufficient to determine if an rdma resource is
> user-mode or not.  For example, resources allocated in the add_one()
> function of an ib_client get falsely labeled as user mode, when they
> are kernel mode allocations.  EG: mad qps.
> 
> The result is that these qps are skipped over during a nldev query
> because of an erroneous namespace mismatch.
> 
> So now we determine if the resource is user-mode by looking at the object
> struct's uobject or similar pointer to know if it was allocated for user
> mode applications.
> 
> Fixes: 02d8883f520e ("RDMA/restrack: Add general infrastructure to track RDMA resources")
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> 
> 
> Changes since v1:
> 
> changed _create_qp() to take the qp ib_uobject ptr so it is availble to
> rdma_restrack_add()
> 
>  drivers/infiniband/core/core_priv.h  |  4 +++-
>  drivers/infiniband/core/restrack.c   | 35 +++++++++++++++++++++++++++++++++--
>  drivers/infiniband/core/uverbs_cmd.c |  4 ++--
>  drivers/infiniband/core/verbs.c      |  3 +--
>  4 files changed, 39 insertions(+), 7 deletions(-)

I took this to for-rc, but when I fixed the XRCD conflict with Leon's
patch I ended up retyping it to this - don't really need all rambly
boilerplate. Someone should fix the other one too..

static bool res_is_user(struct rdma_restrack_entry *res)
{
	switch (res->type) {
	case RDMA_RESTRACK_PD:
		return container_of(res, struct ib_pd, res)->uobject;
	case RDMA_RESTRACK_CQ:
		return container_of(res, struct ib_cq, res)->uobject;
	case RDMA_RESTRACK_QP:
		return container_of(res, struct ib_qp, res)->uobject;
	default:
		WARN_ONCE(true, "Wrong resource tracking type %u\n", res->type);
		return false;
	}
}

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
