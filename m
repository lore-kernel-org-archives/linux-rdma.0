From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] nes: handling failed allocation when creating workqueue
Date: Thu, 18 Feb 2016 06:59:05 +0200
Message-ID: <20160218045905.GF30450@leon.nu>
References: <1455732393-11029-1-git-send-email-wuninsu@gmail.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1455732393-11029-1-git-send-email-wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, taesoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, yeongjin.jang-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, insu-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org, changwoo-/4noJB3qBVQ3uPMLIKxrzw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Please see my minor comments below.
Reviewed-by: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>

On Wed, Feb 17, 2016 at 01:06:33PM -0500, Insu Yun wrote:
> Since create_singlethread_workqueue uses kzalloc internally, 
> it can be failed in memory pressure, so need to handle it.

s/can be failed/can fail/

> 
> Signed-off-by: Insu Yun <wuninsu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/nes/nes_cm.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
> index cb9f0f2..23afad6 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.c
> +++ b/drivers/infiniband/hw/nes/nes_cm.c
> @@ -2833,7 +2833,7 @@ static struct nes_cm_core *nes_cm_alloc_core(void)
>  	/* alloc top level core control structure */
>  	cm_core = kzalloc(sizeof(*cm_core), GFP_KERNEL);
>  	if (!cm_core)
> -		return NULL;
> +		goto enomem_3;

IMHO, there is no need to define goto label for one return.

>  
>  	INIT_LIST_HEAD(&cm_core->connected_nodes);
>  	init_timer(&cm_core->tcp_timer);
> @@ -2856,12 +2856,23 @@ static struct nes_cm_core *nes_cm_alloc_core(void)
>  
>  	nes_debug(NES_DBG_CM, "Enable QUEUE EVENTS\n");
>  	cm_core->event_wq = create_singlethread_workqueue("nesewq");
> +	if (!cm_core->event_wq)
> +		goto enomem_2;
>  	cm_core->post_event = nes_cm_post_event;
>  	nes_debug(NES_DBG_CM, "Enable QUEUE DISCONNECTS\n");
>  	cm_core->disconn_wq = create_singlethread_workqueue("nesdwq");
> +	if (!cm_core->disconn_wq)
> +		goto enomem_1;
>  
>  	print_core(cm_core);
>  	return cm_core;
> +
> +enomem_1:
> +	destroy_workqueue(cm_core->event_wq);
> +enomem_2:
> +	kfree(cm_core);
> +enomem_3:
> +	return NULL;
>  }
>  
>  
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
