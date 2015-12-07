From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] staging/rdma/hfi1: Add page lock limit check for
 SDMA requests
Date: Mon, 7 Dec 2015 11:49:46 +0300
Message-ID: <20151207084946.GD18797@mwanda>
References: <1449089787-7258-1-git-send-email-ira.weiny@intel.com>
 <1449089787-7258-6-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1449089787-7258-6-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 02, 2015 at 03:56:27PM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> -		for (i = tx->idx; i >= 0; i--) {
> -			if (tx->iovecs[i].flags & TXREQ_FLAGS_IOVEC_LAST_PKT)
> -				unpin_vector_pages(tx->iovecs[i].vec);
> +	/*
> +	 * If we have any io vectors associated with this txreq,
> +	 * check whether they need to be 'freed'. We can't free them
> +	 * here because the unpin function needs to be able to sleep.
> +	 */
> +	i = tx->idx;
> +	while (i)
> +		if (tx->iovecs[i--].flags & TXREQ_FLAGS_IOVEC_LAST_PKT) {
> +			defer = true;
> +			break;
>  		}


In the original code, we checked tx->iovecs[0].flags but now we skip
that one.  Going back to the original for loop is probably the right way
to fix this.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
