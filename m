From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/ibsysstat.c: Fix non default OUI operation
Date: Thu, 01 Nov 2012 08:35:41 -0400
Message-ID: <50926C9D.3000200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shaked Tzadok <shakedt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibsysstat.c b/src/ibsysstat.c
index d798fe2..eb876d4 100644
--- a/src/ibsysstat.c
+++ b/src/ibsysstat.c
@@ -63,6 +63,7 @@ typedef struct cpu_info {
 
 static cpu_info cpus[MAX_CPUS];
 static int host_ncpu;
+static int server = 0, oui = IB_OPENIB_OUI;
 
 static int server_respond(void *umad, int size)
 {
@@ -222,7 +223,7 @@ static char *ibsystat(ib_portid_t * portid, int attr)
 	rpc.method = IB_MAD_METHOD_GET;
 	rpc.attr.id = attr;
 	rpc.attr.mod = 0;
-	rpc.oui = IB_OPENIB_OUI;
+	rpc.oui = oui;
 	rpc.timeout = 0;
 	rpc.datasz = IB_VENDOR_RANGE2_DATA_SIZE;
 	rpc.dataoffs = IB_VENDOR_RANGE2_DATA_OFFS;
@@ -293,8 +294,6 @@ int build_cpuinfo(void)
 	return ncpu;
 }
 
-static int server = 0, oui = IB_OPENIB_OUI;
-
 static int process_opt(void *context, int ch, char *optarg)
 {
 	switch (ch) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
