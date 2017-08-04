From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/hns: checking for IS_ERR() instead of NULL
Date: Fri, 04 Aug 2017 15:11:15 -0400
Message-ID: <1501873875.79618.11.camel@redhat.com>
References: <20170804081208.qkkj3yons7ljccjp@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170804081208.qkkj3yons7ljccjp@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-08-04 at 11:12 +0300, Dan Carpenter wrote:
> The hns_roce_v1_create_lp_qp() returns NULL on error, not error
> pointers.
> 
> Fixes: bfcc681bd09d ("IB/hns: Fix the bug when free mr")
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index 38f5c77baabf..747efd1ae5a6 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -733,7 +733,7 @@ static int hns_roce_v1_rsv_lp_qp(struct
> hns_roce_dev *hr_dev)
>  			continue;
>  
>  		free_mr->mr_free_qp[i] =
> hns_roce_v1_create_lp_qp(hr_dev, pd);
> -		if (IS_ERR(free_mr->mr_free_qp[i])) {
> +		if (!free_mr->mr_free_qp[i]) {
>  			dev_err(dev, "Create loop qp failed!\n");
>  			goto create_lp_qp_failed;
>  		}

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
