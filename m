From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core v1 1/3] travis: Add RedHat and SuSE rpmbuild support
Date: Sun,  5 Nov 2017 16:45:00 +0200
Message-ID: <20171105144503.32709-2-leon@kernel.org>
References: <20171105144503.32709-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171105144503.32709-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicolas Morey-Chaisemartin <nmoreychaisemartin-l3A5Bk7waGM@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Provide a new script for testing rpmbuild under RedHat and SuSE
environments which validates both of the suse/rdma-core.spec and
redhat/rdma-core.spec spec files.

The script performs the RPM package build test by utilizing the existing
cbuild tool.

Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 .travis.yml                 |  4 ++++
 buildlib/package-build-test | 21 +++++++++++++++++++++
 2 files changed, 25 insertions(+)
 create mode 100755 buildlib/package-build-test

diff --git a/.travis.yml b/.travis.yml
index c190a241..4d7b0cc0 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -42,6 +42,9 @@ addons:
       - gcc-multilib
       - lib32gcc-7-dev
 
+service:
+    - docker
+
 before_script:
   - export LATEST_GCC_LINARO_URL=`wget -qO - https://releases.linaro.org/components/toolchain/binaries/latest/aarch64-linux-gnu/ | grep -o '<a href=['"'"'"].*gcc-linaro-.*x86_64_aarch64-linux-gnu.tar.xz['"'"'"]'  |  sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//'`
   - export LATEST_GCC_LINARO_TAR=`basename $LATEST_GCC_LINARO_URL`
@@ -51,6 +54,7 @@ before_script:
 script:
   - buildlib/travis-build
   - buildlib/travis-checkpatch
+  - buildlib/package-build-test
   - buildlib/github-release
 deploy:
   # Deploy assets to Github releases
diff --git a/buildlib/package-build-test b/buildlib/package-build-test
new file mode 100755
index 00000000..d5fcdd9c
--- /dev/null
+++ b/buildlib/package-build-test
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# fail on errors
+set -e
+# be verbose
+set -x
+
+# Do not run these tests if we are already inside a container
+if [ -e "/.dockerenv" ] || (grep -q docker /proc/self/cgroup &>/dev/null); then
+       echo "We are running in a container, skipping ..."
+       exit 0
+fi
+
+for OS in centos7 opensuse-42.3
+do
+	echo
+	echo "Checking package build for ${OS} ...."
+	echo
+	buildlib/cbuild build-images ${OS}
+	buildlib/cbuild pkg ${OS}
+done
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
