From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH ibacm] acm.c: Fix addr_data_file handling
Date: Fri, 28 Jun 2013 11:18:47 -0400
Message-ID: <51CDA957.70207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/acm.c b/src/acm.c
index f55ebc0..ae326e5 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -3466,7 +3466,7 @@ static void acm_set_options(void)
 		else if (!stricmp("addr_preload", opt))
 			addr_preload = acm_convert_addr_preload(value);
 		else if (!stricmp("addr_data_file", opt))
-			strcpy(addr_data_file, opt);
+			strcpy(addr_data_file, value);
 	}
 
 	fclose(f);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
