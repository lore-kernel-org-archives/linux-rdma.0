From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH TRIVIAL] ib_pack.h: Fix commentary IBA reference for CNP in
 IB opcode enum
Date: Wed, 30 Sep 2015 15:04:29 -0400
Message-ID: <560C323D.1000409@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


IBA spec is now 1.3 not 3.1 and vol 1 should be mentioned
as there is also vol 2.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
index 709a533..e99d8f9 100644
--- a/include/rdma/ib_pack.h
+++ b/include/rdma/ib_pack.h
@@ -76,7 +76,7 @@ enum {
 	IB_OPCODE_UC                                = 0x20,
 	IB_OPCODE_RD                                = 0x40,
 	IB_OPCODE_UD                                = 0x60,
-	/* per IBTA 3.1 Table 38, A10.3.2 */
+	/* per IBTA 1.3 vol 1 Table 38, A10.3.2 */
 	IB_OPCODE_CNP                               = 0x80,
 
 	/* operations -- just used to define real constants */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
