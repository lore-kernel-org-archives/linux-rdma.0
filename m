From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: IB/iSER problems with Linux 3.0
Date: Thu, 19 Jan 2012 12:29:27 +0100
Message-ID: <4F17FE97.6090708@profitbricks.com>
References: <CAJZOPZL=bV4SjdD2eakX9MhOhw=91xzCK=BEkirhRQd8oPA6bg@mail.gmail.com> <4F154CF2.7030504@profitbricks.com> <4F158C0D.7070302@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070807060309010602020203"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F158C0D.7070302-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070807060309010602020203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 17/01/12 15:56, Or Gerlitz wrote:
> could you try and patch your 3.0.15 kernel with commit
> 52439540ea30396982b69662dd21aede6b336288 "IB/iser: DMA unmap TX bufs
> used for iSCSI/iSER headers" from upstream, this could help here.
>
Hi Or,

unfortunately, just cherry-picking that commit didn't do the job.
Therefore, I've backported the whole ib_iser code from 3.2.1 to 3.0.15.
Now it works fine. I've attached the git diff.

Should I test anything further?

Thanks for your time again!

Cheers,
Sebastian

--------------070807060309010602020203
Content-Type: text/x-patch;
 name="iser_backport_3.2_to_3.0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iser_backport_3.2_to_3.0.patch"

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8db008d..daf293c 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -57,6 +57,7 @@
 #include <linux/scatterlist.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include <net/sock.h>
 
@@ -101,13 +102,17 @@ iscsi_iser_recv(struct iscsi_conn *conn,
 
 	/* verify PDU length */
 	datalen = ntoh24(hdr->dlength);
-	if (datalen != rx_data_len) {
-		printk(KERN_ERR "iscsi_iser: datalen %d (hdr) != %d (IB) \n",
-		       datalen, rx_data_len);
+	if (datalen > rx_data_len || (datalen + 4) < rx_data_len) {
+		iser_err("wrong datalen %d (hdr), %d (IB)\n",
+			datalen, rx_data_len);
 		rc = ISCSI_ERR_DATALEN;
 		goto error;
 	}
 
+	if (datalen != rx_data_len)
+		iser_dbg("aligned datalen (%d) hdr, %d (IB)\n",
+			datalen, rx_data_len);
+
 	/* read AHS */
 	ahslen = hdr->hlength * 4;
 
@@ -147,7 +152,6 @@ int iser_initialize_task_headers(struct iscsi_task *task,
 	tx_desc->tx_sg[0].length = ISER_HEADERS_LEN;
 	tx_desc->tx_sg[0].lkey   = device->mr->lkey;
 
-	iser_task->headers_initialized	= 1;
 	iser_task->iser_conn		= iser_conn;
 	return 0;
 }
@@ -162,8 +166,7 @@ iscsi_iser_task_init(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
 
-	if (!iser_task->headers_initialized)
-		if (iser_initialize_task_headers(task, &iser_task->desc))
+	if (iser_initialize_task_headers(task, &iser_task->desc))
 			return -ENOMEM;
 
 	/* mgmt task */
@@ -274,6 +277,13 @@ iscsi_iser_task_xmit(struct iscsi_task *task)
 static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
+	struct iser_tx_desc	*tx_desc = &iser_task->desc;
+
+	struct iscsi_iser_conn *iser_conn = task->conn->dd_data;
+	struct iser_device     *device    = iser_conn->ib_conn->device;
+
+	ib_dma_unmap_single(device->ib_device,
+		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);
 
 	/* mgmt tasks do not need special cleanup */
 	if (!task->sc)
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 2f02ab0..db7ea37 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -45,6 +45,7 @@
 #include <scsi/libiscsi.h>
 #include <scsi/scsi_transport_iscsi.h>
 
+#include <linux/interrupt.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
 #include <linux/list.h>
@@ -88,7 +89,7 @@
 	} while (0)
 
 #define SHIFT_4K	12
-#define SIZE_4K	(1UL << SHIFT_4K)
+#define SIZE_4K	(1ULL << SHIFT_4K)
 #define MASK_4K	(~(SIZE_4K-1))
 
 					/* support up to 512KB in one RDMA */
@@ -256,7 +257,8 @@ struct iser_conn {
 	struct list_head	     conn_list;       /* entry in ig conn list */
 
 	char  			     *login_buf;
-	u64 			     login_dma;
+	char			     *login_req_buf, *login_resp_buf;
+	u64			     login_req_dma, login_resp_dma;
 	unsigned int 		     rx_desc_head;
 	struct iser_rx_desc	     *rx_descs;
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
@@ -276,7 +278,6 @@ struct iscsi_iser_task {
 	struct iser_regd_buf         rdma_regd[ISER_DIRS_NUM];/* regd rdma buf */
 	struct iser_data_buf         data[ISER_DIRS_NUM];     /* orig. data des*/
 	struct iser_data_buf         data_copy[ISER_DIRS_NUM];/* contig. copy  */
-	int                          headers_initialized;
 };
 
 struct iser_page_vec {
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 95a08a8..b53b04d 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -221,8 +221,14 @@ void iser_free_rx_descriptors(struct iser_conn *ib_conn)
 	struct iser_device *device = ib_conn->device;
 
 	if (ib_conn->login_buf) {
-		ib_dma_unmap_single(device->ib_device, ib_conn->login_dma,
-			ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+		if (ib_conn->login_req_dma)
+			ib_dma_unmap_single(device->ib_device,
+				ib_conn->login_req_dma,
+				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
+		if (ib_conn->login_resp_dma)
+			ib_dma_unmap_single(device->ib_device,
+				ib_conn->login_resp_dma,
+				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
 		kfree(ib_conn->login_buf);
 	}
 
@@ -394,6 +400,7 @@ int iser_send_control(struct iscsi_conn *conn,
 	unsigned long data_seg_len;
 	int err = 0;
 	struct iser_device *device;
+	struct iser_conn *ib_conn = iser_conn->ib_conn;
 
 	/* build the tx desc regd header and add it to the tx desc dto */
 	mdesc->type = ISCSI_TX_CONTROL;
@@ -409,10 +416,20 @@ int iser_send_control(struct iscsi_conn *conn,
 			iser_err("data present on non login task!!!\n");
 			goto send_control_error;
 		}
-		memcpy(iser_conn->ib_conn->login_buf, task->data,
+
+		ib_dma_sync_single_for_cpu(device->ib_device,
+			ib_conn->login_req_dma, task->data_count,
+			DMA_TO_DEVICE);
+
+		memcpy(iser_conn->ib_conn->login_req_buf, task->data,
 							task->data_count);
-		tx_dsg->addr    = iser_conn->ib_conn->login_dma;
-		tx_dsg->length  = data_seg_len;
+
+		ib_dma_sync_single_for_device(device->ib_device,
+			ib_conn->login_req_dma, task->data_count,
+			DMA_TO_DEVICE);
+
+		tx_dsg->addr    = iser_conn->ib_conn->login_req_dma;
+		tx_dsg->length  = task->data_count;
 		tx_dsg->lkey    = device->mr->lkey;
 		mdesc->num_sge = 2;
 	}
@@ -445,8 +462,8 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	int rx_buflen, outstanding, count, err;
 
 	/* differentiate between login to all other PDUs */
-	if ((char *)rx_desc == ib_conn->login_buf) {
-		rx_dma = ib_conn->login_dma;
+	if ((char *)rx_desc == ib_conn->login_resp_buf) {
+		rx_dma = ib_conn->login_resp_dma;
 		rx_buflen = ISER_RX_LOGIN_SIZE;
 	} else {
 		rx_dma = rx_desc->dma_addr;
@@ -473,7 +490,7 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	 * for the posted rx bufs refcount to become zero handles everything   */
 	conn->ib_conn->post_recv_buf_count--;
 
-	if (rx_dma == ib_conn->login_dma)
+	if (rx_dma == ib_conn->login_resp_dma)
 		return;
 
 	outstanding = ib_conn->post_recv_buf_count;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index ede1475..e28877c 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -155,20 +155,39 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 {
 	struct iser_device	*device;
 	struct ib_qp_init_attr	init_attr;
-	int			ret = -ENOMEM;
+	int			req_err, resp_err, ret = -ENOMEM;
 	struct ib_fmr_pool_param params;
 
 	BUG_ON(ib_conn->device == NULL);
 
 	device = ib_conn->device;
 
-	ib_conn->login_buf = kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
+	ib_conn->login_buf = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
+					ISER_RX_LOGIN_SIZE, GFP_KERNEL);
 	if (!ib_conn->login_buf)
 		goto out_err;
 
-	ib_conn->login_dma = ib_dma_map_single(ib_conn->device->ib_device,
-				(void *)ib_conn->login_buf, ISER_RX_LOGIN_SIZE,
-				DMA_FROM_DEVICE);
+	ib_conn->login_req_buf  = ib_conn->login_buf;
+	ib_conn->login_resp_buf = ib_conn->login_buf + ISCSI_DEF_MAX_RECV_SEG_LEN;
+
+	ib_conn->login_req_dma = ib_dma_map_single(ib_conn->device->ib_device,
+				(void *)ib_conn->login_req_buf,
+				ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
+
+	ib_conn->login_resp_dma = ib_dma_map_single(ib_conn->device->ib_device,
+				(void *)ib_conn->login_resp_buf,
+				ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+
+	req_err  = ib_dma_mapping_error(device->ib_device, ib_conn->login_req_dma);
+	resp_err = ib_dma_mapping_error(device->ib_device, ib_conn->login_resp_dma);
+
+	if (req_err || resp_err) {
+		if (req_err)
+			ib_conn->login_req_dma = 0;
+		if (resp_err)
+			ib_conn->login_resp_dma = 0;
+		goto out_err;
+	}
 
 	ib_conn->page_vec = kmalloc(sizeof(struct iser_page_vec) +
 				    (sizeof(u64) * (ISCSI_ISER_SG_TABLESIZE +1)),
@@ -658,11 +677,11 @@ int iser_post_recvl(struct iser_conn *ib_conn)
 	struct ib_sge	  sge;
 	int ib_ret;
 
-	sge.addr   = ib_conn->login_dma;
+	sge.addr   = ib_conn->login_resp_dma;
 	sge.length = ISER_RX_LOGIN_SIZE;
 	sge.lkey   = ib_conn->device->mr->lkey;
 
-	rx_wr.wr_id   = (unsigned long)ib_conn->login_buf;
+	rx_wr.wr_id   = (unsigned long)ib_conn->login_resp_buf;
 	rx_wr.sg_list = &sge;
 	rx_wr.num_sge = 1;
 	rx_wr.next    = NULL;

--------------070807060309010602020203--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
