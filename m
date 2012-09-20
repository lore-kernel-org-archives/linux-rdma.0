From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 2/3] Add helpers to deal with new InfiniBand link speeds
Date: Thu, 20 Sep 2012 23:30:33 +0300
Message-ID: <1348173034-11929-3-git-send-email-ogerlitz@mellanox.com>
References: <1348173034-11929-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348173034-11929-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Introduce support for the following extended speeds:

FDR:    IBA extended speed 14.0625 Gbps.
EDR:    IBA extended speed 25.78125 Gbps.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am                |    6 +++-
 include/infiniband/verbs.h |   23 ++++++++++++++++++++-
 man/ibv_rate_to_mbps.3     |   45 +++++++++++++++++++++++++++++++++++++++++
 src/libibverbs.map         |    3 ++
 src/verbs.c                |   48 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 122 insertions(+), 3 deletions(-)
 create mode 100644 man/ibv_rate_to_mbps.3

diff --git a/Makefile.am b/Makefile.am
index cd00a65..40e83be 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -54,7 +54,7 @@ man_MANS = man/ibv_asyncwatch.1 man/ibv_devices.1 man/ibv_devinfo.1	\
     man/ibv_post_srq_recv.3 man/ibv_query_device.3 man/ibv_query_gid.3	\
     man/ibv_query_pkey.3 man/ibv_query_port.3 man/ibv_query_qp.3	\
     man/ibv_query_srq.3 man/ibv_rate_to_mult.3 man/ibv_reg_mr.3		\
-    man/ibv_req_notify_cq.3 man/ibv_resize_cq.3
+    man/ibv_req_notify_cq.3 man/ibv_resize_cq.3 man/ibv_rate_to_mbps.3
 
 DEBIAN = debian/changelog debian/compat debian/control debian/copyright \
     debian/ibverbs-utils.install debian/libibverbs1.install \
@@ -88,6 +88,7 @@ install-data-hook:
 	$(RM) mult_to_ibv_rate.3 && \
 	$(RM) ibv_node_type_str.3 && \
 	$(RM) ibv_port_state_str.3 && \
+	$(RM) mbps_to_ibv_rate.3 && \
 	$(LN_S) ibv_get_async_event.3 ibv_ack_async_event.3 && \
 	$(LN_S) ibv_get_cq_event.3 ibv_ack_cq_events.3 && \
 	$(LN_S) ibv_open_device.3 ibv_close_device.3 && \
@@ -103,4 +104,5 @@ install-data-hook:
 	$(LN_S) ibv_create_ah_from_wc.3 ibv_init_ah_from_wc.3 && \
 	$(LN_S) ibv_rate_to_mult.3 mult_to_ibv_rate.3 && \
 	$(LN_S) ibv_event_type_str.3 ibv_node_type_str.3 && \
-	$(LN_S) ibv_event_type_str.3 ibv_port_state_str.3
+	$(LN_S) ibv_event_type_str.3 ibv_port_state_str.3 && \
+	$(LN_S) ibv_rate_to_mbps.3 mbps_to_ibv_rate.3
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 8ed8a66..4b1ab57 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -353,7 +353,15 @@ enum ibv_rate {
 	IBV_RATE_40_GBPS  = 7,
 	IBV_RATE_60_GBPS  = 8,
 	IBV_RATE_80_GBPS  = 9,
-	IBV_RATE_120_GBPS = 10
+	IBV_RATE_120_GBPS = 10,
+	IBV_RATE_14_GBPS  = 11,
+	IBV_RATE_56_GBPS  = 12,
+	IBV_RATE_112_GBPS = 13,
+	IBV_RATE_168_GBPS = 14,
+	IBV_RATE_25_GBPS  = 15,
+	IBV_RATE_100_GBPS = 16,
+	IBV_RATE_200_GBPS = 17,
+	IBV_RATE_300_GBPS = 18
 };
 
 /**
@@ -370,6 +378,19 @@ int ibv_rate_to_mult(enum ibv_rate rate) __attribute_const;
  */
 enum ibv_rate mult_to_ibv_rate(int mult) __attribute_const;
 
+/**
+ * ibv_rate_to_mbps - Convert the IB rate enum to Mbit/sec.
+ * For example, IBV_RATE_5_GBPS will return the value 5000.
+ * @rate: rate to convert.
+ */
+int ibv_rate_to_mbps(enum ibv_rate rate) __attribute_const;
+
+/**
+ * mbps_to_ibv_rate - Convert a Mbit/sec value to an IB rate enum.
+ * @mbps: value to convert.
+ */
+enum ibv_rate mbps_to_ibv_rate(int mbps) __attribute_const;
+
 struct ibv_ah_attr {
 	struct ibv_global_route	grh;
 	uint16_t		dlid;
diff --git a/man/ibv_rate_to_mbps.3 b/man/ibv_rate_to_mbps.3
new file mode 100644
index 0000000..089db01
--- /dev/null
+++ b/man/ibv_rate_to_mbps.3
@@ -0,0 +1,45 @@
+.\" -*- nroff -*-
+.\"
+.TH IBV_RATE_TO_MBPS 3 2012-03-31 libibverbs "Libibverbs Programmer's Manual"
+.SH "NAME"
+.nf
+ibv_rate_to_mbps \- convert IB rate enumeration to Mbit/sec
+.sp
+mbps_to_ibv_rate \- convert Mbit/sec to an IB rate enumeration
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/verbs.h>
+.sp
+.BI "int ibv_rate_to_mbps(enum ibv_rate " "rate" ");
+.sp
+.BI "enum ibv_rate mbps_to_ibv_rate(int " "mbps" ");
+.fi
+.SH "DESCRIPTION"
+.B ibv_rate_to_mbps()
+converts the IB transmission rate enumeration
+.I rate
+to a number of Mbit/sec. For example, if
+.I rate
+is
+.BR IBV_RATE_5_GBPS\fR,
+the value 5000 will be returned (5 Gbit/sec = 5000 Mbit/sec).
+.PP
+.B mbps_to_ibv_rate()
+converts the number of Mbit/sec
+.I mult
+to an IB transmission rate enumeration. For example, if
+.I mult
+is 5000, the rate enumeration
+.BR IBV_RATE_5_GBPS
+will be returned.
+.SH "RETURN VALUE"
+.B ibv_rate_to_mbps()
+returns the number of Mbit/sec.
+.PP
+.B mbps_to_ibv_rate()
+returns the enumeration representing the IB transmission rate.
+.SH "SEE ALSO"
+.BR ibv_query_port (3)
+.SH "AUTHORS"
+.TP
+Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 1827da0..7e722f4 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -96,4 +96,7 @@ IBVERBS_1.1 {
 		ibv_port_state_str;
 		ibv_event_type_str;
 		ibv_wc_status_str;
+
+		ibv_rate_to_mbps;
+		mbps_to_ibv_rate;
 } IBVERBS_1.0;
diff --git a/src/verbs.c b/src/verbs.c
index b5938f2..a6aae70 100644
--- a/src/verbs.c
+++ b/src/verbs.c
@@ -76,6 +76,54 @@ enum ibv_rate mult_to_ibv_rate(int mult)
 	}
 }
 
+int ibv_rate_to_mbps(enum ibv_rate rate)
+{
+	switch (rate) {
+	case IBV_RATE_2_5_GBPS: return 2500;
+	case IBV_RATE_5_GBPS:   return 5000;
+	case IBV_RATE_10_GBPS:  return 10000;
+	case IBV_RATE_20_GBPS:  return 20000;
+	case IBV_RATE_30_GBPS:  return 30000;
+	case IBV_RATE_40_GBPS:  return 40000;
+	case IBV_RATE_60_GBPS:  return 60000;
+	case IBV_RATE_80_GBPS:  return 80000;
+	case IBV_RATE_120_GBPS: return 120000;
+	case IBV_RATE_14_GBPS:  return 14062;
+	case IBV_RATE_56_GBPS:  return 56250;
+	case IBV_RATE_112_GBPS: return 112500;
+	case IBV_RATE_168_GBPS: return 168750;
+	case IBV_RATE_25_GBPS:  return 25781;
+	case IBV_RATE_100_GBPS: return 103125;
+	case IBV_RATE_200_GBPS: return 206250;
+	case IBV_RATE_300_GBPS: return 309375;
+	default:               return -1;
+	}
+}
+
+enum ibv_rate mbps_to_ibv_rate(int mbps)
+{
+	switch (mbps) {
+	case 2500:   return IBV_RATE_2_5_GBPS;
+	case 5000:   return IBV_RATE_5_GBPS;
+	case 10000:  return IBV_RATE_10_GBPS;
+	case 20000:  return IBV_RATE_20_GBPS;
+	case 30000:  return IBV_RATE_30_GBPS;
+	case 40000:  return IBV_RATE_40_GBPS;
+	case 60000:  return IBV_RATE_60_GBPS;
+	case 80000:  return IBV_RATE_80_GBPS;
+	case 120000: return IBV_RATE_120_GBPS;
+	case 14062:  return IBV_RATE_14_GBPS;
+	case 56250:  return IBV_RATE_56_GBPS;
+	case 112500: return IBV_RATE_112_GBPS;
+	case 168750: return IBV_RATE_168_GBPS;
+	case 25781:  return IBV_RATE_25_GBPS;
+	case 103125: return IBV_RATE_100_GBPS;
+	case 206250: return IBV_RATE_200_GBPS;
+	case 309375: return IBV_RATE_300_GBPS;
+	default:     return IBV_RATE_MAX;
+	}
+}
+
 int __ibv_query_device(struct ibv_context *context,
 		       struct ibv_device_attr *device_attr)
 {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
