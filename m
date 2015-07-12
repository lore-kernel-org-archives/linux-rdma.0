From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 05/12] xprtrdma: Account for RPC/RDMA header size when
 deciding to inline
Date: Sun, 12 Jul 2015 17:37:17 +0300
Message-ID: <55A27B9D.5010002@dev.mellanox.co.il>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
 <20150709204227.26247.51111.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709204227.26247.51111.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/9/2015 11:42 PM, Chuck Lever wrote:
> When marshaling RPC/RDMA requests, ensure the combined size of
> RPC/RDMA header and RPC header do not exceed the inline threshold.
> Endpoints typically reject RPC/RDMA messages that exceed the size
> of their receive buffers.

Did this solve a bug? because is seems like it does.
Maybe it will be a good idea to describe this bug.

>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   net/sunrpc/xprtrdma/rpc_rdma.c |   29 +++++++++++++++++++++++++++--
>   1 file changed, 27 insertions(+), 2 deletions(-)
>
> diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc=
_rdma.c
> index 84ea37d..8cf9402 100644
> --- a/net/sunrpc/xprtrdma/rpc_rdma.c
> +++ b/net/sunrpc/xprtrdma/rpc_rdma.c
> @@ -71,6 +71,31 @@ static const char transfertypes[][12] =3D {
>   };
>   #endif
>
> +/* The client can send a request inline as long as the RPCRDMA heade=
r
> + * plus the RPC call fit under the transport's inline limit. If the
> + * combined call message size exceeds that limit, the client must us=
e
> + * the read chunk list for this operation.
> + */
> +static bool rpcrdma_args_inline(struct rpc_rqst *rqst)

maybe static inline?

> +{
> +	unsigned int callsize =3D RPCRDMA_HDRLEN_MIN + rqst->rq_snd_buf.len=
;
> +
> +	return callsize <=3D RPCRDMA_INLINE_WRITE_THRESHOLD(rqst);
> +}
> +
> +/* The client can=E2=80=99t know how large the actual reply will be.=
 Thus it
> + * plans for the largest possible reply for that particular ULP
> + * operation. If the maximum combined reply message size exceeds tha=
t
> + * limit, the client must provide a write list or a reply chunk for
> + * this request.
> + */
> +static bool rpcrdma_results_inline(struct rpc_rqst *rqst)
> +{
> +	unsigned int repsize =3D RPCRDMA_HDRLEN_MIN + rqst->rq_rcv_buf.bufl=
en;
> +
> +	return repsize <=3D RPCRDMA_INLINE_READ_THRESHOLD(rqst);
> +}
> +
>   /*
>    * Chunk assembly from upper layer xdr_buf.
>    *
> @@ -418,7 +443,7 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
>   	 * a READ, then use write chunks to separate the file data
>   	 * into pages; otherwise use reply chunks.
>   	 */
> -	if (rqst->rq_rcv_buf.buflen <=3D RPCRDMA_INLINE_READ_THRESHOLD(rqst=
))
> +	if (rpcrdma_results_inline(rqst))
>   		wtype =3D rpcrdma_noch;
>   	else if (rqst->rq_rcv_buf.page_len =3D=3D 0)
>   		wtype =3D rpcrdma_replych;
> @@ -441,7 +466,7 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
>   	 * implies the op is a write.
>   	 * TBD check NFSv4 setacl
>   	 */
> -	if (rqst->rq_snd_buf.len <=3D RPCRDMA_INLINE_WRITE_THRESHOLD(rqst))
> +	if (rpcrdma_args_inline(rqst))
>   		rtype =3D rpcrdma_noch;
>   	else if (rqst->rq_snd_buf.page_len =3D=3D 0)
>   		rtype =3D rpcrdma_areadch;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
