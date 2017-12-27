From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2 for-next 1/2] RDMA/hns: Add detailed comments for mb()
 call
Date: Wed, 27 Dec 2017 09:45:51 -0700
Message-ID: <20171227164551.GC25436@ziepe.ca>
References: <1514372644-171663-1-git-send-email-liuyixian@huawei.com>
 <1514372644-171663-2-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514372644-171663-2-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 27, 2017 at 07:04:03PM +0800, Yixian Liu wrote:
> This patch adds more detailed comments when we call the
> memory barrier function, such as rmb, wmb and mb. Three
> mb() callers are deleted since they are unnecessary.

Are you sure none of these need to be dma_*mb ?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
