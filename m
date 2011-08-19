From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad: Fix build on win8
Date: Thu, 18 Aug 2011 18:00:40 -0700
Message-ID: <20110818180040.935b5caa.weiny2@llnl.gov>
References: <1828884A29C6694DAF28B7E6B8A8237316E4175C@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E4175C-Q3cL8pyY+6ukrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hal Rosenstock (hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org)" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "Leonid Keller (leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org)" <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 18 Aug 2011 09:46:49 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> The win8 compiler appears to be even more brain dead than its
> predecessor.  It complains of an uninitialized variable mad in
> rpc.c around line 213.  Fix this by removing the redirect
> variable and using while (1) / break instead.
> 
> Problem was reported by Leonid Keller <leonid-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
>  src/rpc.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/src/rpc.c b/src/rpc.c
> index d20c321..19a5a70 100644
> --- a/src/rpc.c
> +++ b/src/rpc.c
> @@ -213,13 +213,12 @@ void *mad_rpc(const struct ibmad_port *port, ib_rpc_t * rpc,
>  {
>  	int status, len;
>  	uint8_t sndbuf[1024], rcvbuf[1024], *mad;
> -	int redirect = 1;
>  	ib_rpc_v1_t *rpcv1 = (ib_rpc_v1_t *)rpc;
>  	int error = 0;
>  
>  	if ((rpc->mgtclass & IB_MAD_RPC_VERSION_MASK) == IB_MAD_RPC_VERSION1)
>  		rpcv1->error = 0;
> -	while (redirect) {
> +	do {
>  		len = 0;
>  		memset(sndbuf, 0, umad_size() + IB_MAD_SIZE);
>  
> @@ -247,10 +246,10 @@ void *mad_rpc(const struct ibmad_port *port, ib_rpc_t * rpc,
>  			/* update dport for next request and retry */
>  			/* bail if redirection fails */
>  			if (redirect_port(dport, mad))
> -				redirect = 0;
> +				break;
>  		} else
> -			redirect = 0;
> -	}
> +			break;
> +	} while (1);
>  
>  	if ((rpc->mgtclass & IB_MAD_RPC_VERSION_MASK) == IB_MAD_RPC_VERSION1)
>  		rpcv1->error = error;
> 
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
