From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] libibumad: fix umad_register man page
Date: Mon, 3 Dec 2012 16:05:45 -0800
Message-ID: <20121203160545.e5f38b03052aca9f8c6040be@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 man/umad_register.3 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/man/umad_register.3 b/man/umad_register.3
index 7f11b51..eb6b986 100644
--- a/man/umad_register.3
+++ b/man/umad_register.3
@@ -7,7 +7,7 @@ umad_register \- register the specified management class and version for port
 .nf
 .B #include <infiniband/umad.h>
 .sp
-.BI "int umad_register(int " "portid" ", int " "mgmt_class" ", int " "mgmt_version" " , uint8_t " "rmpp_version" ", uint32_t " "method_mask[4]");
+.BI "int umad_register(int " "portid" ", int " "mgmt_class" ", int " "mgmt_version" " , uint8_t " "rmpp_version" ", long " "method_mask[16/sizeof(long)]");
 .fi
 .SH "DESCRIPTION"
 .B umad_register()
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
