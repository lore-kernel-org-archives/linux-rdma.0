From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [Patch] iser: free ib connection resources in the proper place
Date: Thu, 1 Mar 2012 19:35:40 +0200
Message-ID: <4F4FB36C.9080008@mellanox.com>
References: <35056e0cff3c2ea514095edf5445b9c7fd2fd631.1330198520.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35056e0cff3c2ea514095edf5445b9c7fd2fd631.1330198520.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/25/2012 9:36 PM, Doug Ledford wrote:
>
> @@ -274,6 +274,18 @@ static int iser_free_ib_conn_res(struct iser_conn *ib_conn, int can_destroy_id)
>   	ib_conn->cma_id   = NULL;
>   	kfree(ib_conn->page_vec);
>
> +	if (ib_conn->login_buf) {
> +		if (ib_conn->login_req_dma)
> +			ib_dma_unmap_single(device->ib_device,
> +				ib_conn->login_req_dma,
> +				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
>
Doug, this failed to build against 3.3-rc5, I will fix and repost with 
you being the author

Or.

> CC [M]  drivers/infiniband/ulp/iser/iser_verbs.o
> drivers/infiniband/ulp/iser/iser_verbs.c: In function 
> iser_free_ib_conn_res:
> drivers/infiniband/ulp/iser/iser_verbs.c:279: error: device undeclared 
> (first use in this function)
> drivers/infiniband/ulp/iser/iser_verbs.c:279: error: (Each undeclared 
> identifier is reported only once
> drivers/infiniband/ulp/iser/iser_verbs.c:279: error: for each function 
> it appears in.)



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
