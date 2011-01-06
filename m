From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] ibutils:Update requirements for building and installing
Date: Wed, 5 Jan 2011 17:34:20 -0800
Message-ID: <20110105173420.a3356706.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


[PATCH] Update requirements for building and installing


Signed-off-by: Ira Weiny <weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
---
 ibutils.spec.in |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/ibutils.spec.in b/ibutils.spec.in
index a5d7b76..4209a4c 100644
--- a/ibutils.spec.in
+++ b/ibutils.spec.in
@@ -42,7 +42,8 @@ Url: http://openfabrics.org/downloads/%{name}-%{version}.tar.gz
 Group: System Environment/Libraries
 Source: %{name}-%{version}.tar.gz
 BuildRoot: %{?build_root:%{build_root}}%{!?build_root:%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)}
-# Requires: opensm
+Requires: opensm-libs, libibumad, libibcommon, libibverbs, tk
+BuildRequires: opensm-devel, libibverbs-devel, libibumad-devel, libibcommon-devel, tk-devel
 Vendor: Mellanox Technologies Ltd.
 %description
 ibutils provides IB network and path diagnostics.
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
