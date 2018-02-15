From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v4 for-next 1/4] RDMA/hns: Support rq record doorbell for
 the user space
Date: Thu, 15 Feb 2018 16:23:14 -0700
Message-ID: <20180215232313.GC7803@ziepe.ca>
References: <1518430451-89833-1-git-send-email-liuyixian@huawei.com>
 <1518430451-89833-2-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518430451-89833-2-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 12, 2018 at 06:14:08PM +0800, Yixian Liu wrote:
> +int hns_roce_db_map_user(struct hns_roce_ucontext *context, unsigned long virt,
> +			 struct hns_roce_db *db)
> +{
> +	struct hns_roce_user_db_page *db_page;
> +	int ret = 0;
> +
> +	mutex_lock(&context->db_page_mutex);
> +
> +	list_for_each_entry(db_page, &context->db_page_list, list)
> +		if (db_page->user_virt == (virt & PAGE_MASK))
> +			goto found;
> +
> +	db_page = kmalloc(sizeof(*db_page), GFP_KERNEL);
> +	if (!db_page) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	db_page->user_virt = (virt & PAGE_MASK);
> +	db_page->refcount_t = 0;
> +	db_page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
> +					 PAGE_SIZE, 0, 0);

It seems quite odd to call something 'doorbell' that exists in system
memory? doorbell should exist in BAR memory..

> +	if (IS_ERR(db_page->umem)) {
> +		ret = PTR_ERR(db_page->umem);
> +		kfree(db_page);
> +		goto out;
> +	}
> +
> +	list_add(&db_page->list, &context->db_page_list);
> +
> +found:
> +	db->dma = sg_dma_address(db_page->umem->sg_head.sgl) +
> +		  (virt & ~PAGE_MASK);
> +	db->u.user_page = db_page;
> +	++db_page->refcount_t;

Since user space controls this it should be a refcount_t

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
