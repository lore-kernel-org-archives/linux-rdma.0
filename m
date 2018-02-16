From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 rdma-core 1/2] libhns: Support rq record doorbell
Date: Fri, 16 Feb 2018 12:57:20 -0700
Message-ID: <20180216195720.GA23877@ziepe.ca>
References: <1518352834-80200-1-git-send-email-liuyixian@huawei.com>
 <1518352834-80200-2-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518352834-80200-2-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 11, 2018 at 08:40:33PM +0800, Yixian Liu wrote:
> This patch updates to support rq record doorbell in the
> user space driver.
> 
> Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

You should't add those Reviwed-by tags unless someone actually sends
you a tag..

> +#define BIT_CNT_PER_BYTE       8

I'm getting tired of seeing people open code bitmaps.

Can you please add and use ccan/bitmap for this?

https://github.com/rustyrussell/ccan/blob/master/ccan/bitmap/

If this is unclear I can help you

> +	/* alloc db page */
> +	page_size = (uint32_t)to_hr_dev(ctx->ibv_ctx.context.device)->page_size;
> +	page = (struct hns_roce_db_page *)calloc(1, sizeof(*page));

And please go through and clean up all the extra  casting, none of
this is necessary.

> +static void hns_roce_clear_db_page(struct hns_roce_db_page *page)
> +{
> +	if (!page) {
> +		fprintf(stderr, "error clear: db page is NULL!\n");
> +		return;

No prints in drivers. Use assert()

Same sort of comments on other patches

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
