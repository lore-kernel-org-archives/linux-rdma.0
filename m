From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v4 for-next 2/4] RDMA/hns: Support cq record doorbell for
 the user space
Date: Fri, 16 Feb 2018 11:01:07 -0700
Message-ID: <20180216180107.GD22739@ziepe.ca>
References: <1518430451-89833-1-git-send-email-liuyixian@huawei.com>
 <1518430451-89833-3-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518430451-89833-3-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 12, 2018 at 06:14:09PM +0800, Yixian Liu wrote:

> +struct hns_roce_ib_create_cq_resp {
> +	__u32	cqn;
> +	__u32	reserved;
> +	__u32	cap_flags;
> +	__u32	reserved1;
>  };

This is a bit weird, are you sure you want those reserved?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
