From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH] IB/cma: Make the code easier to verify
Date: Fri, 10 Jun 2016 13:58:42 -0500
Message-ID: <022f01d1c34a$1b6eaf90$524c0eb0$@opengridcomputing.com>
References: <25a76a5c-dc56-3a75-cdf8-096f89b8e2df@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <25a76a5c-dc56-3a75-cdf8-096f89b8e2df-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Leon Romanovsky' <leon-2ukJVAZIZ/Y@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Static source code analysis tools like smatch cannot handle functions
> that lock or not lock a mutex depending on the value of the arguments.
> Hence inline the function cma_disable_callback(). Additionally, this
> patch realizes a small performance optimization by reducing the number of
> mutex_lock() and mutex_unlock() calls in the modified functions. With
> this patch applied smatch no longer complains about source file cma.c.
> Without this patch smatch reports the following for this source file:
> 
> drivers/infiniband/core/cma.c:1959: cma_req_handler() warn: inconsistent returns
> 'mutex:&listen_id->handler_mutex'.
>   Locked on:   line 1880
>                line 1959
>   Unlocked on: line 1941
> drivers/infiniband/core/cma.c:2112: iw_conn_req_handler() warn: inconsistent
> returns 'mutex:&listen_id->handler_mutex'.
>   Locked on:   line 2048
>   Unlocked on: line 2112
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Looks ok to me...

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
