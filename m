From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] infiniband-diags/saquery.c: Display NodeRecord LID
 in decimal
Date: Fri, 11 Jan 2013 14:33:43 -0500
Message-ID: <50F06917.3080706@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


rather than hex

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/saquery.c b/src/saquery.c
index bdf5e9a..2c5b465 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -146,7 +146,7 @@ static void dump_node_record(void *data)
 	ib_node_info_t *ni = &nr->node_info;
 
 	printf("NodeRecord dump:\n"
-	       "\t\tlid.....................0x%X\n"
+	       "\t\tlid.....................%u\n"
 	       "\t\treserved................0x%X\n"
 	       "\t\tbase_version............0x%X\n"
 	       "\t\tclass_version...........0x%X\n"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
