From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 2/2] debian: Move perl:Depends from ibverbs-providers to rdma-core
Date: Mon, 18 Sep 2017 11:33:44 +0200
Message-ID: <20170918093344.11482-2-benjamin.drung@profitbricks.com>
References: <20170918093344.11482-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170918093344.11482-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The build process shows these warnings:

dpkg-gencontrol: warning: package rdma-core: unused substitution
variable ${perl:Depends}
dpkg-gencontrol: warning: Depends field of package ibverbs-providers:
unknown substitution variable ${perl:Depends}

The binary /usr/bin/rxe_cfg is a Perl script that is shipped by
rdma-core now.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/control | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/debian/control b/debian/control
index f87f8999..fef59ad5 100644
--- a/debian/control
+++ b/debian/control
@@ -23,7 +23,10 @@ Homepage: https://github.com/linux-rdma/rdma-core
 
 Package: rdma-core
 Architecture: linux-any
-Depends: lsb-base (>= 3.2-14~), ${misc:Depends}, ${shlibs:Depends}
+Depends: lsb-base (>= 3.2-14~),
+         ${misc:Depends},
+         ${perl:Depends},
+         ${shlibs:Depends}
 Recommends: dmidecode, ethtool, net-tools
 Breaks: infiniband-diags (<< 2.0.0)
 Replaces: infiniband-diags (<< 2.0.0)
@@ -57,7 +60,7 @@ Description: InfiniBand Communication Manager Assistant (ACM)
 Package: ibverbs-providers
 Architecture: linux-any
 Multi-Arch: same
-Depends: ${misc:Depends}, ${perl:Depends}, ${shlibs:Depends}
+Depends: ${misc:Depends}, ${shlibs:Depends}
 Provides: libcxgb3-1, libipathverbs1, libmlx4-1, libmlx5-1, libmthca1, libnes1
 Replaces: libcxgb3-1, libipathverbs1, libmlx4-1, libmlx5-1, libmthca1, libnes1
 Breaks: libcxgb3-1, libipathverbs1, libmlx4-1, libmlx5-1, libmthca1, libnes1
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
