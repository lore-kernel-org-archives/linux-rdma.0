From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 07/17] verbs: Use kernel uapi names for
 identical structs
Date: Mon, 15 Jan 2018 18:48:06 +0200
Message-ID: <2f04c4d8-bc14-9293-2e03-b29074e08637@dev.mellanox.co.il>
References: <20180111221340.965-1-jgg@ziepe.ca>
 <20180111221340.965-8-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-8-jgg-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/12/2018 12:13 AM, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> And delete the duplicates from kern-abi.h
> 
> A script was made to find the trivially duplicate structs, which
> produced this sed script:
> 
> $ sed -i \
>   -e 's/struct[ \t]ibv_alloc_mw_resp\([ \t,]\)/struct ib_uverbs_alloc_mw_resp\1/g' \
>   -e 's/struct[ \t]ibv_alloc_pd_resp\([ \t,]\)/struct ib_uverbs_alloc_pd_resp\1/g' \
>   -e 's/struct[ \t]ibv_comp_event\([ \t,]\)/struct ib_uverbs_comp_event_desc\1/g' \
>   -e 's/struct[ \t]ibv_create_comp_channel_resp\([ \t,]\)/struct ib_uverbs_create_comp_channel_resp\1/g' \
>   -e 's/struct[ \t]ibv_create_cq_resp\([ \t,]\)/struct ib_uverbs_create_cq_resp\1/g' \
>   -e 's/struct[ \t]ibv_create_cq_resp_ex\([ \t,]\)/struct ib_uverbs_ex_create_cq_resp\1/g' \
>   -e 's/struct[ \t]ibv_create_flow_resp\([ \t,]\)/struct ib_uverbs_destroy_flow \1/g' \
>   -e 's/struct[ \t]ibv_create_qp_resp\([ \t,]\)/struct ib_uverbs_create_qp_resp\1/g' \
>   -e 's/struct[ \t]ibv_create_qp_resp_ex\([ \t,]\)/struct ib_uverbs_ex_create_qp_resp\1/g' \
>   -e 's/struct[ \t]ibv_create_rwq_ind_table_resp\([ \t,]\)/struct ib_uverbs_ex_create_rwq_ind_table_resp\1/g' \
>   -e 's/struct[ \t]ibv_create_srq_resp\([ \t,]\)/struct ib_uverbs_create_srq_resp\1/g' \
>   -e 's/struct[ \t]ibv_create_wq_resp\([ \t,]\)/struct ib_uverbs_ex_create_wq_resp\1/g' \
>   -e 's/struct[ \t]ibv_destroy_cq_resp\([ \t,]\)/struct ib_uverbs_destroy_cq_resp\1/g' \
>   -e 's/struct[ \t]ibv_destroy_qp_resp\([ \t,]\)/struct ib_uverbs_destroy_qp_resp\1/g' \
>   -e 's/struct[ \t]ibv_destroy_srq_resp\([ \t,]\)/struct ib_uverbs_destroy_qp_resp\1/g' \
>   -e 's/struct[ \t]ibv_destroy_wq_resp\([ \t,]\)/struct ib_uverbs_ex_destroy_wq_resp\1/g' \
>   -e 's/struct[ \t]ibv_get_context_resp\([ \t,]\)/struct ib_uverbs_get_context_resp\1/g' \
>   -e 's/struct[ \t]ibv_kern_ah_attr\([ \t,]\)/struct ib_uverbs_ah_attr\1/g' \
>   -e 's/struct[ \t]ibv_kern_async_event\([ \t,]\)/struct ib_uverbs_async_event_desc\1/g' \
>   -e 's/struct[ \t]ibv_kern_eth_filter\([ \t,]\)/struct ib_uverbs_flow_eth_filter\1/g' \
>   -e 's/struct[ \t]ibv_kern_flow_attr\([ \t,]\)/struct ib_uverbs_flow_attr\1/g' \
>   -e 's/struct[ \t]ibv_kern_global_route\([ \t,]\)/struct ib_uverbs_global_route\1/g' \
>   -e 's/struct[ \t]ibv_kern_ipv4_ext_filter\([ \t,]\)/struct ib_uverbs_flow_ipv4_filter\1/g' \
>   -e 's/struct[ \t]ibv_kern_ipv6_filter\([ \t,]\)/struct ib_uverbs_flow_ipv6_filter\1/g' \
>   -e 's/struct[ \t]ibv_kern_modify_cq_attr\([ \t,]\)/struct ib_uverbs_cq_moderation\1/g' \
>   -e 's/struct[ \t]ibv_kern_qp_attr\([ \t,]\)/struct ib_uverbs_qp_attr\1/g' \
>   -e 's/struct[ \t]ibv_kern_recv_wr\([ \t,]\)/struct ib_uverbs_recv_wr\1/g' \
>   -e 's/struct[ \t]ibv_kern_tcp_udp_filter\([ \t,]\)/struct ib_uverbs_flow_tcp_udp_filter\1/g' \
>   -e 's/struct[ \t]ibv_kern_tunnel_filter\([ \t,]\)/struct ib_uverbs_flow_tunnel_filter\1/g' \
>   -e 's/struct[ \t]ibv_modify_qp_resp_ex\([ \t,]\)/struct ib_uverbs_ex_modify_qp_resp\1/g' \
>   -e 's/struct[ \t]ibv_odp_caps_resp\([ \t,]\)/struct ib_uverbs_odp_caps\1/g' \
>   -e 's/struct[ \t]ibv_open_xrcd_resp\([ \t,]\)/struct ib_uverbs_close_xrcd\1/g' \
>   -e 's/struct[ \t]ibv_post_recv_resp\([ \t,]\)/struct ib_uverbs_post_send_resp\1/g' \
>   -e 's/struct[ \t]ibv_post_send_resp\([ \t,]\)/struct ib_uverbs_post_send_resp\1/g' \
>   -e 's/struct[ \t]ibv_post_srq_recv_resp\([ \t,]\)/struct ib_uverbs_post_recv_resp\1/g' \
>   -e 's/struct[ \t]ibv_qp_dest\([ \t,]\)/struct ib_uverbs_qp_dest\1/g' \
>   -e 's/struct[ \t]ibv_query_device_resp\([ \t,]\)/struct ib_uverbs_query_device_resp\1/g' \
>   -e 's/struct[ \t]ibv_query_port_resp\([ \t,]\)/struct ib_uverbs_query_port_resp\1/g' \
>   -e 's/struct[ \t]ibv_query_qp_resp\([ \t,]\)/struct ib_uverbs_query_qp_resp\1/g' \
>   -e 's/struct[ \t]ibv_query_srq_resp\([ \t,]\)/struct ib_uverbs_query_srq_resp\1/g' \
>   -e 's/struct[ \t]ibv_reg_mr_resp\([ \t,]\)/struct ib_uverbs_reg_mr_resp\1/g' \
>   -e 's/struct[ \t]ibv_rereg_mr_resp\([ \t,]\)/struct ib_uverbs_rereg_mr_resp\1/g' \
>   -e 's/struct[ \t]ibv_resize_cq_resp\([ \t,]\)/struct ib_uverbs_resize_cq_resp\1/g' \
>   -e 's/struct[ \t]ibv_rss_caps_resp\([ \t,]\)/struct ib_uverbs_rss_caps\1/g' \
>   -e 's/struct[ \t]ibv_tm_caps_resp\([ \t,]\)/struct ib_uverbs_tm_caps\1/g' \
>   `git ls-files`
> 
> Followed by hand checking and removing the changed structs from
> kern-abi.h and fixing the trivial residual compiler errors.
> 
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   libibcm/cm.c                          |   2 +-
>   libibverbs/cmd.c                      |  82 +++---
>   libibverbs/device.c                   |   2 +-
>   libibverbs/driver.h                   |  36 +--
>   libibverbs/kern-abi.h                 | 453 ++--------------------------------
>   libibverbs/marshall.c                 |   4 +-
>   libibverbs/marshall.h                 |   4 +-
>   libibverbs/verbs.c                    |   4 +-
>   librdmacm/cma.c                       |   2 +-
>   librdmacm/rdma_cma_abi.h              |   2 +-
>   providers/bnxt_re/bnxt_re-abi.h       |  10 +-
>   providers/cxgb3/iwch-abi.h            |  12 +-
>   providers/cxgb4/cxgb4-abi.h           |  10 +-
>   providers/cxgb4/verbs.c               |   4 +-
>   providers/hfi1verbs/hfi-abi.h         |  10 +-
>   providers/hfi1verbs/hfiverbs.c        |   2 +-
>   providers/hfi1verbs/verbs.c           |  12 +-
>   providers/hns/hns_roce_u_abi.h        |   6 +-
>   providers/hns/hns_roce_u_verbs.c      |   6 +-
>   providers/i40iw/i40iw-abi.h           |   8 +-
>   providers/i40iw/i40iw_uverbs.c        |   6 +-
>   providers/ipathverbs/ipath-abi.h      |  10 +-
>   providers/ipathverbs/ipathverbs.c     |   2 +-
>   providers/ipathverbs/verbs.c          |  12 +-
>   providers/mlx4/mlx4-abi.h             |  14 +-
>   providers/mlx4/verbs.c                |  18 +-
>   providers/mlx5/mlx5-abi.h             |  18 +-
>   providers/mlx5/verbs.c                |  10 +-
>   providers/mthca/mthca-abi.h           |   8 +-
>   providers/mthca/verbs.c               |   6 +-
>   providers/nes/nes-abi.h               |   8 +-
>   providers/nes/nes_uverbs.c            |   6 +-
>   providers/ocrdma/ocrdma_abi.h         |  12 +-
>   providers/ocrdma/ocrdma_verbs.c       |   2 +-
>   providers/qedr/qelr_abi.h             |  10 +-
>   providers/rxe/rxe-abi.h               |  10 +-
>   providers/rxe/rxe.c                   |   8 +-
>   providers/vmw_pvrdma/pvrdma-abi-fix.h |   8 +-
>   providers/vmw_pvrdma/qp.c             |   4 +-
>   providers/vmw_pvrdma/verbs.c          |   2 +-
>   40 files changed, 217 insertions(+), 628 deletions(-)
> 
> diff --git a/libibcm/cm.c b/libibcm/cm.c
> index 4fd3fdd6510a2f..ec9252673bdb5b 100644
> --- a/libibcm/cm.c
> +++ b/libibcm/cm.c
> @@ -335,7 +335,7 @@ int ib_cm_init_qp_attr(struct ib_cm_id *cm_id,
>   		       struct ibv_qp_attr *qp_attr,
>   		       int *qp_attr_mask)
>   {
> -	struct ibv_kern_qp_attr *resp;
> +	struct ib_uverbs_qp_attr *resp;
>   	struct ib_ucm_init_qp_attr *cmd;
>   	void *msg;
>   	int result;
> diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
> index fbd87d475a2751..a675bfb7d02fd3 100644
> --- a/libibverbs/cmd.c
> +++ b/libibverbs/cmd.c
> @@ -46,7 +46,7 @@
>   
>   int ibv_cmd_get_context(struct verbs_context *context_ex,
>   			struct ibv_get_context *cmd, size_t cmd_size,
> -			struct ibv_get_context_resp *resp, size_t resp_size)
> +			struct ib_uverbs_get_context_resp *resp, size_t resp_size)
>   {
>   	IBV_INIT_CMD_RESP(cmd, cmd_size, GET_CONTEXT, resp, resp_size);
>   
> @@ -62,7 +62,7 @@ int ibv_cmd_get_context(struct verbs_context *context_ex,
>   }
>   
>   static void copy_query_dev_fields(struct ibv_device_attr *device_attr,
> -				  struct ibv_query_device_resp *resp,
> +				  struct ib_uverbs_query_device_resp *resp,
>   				  uint64_t *raw_fw_ver)
>   {
>   	*raw_fw_ver				= resp->fw_ver;
> @@ -112,7 +112,7 @@ int ibv_cmd_query_device(struct ibv_context *context,
>   			 uint64_t *raw_fw_ver,
>   			 struct ibv_query_device *cmd, size_t cmd_size)
>   {
> -	struct ibv_query_device_resp resp;
> +	struct ib_uverbs_query_device_resp resp;
>   
>   	IBV_INIT_CMD_RESP(cmd, cmd_size, QUERY_DEVICE, &resp, sizeof resp);
>   
> @@ -269,7 +269,7 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
>   		       struct ibv_port_attr *port_attr,
>   		       struct ibv_query_port *cmd, size_t cmd_size)
>   {
> -	struct ibv_query_port_resp resp;
> +	struct ib_uverbs_query_port_resp resp;
>   
>   	IBV_INIT_CMD_RESP(cmd, cmd_size, QUERY_PORT, &resp, sizeof resp);
>   	cmd->port_num = port_num;
> @@ -306,7 +306,7 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
>   
>   int ibv_cmd_alloc_pd(struct ibv_context *context, struct ibv_pd *pd,
>   		     struct ibv_alloc_pd *cmd, size_t cmd_size,
> -		     struct ibv_alloc_pd_resp *resp, size_t resp_size)
> +		     struct ib_uverbs_alloc_pd_resp *resp, size_t resp_size)
>   {
>   	IBV_INIT_CMD_RESP(cmd, cmd_size, ALLOC_PD, resp, resp_size);
>   
> @@ -338,7 +338,7 @@ int ibv_cmd_open_xrcd(struct ibv_context *context, struct verbs_xrcd *xrcd,
>   		      int vxrcd_size,
>   		      struct ibv_xrcd_init_attr *attr,
>   		      struct ibv_open_xrcd *cmd, size_t cmd_size,
> -		      struct ibv_open_xrcd_resp *resp, size_t resp_size)
> +		      struct ib_uverbs_close_xrcd *resp, size_t resp_size)

This had to be ib_uverbs_open_xrcd_resp, correct ? need to fix in the 
drivers' code that uses this as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
