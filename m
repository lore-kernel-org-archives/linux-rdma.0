From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH TRIVIAL rdma-core] libibumad/man/umad_set_addr_net.3: Update
 function signature
Date: Wed, 22 Mar 2017 17:14:02 -0400
Message-ID: <ae127b69-661e-6ce1-8ffc-6a7ebf7d34d4@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


to be consistent with change in commit 8a342f390e7af71bba0d8794d741453604647e98
umad: Add missing be annotation

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibumad/man/umad_set_addr_net.3 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libibumad/man/umad_set_addr_net.3 b/libibumad/man/umad_set_addr_net.3
index 778faf4..b395252 100644
--- a/libibumad/man/umad_set_addr_net.3
+++ b/libibumad/man/umad_set_addr_net.3
@@ -8,7 +8,7 @@ umad_set_addr_net \- set MAD address fields within umad buffer using network ord
 .nf
 .B #include <infiniband/umad.h>
 .sp
-.BI "int umad_set_addr_net(void " "*umad" ", int " "dlid" ", int " "dqp" ", int " "sl" ", int " "qkey");
+.BI "int umad_set_addr_net(void " "*umad" ", __be16 " "dlid" ", __be32 " "dqp" ", int " "sl" ", __be32 " "qkey");
 .fi
 .SH "DESCRIPTION"
 .B umad_set_addr_net()
-- 
1.8.2.3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
