From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [rdma-core PATCH] srp_daemon: Don't create async_ev_thread if
 only run once
Date: Wed, 3 Jan 2018 11:27:27 +0100
Message-ID: <ea3fe465-cc3b-1db3-e274-8c13f976953c@suse.de>
References: <20171219190958.3189-1-honli@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171219190958.3189-1-honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, "stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org" <stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Le 19/12/2017 à 20:09, Honggang LI a écrit :
> From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> fd3005f0cd34 moves the signal handler setup from ibsrpdm path. So,
> default signal handler will be used when the main pthread send signal
> SIGINT to pthread async_ev_thread. ibsrpdm will exit with non-zero
> exit code as default signal handler killed it. ibsrpdm should return
> with exit code zero, if no error emerged.
>
> We should not create async_ev_thread for ibsrpdm.
>
> Fixes: fd3005f0cd34 ("srp_daemon: Move the setup of the wakeup_pipe after openlog")
> Reviewed-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  srp_daemon/srp_daemon.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
> index cec36db2..4012a7db 100644
> --- a/srp_daemon/srp_daemon.c
> +++ b/srp_daemon/srp_daemon.c
> @@ -1945,12 +1945,12 @@ static struct resources *alloc_res(void)
>  				     run_thread_get_trap_notices, &res->res);
>  		if (ret)
>  			goto err;
> -	}
>  
> -	ret = pthread_create(&res->res.async_ev_thread, NULL,
> -			     run_thread_listen_to_events, &res->res);
> -	if (ret)
> -		goto err;
> +		ret = pthread_create(&res->res.async_ev_thread, NULL,
> +				     run_thread_listen_to_events, &res->res);
> +		if (ret)
> +			goto err;
> +	}
>  
>  	if (config->retry_timeout && !config->once) {
>  		ret = pthread_create(&res->res.reconnect_thread, NULL,
Reviewed-by: Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
Note: I will backport this to stable-v1[56] branches once its in master
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
