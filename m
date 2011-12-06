From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] rdma/core: Fix sparse warnings
Date: Tue, 6 Dec 2011 21:13:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325653854@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Cleanup sparse warnings in the rdma core layer.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
please queue for 3.3

 drivers/infiniband/core/ucm.c        |    3 ---
 drivers/infiniband/core/uverbs_cmd.c |    6 +++---
 include/rdma/ib_addr.h               |    2 +-
 include/rdma/ib_cm.h                 |    3 +++
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index b8a0b4a..06f0871 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -106,9 +106,6 @@ enum {
 	IB_UCM_MAX_DEVICES = 32
 };
 
-/* ib_cm and ib_user_cm modules share /sys/class/infiniband_cm */
-extern struct class cm_class;
-
 #define IB_UCM_BASE_DEV MKDEV(IB_UCM_MAJOR, IB_UCM_BASE_MINOR)
 
 static void ib_ucm_add_one(struct ib_device *device);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 254f164..e26193f 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2446,9 +2446,9 @@ out_put:
 	return ret ? ret : in_len;
 }
 
-int __uverbs_create_xsrq(struct ib_uverbs_file *file,
-			 struct ib_uverbs_create_xsrq *cmd,
-			 struct ib_udata *udata)
+static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
+				struct ib_uverbs_create_xsrq *cmd,
+				struct ib_udata *udata)
 {
 	struct ib_uverbs_create_srq_resp resp;
 	struct ib_usrq_object           *obj;
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 639a449..9996539 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -281,7 +281,7 @@ static inline u16 rdma_get_vlan_id(union ib_gid *dgid)
 static inline struct net_device *rdma_vlan_dev_real_dev(const struct net_device *dev)
 {
 	return dev->priv_flags & IFF_802_1Q_VLAN ?
-		vlan_dev_real_dev(dev) : 0;
+		vlan_dev_real_dev(dev) : NULL;
 }
 
 #endif /* IB_ADDR_H */
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index c8f94e8..83f77ac 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -38,6 +38,9 @@
 #include <rdma/ib_mad.h>
 #include <rdma/ib_sa.h>
 
+/* ib_cm and ib_user_cm modules share /sys/class/infiniband_cm */
+extern struct class cm_class;
+
 enum ib_cm_state {
 	IB_CM_IDLE,
 	IB_CM_LISTEN,


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
