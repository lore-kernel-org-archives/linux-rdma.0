From: Minh Duc Tran <MinhDuc.Tran-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and
 send_wr
Date: Mon, 20 Oct 2014 05:36:50 +0000
Message-ID: <ecfd3441-253c-47bf-b2cb-030b2a00f689@CMEXHTCAS1.ad.emulex.com>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
 <543CD5D6.1020506@mellanox.com>
 <44d2d670-4785-4a76-8c05-f59791c999cf@CMEXHTCAS1.ad.emulex.com>
 <5443DBCA.4000002@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5443DBCA.4000002-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jayamohan Kallickal <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

I've created a new patch over the 21 iser patches you have mentioned early in this thread.  It is pasted at the end of this email.
If I understand correctly, this patch will be applied along with Or's TODO list.


>> ISER_MAX_RX_CQ_LEN             4096               /* This number should be calculated during create_session */

>So in iSER CQs are shared a across the device - so this number should satisfy maximum number of connections per CQ (which is currently 8).

Again, there should be no rules enforcing a CQ to support 8 connections.  The underlining hw should be able to supports more or less as it is configured to do.  Specific to the ocrdma hw, it has lower number of CQE per CQ but it has 32 CQ

>> ISER_QP_MAX_RECV_DTOS    512                 /* Why can't we use ISCSI_DEF_XMIT_CMDS_MAX here ? */

>iSER creates the connection QP when before the session is created - so it doesn't know what the user will set at cmds_max (which is potentially larger than ISCSI_DEF_XMIT_CMDS_MAX). So we allow 512 at the moment and adjust the session cmds_max accordingly. I agree that this is a >work around for the moment as we don't know at QP creation time what is the user setting of cmds_max.

Like any other drivers, we should limit this number to the range hw supports.  If user setting is within hw range then number will be adjusted accordingly.  If user setting is not within hw range, set it to default values.
What about something like this:
#define ISER_GET_MAX_XMIT_CMDS(send_wr) (send_wr - ISER_MAX_TX_MISC_PDUS - \
					ISER_MAX_RX_MISC_PDUS)	/	\
					 (1 + ISER_INFLIGHT_DATAOUTS)
cmds_max_supported = ISER_GET_MAX_XMIT_CMDS(dev_attr->max_qp_wr)


>> ISER_MAX_TX_CQ_LEN             36944           /* the mlx4 hw supports up to 3 CQ, but the ocrdma hw supports up to  32CQ with lower number of cqe per CQ */

>What led you to conclude that: "the mlx4 hw supports up to 3 CQ"?
>TX CQ length should be

I was debugging some iser target problems sometimes back.  I could be wrong with 3CQ but it's not far from the hard limit of 4CQ set by current ib/iser code

>> ISER_QP_MAX_REQ_DTOS       4618
> >ISCSI_ISER_MAX_CONN            8                  /* I am not sure what this 8 connections per CQ is.  Open-iscsi will supports 1 connection per session so this can implies either one of these two things:
>>                                                                                          1- mlx4 is limited to 8 sessions per CQ
>>                                                                                          
>> 2- mlx4 is doing something proprietary on the hw to have multiple QP 
>> per session */

>As I said, CQs are per device and shared across iscsi connections. So each CQ will support up to 8 connections per CQ. I agree we should allocate more CQs in case of more connections are opened - but we never got any CQ to overrun (even in high stress) so this still on my todo list...

>> ISER_MAX_CQ                               4                  /* Should this number be much higher or bases on the number of cpu cores on the system to distribute CQ processing per core? */

>I completely agree, This is a legacy MAX ceiling. I have a patch for that pending at Or's table. I am all for getting it to 3.18/3.19

>>
>> We are open for suggestions.

>OK,

>I'll respond to Or's reply on the TODOs.

>Sagi.


================
From: Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

        This patch allows the underlying hardware to choose
values other than  hard coded max values for cqe and send_wr
while preventing them from exceeding max supported values.

Signed-off-by: Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 67225bb..73955c1 100644
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
@@ -114,6 +114,9 @@ static int iser_create_device_ib_res(struct iser_device *device)
        if (IS_ERR(device->pd))
                goto pd_err;

+       max_cqe = (dev_attr->max_cqe < ISER_MAX_CQ_LEN) ?
+                  dev_attr->max_cqe : ISER_MAX_CQ_LEN;
+
        for (i = 0; i < device->comps_used; i++) {
                struct iser_comp *comp = &device->comps[i];

@@ -122,7 +125,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
                                        iser_cq_callback,
                                        iser_cq_event_callback,
                                        (void *)comp,
-                                       ISER_MAX_CQ_LEN, i);
+                                       max_cqe, i);
                if (IS_ERR(comp->cq)) {
                        comp->cq = NULL;
                        goto cq_err;
@@ -426,6 +429,7 @@ void iser_free_fastreg_pool(struct ib_conn *ib_conn)
 static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 {
        struct iser_device      *device;
+       struct ib_device_attr *dev_attr;
        struct ib_qp_init_attr  init_attr;
        int                     ret = -ENOMEM;
        int index, min_index = 0;
@@ -433,6 +437,7 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
        BUG_ON(ib_conn->device == NULL);

        device = ib_conn->device;
+       dev_attr = &device->dev_attr;

        memset(&init_attr, 0, sizeof init_attr);

@@ -461,7 +466,9 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
                init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS + 1;
                init_attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
        } else {
-               init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS + 1;
+               init_attr.cap.max_send_wr  =
+                       (dev_attr->max_qp_wr < ISER_QP_MAX_REQ_DTOS) ?
+                        dev_attr->max_qp_wr : ISER_QP_MAX_REQ_DTOS;
        }

        ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
