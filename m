From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH v2] RDMA/rxe: Set wqe->status correctly if an unexpected
 response is received
Date: Wed, 27 Jun 2018 19:31:50 +0300
Message-ID: <20180627163150.GA9553@lap1>
References: <20180626153936.9576-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180626153936.9576-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Zhu Yanjun <yanjun.zhu@oracle.com>, Jianchao Wang <jianchao.w.wang@oracle.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 26, 2018 at 08:39:36AM -0700, Bart Van Assche wrote:
> Every function that returns COMPST_ERROR must set wqe->status to
> another value than IB_WC_SUCCESS before returning COMPST_ERROR. Fix
> the only code path for which this is not yet the case.

It is unclear to me why other places left out from this fix (e.x. lines
248, 288 etc).

> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Zhu Yanjun <yanjun.zhu@oracle.com>
> Cc: Jianchao Wang <jianchao.w.wang@oracle.com>
> Cc: Yuval Shaia <yuval.shaia@oracle.com>
> Cc: <stable@vger.kernel.org>
> ---
> 
> Changes compared to v1: left out a pr_err() statement as requested by Jason.
> 
>  drivers/infiniband/sw/rxe/rxe_comp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
> index 98d470d1f3fc..83311dd07019 100644
> --- a/drivers/infiniband/sw/rxe/rxe_comp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_comp.c
> @@ -276,6 +276,7 @@ static inline enum comp_state check_ack(struct rxe_qp *qp,
>  	case IB_OPCODE_RC_RDMA_READ_RESPONSE_MIDDLE:
>  		if (wqe->wr.opcode != IB_WR_RDMA_READ &&
>  		    wqe->wr.opcode != IB_WR_RDMA_READ_WITH_INV) {
> +			wqe->status = IB_WC_FATAL_ERR;
>  			return COMPST_ERROR;
>  		}
>  		reset_retry_counters(qp);
> -- 
> 2.17.1
> 
