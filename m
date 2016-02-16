From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH 2/4] IB/isert: convert to new CQ API
Date: Tue, 16 Feb 2016 20:04:40 +0200
Message-ID: <56C364B8.6010807@mellanox.com>
References: <1455567060-18381-1-git-send-email-hch@lst.de>
 <1455567060-18381-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1455567060-18381-3-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi,


> @@ -977,7 +959,10 @@ isert_post_recvm(struct isert_conn *isert_conn, u32 count)
>
>   	for (rx_wr = isert_conn->rx_wr, i = 0; i < count; i++, rx_wr++) {
>   		rx_desc = &isert_conn->rx_descs[i];
> -		rx_wr->wr_id = (uintptr_t)rx_desc;
> +
> +		rx_desc->rx_cqe.done = isert_recv_done;

perhaps we can do it once in isert_alloc_rx_descriptors ?

> +
> +		rx_wr->wr_cqe = &rx_desc->rx_cqe;
>   		rx_wr->sg_list = &rx_desc->rx_sg;
>   		rx_wr->num_sge = 1;
>   		rx_wr->next = rx_wr + 1;
> @@ -1002,7 +987,9 @@ isert_post_recv(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc)
>   	struct ib_recv_wr *rx_wr_failed, rx_wr;
>   	int ret;
>
> -	rx_wr.wr_id = (uintptr_t)rx_desc;
> +	rx_desc->rx_cqe.done = isert_recv_done;

same here.

> +
> +	rx_wr.wr_cqe = &rx_desc->rx_cqe;
>   	rx_wr.sg_list = &rx_desc->rx_sg;
>   	rx_wr.num_sge = 1;
>   	rx_wr.next = NULL;
> @@ -1018,7 +1005,7 @@ isert_post_recv(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc)


> +static void
> +isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>   {
> +	struct isert_conn *isert_conn = wc->qp->qp_context;
> +	struct ib_device *ib_dev = isert_conn->cm_id->device;
> +	struct iser_rx_desc *rx_desc =
> +		container_of(wc->wr_cqe, struct iser_rx_desc, rx_cqe);

maybe we can define it as:
static inline struct iser_rx_desc *
isert_rx(struct ib_cqe *rx_cqe)
{
    return container_of(rx_cqe, struct iser_rx_desc, rx_cqe);
}
in the .h file ?

> +	struct iscsi_hdr *hdr = &rx_desc->iscsi_header;
>   	struct iser_ctrl *iser_ctrl = &rx_desc->iser_header;
>   	uint64_t read_va = 0, write_va = 0;



> +	if (unlikely(wc->status != IB_WC_SUCCESS)) {
> +		isert_print_wc(wc);
> +		if (!--isert_conn->post_recv_buf_count)

maybe we can do isert_conn->post_recv_buf_count-- once at the beginning 
of the function?

> +			iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
> +		return;
> +	}
> +
> +	ib_dma_sync_single_for_cpu(ib_dev, rx_desc->dma_addr,
> +			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
> +
> +	isert_dbg("DMA: 0x%llx, iSCSI opcode: 0x%02x, ITT: 0x%08x, flags: 0x%02x dlen: %d\n",
> +		 rx_desc->dma_addr, hdr->opcode, hdr->itt, hdr->flags,
> +		 (int)(wc->byte_len - ISER_HEADERS_LEN));
> +
>   	switch (iser_ctrl->flags & 0xF0) {
>   	case ISCSI_CTRL:
>   		if (iser_ctrl->flags & ISER_RSV) {
> @@ -1584,55 +1609,44 @@ isert_rx_do_work(struct iser_rx_desc *rx_desc, struct isert_conn *isert_conn)
>
>   	isert_rx_opcode(isert_conn, rx_desc,
>   			read_stag, read_va, write_stag, write_va);
> +
> +	ib_dma_sync_single_for_device(ib_dev, rx_desc->dma_addr,
> +			ISER_RX_PAYLOAD_SIZE, DMA_FROM_DEVICE);
> +
> +	isert_conn->post_recv_buf_count--;
>   }
>
>   static void
> -isert_rcv_completion(struct iser_rx_desc *desc,
> -		     struct isert_conn *isert_conn,
> -		     u32 xfer_len)
> +isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
>   {
> +	struct isert_conn *isert_conn = wc->qp->qp_context;
>   	struct ib_device *ib_dev = isert_conn->cm_id->device;
> -	struct iscsi_hdr *hdr;
> -	u64 rx_dma;
> -	int rx_buflen;
> -
> -	if (desc == isert_conn->login_req_buf) {
> -		rx_dma = isert_conn->login_req_dma;
> -		rx_buflen = ISER_RX_LOGIN_SIZE;
> -		isert_dbg("login_buf: Using rx_dma: 0x%llx, rx_buflen: %d\n",
> -			 rx_dma, rx_buflen);
> -	} else {
> -		rx_dma = desc->dma_addr;
> -		rx_buflen = ISER_RX_PAYLOAD_SIZE;
> -		isert_dbg("req_buf: Using rx_dma: 0x%llx, rx_buflen: %d\n",
> -			 rx_dma, rx_buflen);
> +
> +	if (unlikely(wc->status != IB_WC_SUCCESS)) {
> +		isert_print_wc(wc);
> +		if (!--isert_conn->post_recv_buf_count)

maybe we can do isert_conn->post_recv_buf_count-- once at the beginning 
of the function?

> +			iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
> +		return;
>   	}
>
> -	ib_dma_sync_single_for_cpu(ib_dev, rx_dma, rx_buflen, DMA_FROM_DEVICE);
> +	ib_dma_sync_single_for_cpu(ib_dev, isert_conn->login_req_dma,
> +			ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
>
> -	hdr = &desc->iscsi_header;
> -	isert_dbg("iSCSI opcode: 0x%02x, ITT: 0x%08x, flags: 0x%02x dlen: %d\n",
> -		 hdr->opcode, hdr->itt, hdr->flags,
> -		 (int)(xfer_len - ISER_HEADERS_LEN));
> +	isert_conn->login_req_len = wc->byte_len - ISER_HEADERS_LEN;
>
> -	if (desc == isert_conn->login_req_buf) {
> -		isert_conn->login_req_len = xfer_len - ISER_HEADERS_LEN;
> -		if (isert_conn->conn) {
> -			struct iscsi_login *login = isert_conn->conn->conn_login;
> +	if (isert_conn->conn) {
> +		struct iscsi_login *login = isert_conn->conn->conn_login;
>
> -			if (login && !login->first_request)
> -				isert_rx_login_req(isert_conn);
> -		}
> -		mutex_lock(&isert_conn->mutex);
> -		complete(&isert_conn->login_req_comp);
> -		mutex_unlock(&isert_conn->mutex);
> -	} else {
> -		isert_rx_do_work(desc, isert_conn);
> +		if (login && !login->first_request)
> +			isert_rx_login_req(isert_conn);
>   	}
>
> -	ib_dma_sync_single_for_device(ib_dev, rx_dma, rx_buflen,
> -				      DMA_FROM_DEVICE);
> +	mutex_lock(&isert_conn->mutex);
> +	complete(&isert_conn->login_req_comp);
> +	mutex_unlock(&isert_conn->mutex);
>
> +	ib_dma_sync_single_for_device(ib_dev, isert_conn->login_req_dma,
> +				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
>   	isert_conn->post_recv_buf_count--;
>   }


> +isert_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
>   {
> -	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
> -	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
> -	struct se_cmd *se_cmd = &cmd->se_cmd;
> -	struct isert_conn *isert_conn = isert_cmd->conn;
> +	struct isert_conn *isert_conn = wc->qp->qp_context;
>   	struct isert_device *device = isert_conn->device;
> +	struct iser_tx_desc *desc =
> +		container_of(wc->wr_cqe, struct iser_tx_desc, tx_cqe);

maybe we can define it as:
static inline struct iser_tx_desc *
isert_tx(struct ib_cqe *tx_cqe)
{
    return container_of(tx_cqe, struct iser_tx_desc, tx_cqe);
}


> +	struct isert_cmd *isert_cmd = desc->isert_cmd;
> +	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
> +	struct se_cmd *cmd = &isert_cmd->iscsi_cmd->se_cmd;
>   	int ret = 0;


> +isert_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
>   {
> +	struct isert_conn *isert_conn = wc->qp->qp_context;
> +	struct isert_device *device = isert_conn->device;
> +	struct iser_tx_desc *desc =
> +		container_of(wc->wr_cqe, struct iser_tx_desc, tx_cqe);

and use it here.

> +	struct isert_cmd *isert_cmd = desc->isert_cmd;
>   	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
>   	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
>   	struct se_cmd *se_cmd = &cmd->se_cmd;


> +isert_send_done(struct ib_cq *cq, struct ib_wc *wc)
>   {
> +	struct isert_conn *isert_conn = wc->qp->qp_context;
>   	struct ib_device *ib_dev = isert_conn->cm_id->device;
> +	struct iser_tx_desc *tx_desc =
> +		container_of(wc->wr_cqe, struct iser_tx_desc, tx_cqe);

and here.

>   	struct isert_cmd *isert_cmd = tx_desc->isert_cmd;
> -	struct isert_rdma_wr *wr;
>

thanks,
Max.
