From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] iser-target: fix error return code in
 isert_create_device_ib_res()
Date: Mon, 2 Dec 2013 15:00:14 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1312021459400.24931@pobox.suse.cz>
References: <CAPgLHd8eEFhMyfieCULgj+OzCRrTMN9G60pAvTP0+zOhBeK=qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPgLHd8eEFhMyfieCULgj+OzCRrTMN9G60pAvTP0+zOhBeK=qw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 29 Oct 2013, Wei Yongjun wrote:

> From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

This one has been sitting in my queue for quite some time, but I'd like 
the actual infiniband maintainers to be acted upon by.

Roland, please?

> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 6df2350..2ba71c0 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -263,21 +263,29 @@ isert_create_device_ib_res(struct isert_device *device)
>  						isert_cq_event_callback,
>  						(void *)&cq_desc[i],
>  						ISER_MAX_RX_CQ_LEN, i);
> -		if (IS_ERR(device->dev_rx_cq[i]))
> +		if (IS_ERR(device->dev_rx_cq[i])) {
> +			ret = PTR_ERR(device->dev_rx_cq[i]);
> +			device->dev_rx_cq[i] = NULL;
>  			goto out_cq;
> +		}
>  
>  		device->dev_tx_cq[i] = ib_create_cq(device->ib_device,
>  						isert_cq_tx_callback,
>  						isert_cq_event_callback,
>  						(void *)&cq_desc[i],
>  						ISER_MAX_TX_CQ_LEN, i);
> -		if (IS_ERR(device->dev_tx_cq[i]))
> +		if (IS_ERR(device->dev_tx_cq[i])) {
> +			ret = PTR_ERR(device->dev_tx_cq[i]);
> +			device->dev_tx_cq[i] = NULL;
>  			goto out_cq;
> +		}
>  
> -		if (ib_req_notify_cq(device->dev_rx_cq[i], IB_CQ_NEXT_COMP))
> +		ret = ib_req_notify_cq(device->dev_rx_cq[i], IB_CQ_NEXT_COMP);
> +		if (ret)
>  			goto out_cq;
>  
> -		if (ib_req_notify_cq(device->dev_tx_cq[i], IB_CQ_NEXT_COMP))
> +		ret = ib_req_notify_cq(device->dev_tx_cq[i], IB_CQ_NEXT_COMP);
> +		if (ret)
>  			goto out_cq;
>  	}
>  
> 

-- 
Jiri Kosina
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
