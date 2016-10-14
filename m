From: oulijun <oulijun@huawei.com>
Subject: Re: [patch 1/2] IB/hns: Fix a couple pointer math bugs
Date: Fri, 14 Oct 2016 16:39:04 +0800
Message-ID: <580099A8.7070603@huawei.com>
References: <20161014072837.GA15238@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20161014072837.GA15238@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

在 2016/10/14 15:28, Dan Carpenter 写道:
> "wqe" is a void pointer so adding sizeof() works.  The original code
> adds sizeof() multiplied by sizeof() so it doesn't work at all.
> 
> Fixes: 9a4435375cd1 ('IB/hns: Add driver files for hns RoCE driver')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index 399f5de..58b150e 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -205,8 +205,7 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  				      (wr->send_flags & IB_SEND_FENCE ?
>  				      (cpu_to_le32(HNS_ROCE_WQE_FENCE)) : 0);
>  
> -			wqe = (struct hns_roce_wqe_ctrl_seg *)wqe +
> -			       sizeof(struct hns_roce_wqe_ctrl_seg);
> +			wqe = wqe + sizeof(struct hns_roce_wqe_ctrl_seg);
>  
>  			switch (wr->opcode) {
>  			case IB_WR_RDMA_READ:
> @@ -235,8 +234,7 @@ int hns_roce_v1_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
>  				break;
>  			}
>  			ctrl->flag |= cpu_to_le32(ps_opcode);
> -			wqe = (struct hns_roce_wqe_raddr_seg *)wqe +
> -			       sizeof(struct hns_roce_wqe_raddr_seg);
> +			wqe = wqe + sizeof(struct hns_roce_wqe_raddr_seg);
>  
>  			dseg = wqe;
>  			if (wr->send_flags & IB_SEND_INLINE && wr->num_sge) {
> 
> .
> 
Hi, Dan Carpenter
  firstly, thanks your reviewing. This quesiton is checked while i develop and test the CM function, and i have fixed it in a patch. the patch
is as follows:
  https://patchwork.kernel.org/patch/9334859/

  the patch is reviewing by community experts.
  thanks your reviewing again.

Thanks
Lijun Ou


