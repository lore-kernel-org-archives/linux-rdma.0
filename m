From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH V5 for-next 0/6] Add rq inline and bugfixes for hns
Date: Wed, 3 Jan 2018 14:19:34 -0700
Message-ID: <20180103211934.GL11348@ziepe.ca>
References: <1514947448-40475-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514947448-40475-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 03, 2018 at 10:44:02AM +0800, Lijun Ou wrote:
> This patch series add rq inline support for hip08 kernel
> mode as well as fix some bugs for hip06 and hip08.
> 
> Change from V4:
> 1. Fix the comment given by Leon Romanovsky
> 2. Delete unnecessary judgment when kfreeing wqe_list in
>    exception branch
> 
> Change from V3:
> 1. Fix the usage of kcalloc
> 
> Change from V2:
> 1. Delete unnessary judgement for kfree
> 2. Use kcalloc instead of kmalloc_array
> 3. Adjust the method of setting attr_mask
> 
> Change from V1:
> 1. Optimize some lines according to Leon Romanovsky's reviews
> 2. Delete unnecessary operation for setting NULL
> 3. encapsulated the process for handle rq inline wqe with a 
>    seperated function.
> 4. Add signed-off-by.
> 
> Lijun Ou (5):
>   RDMA/hns: Add rq inline data support for hip08 RoCE
>   RDMA/hns: Update the usage of sr_max and rr_max field
>   RDMA/hns: Set access flags of hip08 RoCE
>   RDMA/hns: Filter for zero length of sge in hip08 kernel mode
>   RDMA/hns: Assign dest_qp when deregistering mr
> 
> Yixian Liu (1):
>   RDMA/hns: Fix QP state judgement before sending work requests
> 
>  drivers/infiniband/hw/hns/hns_roce_device.h |  19 ++++
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c  |   2 +-
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 171 ++++++++++++++++++++++------
>  drivers/infiniband/hw/hns/hns_roce_qp.c     |  53 +++++++--
>  4 files changed, 203 insertions(+), 42 deletions(-)

Applied to for-next, thanks

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
