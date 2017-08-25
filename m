From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCHv2 rdma-core 2/5] Documentation: install udev.md
Date: Fri, 25 Aug 2017 12:40:05 +0200
Message-ID: <897eb754-ca40-2dbc-f44a-e47752cab3b2@suse.de>
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

udev.md is referenced by rdma-hw,target and rdma-load-modules@.service
and needs to be installed.

Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
---
 Documentation/CMakeLists.txt | 1 +
 debian/rdma-core.install     | 1 +
 redhat/rdma-core.spec        | 1 +
 3 files changed, 3 insertions(+)

diff --git a/Documentation/CMakeLists.txt b/Documentation/CMakeLists.txt
index 6170b5f2..d6e08ded 100644
--- a/Documentation/CMakeLists.txt
+++ b/Documentation/CMakeLists.txt
@@ -5,6 +5,7 @@ install(FILES
   libibverbs.md
   librdmacm.md
   rxe.md
+  udev.md
   ../README.md
   ../MAINTAINERS
   DESTINATION "${CMAKE_INSTALL_DOCDIR}")
diff --git a/debian/rdma-core.install b/debian/rdma-core.install
index 8f5779a4..87bff10f 100644
--- a/debian/rdma-core.install
+++ b/debian/rdma-core.install
@@ -25,6 +25,7 @@ usr/sbin/rdma-ndd
 usr/share/doc/rdma-core/MAINTAINERS
 usr/share/doc/rdma-core/README.md
 usr/share/doc/rdma-core/rxe.md
+usr/share/doc/rdma-core/udev.md
 usr/share/man/man5/iwpmd.conf.5
 usr/share/man/man7/rxe.7
 usr/share/man/man8/iwpmd.8
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 61e16de5..ca11f663 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -319,6 +319,7 @@ rm -rf %{buildroot}/%{_sbindir}/srp_daemon.sh
 %dir %{_docdir}/%{name}-%{version}
 %doc %{_docdir}/%{name}-%{version}/README.md
 %doc %{_docdir}/%{name}-%{version}/rxe.md
+%doc %{_docdir}/%{name}-%{version}/udev.md
 %config(noreplace) %{_sysconfdir}/rdma/mlx4.conf
 %config(noreplace) %{_sysconfdir}/rdma/modules/infiniband.conf
 %config(noreplace) %{_sysconfdir}/rdma/modules/iwarp.conf
-- 
2.14.1.252.gf15771ee3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
