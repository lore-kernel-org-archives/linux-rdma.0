From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RESEND][PATCH v4 for-next 0/2] Bugfixes for eq support in hns
Date: Fri, 29 Dec 2017 11:10:29 -0700
Message-ID: <20171229181029.GA12569@ziepe.ca>
References: <1514546779-206832-1-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514546779-206832-1-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 29, 2017 at 07:26:17PM +0800, Yixian Liu wrote:
> This patch set fixes the bugs according to Jason's two comments
> on my previous patch set, which listed in the NOTE.
> 
> NOTE: This patch set is dependent on the following patches.
>    "RDMA/hns: Add eq support of hip08"
>    "RDMA/hns: Refactor eq code for hip06"
> v3 -> v4:
> 1. Delete two unnecessary mb() caller in patch [1/2].
> v2 -> v3:
> 1. Update according to Jason's comments
>    - use dma_rmb instead of rmb in patch [1/2]
>    - delete unnecessary assignment for doorbell64
> v1 -> v2:
> 1. Update according to Leon's comment, see the changelog
>    of patch [2/2].
> 
> Yixian Liu (2):
>   RDMA/hns: Add detailed comments for mb() call

I applied this one to for-next, it looks great, thanks

>   RDMA/hns: Fix alignment problem of the doorbell

and dropped this one, please resend with a full solution to this
systemic problem as discussed.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
