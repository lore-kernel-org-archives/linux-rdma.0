From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 5/6] debian: Drop lintian overrides for false positives
Date: Tue, 14 Nov 2017 21:02:46 +0100
Message-ID: <20171114200247.25890-6-benjamin.drung@profitbricks.com>
References: <20171114200247.25890-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114200247.25890-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

lintian 2.5.59 does not complain about the false positives any more.
Thus the lintian overrides can be removed.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/libibumad-dev.lintian-overrides | 3 ---
 debian/libibumad3.lintian-overrides    | 2 --
 2 files changed, 5 deletions(-)
 delete mode 100644 debian/libibumad-dev.lintian-overrides
 delete mode 100644 debian/libibumad3.lintian-overrides

diff --git a/debian/libibumad-dev.lintian-overrides b/debian/libibumad-dev.lintian-overrides
deleted file mode 100644
index ed71b738..00000000
--- a/debian/libibumad-dev.lintian-overrides
+++ /dev/null
@@ -1,3 +0,0 @@
-# False positive for Certificate Authoritys (CAs)
-libibumad-dev: spelling-error-in-manpage usr/share/man/man3/umad_get_cas_names.3.gz cas case
-libibumad-dev: spelling-error-in-manpage usr/share/man/man3/umad_get_cas_names.3.gz CAs Case
diff --git a/debian/libibumad3.lintian-overrides b/debian/libibumad3.lintian-overrides
deleted file mode 100644
index cb001b96..00000000
--- a/debian/libibumad3.lintian-overrides
+++ /dev/null
@@ -1,2 +0,0 @@
-# False positive for Certificate Authoritys (CAs)
-libibumad3: spelling-error-in-binary usr/lib/x86_64-linux-gnu/libibumad.so.3.0.15 cas case
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
