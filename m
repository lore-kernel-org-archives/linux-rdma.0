From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/4] mpxyd/mcm: add provider specific attribute DAT_IB_PROXY_VERSION
Date: Fri, 12 Dec 2014 08:50:43 -0800
Message-ID: <1418403043-2221-5-git-send-email-arlin.r.davis@intel.com>
References: <1418403043-2221-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418403043-2221-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_common/util.c      |   31 ++++++++++++++++++++-----------
 dapl/openib_mcm/dapl_ib_util.h |    1 +
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/dapl/openib_common/util.c b/dapl/openib_common/util.c
index d253f6e..b924b64 100644
--- a/dapl/openib_common/util.c
+++ b/dapl/openib_common/util.c
@@ -425,10 +425,11 @@ DAT_RETURN dapls_ib_query_hca(IN DAPL_HCA * hca_ptr,
 			hca_ptr->ib_trans.na.mode = "DIRECT";
 		hca_ptr->ib_trans.na.read = "FALSE";
 
-		if (!hca_ptr->ib_trans.pr_attr.cpu_family && hca_ptr->ib_trans.scif_ep) {
+		if (!hca_ptr->ib_trans.pr_attr.cpu_family && hca_ptr->ib_trans.self.node) {
 			dapli_mix_get_attr(&hca_ptr->ib_trans, &hca_ptr->ib_trans.pr_attr);
 			sprintf(hca_ptr->ib_trans.fam_str, "%d", hca_ptr->ib_trans.pr_attr.cpu_family);
 			sprintf(hca_ptr->ib_trans.mod_str, "%d", hca_ptr->ib_trans.pr_attr.cpu_model);
+			sprintf(hca_ptr->ib_trans.ver_str, "%d", DAT_MIX_VER);
 		}
 #else
 		hca_ptr->ib_trans.na.mode = "DIRECT";
@@ -725,14 +726,6 @@ DAT_NAMED_ATTR ib_attrs[] = {
 	{
 	 "DAT_IB_PORT_STATUS", "UNKNOWN"}
 	,
-#ifdef _OPENIB_MCM_
-	{
-	 "DAT_IB_PROXY_CPU_FAMILY", "UNKNOWN"}
-	,
-	{
-	 "DAT_IB_PROXY_CPU_MODEL", "UNKNOWN"}
-	,
-#endif
 #ifdef DAT_EXTENSIONS
 	{
 	 "DAT_EXTENSION_INTERFACE", "TRUE"}
@@ -778,6 +771,17 @@ DAT_NAMED_ATTR ib_attrs[] = {
 	 DAT_ATTR_COUNTERS, "TRUE"}
 	,
 #endif				/* DAPL_COUNTERS */
+#ifdef _OPENIB_MCM_
+	{
+	 "DAT_IB_PROXY_CPU_FAMILY", "UNKNOWN"}
+	,
+	{
+	 "DAT_IB_PROXY_CPU_MODEL", "UNKNOWN"}
+	,
+	{
+	 "DAT_IB_PROXY_VERSION", "UNKNOWN"}
+	,
+#endif
 #endif
 };
 
@@ -801,8 +805,13 @@ void dapls_query_provider_specific_attr(IN DAPL_IA * ia_ptr,
 	ib_attrs[5].value = ia_ptr->hca_ptr->ib_trans.na.mtu;
 	ib_attrs[6].value = ia_ptr->hca_ptr->ib_trans.na.port;
 #ifdef _OPENIB_MCM_
-	ib_attrs[7].value = ia_ptr->hca_ptr->ib_trans.fam_str;
-	ib_attrs[8].value = ia_ptr->hca_ptr->ib_trans.mod_str;
+	if (ia_ptr->hca_ptr->ib_trans.self.node) { /* only on MIC */
+		int i = attr_ptr->num_provider_specific_attr;
+		ib_attrs[i-3].value = ia_ptr->hca_ptr->ib_trans.fam_str;
+		ib_attrs[i-2].value = ia_ptr->hca_ptr->ib_trans.mod_str;
+		ib_attrs[i-1].value = ia_ptr->hca_ptr->ib_trans.ver_str;
+	} else
+		attr_ptr->num_provider_specific_attr -= 3;
 #endif
 }
 
diff --git a/dapl/openib_mcm/dapl_ib_util.h b/dapl/openib_mcm/dapl_ib_util.h
index dad8212..9d9d73c 100644
--- a/dapl/openib_mcm/dapl_ib_util.h
+++ b/dapl/openib_mcm/dapl_ib_util.h
@@ -150,6 +150,7 @@ typedef struct _ib_hca_transport
 	char 			guid_str[32];
 	char 			fam_str[8];
 	char 			mod_str[8];
+	char 			ver_str[8];
 	ib_named_attr_t		na;
 	dat_mix_prov_attr_t	pr_attr;	/* attributes from proxy */
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
