From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH V6 6/9] isert: Rename IO functions to more descriptive names
Date: Fri, 24 Jul 2015 11:18:48 -0500
Message-ID: <20150724161848.25617.26092.stgit@build2.ogc.int>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724161331.25617.8475.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is in preparation for adding new FRMR-only IO handlers
for devices that support FRMR and not PI.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/ulp/isert/ib_isert.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 6af3dd4..dcd3c55 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -48,15 +48,15 @@ static struct workqueue_struct *isert_comp_wq;
 static struct workqueue_struct *isert_release_wq;
 
 static void
-isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
+isert_unmap_lkey(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
 static int
-isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+isert_map_lkey(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	       struct isert_rdma_wr *wr);
 static void
-isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
+isert_unreg_frmr_pi(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
 static int
-isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
-	       struct isert_rdma_wr *wr);
+isert_reg_frmr_pi(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+		  struct isert_rdma_wr *wr);
 static int
 isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd);
 static int
@@ -367,12 +367,12 @@ isert_create_device_ib_res(struct isert_device *device)
 	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
 	    dev_attr->device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER) {
 		device->use_fastreg = 1;
-		device->reg_rdma_mem = isert_reg_rdma;
-		device->unreg_rdma_mem = isert_unreg_rdma;
+		device->reg_rdma_mem = isert_reg_frmr_pi;
+		device->unreg_rdma_mem = isert_unreg_frmr_pi;
 	} else {
 		device->use_fastreg = 0;
-		device->reg_rdma_mem = isert_map_rdma;
-		device->unreg_rdma_mem = isert_unmap_cmd;
+		device->reg_rdma_mem = isert_map_lkey;
+		device->unreg_rdma_mem = isert_unmap_lkey;
 	}
 
 	ret = isert_alloc_comps(device, dev_attr);
@@ -1701,7 +1701,7 @@ isert_unmap_data_buf(struct isert_conn *isert_conn, struct isert_data_buf *data)
 
 
 static void
-isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
+isert_unmap_lkey(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 {
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 
@@ -1726,7 +1726,7 @@ isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 }
 
 static void
-isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
+isert_unreg_frmr_pi(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 {
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 
@@ -2442,7 +2442,7 @@ isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 }
 
 static int
-isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+isert_map_lkey(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	       struct isert_rdma_wr *wr)
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
@@ -2848,8 +2848,8 @@ unmap_prot_cmd:
 }
 
 static int
-isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
-	       struct isert_rdma_wr *wr)
+isert_reg_frmr_pi(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+		  struct isert_rdma_wr *wr)
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
