From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 1/2] debian: Don't install disabled providers on archs that miss coherent DMA
Date: Thu, 16 Nov 2017 13:29:36 +0100
Message-ID: <20171116122937.31770-2-benjamin.drung@profitbricks.com>
References: <20171116122937.31770-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116122937.31770-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ibverbs providers mlx4 and mlx5 require cache coherent DMA which is
not available on all architectures. Therefore do not try to install them
on the affected architectures.

Closes: #881731
Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/rules | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/debian/rules b/debian/rules
index 562fff51..b0fbe1d6 100755
--- a/debian/rules
+++ b/debian/rules
@@ -2,12 +2,17 @@
 
 export DEB_BUILD_MAINT_OPTIONS=hardening=+all
 
+NO_COHERENT_DMA_ARCHS = armel armhf mips mips64el mipsel
+
 %:
 	dh $@ --with systemd --builddirectory=build-deb
 
 override_dh_auto_clean:
 	dh_auto_clean
 	rm -rf build-deb
+	for package in ibverbs-providers libibverbs-dev rdma-core; do \
+		test ! -e debian/$$package.install.backup || mv debian/$$package.install.backup debian/$$package.install; \
+	done
 
 # Upstream wishes to use CMAKE_BUILD_TYPE=Release, and ensures that has a
 # sensible basis of options (eg no -O3, including -g). Debian specific options
@@ -34,6 +39,13 @@ override_dh_auto_build:
 override_dh_auto_test:
 
 override_dh_auto_install:
+# Some providers are disabled on architectures that are not able to do coherent DMA
+ifeq (,$(filter-out $(NO_COHERENT_DMA_ARCHS),$(DEB_HOST_ARCH)))
+	for package in ibverbs-providers libibverbs-dev rdma-core; do \
+		test -e debian/$$package.install.backup || cp debian/$$package.install debian/$$package.install.backup; \
+	done
+	sed -i '/mlx[45]/d' debian/ibverbs-providers.install debian/libibverbs-dev.install debian/rdma-core.install
+endif
 	DESTDIR=$(CURDIR)/debian/tmp ninja -C build-deb install
 
 # The following files are not used on Debian (we ship our own sysvinit script)
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
