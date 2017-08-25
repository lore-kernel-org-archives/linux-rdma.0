From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCHv2 rdma-core 1/5] kernel-boot: Add cmake variable to configure
 the path to systemd-* binaries
Date: Fri, 25 Aug 2017 12:40:02 +0200
Message-ID: <78ca92c2-8422-e22d-1efa-1077946d2064@suse.de>
References: <88926674-d707-6f00-e9a1-e2a823fec323@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <88926674-d707-6f00-e9a1-e2a823fec323-l3A5Bk7waGM@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Debian uses /lib/systemd
SUSE uses /usr/lib/systemd
RHEL/Fedora can use both.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 CMakeLists.txt                            | 2 ++
 kernel-boot/rdma-load-modules@.service.in | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 2324cf49..a2464ec5 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -74,6 +74,8 @@ set(CMAKE_INSTALL_INITDDIR "${CMAKE_INSTALL_SYSCONFDIR}/init.d"
   CACHE PATH "Location for init.d files")
 set(CMAKE_INSTALL_SYSTEMD_SERVICEDIR "${CMAKE_INSTALL_PREFIX}/lib/systemd/system"
   CACHE PATH "Location for systemd service files")
+set(CMAKE_INSTALL_SYSTEMD_BINDIR "/lib/systemd"
+  CACHE PATH "Location for systemd extra binaries")
 
 set(ACM_PROVIDER_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/ibacm"
   CACHE PATH "Location for ibacm provider plugin shared library files.")
diff --git a/kernel-boot/rdma-load-modules@.service.in b/kernel-boot/rdma-load-modules@.service.in
index d381bc5b..c390a8cc 100644
--- a/kernel-boot/rdma-load-modules@.service.in
+++ b/kernel-boot/rdma-load-modules@.service.in
@@ -21,5 +21,5 @@ ConditionCapability=CAP_SYS_MODULE
 [Service]
 Type=oneshot
 RemainAfterExit=yes
-ExecStart=/lib/systemd/systemd-modules-load @CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma/modules/%I.conf
+ExecStart=@CMAKE_INSTALL_SYSTEMD_BINDIR@/systemd-modules-load @CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma/modules/%I.conf
 TimeoutSec=90s
-- 
2.14.1.252.gf15771ee3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
