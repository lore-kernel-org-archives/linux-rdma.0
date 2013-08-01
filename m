From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH TRIVIAL ibacm] acm.c: In acm_ep_up, add pkey to error message
Date: Thu, 01 Aug 2013 10:17:41 -0400
Message-ID: <51FA6E05.1060203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


so don't have to turn up log level to see this

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/acm.c b/src/acm.c
index 09051dc..b19582c 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -3080,7 +3080,7 @@ static void acm_ep_up(struct acm_port *port, uint16_t pkey_index)
 
 	ret = acm_assign_ep_names(ep);
 	if (ret) {
-		acm_log(0, "ERROR - unable to assign EP name\n");
+		acm_log(0, "ERROR - unable to assign EP name for pkey 0x%x\n", pkey);
 		goto err0;
 	}
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
