From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: add human readable output for data
 counters
Date: Tue, 23 Aug 2011 09:17:15 -0700
Message-ID: <20110823091715.5d291b34.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



conversion function is provided in ibdiag_common

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    7 +++++
 src/ibdiag_common.c     |   66 +++++++++++++++++++++++++++++++++++++++++++++++
 src/ibqueryerrors.c     |   30 ++++++++++++++++++---
 3 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 2425c94..6586cc6 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -86,6 +86,13 @@ extern int ibdiag_process_opts(int argc, char *const argv[], void *context,
 extern void ibdiag_show_usage();
 extern void iberror(const char *fn, char *msg, ...);
 
+/* convert counter values to a float with a unit specifier returned (using
+ * binary prefix)
+ * "data" is a flag indicating this counter is a byte counter multiplied by 4
+ * as per PortCounters[Extended]
+ */
+extern char *conv_cnt_human_readable(uint64_t val64, float *val, int data);
+
 /* define an SA query structure to be common
  * This is by no means optimal but it moves the saquery functionality out of
  * the saquery tool and provides it to other utilities.
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index e231af2..74960e1 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -342,6 +342,72 @@ void iberror(const char *fn, char *msg, ...)
 	exit(-1);
 }
 
+char *
+conv_cnt_human_readable(uint64_t val64, float *val, int data)
+{
+	uint64_t tmp = val64;
+	int ui = 0;
+	int div = 1;
+
+	tmp /= 1024;
+	while (tmp) {
+		ui++;
+		tmp /= 1024;
+		div *= 1024;
+	}
+
+	*val = (float)(val64);
+	if (data) {
+		*val *= 4;
+		if (*val/div > 1024) {
+			ui++;
+			div *= 1024;
+		}
+	}
+	*val /= div;
+
+	if (data) {
+		switch (ui) {
+			case 0:
+				return ("B");
+			case 1:
+				return ("KB");
+			case 2:
+				return ("MB");
+			case 3:
+				return ("GB");
+			case 4:
+				return ("TB");
+			case 5:
+				return ("PB");
+			case 6:
+				return ("EB");
+			default:
+				return ("");
+		}
+	} else {
+		switch (ui) {
+			case 0:
+				return ("");
+			case 1:
+				return ("K");
+			case 2:
+				return ("M");
+			case 3:
+				return ("G");
+			case 4:
+				return ("T");
+			case 5:
+				return ("P");
+			case 6:
+				return ("E");
+			default:
+				return ("");
+		}
+	}
+	return ("");
+}
+
 /* define a common SA query structure
  * This is by no means optimal but it moves the saquery functionality out of
  * the saquery tool and provides it to other utilities.
diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
index 6de3d6f..83e3eb8 100644
--- a/src/ibqueryerrors.c
+++ b/src/ibqueryerrors.c
@@ -311,6 +311,7 @@ static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
 	return n;
 }
 
+
 static int print_results(ib_portid_t * portid, char *node_name,
 			 ibnd_node_t * node, uint8_t * pc, int portnum,
 			 int *header_printed, uint8_t *pce, uint16_t cap_mask)
@@ -378,11 +379,24 @@ static int print_results(ib_portid_t * portid, char *node_name,
 
 			for (i = start_field; i <= end_field; i++) {
 				uint64_t val64 = 0;
+				float val = 0;
+				char *unit = "";
 				mad_decode_field(pkt, i, (void *)&val64);
-				if (val64)
+				if (val64) {
+					int data = 0;
+					if (i == IB_PC_EXT_XMT_BYTES_F ||
+					    i == IB_PC_EXT_RCV_BYTES_F ||
+					    i == IB_PC_XMT_BYTES_F ||
+					    i == IB_PC_RCV_BYTES_F)
+						data = 1;
+					unit = conv_cnt_human_readable(val64,
+								&val, data);
 					n += snprintf(str + n, 1024 - n,
-						" [%s == %" PRIu64 "]",
-						mad_field_name(i), val64);
+						" [%s == %" PRIu64
+						" (%5.3f%s)]",
+						mad_field_name(i), val64, val,
+						unit);
+				}
 			}
 		}
 
@@ -479,8 +493,16 @@ static int print_data_cnts(ib_portid_t * portid, uint16_t cap_mask,
 
 	for (i = start_field; i <= end_field; i++) {
 		uint64_t val64 = 0;
+		float val = 0;
+		char *unit = "";
+		int data = 0;
 		mad_decode_field(pc, i, (void *)&val64);
-		printf(" [%s == %" PRIu64 "]", mad_field_name(i), val64);
+		if (i == IB_PC_EXT_XMT_BYTES_F || i == IB_PC_EXT_RCV_BYTES_F ||
+		    i == IB_PC_XMT_BYTES_F || i == IB_PC_RCV_BYTES_F)
+			data = 1;
+		unit = conv_cnt_human_readable(val64, &val, data);
+		printf(" [%s == %" PRIu64 " (%5.3f%s)]", mad_field_name(i),
+			val64, val, unit);
 	}
 	printf("\n");
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
