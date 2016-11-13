From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 rdma-core 7/7] libhns: Add consolidated repo for userspace library of hns
Date: Sun, 13 Nov 2016 18:36:00 +0800
Message-ID: <1479033360-56035-8-git-send-email-oulijun@huawei.com>
References: <1479033360-56035-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479033360-56035-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch configures the consolidated repo to build userspace
library of hns(libhns).

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
v5/v4/v3:
- No change over v2

v2:
- Delete the CHECK_C_SOURCE_COMPILES and sort the .c file

v1:
- The initial submit
---
 CMakeLists.txt               | 1 +
 MAINTAINERS                  | 6 ++++++
 README.md                    | 1 +
 providers/hns/CMakeLists.txt | 6 ++++++
 4 files changed, 14 insertions(+)
 create mode 100644 providers/hns/CMakeLists.txt

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 0ac7477..3c2aa79 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -328,6 +328,7 @@ add_subdirectory(libibcm)
 add_subdirectory(providers/cxgb3)
 add_subdirectory(providers/cxgb4)
 add_subdirectory(providers/hfi1verbs)
+add_subdirectory(providers/hns)
 add_subdirectory(providers/i40iw)
 add_subdirectory(providers/ipathverbs)
 add_subdirectory(providers/mlx4)
diff --git a/MAINTAINERS b/MAINTAINERS
index d83de10..bc6eb50 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -57,6 +57,12 @@ S:	Supported
 L:	intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org (moderated for non-subscribers)
 F:	providers/hfi1verbs/
 
+HNS USERSPACE PROVIDER (for hns-roce.ko)
+M:	Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+M:	Wei Hu(Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+S:	Supported
+F:	providers/hns/
+
 I40IW USERSPACE PROVIDER (for i40iw.ko)
 M:	Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 S:	Supported
diff --git a/README.md b/README.md
index 3a13042..e3bc33f 100644
--- a/README.md
+++ b/README.md
@@ -18,6 +18,7 @@ is included:
  - iw_cxgb3.ko
  - iw_cxgb4.ko
  - hfi1.ko
+ - hns-roce.ko
  - i40iw.ko
  - ib_qib.ko
  - mlx4_ib.ko
diff --git a/providers/hns/CMakeLists.txt b/providers/hns/CMakeLists.txt
new file mode 100644
index 0000000..19a793e
--- /dev/null
+++ b/providers/hns/CMakeLists.txt
@@ -0,0 +1,6 @@
+rdma_provider(hns
+  hns_roce_u.c
+  hns_roce_u_buf.c
+  hns_roce_u_hw_v1.c
+  hns_roce_u_verbs.c
+)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
