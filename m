From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 2/7] svcrdma: Clean up RPC-over-RDMA Reply header
 encoder
Date: Wed, 1 Feb 2017 10:25:18 -0800
Message-ID: <20170201182518.GA32532@infradead.org>
References: <20170131184623.14185.35480.stgit@klimt.1015granger.net>
 <20170131185302.14185.10775.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170131185302.14185.10775.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm always confused when a cleanup adds more line than it removes,
but it seems to be just comments in this case and some other
patches in the series.

> + * svc_rdma_xdr_encode_reply_header - Encode Reply's fixed header fields
> + * @rdma: controlling transport
> + * @rdma_argp: Call's transport header
> + * @rdma_resp: Reply's transport header
> + * @rdma_type: procedure number
> + *
> + */
> +void svc_rdma_xdr_encode_reply_header(struct svcxprt_rdma *rdma,
> +				      __be32 *rdma_argp, __be32 *rdma_resp,
> +				      __be32 rdma_type)

To me it would seem much cleaner to just take the few lines of encoding
into the only caller.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
