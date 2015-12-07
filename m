From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/37] IB/rdmavt: Add pkey query stub
Date: Mon, 07 Dec 2015 15:43:32 -0500
Message-ID: <20151207204331.8144.93579.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The pkey table will reside in the rvt structure but it will be modified
only when the driver requests then rvt will simply read the value to return
in the query.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   21 +++++++++++++++++++++
 include/rdma/rdma_vt.h            |    3 ++-
 2 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 513b929..823c877 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -143,6 +143,26 @@ static int rvt_modify_port(struct ib_device *ibdev, u8 port,
 	return -EINVAL;
 }
 
+/**
+ * rvt_query_pkey - Return a pkey from the table at a given index
+ * @ibdev: Verbs IB dev
+ * @port: Port number
+ * @intex: Index into pkey table
+ *
+ * Returns 0 on failure pkey otherwise
+ */
+static int rvt_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
+			  u16 *pkey)
+{
+	/*
+	 * Driver will be responsible for keeping rvt_dev_info.pkey_table up to
+	 * date. This function will just return that value. There is no need to
+	 * lock, if a stale value is read and sent to the user so be it there is
+	 * no way to protect against that anyway.
+	 */
+	return 0;
+}
+
 /*
  * Check driver override. If driver passes a value use it, otherwise we use our
  * own value.
@@ -160,6 +180,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CDR(rdi, modify_device);
 	CDR(rdi, query_port);
 	CDR(rdi, modify_port);
+	CDR(rdi, query_pkey);
 
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 89b8cd9..5112dd7 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -120,12 +120,13 @@ struct rvt_dev_info {
 	 * The driver will also be
 	 * responsible for filling in certain members of dparms.props
 	 */
-
 	struct ib_device ibdev;
 
 	/* Driver specific properties */
 	struct rvt_driver_params dparms;
 
+	/* PKey Table goes here */
+
 	/*
 	 * The work to create port files in /sys/class Infiniband is different
 	 * depending on the driver. This should not be extracted away and

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
