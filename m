From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use boottime
Date: Sun, 31 Jan 2016 11:55:34 +0200
Message-ID: <20160131095534.GA30795@leon.nu>
References: <1454219752-23246-1-git-send-email-klock.android@gmail.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454219752-23246-1-git-send-email-klock.android-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Abhilash Jindal <klock.android-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 31, 2016 at 12:55:52AM -0500, Abhilash Jindal wrote:
> Wall time obtained from ktime_get_real_ns is susceptible to sudden jumps due to
> user setting the time or due to NTP.  Boot time is constantly increasing time
> better suited for comparing two timestamps.

Please add your Signed-of signature and resubmit it.
Thanks.

> ---
>  drivers/infiniband/hw/mlx4/alias_GUID.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
> index 21cb41a..c74ef26 100644
> --- a/drivers/infiniband/hw/mlx4/alias_GUID.c
> +++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
> @@ -310,7 +310,7 @@ static void aliasguid_query_handler(int status,
>  	if (status) {
>  		pr_debug("(port: %d) failed: status = %d\n",
>  			 cb_ctx->port, status);
> -		rec->time_to_run = ktime_get_real_ns() + 1 * NSEC_PER_SEC;
> +		rec->time_to_run = ktime_get_boot_ns() + 1 * NSEC_PER_SEC;
>  		goto out;
>  	}
>  
> @@ -416,7 +416,7 @@ next_entry:
>  			 be64_to_cpu((__force __be64)rec->guid_indexes),
>  			 be64_to_cpu((__force __be64)applied_guid_indexes),
>  			 be64_to_cpu((__force __be64)declined_guid_indexes));
> -		rec->time_to_run = ktime_get_real_ns() +
> +		rec->time_to_run = ktime_get_boot_ns() +
>  			resched_delay_sec * NSEC_PER_SEC;
>  	} else {
>  		rec->status = MLX4_GUID_INFO_STATUS_SET;
> @@ -708,7 +708,7 @@ static int get_low_record_time_index(struct mlx4_ib_dev *dev, u8 port,
>  		}
>  	}
>  	if (resched_delay_sec) {
> -		u64 curr_time = ktime_get_real_ns();
> +		u64 curr_time = ktime_get_boot_ns();
>  
>  		*resched_delay_sec = (low_record_time < curr_time) ? 0 :
>  			div_u64((low_record_time - curr_time), NSEC_PER_SEC);
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
