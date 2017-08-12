From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 1/1] RDMA/uverbs: Intialize cq_context properly
Date: Sat, 12 Aug 2017 18:18:11 +0530
Message-ID: <20170812124810.GA21000@chelsio.com>
References: <1502132526-18355-1-git-send-email-bharat@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502132526-18355-1-git-send-email-bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,
Please pull this change for next rc if you feel the change appropriate.
Thanks,
Bharat.

On Tuesday, August 08/08/17, 2017 at 00:32:06 +0530, Potnuri Bharat Teja wrote:
> Initializing cq_context with ev_queue in create_cq(), leads to NULL pointer
> dereference in ib_uverbs_comp_handler(), if application doesnot use completion
>  channel. This patch fixes the cq_context initialization.
> 
> Fixes: 1e7710f3f65 ("IB/core: Change completion channel to use the reworked")
> Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Tested-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 2c98533a0203..50a6c64f0388 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -1015,7 +1015,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
>  	cq->uobject       = &obj->uobject;
>  	cq->comp_handler  = ib_uverbs_comp_handler;
>  	cq->event_handler = ib_uverbs_cq_event_handler;
> -	cq->cq_context    = &ev_file->ev_queue;
> +	cq->cq_context    = ev_file ? &ev_file->ev_queue : NULL;
>  	atomic_set(&cq->usecnt, 0);
>  
>  	obj->uobject.object = cq;
> -- 
> 2.5.3
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
