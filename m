From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] RDMA: Remove duplicated include from ib_addr.h
Date: Thu, 13 Sep 2018 21:47:52 +0800
Message-ID: <20180913134752.22780-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 include/rdma/ib_addr.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 77c7908..8964e84 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -46,7 +46,6 @@
 #include <net/ip.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_pack.h>
-#include <net/ipv6.h>
 #include <net/net_namespace.h>
 
 /**
-- 
2.7.0
