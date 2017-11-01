From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [RFC] Registering non-contiguous memory
Date: Wed, 1 Nov 2017 10:56:25 -0600
Message-ID: <20171101165625.GE1030@ziepe.ca>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <DB5PR05MB1270529922F451A2CACF7AE9B95F0@DB5PR05MB1270.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB5PR05MB1270529922F451A2CACF7AE9B95F0-8IvNv+8VlcCeKfjjHlISstqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 01, 2017 at 11:11:42AM +0000, Alex Margolin wrote:

>  struct verbs_context {
>  	/*  "grows up" - new fields go here */
> +	struct ib_mw * (*alloc_mw_ex)(struct ibv_mw_alloc_attr
>  	*mw_alloc_attr);

This patch is full of weird little mistakes like the above, wouldn't
compile and doesn't really seem capture the proposed API.

We are now asking for complete rdma-core patches before talking about
merging new kernel uapi features. Please retry this RFC with the new
requirement.

This means a patch similar to the above, except functional, and all
the man pages and documentation.

The text in the cover letter should go into either into a man page or
a Documentation/ file.

For very complex uapis like this, an simple example usage is also
going to help.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
