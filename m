From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] perfquery.c: Change format of capability
 mask in IBWARN for consistency
Date: Thu, 01 May 2014 10:22:00 -0400
Message-ID: <53625888.90607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/perfquery.c b/src/perfquery.c
index 112d92c..535abb6 100644
--- a/src/perfquery.c
+++ b/src/perfquery.c
@@ -327,7 +327,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
 		if (!(cap_mask & IB_PM_EXT_WIDTH_SUPPORTED) &&
 		    !(cap_mask & IB_PM_EXT_WIDTH_NOIETF_SUP))
 			IBWARN
-			    ("PerfMgt ClassPortInfo 0x%x; No extended counter support indicated\n",
+			    ("PerfMgt ClassPortInfo CapMask 0x%02X; No extended counter support indicated\n",
 			     ntohs(cap_mask));
 
 		memset(pc, 0, sizeof(pc));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
