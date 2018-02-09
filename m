From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2 rdma-core 1/2] libhns: Support rq record doorbell
Date: Fri, 9 Feb 2018 08:20:01 -0700
Message-ID: <20180209152001.GB7570@ziepe.ca>
References: <1518176724-126991-1-git-send-email-liuyixian@huawei.com>
 <1518176724-126991-2-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1518176724-126991-2-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 09, 2018 at 07:45:23PM +0800, Yixian Liu wrote:
> @@ -574,6 +588,7 @@ struct ibv_qp *hns_roce_u_create_qp(struct ibv_pd *pd,
>  
>  	qp->rq.wqe_cnt = attr->cap.max_recv_wr;
>  	qp->rq.max_gs	= attr->cap.max_recv_sge;
> +	qp->flags	= resp.cap_flags;

Also need zero init for resp

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
