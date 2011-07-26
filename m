From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/saquery.c: PortInfoRecord now has an options
 field
Date: Tue, 26 Jul 2011 08:18:02 -0400
Message-ID: <4E2EB07A.2070300@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


rather than reserved field

This is for coordination with the latest ib_types.h 

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/saquery.c b/src/saquery.c
index 88abb39..f82772f 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -300,9 +300,9 @@ static void dump_one_portinfo_record(void *data)
 	       "\tRID:\n"
 	       "\t\tEndPortLid..............%u\n"
 	       "\t\tPortNum.................%u\n"
-	       "\t\tReserved................0x%x\n"
+	       "\t\tOptions.................0x%x\n"
 	       "\tPortInfo dump:\n\t\t%s",
-	       cl_ntoh16(pir->lid), pir->port_num, pir->resv, buf2);
+	       cl_ntoh16(pir->lid), pir->port_num, pir->options, buf2);
 }
 
 static void dump_one_mcmember_record(void *data)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
