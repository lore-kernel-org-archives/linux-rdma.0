From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core 5/5] libhns: Update consolidate repo for userspace library of hip08 RoCE
Date: Tue, 17 Oct 2017 21:12:26 +0800
Message-ID: <1508245946-145697-6-git-send-email-oulijun@huawei.com>
References: <1508245946-145697-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508245946-145697-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch configure the consolidated repo to build user driver
of hip08 RoCE.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 providers/hns/CMakeLists.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/providers/hns/CMakeLists.txt b/providers/hns/CMakeLists.txt
index 19a793e..f136151 100644
--- a/providers/hns/CMakeLists.txt
+++ b/providers/hns/CMakeLists.txt
@@ -2,5 +2,6 @@ rdma_provider(hns
   hns_roce_u.c
   hns_roce_u_buf.c
   hns_roce_u_hw_v1.c
+  hns_roce_u_hw_v2.c
   hns_roce_u_verbs.c
 )
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
