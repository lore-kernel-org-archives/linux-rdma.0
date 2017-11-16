From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 1/3] debian: Include architecture.mk for DEB_HOST_ARCH definition
Date: Thu, 16 Nov 2017 17:32:44 +0100
Message-ID: <20171116163246.29736-2-benjamin.drung@profitbricks.com>
References: <20171116163246.29736-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116163246.29736-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

dpkg-buildpackage will set DEB_HOST_ARCH, but a direct call of the
debian/rules makefile will not set this environment variable. Therefore
include /usr/share/dpkg/architecture.mk to get this variable set in all
cases. This will fix the build failure on Travis CI.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/rules | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/debian/rules b/debian/rules
index b0fbe1d6..1201f6a6 100755
--- a/debian/rules
+++ b/debian/rules
@@ -1,5 +1,7 @@
 #!/usr/bin/make -f
 
+include /usr/share/dpkg/architecture.mk
+
 export DEB_BUILD_MAINT_OPTIONS=hardening=+all
 
 NO_COHERENT_DMA_ARCHS = armel armhf mips mips64el mipsel
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
