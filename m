From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: Indicate lmc and lmc_esp0 are not changeable
 "on the fly"
Date: Tue, 10 Jul 2012 13:09:10 -0400
Message-ID: <4FFC61B6.8010201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 7fb5c8f..8e72b37 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -422,8 +422,8 @@ static const opt_rec_t opt_tbl[] = {
 	{ "transaction_retries", OPT_OFFSET(transaction_retries), opts_parse_uint32, NULL, 0 },
 	{ "max_msg_fifo_timeout", OPT_OFFSET(max_msg_fifo_timeout), opts_parse_uint32, NULL, 1 },
 	{ "sm_priority", OPT_OFFSET(sm_priority), opts_parse_uint8, opts_setup_sm_priority, 1 },
-	{ "lmc", OPT_OFFSET(lmc), opts_parse_uint8, NULL, 1 },
-	{ "lmc_esp0", OPT_OFFSET(lmc_esp0), opts_parse_boolean, NULL, 1 },
+	{ "lmc", OPT_OFFSET(lmc), opts_parse_uint8, NULL, 0 },
+	{ "lmc_esp0", OPT_OFFSET(lmc_esp0), opts_parse_boolean, NULL, 0 },
 	{ "max_op_vls", OPT_OFFSET(max_op_vls), opts_parse_uint8, NULL, 1 },
 	{ "force_link_speed", OPT_OFFSET(force_link_speed), opts_parse_uint8, NULL, 1 },
 	{ "force_link_speed_ext", OPT_OFFSET(force_link_speed_ext), opts_parse_uint8, NULL, 1 },
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
