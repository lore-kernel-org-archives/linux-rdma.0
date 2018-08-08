From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] RDMA/rxe: Set wqe->status correctly if an unexpected
 response is received
Date: Wed, 8 Aug 2018 09:58:56 -0600
Message-ID: <20180808155856.GA7230@ziepe.ca>
References: <20180626153936.9576-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180626153936.9576-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Zhu Yanjun <yanjun.zhu@oracle.com>, Jianchao Wang <jianchao.w.wang@oracle.com>, Yuval Shaia <yuval.shaia@oracle.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 26, 2018 at 08:39:36AM -0700, Bart Van Assche wrote:
> Every function that returns COMPST_ERROR must set wqe->status to
> another value than IB_WC_SUCCESS before returning COMPST_ERROR. Fix
> the only code path for which this is not yet the case.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Zhu Yanjun <yanjun.zhu@oracle.com>
> Cc: Jianchao Wang <jianchao.w.wang@oracle.com>
> Cc: Yuval Shaia <yuval.shaia@oracle.com>
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> ---
> 
> Changes compared to v1: left out a pr_err() statement as requested by Jason.
> 
>  drivers/infiniband/sw/rxe/rxe_comp.c | 1 +
>  1 file changed, 1 insertion(+)

applied to for-next

Thanks,
Jason
