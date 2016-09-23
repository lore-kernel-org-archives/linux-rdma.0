From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH TRIVIAL rdma-core] README.md: Fix umad library name
Date: Fri, 23 Sep 2016 12:56:15 -0400
Message-ID: <544ef813-8900-35e1-f7c9-c7135cf92dc5@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/README.md b/README.md
index 65c7644..65514ff 100644
--- a/README.md
+++ b/README.md
@@ -6,7 +6,7 @@ following device nodes:
 
  - /dev/infiniband/uverbsX (libibverbs)
  - /dev/infiniband/rdma_cm (librdmacm)
- - /dev/infiniband/umadX (libumad)
+ - /dev/infiniband/umadX (libibumad)
  - /dev/infiniband/ucmX (libibcm, deprecated)
 
 The userspace component of the libibverbs RDMA kernel drivers are included
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
