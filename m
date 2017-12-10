From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 6/8] verbs: Fill in the libibverbs.map file
Date: Sun, 10 Dec 2017 19:01:52 +0200
Message-ID: <38cbce8e-d177-b4eb-efec-c54951b1cb29@dev.mellanox.co.il>
References: <20171205231721.19410-1-jgg@ziepe.ca>
 <20171205231721.19410-7-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171205231721.19410-7-jgg-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/6/2017 1:17 AM, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Several of the 'latest' verbs are missing from the map file.

Which 'latest' verbs are you referring to ? quite hard to follow post 
the sort.

> The linker does the right thing anyhow since they are tagged with the
> .symver assembler directive, but let us list them anyhow so that the
> map file is a complete list of symbols.
> 

If the linker does the work why do we really need to maintain it now and 
in the future ?

> This also sorts the list
> 
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   libibverbs/libibverbs.map.in | 56 +++++++++++++++++++++++++++++++-------------
>   1 file changed, 40 insertions(+), 16 deletions(-)
> 
> diff --git a/libibverbs/libibverbs.map.in b/libibverbs/libibverbs.map.in
> index d65f06c43de992..3f635a94b82d58 100644
> --- a/libibverbs/libibverbs.map.in
> +++ b/libibverbs/libibverbs.map.in
> @@ -53,29 +53,53 @@ IBVERBS_1.0 {
>   
>   IBVERBS_1.1 {
>   	global:
> -		ibv_get_device_list;
> -		ibv_free_device_list;
> -		ibv_get_device_name;
> -		ibv_get_device_guid;
> -		ibv_open_device;
> +		ibv_ack_async_event;
> +		ibv_ack_cq_events;
> +		ibv_alloc_pd;
> +		ibv_attach_mcast;
>   		ibv_close_device;
> -
> -		ibv_init_ah_from_wc;
> +		ibv_create_ah;
>   		ibv_create_ah_from_wc;
> -		ibv_fork_init;
> -		ibv_dontfork_range;
> +		ibv_create_cq;
> +		ibv_create_qp;
> +		ibv_create_srq;
> +		ibv_dealloc_pd;
> +		ibv_dereg_mr;
> +		ibv_destroy_ah;
> +		ibv_destroy_cq;
> +		ibv_destroy_qp;
> +		ibv_destroy_srq;
> +		ibv_detach_mcast;
>   		ibv_dofork_range;
> -		ibv_register_driver;
> -
> +		ibv_dontfork_range;
> +		ibv_event_type_str;
> +		ibv_fork_init;
> +		ibv_free_device_list;
> +		ibv_get_async_event;
> +		ibv_get_cq_event;
> +		ibv_get_device_guid;
> +		ibv_get_device_list;
> +		ibv_get_device_name;
> +		ibv_init_ah_from_wc;
> +		ibv_modify_qp;
> +		ibv_modify_srq;
>   		ibv_node_type_str;
> +		ibv_open_device;
>   		ibv_port_state_str;
> -		ibv_event_type_str;
> -		ibv_wc_status_str;
> -
> +		ibv_query_device;
> +		ibv_query_gid;
> +		ibv_query_pkey;
> +		ibv_query_port;
> +		ibv_query_qp;
> +		ibv_query_srq;
>   		ibv_rate_to_mbps;
> -		mbps_to_ibv_rate;
> -
> +		ibv_reg_mr;
> +		ibv_register_driver;
> +		ibv_rereg_mr;
> +		ibv_resize_cq;
>   		ibv_resolve_eth_l2_from_gid;
> +		ibv_wc_status_str;
> +		mbps_to_ibv_rate;
>   
>   		/* These historical symbols are now private to libibverbs, but used by
>   		   other rdma-core libraries. Do not change them. */
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
