From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_subnet.c: Fix bug in parsing configuration file
Date: Mon, 24 Mar 2014 14:06:09 -0400
Message-ID: <53307411.2090605@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Sun, 16 Mar 2014 17:35:13 +0200

Added handling a non numeric input for a numeric field
(of the opensm configuration file) and a range check for those
parameters.

Signed-off-by: Tomer Cohen <tomerco-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_subnet.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index aedfbd5..61e1fc2 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -275,12 +275,56 @@ static void opts_setup_sm_priority(osm_subn_t *p_subn, void *p_val)
 	osm_set_sm_priority(p_sm, sm_priority);
 }
 
+static int opts_strtoul(uint32_t *val, IN char *p_val_str,
+			IN char *p_key, uint32_t max_value)
+{
+	char *endptr;
+	unsigned long int tmp_val;
+
+	tmp_val = strtoul(p_val_str, &endptr, 0);
+	*val = tmp_val;
+	if (*p_val_str == '\0' || *endptr != '\0') {
+		log_report("-E- Parsing error in field %s, expected "
+			   "numeric input received: %s\n", p_key, p_val_str);
+		return -1;
+	}
+	if (tmp_val > max_value ||
+	    ((tmp_val == ULONG_MAX) && errno == ERANGE)) {
+		log_report("-E- Parsing error in field %s, value out of range\n", p_key);
+		return -1;
+	}
+	return 0;
+}
+
+static int opts_strtoull(uint64_t *val, IN char *p_val_str,
+			 IN char *p_key, uint64_t max_value)
+{
+	char *endptr;
+	unsigned long long int tmp_val;
+
+	tmp_val = strtoull(p_val_str, &endptr, 0);
+	*val = tmp_val;
+	if (*p_val_str == '\0' || *endptr != '\0') {
+		log_report("-E- Parsing error in field %s, expected "
+			   "numeric input received: %s\n", p_key, p_val_str);
+		return -1;
+	}
+	if (tmp_val > max_value || (tmp_val == ULLONG_MAX && errno == ERANGE)) {
+		log_report("-E- Parsing error in field %s, value out of range", p_key);
+		return -1;
+	}
+	return 0;
+}
+
 static void opts_parse_net64(IN osm_subn_t *p_subn, IN char *p_key,
 			     IN char *p_val_str, void *p_v1, void *p_v2,
 			     void (*pfn)(osm_subn_t *, void *))
 {
 	uint64_t *p_val1 = p_v1, *p_val2 = p_v2;
-	uint64_t val = strtoull(p_val_str, NULL, 0);
+	uint64_t val;
+
+	if (opts_strtoull(&val, p_val_str, p_key, UINT64_MAX))
+		return;
 
 	if (cl_hton64(val) != *p_val1) {
 		log_config_value(p_key, "0x%016" PRIx64, val);
@@ -295,7 +339,10 @@ static void opts_parse_uint32(IN osm_subn_t *p_subn, IN char *p_key,
 			      void (*pfn)(osm_subn_t *, void *))
 {
 	uint32_t *p_val1 = p_v1, *p_val2 = p_v2;
-	uint32_t val = strtoul(p_val_str, NULL, 0);
+	uint32_t val;
+
+	if (opts_strtoul(&val, p_val_str, p_key, UINT32_MAX))
+		return;
 
 	if (val != *p_val1) {
 		log_config_value(p_key, "%u", val);
@@ -310,7 +357,10 @@ static void opts_parse_net32(IN osm_subn_t *p_subn, IN char *p_key,
 			     void (*pfn)(osm_subn_t *, void *))
 {
 	uint32_t *p_val1 = p_v1, *p_val2 = p_v2;
-	uint32_t val = strtoul(p_val_str, NULL, 0);
+	uint32_t val;
+
+	if (opts_strtoul(&val, p_val_str, p_key, UINT32_MAX))
+		return;
 
 	if (cl_hton32(val) != *p_val1) {
 		log_config_value(p_key, "%u", val);
@@ -320,7 +370,6 @@ static void opts_parse_net32(IN osm_subn_t *p_subn, IN char *p_key,
 	}
 }
 
-
 static void opts_parse_int32(IN osm_subn_t *p_subn, IN char *p_key,
 			     IN char *p_val_str, void *p_v1, void *p_v2,
 			     void (*pfn)(osm_subn_t *, void *))
@@ -341,8 +390,12 @@ static void opts_parse_uint16(IN osm_subn_t *p_subn, IN char *p_key,
 			      void (*pfn)(osm_subn_t *, void *))
 {
 	uint16_t *p_val1 = p_v1, *p_val2 = p_v2;
-	uint16_t val = (uint16_t) strtoul(p_val_str, NULL, 0);
+	uint32_t tmp_val;
+
+	if (opts_strtoul(&tmp_val, p_val_str, p_key, UINT16_MAX))
+		return;
 
+	uint16_t val = (uint16_t) tmp_val;
 	if (val != *p_val1) {
 		log_config_value(p_key, "%u", val);
 		if (pfn)
@@ -356,8 +409,12 @@ static void opts_parse_net16(IN osm_subn_t *p_subn, IN char *p_key,
 			     void (*pfn)(osm_subn_t *, void *))
 {
 	uint16_t *p_val1 = p_v1, *p_val2 = p_v2;
-	uint16_t val = strtoul(p_val_str, NULL, 0);
+	uint32_t tmp_val;
 
+	if (opts_strtoul(&tmp_val, p_val_str, p_key, UINT16_MAX))
+		return;
+
+	uint16_t val = (uint16_t) tmp_val;
 	if (cl_hton16(val) != *p_val1) {
 		log_config_value(p_key, "0x%04x", val);
 		if (pfn)
@@ -371,8 +428,12 @@ static void opts_parse_uint8(IN osm_subn_t *p_subn, IN char *p_key,
 			     void (*pfn)(osm_subn_t *, void *))
 {
 	uint8_t *p_val1 = p_v1, *p_val2 = p_v2;
-	uint8_t val = strtoul(p_val_str, NULL, 0);
+	uint32_t tmp_val;
+
+	if (opts_strtoul(&tmp_val, p_val_str, p_key, UINT8_MAX))
+		return;
 
+	uint8_t val = (uint8_t) tmp_val;
 	if (val != *p_val1) {
 		log_config_value(p_key, "%u", val);
 		if (pfn)
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
