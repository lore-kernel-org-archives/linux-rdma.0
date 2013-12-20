From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 08/15] IB/usnic: Remove duplicate and unnecessary consts
Date: Fri, 20 Dec 2013 12:26:39 -0800
Message-ID: <1387571206-8043-9-git-send-email-umalhi@cisco.com>
References: <1387571206-8043-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387571206-8043-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sparse, https://lists.01.org/pipermail/kbuild/2013-December/000877.html,
gave lots of duplicate const warnings.  Remove the duplicate const as well
as the original const bc both consts are unnecessary.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 19 +++++++++----------
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h | 12 +++++-------
 drivers/infiniband/hw/usnic/usnic_vnic.c      | 12 +++++-------
 drivers/infiniband/hw/usnic/usnic_vnic.h      | 12 +++++-------
 4 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index ad57a77..b5fb4d4 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -332,8 +332,8 @@ int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
 }
 
 struct usnic_vnic_res_chunk**
-alloc_res_chunk_list(struct usnic_vnic *vnic, const struct usnic_vnic_res_spec
-			const *res_spec, void *owner_obj)
+alloc_res_chunk_list(struct usnic_vnic *vnic,
+			struct usnic_vnic_res_spec *res_spec, void *owner_obj)
 {
 	enum usnic_vnic_res_type res_type;
 	struct usnic_vnic_res_chunk **res_chunk_list;
@@ -427,20 +427,19 @@ static void qp_grp_and_vf_unbind(struct usnic_ib_qp_grp *qp_grp)
 	qp_grp->vf = NULL;
 }
 
-static void log_spec(const struct usnic_vnic_res_spec
-					const *res_spec)
+static void log_spec(struct usnic_vnic_res_spec *res_spec)
 {
 	char buf[512];
 	usnic_vnic_spec_dump(buf, sizeof(buf), res_spec);
 	usnic_dbg("%s\n", buf);
 }
 
-struct usnic_ib_qp_grp *usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev,
-				struct usnic_ib_vf *vf,
-				struct usnic_ib_pd *pd,
-				const struct usnic_vnic_res_spec
-				const *res_spec,
-				enum usnic_transport_type transport)
+struct usnic_ib_qp_grp *
+usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev,
+			struct usnic_ib_vf *vf,
+			struct usnic_ib_pd *pd,
+			struct usnic_vnic_res_spec *res_spec,
+			enum usnic_transport_type transport)
 {
 	struct usnic_ib_qp_grp *qp_grp;
 	u16 port_num;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
index 37423f8..6416a95 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
@@ -75,13 +75,11 @@ usnic_vnic_res_spec min_transport_spec[USNIC_TRANSPORT_MAX] = {
 const char *usnic_ib_qp_grp_state_to_string(enum ib_qp_state state);
 int usnic_ib_qp_grp_dump_hdr(char *buf, int buf_sz);
 int usnic_ib_qp_grp_dump_rows(void *obj, char *buf, int buf_sz);
-struct usnic_ib_qp_grp *usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev,
-						struct usnic_ib_vf *vf,
-						struct usnic_ib_pd *pd,
-						const struct usnic_vnic_res_spec
-						const *res_spec,
-						enum usnic_transport_type
-							transport);
+struct usnic_ib_qp_grp *
+usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev, struct usnic_ib_vf *vf,
+			struct usnic_ib_pd *pd,
+			struct usnic_vnic_res_spec *res_spec,
+			enum usnic_transport_type transport);
 void usnic_ib_qp_grp_destroy(struct usnic_ib_qp_grp *qp_grp);
 int usnic_ib_qp_grp_modify(struct usnic_ib_qp_grp *qp_grp,
 				enum ib_qp_state new_state,
diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.c b/drivers/infiniband/hw/usnic/usnic_vnic.c
index 02d66d9..5a50acb 100644
--- a/drivers/infiniband/hw/usnic/usnic_vnic.c
+++ b/drivers/infiniband/hw/usnic/usnic_vnic.c
@@ -138,10 +138,8 @@ void usnic_vnic_res_spec_update(struct usnic_vnic_res_spec *spec,
 	WARN_ON(1);
 }
 
-int usnic_vnic_res_spec_satisfied(const struct usnic_vnic_res_spec
-					const *min_spec,
-					const struct usnic_vnic_res_spec
-					const *res_spec)
+int usnic_vnic_res_spec_satisfied(const struct usnic_vnic_res_spec *min_spec,
+					struct usnic_vnic_res_spec *res_spec)
 {
 	int found, i, j;
 
@@ -165,8 +163,8 @@ int usnic_vnic_res_spec_satisfied(const struct usnic_vnic_res_spec
 	return 0;
 }
 
-int usnic_vnic_spec_dump(char *buf, int buf_sz, const struct usnic_vnic_res_spec
-						const *res_spec)
+int usnic_vnic_spec_dump(char *buf, int buf_sz,
+				struct usnic_vnic_res_spec *res_spec)
 {
 	enum usnic_vnic_res_type res_type;
 	int res_cnt;
@@ -186,7 +184,7 @@ int usnic_vnic_spec_dump(char *buf, int buf_sz, const struct usnic_vnic_res_spec
 }
 
 int usnic_vnic_check_room(struct usnic_vnic *vnic,
-			const struct usnic_vnic_res_spec const *res_spec)
+				struct usnic_vnic_res_spec *res_spec)
 {
 	int i;
 	enum usnic_vnic_res_type res_type;
diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.h b/drivers/infiniband/hw/usnic/usnic_vnic.h
index 0a69a5d..14d931a 100644
--- a/drivers/infiniband/hw/usnic/usnic_vnic.h
+++ b/drivers/infiniband/hw/usnic/usnic_vnic.h
@@ -77,14 +77,12 @@ int usnic_vnic_dump(struct usnic_vnic *vnic, char *buf, int buf_sz,
 void usnic_vnic_res_spec_update(struct usnic_vnic_res_spec *spec,
 				enum usnic_vnic_res_type trgt_type,
 				u16 cnt);
-int usnic_vnic_res_spec_satisfied(const struct usnic_vnic_res_spec
-					const *min_spec,
-					const struct usnic_vnic_res_spec
-					const *res_spec);
-int usnic_vnic_spec_dump(char *buf, int buf_sz, const struct usnic_vnic_res_spec
-						const *res_spec);
+int usnic_vnic_res_spec_satisfied(const struct usnic_vnic_res_spec *min_spec,
+					struct usnic_vnic_res_spec *res_spec);
+int usnic_vnic_spec_dump(char *buf, int buf_sz,
+				struct usnic_vnic_res_spec *res_spec);
 int usnic_vnic_check_room(struct usnic_vnic *vnic,
-			const struct usnic_vnic_res_spec const *res_spec);
+				struct usnic_vnic_res_spec *res_spec);
 int usnic_vnic_res_cnt(struct usnic_vnic *vnic,
 				enum usnic_vnic_res_type type);
 int usnic_vnic_res_free_cnt(struct usnic_vnic *vnic,
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
