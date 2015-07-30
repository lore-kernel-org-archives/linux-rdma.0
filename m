From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 20/22] IB/iser: Support up to 8MB data transfer in a
 single command
Date: Thu, 30 Jul 2015 10:12:54 -0500
Message-ID: <55BA3EF6.6080800@opengridcomputing.com>
References: <1438243595-32288-1-git-send-email-sagig@mellanox.com>
 <1438243595-32288-21-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438243595-32288-21-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/30/2015 3:06 AM, Sagi Grimberg wrote:
> iser support up to 512KB data transfer in a single scsi
> command. In order to support up to 8MB, iser needs to pre-allocate
> larger memory regions and larger page vectors.
>
> Given that a few target implementations don't support data transfers
> of more than 512KB by default and the fact that larger IO sizes require
> more resources, we introduce a module parameter to determine the
> maximum number of 512B sectors in a single scsi command.
> Users that are interested in larger transfers can change this value given
> that the target supports larger transfers.
>
> IO operations that consists of N pages will need a page vector
> of size N+1 in case the first SG element contains an offset. Given
> that some devices allocates memory regions in powers of 2, this
> means that allocating a region with N+1 pages, will result in
> region resources allocation of the next power of 2. Since we don't
> want that to happen, in case we are in the limit of IO size supported
> and the first SG element has an offset, we align the SG list using a
> bounce buffer (which is OK given that this is not likely to happen a lot).
>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c     | 19 ++++++++-----------
>   drivers/infiniband/ulp/iser/iscsi_iser.h     | 14 ++++++++++++--
>   drivers/infiniband/ulp/iser/iser_initiator.c |  2 +-
>   drivers/infiniband/ulp/iser/iser_memory.c    | 14 ++++++++++++--
>   drivers/infiniband/ulp/iser/iser_verbs.c     | 27 +++++++++++++++++++++++++++
>   5 files changed, 60 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index e3cea61..9eeefc8 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -93,6 +93,10 @@ static unsigned int iscsi_max_lun = 512;
>   module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
>   MODULE_PARM_DESC(max_lun, "Max LUNs to allow per session (default:512");
>   
> +unsigned int iser_max_sectors = ISER_DEF_MAX_SECTORS;
> +module_param_named(max_sectors, iser_max_sectors, uint, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(max_sectors, "Max number of sectors in a single scsi command (default:1024");
> +
>   bool iser_pi_enable = false;
>   module_param_named(pi_enable, iser_pi_enable, bool, S_IRUGO);
>   MODULE_PARM_DESC(pi_enable, "Enable T10-PI offload support (default:disabled)");
> @@ -625,6 +629,8 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>   	if (ep) {
>   		iser_conn = ep->dd_data;
>   		max_cmds = iser_conn->max_cmds;
> +		shost->sg_tablesize = iser_conn->scsi_sg_tablesize;
> +		shost->max_sectors = iser_conn->scsi_max_sectors;
>   
>   		mutex_lock(&iser_conn->state_mutex);
>   		if (iser_conn->state != ISER_CONN_UP) {
> @@ -643,15 +649,6 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>   						   SHOST_DIX_GUARD_CRC);
>   		}
>   
> -		/*
> -		 * Limit the sg_tablesize and max_sectors based on the device
> -		 * max fastreg page list length.
> -		 */
> -		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
> -			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
> -		shost->max_sectors = min_t(unsigned int,
> -			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
> -
>   		if (iscsi_host_add(shost,
>   				   ib_conn->device->ib_device->dma_device)) {
>   			mutex_unlock(&iser_conn->state_mutex);
> @@ -966,8 +963,8 @@ static struct scsi_host_template iscsi_iser_sht = {
>   	.name                   = "iSCSI Initiator over iSER",
>   	.queuecommand           = iscsi_queuecommand,
>   	.change_queue_depth	= scsi_change_queue_depth,
> -	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
> -	.max_sectors		= 1024,
> +	.sg_tablesize           = ISCSI_ISER_DEF_SG_TABLESIZE,
> +	.max_sectors            = ISER_DEF_MAX_SECTORS,
>   	.cmd_per_lun            = ISER_DEF_CMD_PER_LUN,
>   	.eh_abort_handler       = iscsi_eh_abort,
>   	.eh_device_reset_handler= iscsi_eh_device_reset,
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
> index e9ebe0b..8a32e20 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.h
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
> @@ -98,8 +98,13 @@
>   #define SHIFT_4K	12
>   #define SIZE_4K	(1ULL << SHIFT_4K)
>   #define MASK_4K	(~(SIZE_4K-1))
> -					/* support up to 512KB in one RDMA */
> -#define ISCSI_ISER_SG_TABLESIZE         (0x80000 >> SHIFT_4K)
> +
> +/* Default support is 512KB I/O size */
> +#define ISER_DEF_MAX_SECTORS		1024
> +#define ISCSI_ISER_DEF_SG_TABLESIZE	((ISER_DEF_MAX_SECTORS * 512) >> SHIFT_4K)
> +/* Maximum support is 8MB I/O size */
> +#define ISCSI_ISER_MAX_SG_TABLESIZE	(16384 * 512 >> SHIFT_4K)
> +
>   #define ISER_DEF_XMIT_CMDS_DEFAULT		512
>   #if ISCSI_DEF_XMIT_CMDS_MAX > ISER_DEF_XMIT_CMDS_DEFAULT
>   	#define ISER_DEF_XMIT_CMDS_MAX		ISCSI_DEF_XMIT_CMDS_MAX
> @@ -504,6 +509,8 @@ struct ib_conn {
>    * @rx_desc_head:     head of rx_descs cyclic buffer
>    * @rx_descs:         rx buffers array (cyclic buffer)
>    * @num_rx_descs:     number of rx descriptors
> + * @scsi_sg_tablesize: scsi host sg_tablesize
> + * @scsi_max_sectors: scsi host max sectors
>    */
>   struct iser_conn {
>   	struct ib_conn		     ib_conn;
> @@ -528,6 +535,8 @@ struct iser_conn {
>   	unsigned int 		     rx_desc_head;
>   	struct iser_rx_desc	     *rx_descs;
>   	u32                          num_rx_descs;
> +	unsigned short               scsi_sg_tablesize;
> +	unsigned int                 scsi_max_sectors;
>   };
>   
>   /**
> @@ -583,6 +592,7 @@ extern struct iser_global ig;
>   extern int iser_debug_level;
>   extern bool iser_pi_enable;
>   extern int iser_pi_guard;
> +extern unsigned int iser_max_sectors;
>   
>   int iser_assign_reg_ops(struct iser_device *device);
>   
> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
> index 268a3d6..d511879 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -259,7 +259,7 @@ int iser_alloc_rx_descriptors(struct iser_conn *iser_conn,
>   	iser_conn->min_posted_rx = iser_conn->qp_max_recv_dtos >> 2;
>   
>   	if (device->reg_ops->alloc_reg_res(ib_conn, session->scsi_cmds_max,
> -					   ISCSI_ISER_SG_TABLESIZE + 1))
> +					   iser_conn->scsi_sg_tablesize))
>   		goto create_rdma_reg_res_failed;
>   
>   	if (iser_alloc_login_buf(iser_conn))
> diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
> index 5e807ba..cbf6152 100644
> --- a/drivers/infiniband/ulp/iser/iser_memory.c
> +++ b/drivers/infiniband/ulp/iser/iser_memory.c
> @@ -363,7 +363,8 @@ static int iser_sg_to_page_vec(struct iser_data_buf *data,
>    * consecutive SG elements are actually fragments of the same physcial page.
>    */
>   static int iser_data_buf_aligned_len(struct iser_data_buf *data,
> -				      struct ib_device *ibdev)
> +				     struct ib_device *ibdev,
> +				     unsigned sg_tablesize)
>   {
>   	struct scatterlist *sg, *sgl, *next_sg = NULL;
>   	u64 start_addr, end_addr;
> @@ -375,6 +376,14 @@ static int iser_data_buf_aligned_len(struct iser_data_buf *data,
>   	sgl = data->sg;
>   	start_addr  = ib_sg_dma_address(ibdev, sgl);
>   
> +	if (unlikely(sgl[0].offset &&
> +		     data->data_len >= sg_tablesize * PAGE_SIZE)) {
> +		iser_dbg("can't register length %lx with offset %x "
> +			 "fall to bounce buffer\n", data->data_len,
> +			 sgl[0].offset);
> +		return 0;
> +	}
> +
>   	for_each_sg(sgl, sg, data->dma_nents, i) {
>   		if (start_check && !IS_4K_ALIGNED(start_addr))
>   			break;
> @@ -790,7 +799,8 @@ iser_handle_unaligned_buf(struct iscsi_iser_task *task,
>   	struct iser_device *device = iser_conn->ib_conn.device;
>   	int err, aligned_len;
>   
> -	aligned_len = iser_data_buf_aligned_len(mem, device->ib_device);
> +	aligned_len = iser_data_buf_aligned_len(mem, device->ib_device,
> +						iser_conn->scsi_sg_tablesize);
>   	if (aligned_len != mem->dma_nents) {
>   		err = fall_to_bounce_buf(task, mem, dir);
>   		if (err)
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> index fa778ba..f69cee7 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -756,6 +756,31 @@ static void iser_connect_error(struct rdma_cm_id *cma_id)
>   	iser_conn->state = ISER_CONN_TERMINATING;
>   }
>   
> +static void
> +iser_calc_scsi_params(struct iser_conn *iser_conn,
> +		      unsigned int max_sectors)
> +{
> +	struct iser_device *device = iser_conn->ib_conn.device;
> +	unsigned short sg_tablesize, sup_sg_tablesize;
> +
> +	sg_tablesize = DIV_ROUND_UP(max_sectors * 512, SIZE_4K);
> +	sup_sg_tablesize = min_t(unsigned, ISCSI_ISER_MAX_SG_TABLESIZE,
> +				 device->dev_attr.max_fast_reg_page_list_len);
> +
> +	if (sg_tablesize > sup_sg_tablesize) {
> +		sg_tablesize = sup_sg_tablesize;
> +		iser_conn->scsi_max_sectors = sg_tablesize * SIZE_4K / 512;
> +	} else {
> +		iser_conn->scsi_max_sectors = max_sectors;
> +	}
> +

Why SIZE_4K and not PAGE_SIZE?

> +	iser_conn->scsi_sg_tablesize = sg_tablesize;
> +
> +	iser_dbg("iser_conn %p, sg_tablesize %u, max_sectors %u\n",
> +		 iser_conn, iser_conn->scsi_sg_tablesize,
> +		 iser_conn->scsi_max_sectors);
> +}
> +
>   /**
>    * Called with state mutex held
>    **/
> @@ -794,6 +819,8 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
>   		}
>   	}
>   
> +	iser_calc_scsi_params(iser_conn, iser_max_sectors);
> +
>   	ret = rdma_resolve_route(cma_id, 1000);
>   	if (ret) {
>   		iser_err("resolve route failed: %d\n", ret);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
