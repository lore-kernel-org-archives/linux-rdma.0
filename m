From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V2 8/8] RDMA/mlx5: Add mlx5 initial support of the new
 infrastructure
Date: Wed, 20 Jul 2016 11:39:27 -0600
Message-ID: <20160720173927.GH21460@obsidianresearch.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-9-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468941812-32286-9-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2016 at 06:23:32PM +0300, Matan Barak wrote:
> +DECLARE_UVERBS_TYPE(
> +	mlx5_device,
> +	UVERBS_CTX_ACTION(
> +		DEVICE_ALLOC_CONTEXT, uverbs_get_context, NULL,
> +		&uverbs_get_context_spec,
> +		&UVERBS_ATTR_CHAIN_SPEC(
> +			/*
> +			 * Declared with size 0 as we current provide
> +			 * backward compatibility (0 = variable size)
> +			 */
> +			UVERBS_ATTR_PTR_IN(ALLOC_UCONTEXT_IN, 0),
> +			UVERBS_ATTR_PTR_OUT(ALLOC_UCONTEXT_OUT, 0),
> +			),
> +	),
> +	UVERBS_ACTION(
> +		DEVICE_QUERY, uverbs_query_device_handler, NULL,
> +		&uverbs_query_device_spec,
> +	),
> +);

The entire point of getting rid of the lists and changing the destruct
ordering was to avoid the need to have this kind of stuff in the
drivers.

I really don't want to see driver changes to implement the basic
API..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
