From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 1/3] debian: Add m68k as non-coherent DMA architecture
Date: Thu, 30 Nov 2017 13:39:38 +0100
Message-ID: <20171130123940.25795-2-benjamin.drung@profitbricks.com>
References: <20171130123940.25795-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171130123940.25795-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The architecture m68k does not support coherent DMA. Therefore also
exclude it.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/rules b/debian/rules
index 030eb6b9..be1781ad 100755
--- a/debian/rules
+++ b/debian/rules
@@ -4,7 +4,7 @@ include /usr/share/dpkg/architecture.mk
 
 export DEB_BUILD_MAINT_OPTIONS=hardening=+all
 
-NO_COHERENT_DMA_ARCHS = alpha armel armhf hppa mips mips64el mipsel sh4
+NO_COHERENT_DMA_ARCHS = alpha armel armhf hppa m68k mips mips64el mipsel sh4
 
 %:
 	dh $@ --with systemd --builddirectory=build-deb
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
