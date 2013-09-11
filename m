From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] rstream.c: Indicate when specified address family
 is unknown
Date: Wed, 11 Sep 2013 14:44:32 -0400
Message-ID: <5230BA10.30509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock >hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/examples/rstream.c b/examples/rstream.c
index 278437f..cf84716 100644
--- a/examples/rstream.c
+++ b/examples/rstream.c
@@ -586,6 +586,8 @@ int main(int argc, char **argv)
 				rai_hints.ai_flags = RAI_NUMERICHOST | RAI_FAMILY;
 				rai_hints.ai_family = AF_IB;
 				use_rgai = 1;
+			} else {
+				fprintf(stderr, "Warning: unknown address format\n");
 			}
 			break;
 		case 'B':
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
