From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] RDMA/hns: Fix uninitialized variable in
 hns_roce_v2_query_qp()
Date: Wed, 04 Oct 2017 15:15:41 -0400
Message-ID: <1507144541.46071.2.camel@redhat.com>
References: <20171003105418.jpthrfu7j7ojk5fg@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20171003105418.jpthrfu7j7ojk5fg@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-03 at 13:54 +0300, Dan Carpenter wrote:
> We accidentally return an uninitialized value if
> (hr_qp->state == IB_QPS_RESET).  We should be returning success.
> 
> Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08
> SoC")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Hi Dan, I already took in another patch that solves the same issue. 
Thanks.

> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 4171f73bdad5..e1c59dc066c9 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -2792,7 +2792,7 @@ static int hns_roce_v2_query_qp(struct ib_qp
> *ibqp, struct ib_qp_attr *qp_attr,
>  	struct device *dev = hr_dev->dev;
>  	int tmp_qp_state;
>  	int state;
> -	int ret;
> +	int ret = 0;
>  
>  	context = kzalloc(sizeof(*context), GFP_KERNEL);
>  	if (!context)
-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

