From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibstat.c: If port is 1x SDR, rate is 2.5
 rather than 2 Gbps
Date: Mon, 6 Feb 2017 08:03:12 -0500
Message-ID: <7230ef46-74ff-76cd-4123-f34a75a6d436@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibstat.c b/src/ibstat.c
index 37f2361..2d980c4 100644
--- a/src/ibstat.c
+++ b/src/ibstat.c
@@ -182,8 +182,10 @@ static int port_dump(umad_port_t * port, int alone)
 	       7 ? port_phy_state_str[port->phys_state] : "???");
 	if (is_fdr10(port))
 		printf("%sRate: %d (FDR10)\n", pre, port->rate);
-	else
+	else if (port->rate != 2)	/* 1x SDR */
 		printf("%sRate: %d\n", pre, port->rate);
+	else
+		printf("%sRate: 2.5\n", pre);
 	printf("%sBase lid: %d\n", pre, port->base_lid);
 	printf("%sLMC: %d\n", pre, port->lmc);
 	printf("%sSM lid: %d\n", pre, port->sm_lid);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
