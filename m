From: oulijun <oulijun@huawei.com>
Subject: Re: [patch 2/2] IB/hns: Fix some error handling in
 hns_roce_v1_query_qp()
Date: Mon, 24 Oct 2016 20:29:36 +0800
Message-ID: <580DFEB0.20100@huawei.com>
References: <20161014073441.GB15238@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20161014073441.GB15238@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

在 2016/10/14 15:34, Dan Carpenter 写道:
> to_ib_qp_state() returns IB_QPS_ERR (6) on error, it doesn't return -1.
> 
> Fixes: 9a4435375cd1 ('IB/hns: Add driver files for hns RoCE driver')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index 58b150e..280abac 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -2544,7 +2544,7 @@ int hns_roce_v1_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
>  			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_M,
>  			       QP_CONTEXT_QPC_BYTES_144_QP_STATE_S);
>  	tmp_qp_state = (int)to_ib_qp_state((enum hns_roce_qp_state)state);
> -	if (tmp_qp_state == -1) {
> +	if (tmp_qp_state == IB_QPS_ERR) {
>  		dev_err(dev, "to_ib_qp_state error\n");
>  		ret = -EINVAL;
>  		goto out;
> 
> .
> 
Hi, Dan Carpenter
  After checking your modification, I think that it maybe fix this:
  static enum ib_qp_state to_ib_qp_state(enum hns_roce_qp_state state)
{
	switch (state) {
	case HNS_ROCE_QP_STATE_RST:
		return IB_QPS_RESET;
	case HNS_ROCE_QP_STATE_INIT:
		return IB_QPS_INIT;
	case HNS_ROCE_QP_STATE_RTR:
		return IB_QPS_RTR;
	case HNS_ROCE_QP_STATE_RTS:
		return IB_QPS_RTS;
	case HNS_ROCE_QP_STATE_SQD:
		return IB_QPS_SQD;
	case HNS_ROCE_QP_STATE_ERR:
		return IB_QPS_ERR;
	default:
		return -1;
	}
}

because the IB_QPS_ERR is legal state, but the tmp_qp_state should return a illegal state when
the the to_ib_qp_state executed the default branch.

thanks
Lijun Ou



