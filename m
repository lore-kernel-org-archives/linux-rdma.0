From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] libhns: Support cq record doorbell
Date: Wed, 17 Jan 2018 21:37:17 -0700
Message-ID: <20180118043717.GC8414@ziepe.ca>
References: <1516242961-154453-1-git-send-email-liuyixian@huawei.com>
 <1516242961-154453-3-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516242961-154453-3-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 18, 2018 at 10:36:01AM +0800, Yixian Liu wrote:

> diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
> index cde8568..7037a1c 100644
> +++ b/providers/hns/hns_roce_u_verbs.c
> @@ -276,6 +276,16 @@ struct ibv_cq *hns_roce_u_create_cq(struct ibv_context *context, int cqe,
>  
>  	cmd.buf_addr = (uintptr_t) cq->buf.buf;
>  
> +	if (to_hr_dev(context->device)->hw_version != HNS_ROCE_HW_VER1) {
> +		cq->set_ci_db = hns_roce_alloc_db(to_hr_ctx(context),
> +						  HNS_ROCE_CQ_TYPE_DB);
> +		if (!cq->set_ci_db) {
> +			fprintf(stderr, "alloc cq db buffer failed!\n");
> +			goto err_buf;
> +		}
> +		cmd.db_addr  = (uintptr_t) cq->set_ci_db;

Uhh.. why does the userspace already have the 'db_addr' member of
hns_roce_create_cq when the kernel doesn't?

What is going on here? How does forward and backwards compatibility of
the kABI work?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
