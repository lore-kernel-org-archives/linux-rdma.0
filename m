From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] infiniband-diags/ibportstate.c: Remove an extra
 space from warning message
Date: Thu, 24 May 2012 14:07:07 -0400
Message-ID: <4FBE78CB.3030401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibportstate.c b/src/ibportstate.c
index 5559d18..9bf6f4a 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -654,7 +654,7 @@ int main(int argc, char **argv)
 			} else {
 				if (fdr10e & FDR10 && peerfdr10e & FDR10) {
 					if (!(fdr10a & FDR10))
-						IBWARN("Peer ports operating at  active speed %d rather than FDR10", lsa);
+						IBWARN("Peer ports operating at active speed %d rather than FDR10", lsa);
 				}
 			}
 		}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
