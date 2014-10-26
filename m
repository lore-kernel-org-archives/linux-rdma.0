From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] IB/iser: re-adjust number of max_cqe and send_wr
 to hw supported number.
Date: Sun, 26 Oct 2014 13:39:18 +0200
Message-ID: <544CDD66.3030303@dev.mellanox.co.il>
References: <2cee0ee5-dd62-451a-a6a9-a237b59e8dd1@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000902010407010504040106"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2cee0ee5-dd62-451a-a6a9-a237b59e8dd1-3RiH6ntJJkP8BX6JNMqfyFjyZtpTMMwT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------000902010407010504040106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/2014 3:59 AM, Minh Duc Tran wrote:
> Hi Or and Sagi,
> After getting your feedbacks from the other thread, we have reworked with this new patch.
>

Hey Minh,

This looks better, but I have a couple of comments (below).

I can modify those and add it to a couple of patches I have
piped for 3.18-rcX.

> Thanks.
> -Minh
> -------------
> From: Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
>
> 	This patch allows iser to re-adjust accordingly to the resources being supported by underlying hardwares for max cqe per CQ and max send_wr per QP.
>
> Signed-off-by: Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.h |  4 ++++
>   drivers/infiniband/ulp/iser/iser_verbs.c | 22 +++++++++++++++++-----
>   2 files changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
> index cd4174c..c75d99a 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.h
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
> @@ -135,6 +135,10 @@
>                                          ISER_MAX_TX_MISC_PDUS        + \
>                                          ISER_MAX_RX_MISC_PDUS)
>
> +#define ISER_GET_MAX_XMIT_CMDS(send_wr) (send_wr - ISER_MAX_TX_MISC_PDUS - \
> +                                       ISER_MAX_RX_MISC_PDUS)  /       \
> +                                       (1 + ISER_INFLIGHT_DATAOUTS)
> +

This is not the opposite computation of ISER_QP_MAX_REQ_DTOS.
why not do:
#define ISER_GET_MAX_XMIT_CMDS(send_wr) (send_wr /                     \
                                          (1 + ISER_INFLIGHT_DATAOUTS)  \
                                          - ISER_MAX_TX_MISC_PDUS       \
                                          - ISER_MAX_RX_MISC_PDUS)

>   /* Max registration work requests per command */
>   #define ISER_MAX_REG_WR_PER_CMD                5
>
> diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
> index 67225bb..41d7dec 100644
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -76,7 +76,7 @@ static void iser_event_handler(struct ib_event_handler *handler,
>   static int iser_create_device_ib_res(struct iser_device *device)
>   {
>          struct ib_device_attr *dev_attr = &device->dev_attr;
> -       int ret, i;
> +       int ret, i, max_cqe;
>
>          ret = ib_query_device(device->ib_device, dev_attr);
>          if (ret) {
> @@ -106,9 +106,12 @@ static int iser_create_device_ib_res(struct iser_device *device)
>
>          device->comps_used = min(ISER_MAX_CQ,
>                                   device->ib_device->num_comp_vectors);
> -       iser_info("using %d CQs, device %s supports %d vectors\n",
> +
> +       max_cqe = min(ISER_MAX_CQ_LEN, dev_attr->max_cqe);
> +
> +       iser_info("using %d CQs, device %s supports %d vectors max_cqe %d\n",
>                    device->comps_used, device->ib_device->name,
> -                 device->ib_device->num_comp_vectors);
> +                 device->ib_device->num_comp_vectors, max_cqe);
>
>          device->pd = ib_alloc_pd(device->ib_device);
>          if (IS_ERR(device->pd))
> @@ -118,11 +121,12 @@ static int iser_create_device_ib_res(struct iser_device *device)
>                  struct iser_comp *comp = &device->comps[i];
>
>                  comp->device = device;
> +
>                  comp->cq = ib_create_cq(device->ib_device,
>                                          iser_cq_callback,
>                                          iser_cq_event_callback,
>                                          (void *)comp,
> -                                       ISER_MAX_CQ_LEN, i);
> +                                       max_cqe, i);
>                  if (IS_ERR(comp->cq)) {
>                          comp->cq = NULL;
>                          goto cq_err;
> @@ -426,6 +430,7 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
>   static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
>   {
>          struct iser_device      *device;
> +       struct ib_device_attr *dev_attr;
>          struct ib_qp_init_attr  init_attr;
>          int                     ret = -ENOMEM;
>          int index, min_index = 0;
> @@ -433,6 +438,7 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
>          BUG_ON(ib_conn->device == NULL);
>
>          device = ib_conn->device;
> +       dev_attr = &device->dev_attr;
>
>          memset(&init_attr, 0, sizeof init_attr);
>
> @@ -461,7 +467,13 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
>                  init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS + 1;
>                  init_attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
>          } else {
> -               init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS + 1;
> +               if (dev_attr->max_qp_wr >= ISER_QP_MAX_REQ_DTOS)

checkpatch would complain here (parenthesis on all arms of if statement)
Did you run it?

> +                       init_attr.cap.max_send_wr = ISER_QP_MAX_REQ_DTOS;

This +1 should remain as we need to reserve room for the beacon post.

> +               else {
> +                       init_attr.cap.max_send_wr = dev_attr->max_qp_wr;
> +                       iser_err("lowering max QueueDepth to %d per qp\n",
> +                               ISER_GET_MAX_XMIT_CMDS(dev_attr->max_qp_wr));

In this patch your print is false, since you are not really lowering
the queue_depth. You should follow save this value in iser_conn
(iser_conn->cmds_max_allowed) and then really lower it at 
iscsi_iser_session_create()...

So I see this as a temp fix for now. A more thorough fix will follow
in 3.19.

Can you try the patch attached with my bits modified?

Thanks,
Sagi




--------------000902010407010504040106
Content-Type: text/plain; charset=windows-1252;
 name="0001-IB-iser-re-adjust-number-of-max_cqe-and-send_wr-to-h.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-IB-iser-re-adjust-number-of-max_cqe-and-send_wr-to-h.pa";
 filename*1="tch"

>From bac573fef85520d9685a6ee2a79cdc5bb284a659 Mon Sep 17 00:00:00 2001
From: Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Date: Sun, 26 Oct 2014 00:12:36 +0200
Subject: [PATCH 1/7] IB/iser: re-adjust number of max_cqe and send_wr to hw supported number

This patch allows iser to re-adjust accordingly to the resources being
supported by underlying hardwares for max cqe per CQ and max send_wr per QP.

Signed-off-by: Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Acked-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   10 +++++++---
 drivers/infiniband/ulp/iser/iscsi_iser.h |    7 +++++++
 drivers/infiniband/ulp/iser/iser_verbs.c |   25 ++++++++++++++++++++-----
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index f42ab14..47bd87a 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -569,6 +569,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	struct Scsi_Host *shost;
 	struct iser_conn *iser_conn = NULL;
 	struct ib_conn *ib_conn;
+	u16 max_cmds;
 
 	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, 0);
 	if (!shost)
@@ -586,6 +587,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	 */
 	if (ep) {
 		iser_conn = ep->dd_data;
+		max_cmds = iser_conn->max_cmds;
 		ib_conn = &iser_conn->ib_conn;
 		if (ib_conn->pi_support) {
 			u32 sig_caps = ib_conn->device->dev_attr.sig_prot_cap;
@@ -596,16 +598,18 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 			else
 				scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
 		}
+	} else {
+		max_cmds = ISER_DEF_XMIT_CMDS_MAX;
 	}
 
 	if (iscsi_host_add(shost, ep ?
 			   ib_conn->device->ib_device->dma_device : NULL))
 		goto free_host;
 
-	if (cmds_max > ISER_DEF_XMIT_CMDS_MAX) {
+	if (cmds_max > max_cmds) {
 		iser_info("cmds_max changed from %u to %u\n",
-			  cmds_max, ISER_DEF_XMIT_CMDS_MAX);
-		cmds_max = ISER_DEF_XMIT_CMDS_MAX;
+			  cmds_max, max_cmds);
+		cmds_max = max_cmds;
 	}
 
 	cls_session = iscsi_session_setup(&iscsi_iser_transport, shost,
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index cd4174c..c9b6f41 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -144,6 +144,11 @@
 					ISER_MAX_TX_MISC_PDUS         + \
 					ISER_MAX_RX_MISC_PDUS)
 
+#define ISER_GET_MAX_XMIT_CMDS(send_wr) (send_wr /                      \
+					 (1 + ISER_INFLIGHT_DATAOUTS)   \
+					 - ISER_MAX_TX_MISC_PDUS        \
+					 - ISER_MAX_RX_MISC_PDUS)
+
 #define ISER_WC_BATCH_COUNT   16
 #define ISER_SIGNAL_CMD_COUNT 32
 
@@ -482,6 +487,7 @@ struct ib_conn {
  *                    to max number of post recvs
  * @qp_max_recv_dtos_mask: (qp_max_recv_dtos - 1)
  * @min_posted_rx:    (qp_max_recv_dtos >> 2)
+ * @max_cmds:         maximum cmds allowed for this connection
  * @name:             connection peer portal
  * @release_work:     deffered work for release job
  * @state_mutex:      protects iser onnection state
@@ -507,6 +513,7 @@ struct iser_conn {
 	unsigned		     qp_max_recv_dtos;
 	unsigned		     qp_max_recv_dtos_mask;
 	unsigned		     min_posted_rx;
+	u16                          max_cmds;
 	char 			     name[ISER_OBJECT_NAME_SIZE];
 	struct work_struct	     release_work;
 	struct mutex		     state_mutex;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 67225bb..2ccbc64 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -76,7 +76,7 @@ static void iser_event_handler(struct ib_event_handler *handler,
 static int iser_create_device_ib_res(struct iser_device *device)
 {
 	struct ib_device_attr *dev_attr = &device->dev_attr;
-	int ret, i;
+	int ret, i, max_cqe;
 
 	ret = ib_query_device(device->ib_device, dev_attr);
 	if (ret) {
@@ -106,9 +106,12 @@ static int iser_create_device_ib_res(struct iser_device *device)
 
 	device->comps_used = min(ISER_MAX_CQ,
 				 device->ib_device->num_comp_vectors);
-	iser_info("using %d CQs, device %s supports %d vectors\n",
+
+	max_cqe = min(ISER_MAX_CQ_LEN, dev_attr->max_cqe);
+
+	iser_info("using %d CQs, device %s supports %d vectors max_cqe %d\n",
 		  device->comps_used, device->ib_device->name,
-		  device->ib_device->num_comp_vectors);
+		  device->ib_device->num_comp_vectors, max_cqe);
 
 	device->pd = ib_alloc_pd(device->ib_device);
 	if (IS_ERR(device->pd))
@@ -122,7 +125,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
 					iser_cq_callback,
 					iser_cq_event_callback,
 					(void *)comp,
-					ISER_MAX_CQ_LEN, i);
+					max_cqe, i);
 		if (IS_ERR(comp->cq)) {
 			comp->cq = NULL;
 			goto cq_err;
@@ -425,7 +428,10 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
  */
 static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 {
+	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
+						   ib_conn);
 	struct iser_device	*device;
+	struct ib_device_attr *dev_attr;
 	struct ib_qp_init_attr	init_attr;
 	int			ret = -ENOMEM;
 	int index, min_index = 0;
@@ -433,6 +439,7 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 	BUG_ON(ib_conn->device == NULL);
 
 	device = ib_conn->device;
+	dev_attr = &device->dev_attr;
 
 	memset(&init_attr, 0, sizeof init_attr);
 
@@ -461,7 +468,15 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 		init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS + 1;
 		init_attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
 	} else {
-		init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS + 1;
+		if (dev_attr->max_qp_wr > ISER_QP_MAX_REQ_DTOS) {
+			init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS + 1;
+		} else {
+			init_attr.cap.max_send_wr = dev_attr->max_qp_wr;
+			iser_conn->max_cmds =
+				ISER_GET_MAX_XMIT_CMDS(dev_attr->max_qp_wr);
+			iser_dbg("device %s supports max_send_wr %d\n",
+				 device->ib_device->name, dev_attr->max_qp_wr);
+		}
 	}
 
 	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
-- 
1.7.1


--------------000902010407010504040106--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
