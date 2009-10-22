From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] [RFC] rdma/cm: support option to allow manually setting IB path
Date: Thu, 22 Oct 2009 01:10:09 -0700
Message-ID: <B7E97540810E4A2785FF1FC8CB96F453@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com> <20091020181458.GD14520@obsidianresearch.com> <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com> <20091020191404.GH14520@obsidianresearch.com> <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com> <20091022004245.GV14520@obsidianresearch.com> <AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com> <20091022013542.GX14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091022013542.GX14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Export rdma_set_ib_paths to user space to allow applications to
manually set the IB path used for connections.  This allows
alternative ways for a user space application or library to obtain
path record information, including retrieving path information
from cached data, avoiding direct interaction with the IB SA.
The IB SA is a single, centralized entity that can limit scaling
on large clusters running MPI applications.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes from v1:
Use MAD attribute structure format for path record data.
Add flags to indicate how a path should be used.  This allows separate
forward and reverse paths, and could support APM.

Patch is compiled tested only. 

 drivers/infiniband/core/sa_query.c |    6 +++++
 drivers/infiniband/core/ucma.c     |   44 ++++++++++++++++++++++++++++++++++++
 include/rdma/ib_sa.h               |    6 +++++
 include/rdma/ib_user_sa.h          |   14 +++++++++++
 include/rdma/rdma_user_cm.h        |    7 ++++--
 5 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 1865049..2e73dcc 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -604,6 +604,12 @@ retry:
 	return ret ? ret : id;
 }
 
+void ib_sa_unpack_path(void *attribute, struct ib_sa_path_rec *rec)
+{
+	ib_unpack(path_rec_table, ARRAY_SIZE(path_rec_table), attribute, rec);
+}
+EXPORT_SYMBOL(ib_sa_unpack_path);
+
 static void ib_sa_path_rec_callback(struct ib_sa_query *sa_query,
 				    int status,
 				    struct ib_sa_mad *mad)
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index 4346a24..996a521 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -42,6 +42,7 @@
 #include <rdma/rdma_user_cm.h>
 #include <rdma/ib_marshall.h>
 #include <rdma/rdma_cm.h>
+#include <rdma/rdma_cm_ib.h>
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("RDMA Userspace Connection Manager Access");
@@ -811,6 +812,46 @@ static int ucma_set_option_id(struct ucma_context *ctx, int optname,
 	return ret;
 }
 
+static int ucma_set_ib_path(struct ucma_context *ctx,
+			    struct ib_path_rec_data *path_data, size_t optlen)
+{
+	struct ib_sa_path_rec sa_path;
+	struct rdma_cm_event event;
+	int ret;
+
+	if (optlen != sizeof(*path_data))
+		return -EINVAL;
+
+	if (path_data->flags != IB_PATH_GMP | IB_PATH_PRIMARY |
+				IB_PATH_OUTBOUND | IB_PATH_INBOUND)
+		return -EINVAL;
+
+	ib_sa_unpack_path(path_data->path_rec, &sa_path);
+	ret = rdma_set_ib_paths(ctx->cm_id, &sa_path, 1);
+	if (ret)
+		return ret;
+
+	memset(&event, 0, sizeof event);
+	event.event = RDMA_CM_EVENT_ROUTE_RESOLVED;
+	return ucma_event_handler(ctx->cm_id, &event);
+}
+
+static int ucma_set_option_ib(struct ucma_context *ctx, int optname,
+			      void *optval, size_t optlen)
+{
+	int ret;
+
+	switch (optname) {
+	case RDMA_OPTION_IB_PATH:
+		ret = ucma_set_ib_path(ctx, optval, optlen);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	return ret;
+}
+
 static int ucma_set_option_level(struct ucma_context *ctx, int level,
 				 int optname, void *optval, size_t optlen)
 {
@@ -820,6 +861,9 @@ static int ucma_set_option_level(struct ucma_context *ctx, int level,
 	case RDMA_OPTION_ID:
 		ret = ucma_set_option_id(ctx, optname, optval, optlen);
 		break;
+	case RDMA_OPTION_IB:
+		ret = ucma_set_option_ib(ctx, optname, optval, optlen);
+		break;
 	default:
 		ret = -ENOSYS;
 	}
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 3841c1a..1082afa 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -379,4 +379,10 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 			 struct ib_sa_path_rec *rec,
 			 struct ib_ah_attr *ah_attr);
 
+/**
+ * ib_sa_unpack_path - Convert a path record from MAD format to struct
+ * ib_sa_path_rec.
+ */
+void ib_sa_unpack_path(void *attribute, struct ib_sa_path_rec *rec);
+
 #endif /* IB_SA_H */
diff --git a/include/rdma/ib_user_sa.h b/include/rdma/ib_user_sa.h
index 6591201..c2c2504 100644
--- a/include/rdma/ib_user_sa.h
+++ b/include/rdma/ib_user_sa.h
@@ -35,6 +35,20 @@
 
 #include <linux/types.h>
 
+enum {
+	IB_PATH_GMP	  = 1,
+	IB_PATH_PRIMARY   = (1<<1),
+	IB_PATH_ALTERNATE = (1<<2),
+	IB_PATH_OUTBOUND  = (1<<3),
+	IB_PATH_INBOUND   = (1<<4)
+};
+
+struct ib_path_rec_data {
+	__u32	flags;
+	__u32	reserved;
+	__u32	path_rec[16];
+};
+
 struct ib_user_path_rec {
 	__u8	dgid[16];
 	__u8	sgid[16];
diff --git a/include/rdma/rdma_user_cm.h b/include/rdma/rdma_user_cm.h
index c557054..d7829f4 100644
--- a/include/rdma/rdma_user_cm.h
+++ b/include/rdma/rdma_user_cm.h
@@ -215,12 +215,15 @@ struct rdma_ucm_event_resp {
 
 /* Option levels */
 enum {
-	RDMA_OPTION_ID		= 0
+	RDMA_OPTION_ID		= 0,
+	RDMA_OPTION_IB		= 1
 };
 
 /* Option details */
 enum {
-	RDMA_OPTION_ID_TOS	= 0
+	RDMA_OPTION_ID_TOS	= 0,
+
+	RDMA_OPTION_IB_PATH	= 1
 };
 
 struct rdma_ucm_set_option {



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
