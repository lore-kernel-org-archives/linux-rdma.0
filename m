From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/7] IB/rdmavt: Add query gid support.
Date: Wed, 03 Feb 2016 14:15:11 -0800
Message-ID: <20160203221508.1765.36622.stgit@scvm10.sc.intel.com>
References: <20160203221136.1765.8947.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203221136.1765.8947.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Addin query gid support. Rdmavt still relies on the driver to maintain
the gid table. Rdmavt simply calls into the driver to retrive the guid
for a particular port.

Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/vt.c |   17 ++++++++++++++---
 include/rdma/rdma_vt.h            |    2 ++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 9f9cb9a..e017117 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -210,17 +210,28 @@ static int rvt_query_pkey(struct ib_device *ibdev, u8 port_num, u16 index,
  * Returns 0 on success
  */
 static int rvt_query_gid(struct ib_device *ibdev, u8 port_num,
-			 int index, union ib_gid *gid)
+			 int guid_index, union ib_gid *gid)
 {
+	struct rvt_dev_info *rdi;
+	struct rvt_ibport *rvp;
+	int port_index;
+
 	/*
 	 * Driver is responsible for updating the guid table. Which will be used
 	 * to craft the return value. This will work similar to how query_pkey()
 	 * is being done.
 	 */
-	if (ibport_num_to_idx(ibdev, port_num) < 0)
+	port_index = ibport_num_to_idx(ibdev, port_num);
+	if (port_index < 0)
 		return -EINVAL;
 
-	return -EOPNOTSUPP;
+	rdi = ib_to_rvt(ibdev);
+	rvp = rdi->ports[port_index];
+
+	gid->global.subnet_prefix = rvp->gid_prefix;
+
+	return rdi->driver_f.get_guid_be(rdi, rvp, guid_index,
+					 &gid->global.interface_id);
 }
 
 struct rvt_ucontext {
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 5d1c694..dabf4d5 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -248,6 +248,8 @@ struct rvt_driver_provided {
 	u32 (*mtu_from_qp)(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 			   u32 pmtu);
 	int (*mtu_to_path_mtu)(u32 mtu);
+	int (*get_guid_be)(struct rvt_dev_info *rdi, struct rvt_ibport *rvp,
+			   int guid_index, __be64 *guid);
 
 	/*--------------------*/
 	/* Optional functions */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
