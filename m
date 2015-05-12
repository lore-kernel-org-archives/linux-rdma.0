From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 02/16] xprtrdma: Warn when there are orphaned IB objects
Date: Tue, 12 May 2015 14:14:00 -0400
Message-ID: <555242E8.4050007@Netapp.com>
References: <20150511174401.31263.79596.stgit@manet.1015granger.net> <20150511180235.31263.71754.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150511180235.31263.71754.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

On 05/11/2015 02:02 PM, Chuck Lever wrote:
> WARN during transport destruction if ib_dealloc_pd() fails. This is
> a sign that xprtrdma orphaned one or more RDMA API objects at some
> point, which can pin lower layer kernel modules and cause shutdown
> to hang.

I'm curious, what would cause the API objects to get orphaned in the first place?  Is there any way to prevent it?

Anna

> 
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
> ---
>  net/sunrpc/xprtrdma/verbs.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index 4870d27..51900e6 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -702,17 +702,17 @@ rpcrdma_ia_close(struct rpcrdma_ia *ia)
>  		dprintk("RPC:       %s: ib_dereg_mr returned %i\n",
>  			__func__, rc);
>  	}
> +
>  	if (ia->ri_id != NULL && !IS_ERR(ia->ri_id)) {
>  		if (ia->ri_id->qp)
>  			rdma_destroy_qp(ia->ri_id);
>  		rdma_destroy_id(ia->ri_id);
>  		ia->ri_id = NULL;
>  	}
> -	if (ia->ri_pd != NULL && !IS_ERR(ia->ri_pd)) {
> -		rc = ib_dealloc_pd(ia->ri_pd);
> -		dprintk("RPC:       %s: ib_dealloc_pd returned %i\n",
> -			__func__, rc);
> -	}
> +
> +	/* If the pd is still busy, xprtrdma missed freeing a resource */
> +	if (ia->ri_pd && !IS_ERR(ia->ri_pd))
> +		WARN_ON(ib_dealloc_pd(ia->ri_pd));
>  }
>  
>  /*
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
