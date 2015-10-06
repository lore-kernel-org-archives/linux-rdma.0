From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc v1] xprtrdma: Don't require LOCAL_DMA_LKEY support
 for fasterg
Date: Tue, 6 Oct 2015 13:25:24 -0400
Message-ID: <56140404.1010809@Netapp.com>
References: <1444150357-2362-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444150357-2362-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

On 10/06/2015 12:52 PM, Sagi Grimberg wrote:
> There is no need to require LOCAL_DMA_LKEY support as the
> PD allocation makes sure that there is a local_dma_lkey. Also
> correctly set a return value in error path.
> 
> This caused a NULL pointer dereference in mlx5 which removed
> the support for LOCAL_DMA_LKEY.

Looks good to me!  This is another patch going directly to an RDMA tree somewhere, right?

Anna

> 
> Fixes: bb6c96d72879 ("xprtrdma: Replace global lkey with lkey local to PD")
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> Changes from v0:
> - Added error path rc assignment.
> 
>  net/sunrpc/xprtrdma/verbs.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
> index eb081ad..81e8d31 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -543,11 +543,8 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
>  	}
>  
>  	if (memreg == RPCRDMA_FRMR) {
> -		/* Requires both frmr reg and local dma lkey */
> -		if (((devattr->device_cap_flags &
> -		     (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) !=
> -		    (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) ||
> -		      (devattr->max_fast_reg_page_list_len == 0)) {
> +		if (!(devattr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) ||
> +		    (devattr->max_fast_reg_page_list_len == 0)) {
>  			dprintk("RPC:       %s: FRMR registration "
>  				"not supported by HCA\n", __func__);
>  			memreg = RPCRDMA_MTHCAFMR;
> @@ -557,6 +554,7 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struct sockaddr *addr, int memreg)
>  		if (!ia->ri_device->alloc_fmr) {
>  			dprintk("RPC:       %s: MTHCAFMR registration "
>  				"not supported by HCA\n", __func__);
> +			rc = -EINVAL;
>  			goto out3;
>  		}
>  	}
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
