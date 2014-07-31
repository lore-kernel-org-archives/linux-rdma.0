From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/8] IB/iser: Support IPv6 address family
Date: Thu, 31 Jul 2014 13:27:44 +0300
Message-ID: <1406802471-23359-2-git-send-email-ogerlitz@mellanox.com>
References: <1406802471-23359-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406802471-23359-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Replacing struct sockaddr_in with struct ockaddr which supports
both IPv4 and IPv6, and print using the %pIS format directive.

Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    3 +--
 drivers/infiniband/ulp/iser/iscsi_iser.h |    4 ++--
 drivers/infiniband/ulp/iser/iser_verbs.c |   17 ++++++-----------
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index eb79739..1a53fd2 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -604,8 +604,7 @@ iscsi_iser_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	ib_conn->ep = ep;
 	iser_conn_init(ib_conn);
 
-	err = iser_connect(ib_conn, NULL, (struct sockaddr_in *)dst_addr,
-			   non_blocking);
+	err = iser_connect(ib_conn, NULL, dst_addr, non_blocking);
 	if (err)
 		return ERR_PTR(err);
 
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 97cd385..37e9284 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -448,8 +448,8 @@ int  iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *task,
 			       enum iser_data_dir cmd_dir);
 
 int  iser_connect(struct iser_conn   *ib_conn,
-		  struct sockaddr_in *src_addr,
-		  struct sockaddr_in *dst_addr,
+		  struct sockaddr    *src_addr,
+		  struct sockaddr    *dst_addr,
 		  int                non_blocking);
 
 int  iser_reg_page_vec(struct iser_conn     *ib_conn,
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index ea01075..dc0c90f 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -810,22 +810,19 @@ void iser_conn_init(struct iser_conn *ib_conn)
  * sleeps until the connection is established or rejected
  */
 int iser_connect(struct iser_conn   *ib_conn,
-		 struct sockaddr_in *src_addr,
-		 struct sockaddr_in *dst_addr,
+		 struct sockaddr    *src_addr,
+		 struct sockaddr    *dst_addr,
 		 int                 non_blocking)
 {
-	struct sockaddr *src, *dst;
 	int err = 0;
 
-	sprintf(ib_conn->name, "%pI4:%d",
-		&dst_addr->sin_addr.s_addr, dst_addr->sin_port);
+	sprintf(ib_conn->name, "%pISp", dst_addr);
+
+	iser_info("connecting to: %s\n", ib_conn->name);
 
 	/* the device is known only --after-- address resolution */
 	ib_conn->device = NULL;
 
-	iser_info("connecting to: %pI4, port 0x%x\n",
-		  &dst_addr->sin_addr, dst_addr->sin_port);
-
 	ib_conn->state = ISER_CONN_PENDING;
 
 	ib_conn->cma_id = rdma_create_id(iser_cma_handler,
@@ -837,9 +834,7 @@ int iser_connect(struct iser_conn   *ib_conn,
 		goto id_failure;
 	}
 
-	src = (struct sockaddr *)src_addr;
-	dst = (struct sockaddr *)dst_addr;
-	err = rdma_resolve_addr(ib_conn->cma_id, src, dst, 1000);
+	err = rdma_resolve_addr(ib_conn->cma_id, src_addr, dst_addr, 1000);
 	if (err) {
 		iser_err("rdma_resolve_addr failed: %d\n", err);
 		goto addr_failure;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
