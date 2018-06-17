From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v2 09/20] IB/core: Improve
 uverbs_cleanup_ucontext algorithm
Date: Sun, 17 Jun 2018 13:51:06 -0600
Message-ID: <20180617195106.eai7iajx4y5w3ii6@mellanox.com>
References: <20180617100006.30663-1-leon@kernel.org>
 <20180617100006.30663-10-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180617100006.30663-10-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 17, 2018 at 12:59:55PM +0300, Leon Romanovsky wrote:

> +void uverbs_cleanup_ucontext(struct ib_ucontext *ucontext, bool device_removed)
> +{
>  	/*
>  	 * Waits for all remove_commit and alloc_commit to finish. Logically, We
>  	 * want to hold this forever as the context is going to be destroyed,
>  	 * but we'll release it since it causes a "held lock freed" BUG message.
>  	 */
>  	down_write(&ucontext->cleanup_rwsem);
> +	while (!list_empty(&ucontext->uobjects))
> +		if (__uverbs_cleanup_ucontext(ucontext, RDMA_REMOVE_DESTROY))
> +			/* No entry was cleaned-up successfully during this iteration */
> +			break;

No, this isn't right, it must remain REMOVE or CLOSE here. The enum is
a signal to the driver what is going on. DESTROY is only for user
triggered destroy called in a user context.

There needs to be some kind of guarenteed return from the driver that
destroy is failing due to elevated refcounts, and not some other
reason.. This is just checking for any ret?

> -	while (!list_empty(&ucontext->uobjects)) {
> -		struct ib_uobject *obj, *next_obj;
> -		unsigned int next_order = UINT_MAX;
> +	if (!list_empty(&ucontext->uobjects))
> +		__uverbs_cleanup_ucontext(ucontext, device_removed ?
> +			RDMA_REMOVE_DRIVER_REMOVE : RDMA_REMOVE_CLOSE);

Failure to cleanup is a driver bug, and should be reported with
WARN_ON. This is also mis using the remove enum, CLOSE is not a
'bigger hammer'

Jason
