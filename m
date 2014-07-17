From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [for-next 2/2] xprtrdma: fix deallocation sequence of pd
Date: Thu, 17 Jul 2014 10:05:49 -0500
Message-ID: <53C7E64D.90501@opengridcomputing.com>
References: <1405605697-11583-1-git-send-email-devesh.sharma@emulex.com> <3fdcf67f-2e90-4c61-92da-a8f7743cf54a@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3fdcf67f-2e90-4c61-92da-a8f7743cf54a-3RiH6ntJJkOPfaB/Gd0HpljyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/17/2014 9:01 AM, Devesh Sharma wrote:
> xprtrdma tries to destroy pd after destruction of cm_id. However,
> pd should be deallocated before destruction of cm_id.

Why?

I think you really mean that the pd dealloc needs to be done before the 
module deref that you added in the first patch.  But let us see what 
Roland says about how device removal is supposed to be handled when 
kernel applications are using the device...



> Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>   net/sunrpc/xprtrdma/verbs.c |   22 +++++++++++++---------
>   1 files changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index b00e55e..096e94b 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -544,7 +544,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
>   	if (rc) {
>   		dprintk("RPC:       %s: ib_query_device failed %d\n",
>   			__func__, rc);
> -		goto out2;
> +		goto out3;
>   	}
>   
>   	if (devattr.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY) {
> @@ -602,14 +602,14 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
>   				"phys register failed with %lX\n",
>   				__func__, PTR_ERR(ia->ri_bind_mem));
>   			rc = -ENOMEM;
> -			goto out2;
> +			goto out3;
>   		}
>   		break;
>   	default:
>   		printk(KERN_ERR "RPC: Unsupported memory "
>   				"registration mode: %d\n", memreg);
>   		rc = -ENOMEM;
> -		goto out2;
> +		goto out3;
>   	}
>   	dprintk("RPC:       %s: memory registration strategy is %d\n",
>   		__func__, memreg);
> @@ -619,6 +619,9 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
>   
>   	rwlock_init(&ia->ri_qplock);
>   	return 0;
> +out3:
> +	ib_dealloc_pd(ia->ri_pd);
> +	ia->ri_pd = NULL;
>   out2:
>   	module_put(ia->ri_id->device->owner);
>   	rdma_destroy_id(ia->ri_id);
> @@ -643,19 +646,20 @@ rpcrdma_ia_close(struct rpcrdma_ia *ia)
>   		dprintk("RPC:       %s: ib_dereg_mr returned %i\n",
>   			__func__, rc);
>   	}
> +
>   	if (ia->ri_id != NULL && !IS_ERR(ia->ri_id)) {
>   		if (ia->ri_id->qp)
>   			rdma_destroy_qp(ia->ri_id);
> +
> +		if (ia->ri_pd != NULL && !IS_ERR(ia->ri_pd)) {
> +			rc = ib_dealloc_pd(ia->ri_pd);
> +			dprintk("RPC:       %s: ib_dealloc_pd returned %i\n",
> +				__func__, rc);
> +		}
>   		module_put(ia->ri_id->device->owner);
>   		rdma_destroy_id(ia->ri_id);
>   		ia->ri_id = NULL;
>   	}
> -
> -	if (ia->ri_pd != NULL && !IS_ERR(ia->ri_pd)) {
> -		rc = ib_dealloc_pd(ia->ri_pd);
> -		dprintk("RPC:       %s: ib_dealloc_pd returned %i\n",
> -			__func__, rc);
> -	}
>   }
>   
>   /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
