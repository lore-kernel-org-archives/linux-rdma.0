From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] debian: Add arch.h to libibverbs-dev install
Date: Thu, 16 Feb 2017 10:49:11 +0200
Message-ID: <1487234951-58846-1-git-send-email-talatb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Building a debian package failed with [1], this commit
fixes the issue by adding arch.h to libibverbs-dev.install.

[1]
dh_install: usr/include/infiniband/arch.h exists in debian/tmp but is
not installed to anywhere.

Signed-off-by: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 debian/libibverbs-dev.install | 1 +
 1 file changed, 1 insertion(+)

diff --git a/debian/libibverbs-dev.install b/debian/libibverbs-dev.install
index 0ddb0a8..d010ef2 100644
--- a/debian/libibverbs-dev.install
+++ b/debian/libibverbs-dev.install
@@ -3,6 +3,7 @@ usr/include/infiniband/opcode.h
 usr/include/infiniband/sa-kern-abi.h
 usr/include/infiniband/sa.h
 usr/include/infiniband/verbs.h
+usr/include/infiniband/arch.h
 usr/lib/*/libibverbs*.so
 usr/share/man/man3/ibv_*
 usr/share/man/man3/mbps_to_ibv_rate.3
-- 
2.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
