From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH] RDMA/hns: return 0 rather than return a garbage status
 value
Date: Sat, 30 Sep 2017 15:11:05 +0800
Message-ID: <59CF4389.6050103@huawei.com>
References: <20170929201308.4704-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170929201308.4704-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>
Cc: Lijun Ou <oulijun@huawei.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Thanks,  Colin Ian King

Acked-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>

On 2017/9/30 4:13, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> For the case where hr_qp->state == IB_QPS_RESET, an uninitialized
> value in ret is being returned by function hns_roce_v2_query_qp.
> Fix this by setting ret to 0 for this specific return condition.
>
> Detected by CoverityScan, CID#1457203 ("Unitialized scalar variable")
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> index 4870b51caab9..791dae72e775 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
> @@ -2805,6 +2805,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
>   
>   	if (hr_qp->state == IB_QPS_RESET) {
>   		qp_attr->qp_state = IB_QPS_RESET;
> +		ret = 0;
>   		goto done;
>   	}
>   
