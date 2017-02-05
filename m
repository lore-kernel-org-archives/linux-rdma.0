From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Registering non-contiguous memory
Date: Sun, 5 Feb 2017 15:44:01 -0700
Message-ID: <20170205224401.GB26474@obsidianresearch.com>
References: <VI1PR05MB127817A311C332553E4391AFB9410@VI1PR05MB1278.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR05MB127817A311C332553E4391AFB9410-79XLn2atqDMOK6E67s+DINqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 05, 2017 at 04:46:04PM +0000, Alex Margolin wrote:

> +struct verbs_mw {
> +	struct ibv_mw		mw;
> +	uint32_t		comp_mask;
> +	uint32_t		lkey;
> +	uint32_t		descriptor_num;
> +};

Just as a general comment for all future patches - now that the
provider interface is private I don't want to see 'comp_mask' stuff in
driver.h


> @@ -1411,11 +1478,13 @@ enum verbs_context_mask {
>  	VERBS_CONTEXT_QP	= 1 << 2,
>  	VERBS_CONTEXT_CREATE_FLOW = 1 << 3,
>  	VERBS_CONTEXT_DESTROY_FLOW = 1 << 4,
> -	VERBS_CONTEXT_RESERVED	= 1 << 5
> +	VERBS_CONTEXT_ALLOC_MW	= 1 << 5,
> +	VERBS_CONTEXT_RESERVED	= 1 << 6
>  };

What is this reserved thing?

Don't forget man pages are required.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
