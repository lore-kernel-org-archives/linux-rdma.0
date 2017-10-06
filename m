From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 47/47] RDMA/usnic: Instantiate data structures once
Date: Fri,  6 Oct 2017 14:33:33 -0700
Message-ID: <20171006213333.6721-48-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Data structures should not be defined in a header file. Hence move
the min_transport_spec[] definition from a header file to a .c file.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h | 25 +------------------------
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c  | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
index b1458be1d402..a8a2314c9531 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
@@ -84,30 +84,7 @@ struct usnic_ib_qp_grp_flow {
 	char				dentry_name[32];
 };
 
-static const struct
-usnic_vnic_res_spec min_transport_spec[USNIC_TRANSPORT_MAX] = {
-	{ /*USNIC_TRANSPORT_UNKNOWN*/
-		.resources = {
-			{.type = USNIC_VNIC_RES_TYPE_EOL,	.cnt = 0,},
-		},
-	},
-	{ /*USNIC_TRANSPORT_ROCE_CUSTOM*/
-		.resources = {
-			{.type = USNIC_VNIC_RES_TYPE_WQ,	.cnt = 1,},
-			{.type = USNIC_VNIC_RES_TYPE_RQ,	.cnt = 1,},
-			{.type = USNIC_VNIC_RES_TYPE_CQ,	.cnt = 1,},
-			{.type = USNIC_VNIC_RES_TYPE_EOL,	.cnt = 0,},
-		},
-	},
-	{ /*USNIC_TRANSPORT_IPV4_UDP*/
-		.resources = {
-			{.type = USNIC_VNIC_RES_TYPE_WQ,	.cnt = 1,},
-			{.type = USNIC_VNIC_RES_TYPE_RQ,	.cnt = 1,},
-			{.type = USNIC_VNIC_RES_TYPE_CQ,	.cnt = 1,},
-			{.type = USNIC_VNIC_RES_TYPE_EOL,	.cnt = 0,},
-		},
-	},
-};
+extern const struct usnic_vnic_res_spec min_transport_spec[USNIC_TRANSPORT_MAX];
 
 const char *usnic_ib_qp_grp_state_to_string(enum ib_qp_state state);
 int usnic_ib_qp_grp_dump_hdr(char *buf, int buf_sz);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 8372c32485ad..aa2456a4f9bd 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -51,6 +51,30 @@
 
 #define USNIC_DEFAULT_TRANSPORT USNIC_TRANSPORT_ROCE_CUSTOM
 
+const struct usnic_vnic_res_spec min_transport_spec[USNIC_TRANSPORT_MAX] = {
+	{ /*USNIC_TRANSPORT_UNKNOWN*/
+		.resources = {
+			{.type = USNIC_VNIC_RES_TYPE_EOL,	.cnt = 0,},
+		},
+	},
+	{ /*USNIC_TRANSPORT_ROCE_CUSTOM*/
+		.resources = {
+			{.type = USNIC_VNIC_RES_TYPE_WQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_RQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_CQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_EOL,	.cnt = 0,},
+		},
+	},
+	{ /*USNIC_TRANSPORT_IPV4_UDP*/
+		.resources = {
+			{.type = USNIC_VNIC_RES_TYPE_WQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_RQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_CQ,	.cnt = 1,},
+			{.type = USNIC_VNIC_RES_TYPE_EOL,	.cnt = 0,},
+		},
+	},
+};
+
 static void usnic_ib_fw_string_to_u64(char *fw_ver_str, u64 *fw_ver)
 {
 	*fw_ver = *((u64 *)fw_ver_str);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
