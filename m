From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 6/7] xprtrdma: Add class for RDMA backwards direction
 transport
Date: Tue, 1 Dec 2015 08:38:18 -0500
Message-ID: <565DA2CA.5090507@talpey.com>
References: <20151130222141.13029.98664.stgit@klimt.1015granger.net>
 <20151130222513.13029.52447.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151130222513.13029.52447.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/30/2015 5:25 PM, Chuck Lever wrote:
> To support the server-side of an NFSv4.1 backchannel on RDMA
> connections, add a transport class that enables backward
> direction messages on an existing forward channel connection.
>

> +static void *
> +xprt_rdma_bc_allocate(struct rpc_task *task, size_t size)
> +{
> +	struct rpc_rqst *rqst = task->tk_rqstp;
> +	struct svc_rdma_op_ctxt *ctxt;
> +	struct svcxprt_rdma *rdma;
> +	struct svc_xprt *sxprt;
> +	struct page *page;
> +
> +	if (size > PAGE_SIZE) {
> +		WARN_ONCE(1, "failed to handle buffer allocation (size %zu)\n",
> +			  size);

You may want to add more context to that rather cryptic string, at
least the function name.

Also, it's not exactly "failed to handle", it's an invalid size. Why
would this ever happen? Why even log it?



> +static int
> +rpcrdma_bc_send_request(struct svcxprt_rdma *rdma, struct rpc_rqst *rqst)
> +{
...
> +
> +drop_connection:
> +	dprintk("Failed to send backchannel call\n");

Ditto on the prefix / function context.

And also...

> +	dprintk("%s: sending request with xid: %08x\n",
> +		__func__, be32_to_cpu(rqst->rq_xid));
...
> +	dprintk("RPC:       %s: xprt %p\n", __func__, xprt);

The format strings for many of the dprintk's are somewhat inconsistent.
Some start with "RPC", some with the function name, and some (in other
patches of this series) with "svcrdma". Confusing, and perhaps hard to
pick out of the log.


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
