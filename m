From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 for-next 2/2] RDMA/hns: Fix alignment problem of the
 doorbell
Date: Thu, 28 Dec 2017 08:57:12 -0700
Message-ID: <20171228155712.GU25436@ziepe.ca>
References: <1514470683-6972-1-git-send-email-liuyixian@huawei.com>
 <1514470683-6972-3-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514470683-6972-3-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Thu, Dec 28, 2017 at 10:18:03PM +0800, Yixian Liu wrote:

> -	hns_roce_write64_k(doorbell, eq->doorbell);
> +	hns_roce_write64_k(db.doorbell, eq->doorbell);

You need to pass &db to hns_roce_write64_k and have it deref the 64
bit value using the union. The point here is to eliminate the cast inside
hns_roce_write64_k.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
