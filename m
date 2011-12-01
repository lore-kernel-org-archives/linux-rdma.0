From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] infiniband-diags/perfquery.c: Fix reset for PortExtendedSpeedsCounters
Date: Thu, 01 Dec 2011 11:21:20 -0500
Message-ID: <4ED7A980.6050408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/infiniband-diags/src/perfquery.c b/infiniband-diags/src/perfquery.c
index 859ddbb..3ebf1cc 100644
--- a/infiniband-diags/src/perfquery.c
+++ b/infiniband-diags/src/perfquery.c
@@ -401,12 +401,56 @@ static void rcv_err_query(ib_portid_t * portid, int port, int mask)
 		    mad_dump_perfcounters_rcv_err);
 }
 
-static void extended_speeds_query(ib_portid_t * portid, int port, int mask)
+static uint8_t *ext_speeds_reset_via(void *rcvbuf, ib_portid_t * dest,
+				     int port, uint64_t mask, unsigned timeout,
+				     const struct ibmad_port * srcport)
 {
-	common_func(portid, port, mask, !reset_only, (reset_only || reset),
-		    "PortExtendedSpeedsCounters",
-		    IB_GSI_PORT_EXT_SPEEDS_COUNTERS,
-		    mad_dump_port_ext_speeds_counters);
+	ib_rpc_t rpc = { 0 };
+	int lid = dest->lid;
+
+	DEBUG("lid %u port %d mask 0x%" PRIx64, lid, port, mask);
+
+	if (lid == -1) {
+		IBWARN("only lid routed is supported");
+		return NULL;
+	}
+
+	if (!mask)
+		mask = ~0;
+
+	rpc.mgtclass = IB_PERFORMANCE_CLASS;
+	rpc.method = IB_MAD_METHOD_SET;
+	rpc.attr.id = IB_GSI_PORT_EXT_SPEEDS_COUNTERS;
+
+	memset(rcvbuf, 0, IB_MAD_SIZE);
+
+	mad_set_field(rcvbuf, 0, IB_PESC_PORT_SELECT_F, port);
+	mad_set_field64(rcvbuf, 0, IB_PESC_COUNTER_SELECT_F, mask);
+	rpc.attr.mod = 0;
+	rpc.timeout = timeout;
+	rpc.datasz = IB_PC_DATA_SZ;
+	rpc.dataoffs = IB_PC_DATA_OFFS;
+	if (!dest->qp)
+		dest->qp = 1;
+	if (!dest->qkey)
+		dest->qkey = IB_DEFAULT_QP1_QKEY;
+
+	return mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
+}
+
+static void extended_speeds_query(ib_portid_t * portid, int port, uint64_t ext_mask)
+{
+	int mask = ext_mask;
+
+	if (!reset_only)
+		common_func(portid, port, mask, 1, 0,
+			    "PortExtendedSpeedsCounters",
+			    IB_GSI_PORT_EXT_SPEEDS_COUNTERS,
+			    mad_dump_port_ext_speeds_counters);
+
+	if ((reset_only || reset) &&
+	    !ext_speeds_reset_via(pc, portid, port, ext_mask, ibd_timeout, srcport))
+		IBERROR("cannot reset PortExtendedSpeedsCounters");
 }
 
 void dump_portsamples_control(ib_portid_t * portid, int port)
@@ -472,6 +516,7 @@ int main(int argc, char **argv)
 	};
 	ib_portid_t portid = { 0 };
 	int mask = 0xffff;
+	uint64_t ext_mask = 0xffffffffffffffff;
 	uint16_t cap_mask;
 	int all_ports_loop = 0;
 	int node_type, num_ports = 0;
@@ -518,8 +563,10 @@ int main(int argc, char **argv)
 
 	if (argc > 1)
 		port = strtoul(argv[1], 0, 0);
-	if (argc > 2)
-		mask = strtoul(argv[2], 0, 0);
+	if (argc > 2) {
+		ext_mask = strtoull(argv[2], 0, 0);
+		mask = ext_mask;
+	}
 
 	srcport = mad_rpc_open_port(ibd_ca, ibd_ca_port, mgmt_classes, 4);
 	if (!srcport)
@@ -569,7 +618,7 @@ int main(int argc, char **argv)
 	}
 
 	if (extended_speeds) {
-		extended_speeds_query(&portid, port, mask);
+		extended_speeds_query(&portid, port, ext_mask);
 		goto done;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
