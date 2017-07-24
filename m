From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 12/21] debian: Move truescale setup into rdma-core
Date: Mon, 24 Jul 2017 14:00:20 -0600
Message-ID: <1500926429-31822-13-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This matches what RedHat is doing and makes sense, the rdma-core package
contains the kernel support elements.

Also add a Debian dependency for dmidecode as the truescale.cmd script
uses it.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 debian/control                   | 2 +-
 debian/ibverbs-providers.install | 2 --
 debian/rdma-core.install         | 2 ++
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/debian/control b/debian/control
index 8434bbb23693f8..9d80e38bb07864 100644
--- a/debian/control
+++ b/debian/control
@@ -22,7 +22,7 @@ Homepage: https://github.com/linux-rdma/rdma-core
 
 Package: rdma-core
 Architecture: linux-any
-Depends: ${misc:Depends}, ${shlibs:Depends}
+Depends: dmidecode, ${misc:Depends}, ${shlibs:Depends}
 Breaks: infiniband-diags (<< 2.0.0)
 Replaces: infiniband-diags (<< 2.0.0)
 Description: RDMA core userspace infrastructure and documentation
diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
index e477cd7873b8bd..93144527be04ef 100644
--- a/debian/ibverbs-providers.install
+++ b/debian/ibverbs-providers.install
@@ -1,10 +1,8 @@
 etc/libibverbs.d/
-etc/modprobe.d/truescale.conf
 usr/bin/rxe_cfg
 usr/lib/*/libibverbs/lib*-rdmav2.so
 usr/lib/*/libmlx4.so.*
 usr/lib/*/libmlx5.so.*
-usr/lib/truescale-serdes.cmds
 usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
 usr/share/man/man7/rxe.7
 usr/share/man/man8/rxe_cfg.8
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index 371aaadc7483d3..871f5ff543f2bf 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -1,5 +1,7 @@
+etc/modprobe.d/truescale.conf
 lib/systemd/system/rdma-ndd.service
 lib/udev/rules.d/rdma-ndd.rules
+usr/lib/truescale-serdes.cmds
 usr/sbin/rdma-ndd
 usr/share/doc/rdma-core/MAINTAINERS
 usr/share/doc/rdma-core/README.md
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
