From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 2/3] debian: Add alpha, hppa, sh4 as non-coherent DMA archs
Date: Thu, 16 Nov 2017 17:32:45 +0100
Message-ID: <20171116163246.29736-3-benjamin.drung@profitbricks.com>
References: <20171116163246.29736-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116163246.29736-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The architectures alpha, hppa, and sh4 do not support coherent DMA.
Therefore also exclude those.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/rules b/debian/rules
index 1201f6a6..030eb6b9 100755
--- a/debian/rules
+++ b/debian/rules
@@ -4,7 +4,7 @@ include /usr/share/dpkg/architecture.mk
 
 export DEB_BUILD_MAINT_OPTIONS=hardening=+all
 
-NO_COHERENT_DMA_ARCHS = armel armhf mips mips64el mipsel
+NO_COHERENT_DMA_ARCHS = alpha armel armhf hppa mips mips64el mipsel sh4
 
 %:
 	dh $@ --with systemd --builddirectory=build-deb
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
