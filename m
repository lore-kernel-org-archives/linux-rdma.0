From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH libibmad] configure.ac: Update AM_INIT_AUTOMAKE to use
 subdir-objects
Date: Mon, 14 Nov 2016 16:34:36 -0500
Message-ID: <ba76fb4e-804b-9202-2619-65e0fec703d9@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


With this option, the objects are placed into the subdirectory of
the build directory corresponding to the subdirectory of the source file.

Fixes the following warning:
Makefile.am:16: warning: source file 'src/dump.c' is in a subdirectory,
Makefile.am:16: but option 'subdir-objects' is disabled
automake: warning: possible forward-incompatibility.
automake: At least a source file is in a subdirectory, but the 'subdir-objects'
automake: automake option hasn't been enabled.  For now, the corresponding output
automake: object file(s) will be placed in the top-level directory.  However,
automake: this behaviour will change in future Automake versions: they will
automake: unconditionally cause object files to be placed in the same subdirectory
automake: of the corresponding sources.
automake: You are advised to start using 'subdir-objects' option throughout your
automake: project, to avoid future incompatibilities.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/configure.ac b/configure.ac
index 843dbfd..6453e11 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,7 +6,7 @@ AC_CONFIG_SRCDIR([src/sa.c])
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_MACRO_DIR(config)
 AM_CONFIG_HEADER(config.h)
-AM_INIT_AUTOMAKE
+AM_INIT_AUTOMAKE([subdir-objects])
 
 AC_SUBST(RELEASE, ${RELEASE:-unknown})
 AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
