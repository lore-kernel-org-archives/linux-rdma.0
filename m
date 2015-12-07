From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/37] IB/rdmavt: Add query gid stub
Date: Mon, 07 Dec 2015 15:43:37 -0500
Message-ID: <20151207204336.8144.61573.stgit@phlsvslse11.ph.intel.com>
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

The handler for query gid operates along the same lines as the query pkey
handler. The driver will take care to keep the guid table updated.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 823c877..c4d7f76 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -163,6 +163,27 @@ static int rvt_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 	return 0;
 }
 
+/**
+ * rvt_query_gid - Return a gid from the table
+ * @ibdev: Verbs IB dev
+ * @port: Port number
+ * @index: = Index in table
+ * @gid: Gid to return
+ *
+ * Returns 0 on success
+ */
+static int rvt_query_gid(struct ib_device *ibdev, u8 port,
+			 int index, union ib_gid *gid)
+{
+	/*
+	 * Driver is responsible for updating the guid table. Which will be used
+	 * to craft the return value. This will work similar to how query_pkey()
+	 * is being done.
+	 */
+
+	return -EINVAL;
+}
+
 /*
  * Check driver override. If driver passes a value use it, otherwise we use our
  * own value.
@@ -181,6 +202,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CDR(rdi, query_port);
 	CDR(rdi, modify_port);
 	CDR(rdi, query_pkey);
+	CDR(rdi, query_gid);
 
 	/* DMA Operations */
 	rdi->ibdev.dma_ops =

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
