From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs] Fix configure regression that disallowed building on older systems
Date: Thu, 11 Jul 2013 13:34:19 +0300
Message-ID: <1373538859-32636-1-git-send-email-ogerlitz@r-vnc04.mtr.labs.mlnx>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Commit 9bbd803 "configure: Apply updates proposed by autoupdate" forced
the autoconf package on the builder node to be of version 2.67 or higher.

This doesn't allow to build the library e.g on RHEL 6.x systems
who install this set of tools

	autofs-5.0.5-39.el6.x86_64
	automake-1.11.1-1.2.el6.noarch
	autoconf-2.63-5.1.el6.noarch

Be a bit more conservative and require 2.63 or higher.

CC: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index b8d4cea..32af774 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,6 @@
 dnl Process this file with autoconf to produce a configure script.
 
-AC_PREREQ([2.67])
+AC_PREREQ([2.63])
 AC_INIT([libibverbs],[1.1.7],[linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org])
 AC_CONFIG_SRCDIR([src/ibverbs.h])
 AC_CONFIG_AUX_DIR(config)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
