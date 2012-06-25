From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] ibsim/sim_cmd.c: Fix help for error command
Date: Mon, 25 Jun 2012 10:26:10 -0400
Message-ID: <4FE87502.1010909@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


PortInfo is attribute ID 0x15 (21)

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/ibsim/sim_cmd.c b/ibsim/sim_cmd.c
index 6d3a893..81e9bfa 100644
--- a/ibsim/sim_cmd.c
+++ b/ibsim/sim_cmd.c
@@ -818,7 +818,7 @@ static int dump_help(FILE * f)
 		"\t\t\t\tNodeDescription : 16\n"
 		"\t\t\t\tNodeInfo        : 17\n"
 		"\t\t\t\tSwitchInfo      : 18\n"
-		"\t\t\t\tPortInfo        : 19\n"
+		"\t\t\t\tPortInfo        : 21\n"
 		);
 	fprintf(f,
 		"\tBaselid \"nodeid\"[port] <lid> [lmc] : change port's lid (lmc)\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
