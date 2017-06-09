From: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 04/13] xprtrdma: Rename rpcrdma_req::rl_free
Date: Fri, 9 Jun 2017 14:58:40 -0400
Message-ID: <7ee9b1fd-9628-2767-444e-90c6736d63f9@Netapp.com>
References: <20170608154339.18945.5500.stgit@manet.1015granger.net>
 <20170608155212.18945.37327.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170608155212.18945.37327.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

On 06/08/2017 11:52 AM, Chuck Lever wrote:
> Clean up: I'm about to use the rl_free field for purposes other than
> a free list. So use a more generic name.
> 
> This is a refactoring change only.
> 
> BugLink: https://bugzilla.linux-nfs.org/show_bug.cgi?id=305
> Fixes: 68791649a725 ('xprtrdma: Invalidate in the RPC reply ... ')
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/verbs.c     |    9 ++++-----
>  net/sunrpc/xprtrdma/xprt_rdma.h |    2 +-
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index a8be66d..df72224 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -971,7 +971,6 @@ struct rpcrdma_req *
>  	if (req == NULL)
>  		return ERR_PTR(-ENOMEM);
>  
> -	INIT_LIST_HEAD(&req->rl_free);

Does rl_list still need to get initialized somewhere?

Thanks,
Anna

>  	spin_lock(&buffer->rb_reqslock);
>  	list_add(&req->rl_all, &buffer->rb_allreqs);
>  	spin_unlock(&buffer->rb_reqslock);
> @@ -1055,7 +1054,7 @@ struct rpcrdma_rep *
>  			goto out;
>  		}
>  		req->rl_backchannel = false;
> -		list_add(&req->rl_free, &buf->rb_send_bufs);
> +		list_add(&req->rl_list, &buf->rb_send_bufs);
>  	}
>  
>  	INIT_LIST_HEAD(&buf->rb_recv_bufs);
> @@ -1084,8 +1083,8 @@ struct rpcrdma_rep *
>  	struct rpcrdma_req *req;
>  
>  	req = list_first_entry(&buf->rb_send_bufs,
> -			       struct rpcrdma_req, rl_free);
> -	list_del(&req->rl_free);
> +			       struct rpcrdma_req, rl_list);
> +	list_del(&req->rl_list);
>  	return req;
>  }
>  
> @@ -1268,7 +1267,7 @@ struct rpcrdma_req *
>  
>  	spin_lock(&buffers->rb_lock);
>  	buffers->rb_send_count--;
> -	list_add_tail(&req->rl_free, &buffers->rb_send_bufs);
> +	list_add_tail(&req->rl_list, &buffers->rb_send_bufs);
>  	if (rep) {
>  		buffers->rb_recv_count--;
>  		list_add_tail(&rep->rr_list, &buffers->rb_recv_bufs);
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
> index 1c23117..ad918c8 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -340,7 +340,7 @@ enum {
>  
>  struct rpcrdma_buffer;
>  struct rpcrdma_req {
> -	struct list_head	rl_free;
> +	struct list_head	rl_list;
>  	unsigned int		rl_mapped_sges;
>  	unsigned int		rl_connect_cookie;
>  	struct rpcrdma_buffer	*rl_buffer;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
