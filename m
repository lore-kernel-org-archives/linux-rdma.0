From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibmad/src/rpc.c: Remove superfluous packet dump
Date: Fri, 9 Jan 2015 23:27:03 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CBF09D5@CRSMSX101.amr.corp.intel.com>
References: <1419016100.20566.155.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1419016100.20566.155.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Any reason this should not be removed from mad_rpc_rmpp as well?

Ira


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Albert Chu
> Sent: Friday, December 19, 2014 11:08 AM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH] libibmad/src/rpc.c: Remove superfluous packet dump
> 
> When idebug == 1, mad_rpc outputs only the mad data response in debug
> output.  It does not output the request mad data.  This is confusing since it's not
> clear if it's request or response output.
> 
> When idebug > 1, full mad send and receive buffers are output, which makes
> the mad data output with idebug == 1 superfluous.  Remove it to remove
> confusion.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---
>  src/rpc.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/src/rpc.c b/src/rpc.c
> index 8d961f2..202fac5 100644
> --- a/src/rpc.c
> +++ b/src/rpc.c
> @@ -272,11 +272,6 @@ void *mad_rpc(const struct ibmad_port *port,
> ib_rpc_t * rpc,
>  		return NULL;
>  	}
> 
> -	if (ibdebug) {
> -		IBWARN("data offs %d sz %d", rpc->dataoffs, rpc->datasz);
> -		xdump(stderr, "mad data\n", mad + rpc->dataoffs, rpc-
> >datasz);
> -	}
> -
>  	if (rcvdata)
>  		memcpy(rcvdata, mad + rpc->dataoffs, rpc->datasz);
> 
> --
> 1.7.1
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
