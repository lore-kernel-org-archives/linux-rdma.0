From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 4/4 for opensm] opensm.spec.in: Improve portability
Date: Fri, 21 Sep 2012 16:46:12 +0200
Message-ID: <505C7DB4.3090803@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support for Debian and for other systems that do not support
chkconfig. See also http://refspecs.linuxbase.org/LSB_4.0.0/LSB-Core-generic/LSB-Core-generic/command.html.

Also, after having installed /etc/init.d/opensmd on a system where
systemd is present, tell systemd to reload the files in /etc/init.d.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 opensm.spec.in |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/opensm.spec.in b/opensm.spec.in
index 65e46c9..0187069 100644
--- a/opensm.spec.in
+++ b/opensm.spec.in
@@ -36,8 +36,6 @@ Source: http://www.openfabrics.org/downloads/management/@TARBALL@
 BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
 BuildRequires: libibumad-devel, libtool
 Requires: %{name}-libs = %{version}-%{release}, logrotate
-Requires(post): /sbin/service, /sbin/chkconfig
-Requires(preun): /sbin/chkconfig, /sbin/service
 
 %description
 OpenSM provides an implementation of an InfiniBand Subnet Manager and
@@ -109,15 +107,30 @@ rm -rf $RPM_BUILD_ROOT
 
 %post
 if [ $1 = 1 ]; then
-    /sbin/chkconfig --add opensmd
+    if [ -e /sbin/chkconfig ]; then
+        /sbin/chkconfig --add opensmd
+    elif [ -e /usr/sbin/update-rc.d ]; then
+        /usr/sbin/update-rc.d opensmd defaults
+    else
+        /usr/lib/lsb/install_initd /etc/init.d/opensmd
+    fi
+    if type systemctl >/dev/null 2>&1; then
+        systemctl --system daemon-reload
+    fi
 else
-    /sbin/service opensmd condrestart
+    /etc/init.d/opensmd condrestart
 fi
 
 %preun
 if [ $1 = 0 ]; then
-    /sbin/service opensmd stop
-    /sbin/chkconfig --del opensmd
+    /etc/init.d/opensmd stop
+    if [ -e /sbin/chkconfig ]; then
+        /sbin/chkconfig --del opensmd
+    elif [ -e /usr/sbin/update-rc.d ]; then
+        /usr/sbin/update-rc.d -f opensmd remove
+    else
+        /usr/lib/lsb/remove_initd /etc/init.d/opensmd
+    fi
     rm -f /var/cache/opensm/*
 fi
 
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
