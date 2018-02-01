From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core] build: Pass extra cmake flags
Date: Thu,  1 Feb 2018 12:32:06 +0200
Message-ID: <20180201103206.26356-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add ability to provide extra cmake flags when building library
and when creating RPMs or DEBs using EXTRA_CMAKE_FLAGS.

Set an environment variable prior execution to provide
this information to build scripts:
export EXTRA_CMAKE_FLAGS="<flags>"

Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 build.sh              | 4 ++--
 debian/rules          | 3 ++-
 redhat/rdma-core.spec | 5 ++++-
 suse/rdma-core.spec   | 5 ++++-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/build.sh b/build.sh
index 17dc4408..a6b1e8f0 100755
--- a/build.sh
+++ b/build.sh
@@ -23,9 +23,9 @@ fi
 cd "$BUILDDIR"

 if [ "x$NINJA" == "x" ]; then
-    $CMAKE -DIN_PLACE=1 ..
+    $CMAKE -DIN_PLACE=1 ${EXTRA_CMAKE_FLAGS:-} ..
     make
 else
-    $CMAKE -DIN_PLACE=1 -GNinja ..
+    $CMAKE -DIN_PLACE=1 -GNinja ${EXTRA_CMAKE_FLAGS:-} ..
     $NINJA
 fi
diff --git a/debian/rules b/debian/rules
index 87d02104..46d9a2be 100755
--- a/debian/rules
+++ b/debian/rules
@@ -32,7 +32,8 @@ override_dh_auto_configure:
 			-DCMAKE_INSTALL_LIBEXECDIR:PATH=/usr/lib \
 			-DCMAKE_INSTALL_SHAREDSTATEDIR:PATH=/var/lib \
 			-DCMAKE_INSTALL_RUNDIR:PATH=/run \
-			-DCMAKE_INSTALL_UDEV_RULESDIR:PATH=/lib/udev/rules.d
+			-DCMAKE_INSTALL_UDEV_RULESDIR:PATH=/lib/udev/rules.d \
+			$(EXTRA_CMAKE_FLAGS)

 override_dh_auto_build:
 	ninja -C build-deb -v
diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
index 434d5679..fd9a95ee 100644
--- a/redhat/rdma-core.spec
+++ b/redhat/rdma-core.spec
@@ -205,6 +205,8 @@ discover and use SCSI devices via the SCSI RDMA Protocol over InfiniBand.
 %define _rundir /var/run
 %endif

+%{!?EXTRA_CMAKE_FLAGS: %define EXTRA_CMAKE_FLAGS %{nil}}
+
 # Pass all of the rpm paths directly to GNUInstallDirs and our other defines.
 %cmake %{CMAKE_FLAGS} \
          -DCMAKE_BUILD_TYPE=Release \
@@ -222,7 +224,8 @@ discover and use SCSI devices via the SCSI RDMA Protocol over InfiniBand.
          -DCMAKE_INSTALL_INITDDIR:PATH=%{_initrddir} \
          -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir} \
          -DCMAKE_INSTALL_DOCDIR:PATH=%{_docdir}/%{name}-%{version} \
-         -DCMAKE_INSTALL_UDEV_RULESDIR:PATH=%{_udevrulesdir}
+         -DCMAKE_INSTALL_UDEV_RULESDIR:PATH=%{_udevrulesdir} \
+         %{EXTRA_CMAKE_FLAGS}
 %make_jobs

 %install
diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
index cb6ffb36..698c1536 100644
--- a/suse/rdma-core.spec
+++ b/suse/rdma-core.spec
@@ -319,6 +319,8 @@ on those changes.
 %define _rundir /var/run
 %endif

+%{!?EXTRA_CMAKE_FLAGS: %define EXTRA_CMAKE_FLAGS %{nil}}
+
 # Pass all of the rpm paths directly to GNUInstallDirs and our other defines.
 %cmake %{CMAKE_FLAGS} \
 	 -DCMAKE_MODULE_LINKER_FLAGS="-Wl,--as-needed -Wl,-z,now" \
@@ -338,7 +340,8 @@ on those changes.
          -DCMAKE_INSTALL_INITDDIR:PATH=%{_initddir} \
          -DCMAKE_INSTALL_RUNDIR:PATH=%{_rundir} \
          -DCMAKE_INSTALL_DOCDIR:PATH=%{_docdir}/%{name}-%{version} \
-         -DCMAKE_INSTALL_UDEV_RULESDIR:PATH=%{_udevrulesdir}
+         -DCMAKE_INSTALL_UDEV_RULESDIR:PATH=%{_udevrulesdir} \
+         %{EXTRA_CMAKE_FLAGS}
 %make_jobs

 %install
--
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
