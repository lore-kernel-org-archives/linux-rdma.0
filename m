From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 09/12] ehca: convert cpu notifier to return encapsulate
 errno value
Date: Mon, 29 Mar 2010 10:47:24 +0200
Message-ID: <20100329104724.48b23c09@alex-laptop>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
	<1268903124-10237-9-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1268903124-10237-9-git-send-email-akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 18 Mar 2010 18:05:21 +0900
Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> By the previous modification, the cpu notifier can return encapsulate
> errno value. This converts the cpu notifiers for ehca.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> Cc: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

> ---
>  drivers/infiniband/hw/ehca/ehca_irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
> index b2b6fea..31f3ee1 100644
> --- a/drivers/infiniband/hw/ehca/ehca_irq.c
> +++ b/drivers/infiniband/hw/ehca/ehca_irq.c
> @@ -845,7 +845,7 @@ static int __cpuinit comp_pool_callback(struct notifier_block *nfb,
>  		ehca_gen_dbg("CPU: %x (CPU_PREPARE)", cpu);
>  		if (!create_comp_task(pool, cpu)) {
>  			ehca_gen_err("Can't create comp_task for cpu: %x", cpu);
> -			return NOTIFY_BAD;
> +			return notifier_from_errno(-ENOMEM);
>  		}
>  		break;
>  	case CPU_UP_CANCELED:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
