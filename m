From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next 7/8] IB/core: Change wc.slid from 16 to 32 bits
Date: Thu, 11 May 2017 08:42:47 -0400
Message-ID: <830cdb79-3274-4073-126a-a328e49254c6@dev.mellanox.co.il>
References: <1494458576-6816-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1494458576-6816-8-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494458576-6816-8-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/10/2017 7:22 PM, Dasaratharaman Chandramouli wrote:
> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> slid field in struct ib_wc is increased to 32 bits.
> This enables core components to use larger LIDs if needed.
> The user ABI is unchanged and return 16 bit values when queried.
> 
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/cm.c            |  4 ++--
>  drivers/infiniband/core/user_mad.c      |  2 +-
>  drivers/infiniband/core/uverbs_cmd.c    | 11 ++++++++---
>  drivers/infiniband/hw/hfi1/mad.c        |  2 +-
>  drivers/infiniband/hw/mlx4/mad.c        |  6 +++---
>  drivers/infiniband/hw/mlx5/mad.c        |  2 +-
>  drivers/infiniband/hw/mthca/mthca_cmd.c |  4 ++--
>  drivers/infiniband/hw/mthca/mthca_mad.c |  2 +-
>  drivers/infiniband/sw/rdmavt/cq.c       |  2 +-
>  include/rdma/ib_verbs.h                 |  2 +-
>  10 files changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> index 1844770..6b3b0be 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -1703,7 +1703,7 @@ static void cm_process_routed_req(struct cm_req_msg *req_msg, struct ib_wc *wc)
>  {
>  	if (!cm_req_get_primary_subnet_local(req_msg)) {
>  		if (req_msg->primary_local_lid == IB_LID_PERMISSIVE) {
> -			req_msg->primary_local_lid = cpu_to_be16(wc->slid);
> +			req_msg->primary_local_lid = cpu_to_be16((u16)wc->slid);
>  			cm_req_set_primary_sl(req_msg, wc->sl);
>  		}
>  
> @@ -1713,7 +1713,7 @@ static void cm_process_routed_req(struct cm_req_msg *req_msg, struct ib_wc *wc)
>  
>  	if (!cm_req_get_alt_subnet_local(req_msg)) {
>  		if (req_msg->alt_local_lid == IB_LID_PERMISSIVE) {
> -			req_msg->alt_local_lid = cpu_to_be16(wc->slid);
> +			req_msg->alt_local_lid = cpu_to_be16((u16)wc->slid);
>  			cm_req_set_alt_sl(req_msg, wc->sl);
>  		}
>  
> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
> index 200422d..8272d65 100644
> --- a/drivers/infiniband/core/user_mad.c
> +++ b/drivers/infiniband/core/user_mad.c
> @@ -229,7 +229,7 @@ static void recv_handler(struct ib_mad_agent *agent,
>  	packet->mad.hdr.status	   = 0;
>  	packet->mad.hdr.length	   = hdr_size(file) + mad_recv_wc->mad_len;
>  	packet->mad.hdr.qpn	   = cpu_to_be32(mad_recv_wc->wc->src_qp);
> -	packet->mad.hdr.lid	   = cpu_to_be16(mad_recv_wc->wc->slid);
> +	packet->mad.hdr.lid	   = cpu_to_be16((u16)mad_recv_wc->wc->slid);
>  	packet->mad.hdr.sl	   = mad_recv_wc->wc->sl;
>  	packet->mad.hdr.path_bits  = mad_recv_wc->wc->dlid_path_bits;
>  	packet->mad.hdr.pkey_index = mad_recv_wc->wc->pkey_index;
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
> index 6964c05..b08045f 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -1190,7 +1190,8 @@ ssize_t ib_uverbs_resize_cq(struct ib_uverbs_file *file,
>  	return ret ? ret : in_len;
>  }
>  
> -static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
> +static int copy_wc_to_user(struct ib_device *ib_dev, void __user *dest,
> +			   struct ib_wc *wc)
>  {
>  	struct ib_uverbs_wc tmp;
>  
> @@ -1204,7 +1205,11 @@ static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
>  	tmp.src_qp		= wc->src_qp;
>  	tmp.wc_flags		= wc->wc_flags;
>  	tmp.pkey_index		= wc->pkey_index;
> -	tmp.slid		= wc->slid;
> +	if (rdma_cap_opa_ah(ib_dev, wc->port_num))
> +		tmp.slid  = OPA_TO_IB_UCAST_LID(wc->slid);
> +	else
> +		tmp.slid  = (u16)wc->slid;
> +	tmp.slid		= (u16)wc->slid;

Is one line too many added here ?

-- Hal

>  	tmp.sl			= wc->sl;
>  	tmp.dlid_path_bits	= wc->dlid_path_bits;
>  	tmp.port_num		= wc->port_num;
> @@ -1248,7 +1253,7 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
>  		if (!ret)
>  			break;
>  
> -		ret = copy_wc_to_user(data_ptr, &wc);
> +		ret = copy_wc_to_user(ib_dev, data_ptr, &wc);
>  		if (ret)
>  			goto out_put;
>  
> diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
> index 5977673..345b40e 100644
> --- a/drivers/infiniband/hw/hfi1/mad.c
> +++ b/drivers/infiniband/hw/hfi1/mad.c
> @@ -3958,7 +3958,7 @@ static int opa_local_smp_check(struct hfi1_ibport *ibp,
>  			       const struct ib_wc *in_wc)
>  {
>  	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
> -	u16 slid = in_wc->slid;
> +	u16 slid = (u16)in_wc->slid;
>  	u16 pkey;
>  
>  	if (in_wc->pkey_index >= ARRAY_SIZE(ppd->pkeys))
> diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
> index cd5bfe1..27b0cd9 100644
> --- a/drivers/infiniband/hw/mlx4/mad.c
> +++ b/drivers/infiniband/hw/mlx4/mad.c
> @@ -169,7 +169,7 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
>  
>  		op_modifier |= 0x4;
>  
> -		in_modifier |= in_wc->slid << 16;
> +		in_modifier |= (u16)in_wc->slid << 16;
>  	}
>  
>  	err = mlx4_cmd_box(dev->dev, inmailbox->dma, outmailbox->dma, in_modifier,
> @@ -625,7 +625,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
>  		memcpy((char *)&tun_mad->hdr.slid_mac_47_32, &(wc->smac[4]), 2);
>  	} else {
>  		tun_mad->hdr.sl_vid = cpu_to_be16(((u16)(wc->sl)) << 12);
> -		tun_mad->hdr.slid_mac_47_32 = cpu_to_be16(wc->slid);
> +		tun_mad->hdr.slid_mac_47_32 = cpu_to_be16((u16)wc->slid);
>  	}
>  
>  	ib_dma_sync_single_for_device(&dev->ib_dev,
> @@ -826,7 +826,7 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
>  		}
>  	}
>  
> -	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
> +	slid = in_wc ? (u16)in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
>  
>  	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP && slid == 0) {
>  		forward_trap(to_mdev(ibdev), port_num, in_mad);
> diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
> index f1b56de6..e867f84 100644
> --- a/drivers/infiniband/hw/mlx5/mad.c
> +++ b/drivers/infiniband/hw/mlx5/mad.c
> @@ -78,7 +78,7 @@ static int process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
>  	u16 slid;
>  	int err;
>  
> -	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
> +	slid = in_wc ? (u16)in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
>  
>  	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP && slid == 0)
>  		return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED;
> diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
> index 9d83a53..507fa19 100644
> --- a/drivers/infiniband/hw/mthca/mthca_cmd.c
> +++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
> @@ -1921,7 +1921,7 @@ int mthca_MAD_IFC(struct mthca_dev *dev, int ignore_mkey, int ignore_bkey,
>  			(in_wc->wc_flags & IB_WC_GRH ? 0x80 : 0);
>  		MTHCA_PUT(inbox, val,               MAD_IFC_G_PATH_OFFSET);
>  
> -		MTHCA_PUT(inbox, in_wc->slid,       MAD_IFC_RLID_OFFSET);
> +		MTHCA_PUT(inbox, (u16)in_wc->slid,       MAD_IFC_RLID_OFFSET);
>  		MTHCA_PUT(inbox, in_wc->pkey_index, MAD_IFC_PKEY_OFFSET);
>  
>  		if (in_grh)
> @@ -1929,7 +1929,7 @@ int mthca_MAD_IFC(struct mthca_dev *dev, int ignore_mkey, int ignore_bkey,
>  
>  		op_modifier |= 0x4;
>  
> -		in_modifier |= in_wc->slid << 16;
> +		in_modifier |= (u16)in_wc->slid << 16;
>  	}
>  
>  	err = mthca_cmd_box(dev, inmailbox->dma, outmailbox->dma,
> diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
> index 617531f..e6911ee 100644
> --- a/drivers/infiniband/hw/mthca/mthca_mad.c
> +++ b/drivers/infiniband/hw/mthca/mthca_mad.c
> @@ -205,7 +205,7 @@ int mthca_process_mad(struct ib_device *ibdev,
>  		      u16 *out_mad_pkey_index)
>  {
>  	int err;
> -	u16 slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
> +	u16 slid = in_wc ? (u16)in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
>  	u16 prev_lid = 0;
>  	struct ib_port_attr pattr;
>  	const struct ib_mad *in_mad = (const struct ib_mad *)in;
> diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
> index 0ae2ff8..c1e4fc5 100644
> --- a/drivers/infiniband/sw/rdmavt/cq.c
> +++ b/drivers/infiniband/sw/rdmavt/cq.c
> @@ -107,7 +107,7 @@ void rvt_cq_enter(struct rvt_cq *cq, struct ib_wc *entry, bool solicited)
>  		wc->uqueue[head].src_qp = entry->src_qp;
>  		wc->uqueue[head].wc_flags = entry->wc_flags;
>  		wc->uqueue[head].pkey_index = entry->pkey_index;
> -		wc->uqueue[head].slid = entry->slid;
> +		wc->uqueue[head].slid = (u16)entry->slid;
>  		wc->uqueue[head].sl = entry->sl;
>  		wc->uqueue[head].dlid_path_bits = entry->dlid_path_bits;
>  		wc->uqueue[head].port_num = entry->port_num;
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index e161968..ad7cced 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -947,7 +947,7 @@ struct ib_wc {
>  	u32			src_qp;
>  	int			wc_flags;
>  	u16			pkey_index;
> -	u16			slid;
> +	u32			slid;
>  	u8			sl;
>  	u8			dlid_path_bits;
>  	u8			port_num;	/* valid only for DR SMPs on switches */
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
