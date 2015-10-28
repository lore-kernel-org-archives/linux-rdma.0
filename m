From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs] Makefile.am: Fix "make distcheck"
Date: Wed, 28 Oct 2015 17:48:39 +0200
Message-ID: <1446047319-22887-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

make distcheck failed because it searched for headers
in the src directory.
Added noinst_HEADERS to fix that.

Change-Id: Ibc0949286a97ac8775156df6465e31fe301d27db
Signed-off-by: Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Hi Doug,

This fixes a "make distcheck" issue. make distcheck
was broken because it tried to use src/neigh.h and
src/nl1_compat.h header files.

Regards,
Alaa and Matan

 Makefile.am | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile.am b/Makefile.am
index c85e98a..7d22e06 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -15,6 +15,7 @@ src_libibverbs_la_SOURCES = src/cmd.c src/compat-1_0.c src/device.c src/init.c \
 			    src/enum_strs.c
 if ! NO_RESOLVE_NEIGH
 src_libibverbs_la_SOURCES += src/neigh.c
+noinst_HEADERS = src/neigh.h src/nl1_compat.h
 endif
 src_libibverbs_la_LDFLAGS = -version-info 1 -export-dynamic \
     $(libibverbs_version_script)
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
