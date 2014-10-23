From: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/1] IB/iser: re-adjust number of max_cqe and send_wr to hw
 supported number.
Date: Thu, 23 Oct 2014 00:59:15 +0000
Message-ID: <2cee0ee5-dd62-451a-a6a9-a237b59e8dd1@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or and Sagi,
After getting your feedbacks from the other thread, we have reworked with this new patch.

Thanks.
-Minh
-------------
From: Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

	This patch allows iser to re-adjust accordingly to the resources being supported by underlying hardwares for max cqe per CQ and max send_wr per QP.

Signed-off-by: Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> 
---
 drivers/infiniband/ulp/iser/iscsi_iser.h |  4 ++++
 drivers/infiniband/ulp/iser/iser_verbs.c | 22 +++++++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index cd4174c..c75d99a 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -135,6 +135,10 @@
                                        ISER_MAX_TX_MISC_PDUS        + \
                                        ISER_MAX_RX_MISC_PDUS)

+#define ISER_GET_MAX_XMIT_CMDS(send_wr) (send_wr - ISER_MAX_TX_MISC_PDUS - \
+                                       ISER_MAX_RX_MISC_PDUS)  /       \
+                                       (1 + ISER_INFLIGHT_DATAOUTS)
+
 /* Max registration work requests per command */
 #define ISER_MAX_REG_WR_PER_CMD                5

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 67225bb..41d7dec 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -76,7 +76,7 @@ static void iser_event_handler(struct ib_event_handler *handler,
 static int iser_create_device_ib_res(struct iser_device *device)
 {
        struct ib_device_attr *dev_attr = &device->dev_attr;
-       int ret, i;
+       int ret, i, max_cqe;

        ret = ib_query_device(device->ib_device, dev_attr);
        if (ret) {
@@ -106,9 +106,12 @@ static int iser_create_device_ib_res(struct iser_device *device)

        device->comps_used = min(ISER_MAX_CQ,
                                 device->ib_device->num_comp_vectors);
-       iser_info("using %d CQs, device %s supports %d vectors\n",
+
+       max_cqe = min(ISER_MAX_CQ_LEN, dev_attr->max_cqe);
+
+       iser_info("using %d CQs, device %s supports %d vectors max_cqe %d\n",
                  device->comps_used, device->ib_device->name,
-                 device->ib_device->num_comp_vectors);
+                 device->ib_device->num_comp_vectors, max_cqe);

        device->pd = ib_alloc_pd(device->ib_device);
        if (IS_ERR(device->pd))
@@ -118,11 +121,12 @@ static int iser_create_device_ib_res(struct iser_device *device)
                struct iser_comp *comp = &device->comps[i];

                comp->device = device;
+
                comp->cq = ib_create_cq(device->ib_device,
                                        iser_cq_callback,
                                        iser_cq_event_callback,
                                        (void *)comp,
-                                       ISER_MAX_CQ_LEN, i);
+                                       max_cqe, i);
                if (IS_ERR(comp->cq)) {
                        comp->cq = NULL;
                        goto cq_err;
@@ -426,6 +430,7 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 {
        struct iser_device      *device;
+       struct ib_device_attr *dev_attr;
        struct ib_qp_init_attr  init_attr;
        int                     ret = -ENOMEM;
        int index, min_index = 0;
@@ -433,6 +438,7 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
        BUG_ON(ib_conn->device == NULL);

        device = ib_conn->device;
+       dev_attr = &device->dev_attr;

        memset(&init_attr, 0, sizeof init_attr);

@@ -461,7 +467,13 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
                init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS + 1;
                init_attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
        } else {
-               init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS + 1;
+               if (dev_attr->max_qp_wr >= ISER_QP_MAX_REQ_DTOS)
+                       init_attr.cap.max_send_wr = ISER_QP_MAX_REQ_DTOS;
+               else {
+                       init_attr.cap.max_send_wr = dev_attr->max_qp_wr;
+                       iser_err("lowering max QueueDepth to %d per qp\n",
+                               ISER_GET_MAX_XMIT_CMDS(dev_attr->max_qp_wr));
+               }
        }

        ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
--
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
