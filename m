From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH V3 for-next 1/6] RDMA/hns: Add rq inline data support for
 hip08 RoCE
Date: Fri, 29 Dec 2017 11:18:43 -0700
Message-ID: <20171229181843.GF6513@ziepe.ca>
References: <1514540341-115107-1-git-send-email-oulijun@huawei.com>
 <1514540341-115107-2-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514540341-115107-2-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 29, 2017 at 05:38:56PM +0800, Lijun Ou wrote:
> +		hr_qp->rq_inl_buf.wqe_list = kcalloc(1, hr_qp->rq.wqe_cnt *
> +					       sizeof(struct hns_roce_rinl_wqe),
> +					       GFP_KERNEL);

This is complete mis-use of the 2d allocator functions. It needs to
be:

	hr_qp->rq_inl_buf.wqe_list = kcalloc(hr_qp->rq.wqe_cnt,
					       sizeof(struct hns_roce_rinl_wqe),
					       GFP_KERNEL);

It is important that the first argument be the 'untrsuted' value so
the multiply overflow checking works properly.

> +		/* Firstly, allocate a list of sge space buffer */
> +		hr_qp->rq_inl_buf.wqe_list[0].sg_list =
> +					kcalloc(1, hr_qp->rq_inl_buf.wqe_cnt *
> +					       init_attr->cap.max_recv_sge *
> +					       sizeof(struct hns_roce_rinl_sge),
> +					       GFP_KERNEL);

ditto

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
