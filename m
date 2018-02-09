From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [RFC PATCH rdma-core] Check that public headers support
 -Wpedantic
Date: Fri, 9 Feb 2018 10:46:27 -0800
Message-ID: <073d4608-cfe3-c40a-df76-648b1ae40318@wdc.com>
References: <20180209181410.GA15016@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209181410.GA15016-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Monjalon <thomasm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/09/18 10:14, Jason Gunthorpe wrote:
> +static inline struct verbs_context *_verbs_get_ctx_op(struct ibv_context *ctx,
> +						      size_t op_off)
> +{
> +	struct verbs_context *vctx = verbs_get_ctx(ctx);
> +	void *op;
> +	if (!vctx)
> +		return NULL;
> +
> +	if (vctx->sz < sizeof(*vctx) - op_off)
> +		return NULL;
> +
> +	op = *((void **)((uint8_t *)vctx) + op_off);

Something really minor: I think there are more parentheses in the above 
expression than strictly needed. Otherwise this patch looks fine to me.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
