From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 6/9] IB/core: add a need_inval flag to struct ib_mr
Date: Mon, 29 Feb 2016 14:40:44 -0800
Message-ID: <56D4C8EC.8020805@sandisk.com>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456784410-20166-7-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Steve Wise <swise@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

On 02/29/2016 02:20 PM, Christoph Hellwig wrote:
> From: Steve Wise <swise@chelsio.com>
>
> This is the first step toward moving MR invalidation decisions
> to the core.  It will be needed by the upcoming RW API.
>
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
>   include/rdma/ib_verbs.h | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 1e68dae..2b94cea 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1431,6 +1431,7 @@ struct ib_mr {
>   	u64		   iova;
>   	u32		   length;
>   	unsigned int	   page_size;
> +	bool		   need_inval;
>   	union {
>   		struct ib_uobject	*uobject;	/* user */
>   		struct list_head	qp_entry;	/* FR */

Hi Christoph,

mthca uses kmalloc() to allocate a struct mr. Are you sure we don't need 
to initialize the 'need_inval' member in ib_alloc_mr()?

Bart.
