From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] Set BuildArch to noarch
Date: Wed, 21 Sep 2011 12:59:51 -0500
Message-ID: <20110921175948.GA3010@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A documentation package should be built as noarch since it does not
carry any binaries.

Also removed executable permissions from dhcp/dhcp-3.0.4/*.patch

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 ofed-docs.spec                                     |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 dhcp/dhcp-3.0.4/0001-Make-DHCP-server-print-HW-info.patch
 mode change 100755 => 100644 dhcp/dhcp-3.0.4/dhcp-3.0.4.patch

diff --git a/dhcp/dhcp-3.0.4/0001-Make-DHCP-server-print-HW-info.patch b/dhcp/dhcp-3.0.4/0001-Make-DHCP-server-print-HW-info.patch
old mode 100755
new mode 100644
diff --git a/dhcp/dhcp-3.0.4/dhcp-3.0.4.patch b/dhcp/dhcp-3.0.4/dhcp-3.0.4.patch
old mode 100755
new mode 100644
diff --git a/ofed-docs.spec b/ofed-docs.spec
index a49ed76..c19b580 100644
--- a/ofed-docs.spec
+++ b/ofed-docs.spec
@@ -37,6 +37,7 @@ Url: http://git.openfabrics.org/git?p=ofed_1_5/docs.git;a=summary
 Group: Documentation/Man
 Source: %{name}-%{version}.tar.gz
 BuildRoot: %{?build_root:%{build_root}}%{!?build_root:/var/tmp/%{name}-%{version}-root}
+BuildArch: noarch
 Vendor: OpenFabrics
 %description
 OpenFabrics documentation
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
