From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] saquery.c: In print_node_record, change
 LID print format
Date: Wed, 26 Feb 2014 10:25:06 -0500
Message-ID: <530E0752.1000709@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


"Standard" for LID printing is unsigned rather than signed decimal

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/saquery.c b/src/saquery.c
index 837d8ae..0f39064 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -186,7 +186,7 @@ static void print_node_record(ib_node_record_t * node_record)
 	switch (node_print_desc) {
 	case LID_ONLY:
 	case UNIQUE_LID_ONLY:
-		printf("%d\n", cl_ntoh16(node_record->lid));
+		printf("%u\n", cl_ntoh16(node_record->lid));
 		return;
 	case GUID_ONLY:
 		printf("0x%016" PRIx64 "\n", cl_ntoh64(p_ni->port_guid));
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
