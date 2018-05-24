From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH V2 rdma-next 4/4] RDMA/hns: Fix the illegal memory
 operation when cross page
Date: Thu, 24 May 2018 15:40:47 -0600
Message-ID: <20180524214047.GF3948@ziepe.ca>
References: <1527070590-94399-1-git-send-email-xavier.huwei@huawei.com>
 <1527070590-94399-5-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1527070590-94399-5-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 23, 2018 at 06:16:30PM +0800, Wei Hu (Xavier) wrote:
> This patch fixed the potential illegal operation when using the
> extend sge buffer cross page in post send operation. The bug
> will cause the calltrace.

Should include the oops for reference here..

> Reported-by: Jie Chen <chenjie103@huawei.com>
> Reported-by: Xiping Zhang (Francis) <zhangxiping3@huawei.com>
> Fixes: b1c158350968("RDMA/hns: Get rid of virt_to_page and vmap calls after dma_alloc_coherent")
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>
> 
> v1->v2: Modify the Fixes statement according to Leon's comment.
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 70 +++++++++++++++++++++---------
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  1 +
>  2 files changed, 51 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index a70d07b..62c1eb5 100644
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -52,6 +52,52 @@ static void set_data_seg_v2(struct hns_roce_v2_wqe_data_seg *dseg,
>  	dseg->len  = cpu_to_le32(sg->length);
>  }
>  
> +static void set_extend_sge(struct hns_roce_qp *qp, struct ib_send_wr *wr,
> +			   unsigned int *sge_ind)
> +{
> +	struct hns_roce_v2_wqe_data_seg *dseg;
> +	struct ib_sge *sg;
> +	int num_in_wqe = 0;
> +	int extend_sge_num;
> +	int fi_sge_num;
> +	int se_sge_num;
> +	int shift;
> +	int i;
> +
> +	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC)
> +		num_in_wqe = HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE;
> +	extend_sge_num = wr->num_sge - num_in_wqe;
> +	sg = wr->sg_list + num_in_wqe;
> +	shift = qp->hr_buf.page_shift;
> +
> +	/*
> +	 * Check whether wr->num_sge sges are in the same page. If not, we
> +	 * should calculate how many sges in the first page and the second
> +	 * page.
> +	 */
> +	dseg = get_send_extend_sge(qp, (*sge_ind) & (qp->sge.sge_cnt - 1));
> +	fi_sge_num = (((((u64)dseg >> shift) + 1) << shift) - (u64)dseg) /
> +		      sizeof(struct hns_roce_v2_wqe_data_seg);

desg is a pointer.. that u64 should be a uinptr_t

And it is better written as

  (round_up((uintptr_t)dseg, 1 << shift) - (uintptr)desg)/sizeof(struct hns_roce_v2_wqe_data_seg)

if I got it right..

Jason
