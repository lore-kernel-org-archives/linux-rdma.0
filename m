From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] libibumad: Minor fixups for previous umad_str patch
Date: Thu, 07 Mar 2013 06:36:52 -0500
Message-ID: <51387BD4.5070900@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/libibumad.map b/src/libibumad.map
index af68d11..0b39333 100644
--- a/src/libibumad.map
+++ b/src/libibumad.map
@@ -32,7 +32,8 @@ IBUMAD_1.0 {
 		umad_dump;
 		umad_class_str;
 		umad_method_str;
-		umad_mad_status_str;
+		umad_common_mad_status_str;
+		umad_sa_status_str;
 		umad_attribute_str;
 	local: *;
 };
diff --git a/src/umad_str.c b/src/umad_str.c
index 6dca087..957552f 100644
--- a/src/umad_str.c
+++ b/src/umad_str.c
@@ -83,7 +83,7 @@ const char * umad_class_str(uint8_t mgmt_class)
 	return ("<unknown>");
 }
 
-static char * umad_common_method_str(uint8_t method)
+static const char * umad_common_method_str(uint8_t method)
 {
 	switch(method) {
 		case UMAD_METHOD_GET:
@@ -107,7 +107,7 @@ static char * umad_common_method_str(uint8_t method)
 	}
 }
 
-static char * umad_sa_method_str(uint8_t method)
+static const char * umad_sa_method_str(uint8_t method)
 {
 	switch(method) {
 		case UMAD_SA_METHOD_GET_TABLE:
@@ -186,7 +186,7 @@ const char * umad_sa_mad_status_str(be16_t status)
 	return ("Undefined Error");
 }
 
-static char *umad_common_attr_str(be16_t attr_id)
+static const char *umad_common_attr_str(be16_t attr_id)
 {
 	switch(ntohs(attr_id)) {
 		case UMAD_ATTR_CLASS_PORT_INFO:
@@ -200,7 +200,7 @@ static char *umad_common_attr_str(be16_t attr_id)
 	}
 }
 
-static char * umad_sm_attr_str(be16_t attr_id)
+static const char * umad_sm_attr_str(be16_t attr_id)
 {
 	switch(ntohs(attr_id)) {
 		case UMAD_SMP_ATTR_NODE_DESC:
@@ -239,7 +239,7 @@ static char * umad_sm_attr_str(be16_t attr_id)
 	return ("<unknown>");
 }
 
-static char * umad_sa_attr_str(be16_t attr_id)
+static const char * umad_sa_attr_str(be16_t attr_id)
 {
 	switch(ntohs(attr_id)) {
 		case UMAD_SA_ATTR_NODE_REC:
@@ -286,7 +286,7 @@ static char * umad_sa_attr_str(be16_t attr_id)
 	return ("<unknown>");
 }
 
-static char * umad_cm_attr_str(be16_t attr_id)
+static const char * umad_cm_attr_str(be16_t attr_id)
 {
 	switch(ntohs(attr_id)) {
 		case UMAD_CM_ATTR_REQ:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
