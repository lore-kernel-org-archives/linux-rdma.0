From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 12/16] ib_srpt: fix error return code
Date: Sun, 5 Apr 2015 18:27:14 +0200
Message-ID: <55216262.7000601@sandisk.com>
References: <1428235596-4757-1-git-send-email-Julia.Lawall@lip6.fr>
 <1428235596-4757-13-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428235596-4757-13-git-send-email-Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/05/15 14:06, Julia Lawall wrote:
> Return a negative error code on failure.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> identifier ret; expression e1,e2;
> @@
> (
> if (\(ret < 0\|ret != 0\))
>   { ... return ret; }
> |
> ret = 0
> )
> ... when != ret = e1
>      when != &ret
> *if(...)
> {
>    ... when != ret = e2
>        when forall
>   return ret;
> }
> // </smpl>
>
> In the first case, the printk is changed to use the ret value, rather
> than duplicating PTR_ERR(ch->thread).  This requires changing the format
> from %ld to %d, to account for the type of ret.
>
> Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
>
> ---
>   drivers/infiniband/ulp/srpt/ib_srpt.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 6e0a477..5ec98f5 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2143,8 +2143,8 @@ retry:
>
>   	ch->thread = kthread_run(srpt_compl_thread, ch, "ib_srpt_compl");
>   	if (IS_ERR(ch->thread)) {
> -		printk(KERN_ERR "failed to create kernel thread %ld\n",
> -		       PTR_ERR(ch->thread));
> +		ret = PTR_ERR(ch->thread);
> +		printk(KERN_ERR "failed to create kernel thread %d\n", ret);
>   		ch->thread = NULL;
>   		goto err_destroy_qp;
>   	}
> @@ -2590,6 +2590,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
>   		       " configured yet for initiator %s.\n", ch->sess_name);
>   		rej->reason = __constant_cpu_to_be32(
>   				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
> +		ret = -EINVAL;
>   		goto destroy_ib;
>   	}
>
> @@ -2598,6 +2599,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
>   		rej->reason = __constant_cpu_to_be32(
>   				SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
>   		pr_debug("Failed to create session\n");
> +		ret = PTR_ERR(ch->sess);
>   		goto deregister_session;
>   	}
>   	ch->sess->se_node_acl = &nacl->nacl;

This is not the proper way to fix srpt_cm_req_recv(). The kthread_run() 
call must be moved from srpt_create_ch_ib() to after the session 
registration code in srpt_cm_req_recv(), and the session registration 
call + the kthread_run() call must be protected via a mutex against 
concurrent HCA hot-plug removal events (see also srpt_remove_one() and 
srpt_remove_sdev()).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
