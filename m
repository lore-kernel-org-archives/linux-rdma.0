From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/4] verbs: Replace infiniband/sa-kern-abi.h with the kernel's uapi/rdma/ib_user_sa.h
Date: Thu, 27 Oct 2016 17:06:09 -0600
Message-ID: <1477609570-8087-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1477609570-8087-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477609570-8087-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Using the system header from the kernel is now the expected way to export
definitions to user space. Tree wide update to shift from the local
header and deal with the name changes.

Unfortunately this was exposed as a public installed header, for
now drop in a compat header with a #warning not to use it. Some
day we can delete it.

Apps are expected to also migrate to rdma/ib_user_sa.h as their
source for this information.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibcm/cm.c             |  8 ++++----
 libibverbs/marshall.c    |  4 ++--
 libibverbs/marshall.h    |  6 +++---
 libibverbs/sa-kern-abi.h | 34 +++++-----------------------------
 librdmacm/rdma_cma_abi.h |  4 ++--
 5 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/libibcm/cm.c b/libibcm/cm.c
index f775923aa73c..5bc521be5e3a 100644
--- a/libibcm/cm.c
+++ b/libibcm/cm.c
@@ -380,8 +380,8 @@ int ib_cm_listen(struct ib_cm_id *cm_id,
 
 int ib_cm_send_req(struct ib_cm_id *cm_id, struct ib_cm_req_param *param)
 {
-	struct ibv_kern_path_rec p_path;
-	struct ibv_kern_path_rec *a_path;
+	struct ib_user_path_rec p_path;
+	struct ib_user_path_rec *a_path;
 	struct cm_abi_req *cmd;
 	void *msg;
 	int result;
@@ -646,7 +646,7 @@ int ib_cm_send_lap(struct ib_cm_id *cm_id,
 		   void *private_data,
 		   uint8_t private_data_len)
 {
-	struct ibv_kern_path_rec abi_path;
+	struct ib_user_path_rec abi_path;
 	struct cm_abi_lap *cmd;
 	void *msg;
 	int result;
@@ -673,7 +673,7 @@ int ib_cm_send_lap(struct ib_cm_id *cm_id,
 int ib_cm_send_sidr_req(struct ib_cm_id *cm_id,
 			struct ib_cm_sidr_req_param *param)
 {
-	struct ibv_kern_path_rec abi_path;
+	struct ib_user_path_rec abi_path;
 	struct cm_abi_sidr_req *cmd;
 	void *msg;
 	int result;
diff --git a/libibverbs/marshall.c b/libibverbs/marshall.c
index a33048404d35..5b0260832ca7 100644
--- a/libibverbs/marshall.c
+++ b/libibverbs/marshall.c
@@ -90,7 +90,7 @@ void ibv_copy_qp_attr_from_kern(struct ibv_qp_attr *dst,
 }
 
 void ibv_copy_path_rec_from_kern(struct ibv_sa_path_rec *dst,
-				 struct ibv_kern_path_rec *src)
+				 struct ib_user_path_rec *src)
 {
 	memcpy(dst->dgid.raw, src->dgid, sizeof dst->dgid);
 	memcpy(dst->sgid.raw, src->sgid, sizeof dst->sgid);
@@ -114,7 +114,7 @@ void ibv_copy_path_rec_from_kern(struct ibv_sa_path_rec *dst,
 	dst->packet_life_time_selector = src->packet_life_time_selector;
 }
 
-void ibv_copy_path_rec_to_kern(struct ibv_kern_path_rec *dst,
+void ibv_copy_path_rec_to_kern(struct ib_user_path_rec *dst,
 			       struct ibv_sa_path_rec *src)
 {
 	memcpy(dst->dgid, src->dgid.raw, sizeof src->dgid);
diff --git a/libibverbs/marshall.h b/libibverbs/marshall.h
index 8be76c5444d2..1dab1114a58c 100644
--- a/libibverbs/marshall.h
+++ b/libibverbs/marshall.h
@@ -36,7 +36,7 @@
 #include <infiniband/verbs.h>
 #include <infiniband/sa.h>
 #include <infiniband/kern-abi.h>
-#include <infiniband/sa-kern-abi.h>
+#include <rdma/ib_user_sa.h>
 
 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -55,9 +55,9 @@ void ibv_copy_ah_attr_from_kern(struct ibv_ah_attr *dst,
 				struct ibv_kern_ah_attr *src);
 
 void ibv_copy_path_rec_from_kern(struct ibv_sa_path_rec *dst,
-				 struct ibv_kern_path_rec *src);
+				 struct ib_user_path_rec *src);
 
-void ibv_copy_path_rec_to_kern(struct ibv_kern_path_rec *dst,
+void ibv_copy_path_rec_to_kern(struct ib_user_path_rec *dst,
 			       struct ibv_sa_path_rec *src);
 
 END_C_DECLS
diff --git a/libibverbs/sa-kern-abi.h b/libibverbs/sa-kern-abi.h
index 4927d114ea0f..134aeccb4a0a 100644
--- a/libibverbs/sa-kern-abi.h
+++ b/libibverbs/sa-kern-abi.h
@@ -1,6 +1,4 @@
 /*
- * Copyright (c) 2005 Intel Corporation.  All rights reserved.
- *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
  * General Public License (GPL) Version 2, available from the file
@@ -33,33 +31,11 @@
 #ifndef INFINIBAND_SA_KERN_ABI_H
 #define INFINIBAND_SA_KERN_ABI_H
 
-#include <linux/types.h>
+#warning "This header is obsolete, use rdma/ib_user_sa.h instead"
 
-/*
- * Obsolete, deprecated names.  Will be removed in libibverbs 1.1.
- */
-#define ib_kern_path_rec	ibv_kern_path_rec
+#include <rdma/ib_user_sa.h>
 
-struct ibv_kern_path_rec {
-	__u8  dgid[16];
-	__u8  sgid[16];
-	__u16 dlid;
-	__u16 slid;
-	__u32 raw_traffic;
-	__u32 flow_label;
-	__u32 reversible;
-	__u32 mtu;
-	__u16 pkey;
-	__u8  hop_limit;
-	__u8  traffic_class;
-	__u8  numb_path;
-	__u8  sl;
-	__u8  mtu_selector;
-	__u8  rate_selector;
-	__u8  rate;
-	__u8  packet_life_time_selector;
-	__u8  packet_life_time;
-	__u8  preference;
-};
+#define ib_kern_path_rec ib_user_path_rec
+#define ibv_kern_path_rec ib_user_path_rec
 
-#endif /* INFINIBAND_SA_KERN_ABI_H */
+#endif
diff --git a/librdmacm/rdma_cma_abi.h b/librdmacm/rdma_cma_abi.h
index b72f33080b42..71b93f888cc8 100644
--- a/librdmacm/rdma_cma_abi.h
+++ b/librdmacm/rdma_cma_abi.h
@@ -34,7 +34,7 @@
 #define RDMA_CMA_ABI_H
 
 #include <infiniband/kern-abi.h>
-#include <infiniband/sa-kern-abi.h>
+#include <rdma/ib_user_sa.h>
 #include <infiniband/sa.h>
 
 /*
@@ -173,7 +173,7 @@ struct ucma_abi_query {
 
 struct ucma_abi_query_route_resp {
 	__u64 node_guid;
-	struct ibv_kern_path_rec ib_route[2];
+	struct ib_user_path_rec ib_route[2];
 	struct sockaddr_in6 src_addr;
 	struct sockaddr_in6 dst_addr;
 	__u32 num_paths;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
