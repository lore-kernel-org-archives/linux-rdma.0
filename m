From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/4] IB/isert: properly type the login buffer
Date: Tue, 16 Feb 2016 19:19:19 +0200
Message-ID: <56C35A17.6050305@mellanox.com>
References: <1455567060-18381-1-git-send-email-hch@lst.de>
 <1455567060-18381-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455567060-18381-2-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Christoph,
I have noticed that we are allocating login_req_buf sized 
ISCSI_DEF_MAX_RECV_SEG_LEN but the sge.lenth we post_recv is 
ISER_RX_LOGIN_SIZE, thus the rx_buflen in the recv completion is also 
ISER_RX_LOGIN_SIZE in case we are in login stage.
I think we might crash here in case the initiator send request bigger 
than ISCSI_DEF_MAX_RECV_SEG_LEN, won't we ?


>   static int
> @@ -609,50 +611,48 @@ isert_alloc_login_buf(struct isert_conn *isert_conn,
>   {
>   	int ret;
>
> -	isert_conn->login_buf = kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
> -					ISER_RX_LOGIN_SIZE, GFP_KERNEL);
> -	if (!isert_conn->login_buf) {
> -		isert_err("Unable to allocate isert_conn->login_buf\n");
> +	isert_conn->login_req_buf =
> +		kzalloc(ISCSI_DEF_MAX_RECV_SEG_LEN, GFP_KERNEL);
> +	if (!isert_conn->login_req_buf) {
> +		isert_err("Unable to allocate isert_conn->login_req_buf\n");
>   		return -ENOMEM;
>   	}
>
> -	isert_conn->login_req_buf = isert_conn->login_buf;
> -	isert_conn->login_rsp_buf = isert_conn->login_buf +
> -				    ISCSI_DEF_MAX_RECV_SEG_LEN;
> -
> -	isert_dbg("Set login_buf: %p login_req_buf: %p login_rsp_buf: %p\n",
> -		 isert_conn->login_buf, isert_conn->login_req_buf,
> -		 isert_conn->login_rsp_buf);
> -
>   	isert_conn->login_req_dma = ib_dma_map_single(ib_dev,
> -				(void *)isert_conn->login_req_buf,
> +				isert_conn->login_req_buf,
>   				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_FROM_DEVICE);
> -
>



>
> -	if ((char *)desc == isert_conn->login_req_buf) {
> +	if (desc == isert_conn->login_req_buf) {
>   		rx_dma = isert_conn->login_req_dma;
>   		rx_buflen = ISER_RX_LOGIN_SIZE;
>   		isert_dbg("login_buf: Using rx_dma: 0x%llx, rx_buflen: %d\n",
> @@ -1615,7 +1615,7 @@ isert_rcv_completion(struct iser_rx_desc *desc,
>   		 hdr->opcode, hdr->itt, hdr->flags,
>   		 (int)(xfer_len - ISER_HEADERS_LEN));
>


Max.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
