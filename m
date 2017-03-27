From: Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v11 11/12] uapi: export all arch specifics directories
Date: Mon, 27 Mar 2017 14:20:16 +0200
Message-ID: <1490617217-30192-12-git-send-email-nicolas.dichtel@6wind.com>
References: <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490617217-30192-1-git-send-email-nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org
Cc: arnd-r2nGTMty4D4@public.gmane.org, mmarek-IBi9RG/b67k@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, airlied-cv59FeDIM0c@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, slash.tmp-GANU6spQydw@public.gmane.org, daniel.vetter-/w4YWyX8dFk@public.gmane.org, rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jengelh-9+2X+4sQBs8@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org, nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch removes the need of subdir-y. Now all files/directories under
arch/<arch>/include/uapi/ are exported.

The only change for userland is the layout of the command 'make
headers_install_all': directories asm-<arch> are replaced by arch-<arch>/.
Those new directories contains all files/directories of the specified arch.

Note that only cris and tile have more directories than only asm:
 - arch-v[10|32] for cris;
 - arch for tile.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org>
---
 Documentation/kbuild/makefiles.txt | 15 +--------------
 Makefile                           |  6 +++---
 arch/cris/include/uapi/asm/Kbuild  |  3 ---
 arch/tile/include/uapi/asm/Kbuild  |  2 --
 scripts/Makefile.headersinst       |  3 +--
 5 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index b9f7ca4e62ae..e18daca65ccd 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -49,7 +49,6 @@ This document describes the Linux kernel Makefiles.
 		--- 7.3 generic-y
 		--- 7.4 generated-y
 		--- 7.5 mandatory-y
-		--- 7.6 subdir-y
 
 	=== 8 Kbuild Variables
 	=== 9 Makefile language
@@ -1265,7 +1264,7 @@ The pre-processing does:
 - drop all sections that are kernel internal (guarded by ifdef __KERNEL__)
 
 All headers under include/uapi/, include/generated/uapi/,
-arch/<arch>/include/uapi/asm/ and arch/<arch>/include/generated/uapi/asm/
+arch/<arch>/include/uapi/ and arch/<arch>/include/generated/uapi/
 are exported.
 
 A Kbuild file may be defined under arch/<arch>/include/uapi/asm/ and
@@ -1338,18 +1337,6 @@ See subsequent chapter for the syntax of the Kbuild file.
 	The convention is to list one subdir per line and
 	preferably in alphabetic order.
 
-	--- 7.6 subdir-y
-
-	subdir-y may be used to specify a subdirectory to be exported.
-
-		Example:
-			#arch/cris/include/uapi/asm/Kbuild
-			subdir-y += ../arch-v10/arch/
-			subdir-y += ../arch-v32/arch/
-
-	The convention is to list one subdir per line and
-	preferably in alphabetic order.
-
 === 8 Kbuild Variables
 
 The top Makefile exports the following variables:
diff --git a/Makefile b/Makefile
index 6ea27d9f1384..50547481ed5a 100644
--- a/Makefile
+++ b/Makefile
@@ -1131,7 +1131,7 @@ firmware_install:
 export INSTALL_HDR_PATH = $(objtree)/usr
 
 # If we do an all arch process set dst to asm-$(hdr-arch)
-hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
+hdr-dst = $(if $(KBUILD_HEADERS), dst=include/arch-$(hdr-arch), dst=include)
 
 PHONY += archheaders
 archheaders:
@@ -1152,7 +1152,7 @@ headers_install: __headers
 	$(if $(wildcard $(srctree)/arch/$(hdr-arch)/include/uapi/asm/Kbuild),, \
 	  $(error Headers not exportable for the $(SRCARCH) architecture))
 	$(Q)$(MAKE) $(hdr-inst)=include/uapi
-	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst)
+	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi $(hdr-dst)
 
 PHONY += headers_check_all
 headers_check_all: headers_install_all
@@ -1161,7 +1161,7 @@ headers_check_all: headers_install_all
 PHONY += headers_check
 headers_check: headers_install
 	$(Q)$(MAKE) $(hdr-inst)=include/uapi HDRCHECK=1
-	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
+	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/ $(hdr-dst) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
 # Kernel selftest
diff --git a/arch/cris/include/uapi/asm/Kbuild b/arch/cris/include/uapi/asm/Kbuild
index d0c5471856e0..b15bf6bc0e94 100644
--- a/arch/cris/include/uapi/asm/Kbuild
+++ b/arch/cris/include/uapi/asm/Kbuild
@@ -1,5 +1,2 @@
 # UAPI Header export list
 include include/uapi/asm-generic/Kbuild.asm
-
-subdir-y += ../arch-v10/arch/
-subdir-y += ../arch-v32/arch/
diff --git a/arch/tile/include/uapi/asm/Kbuild b/arch/tile/include/uapi/asm/Kbuild
index e0a50111e07f..0c74c3c5ebfa 100644
--- a/arch/tile/include/uapi/asm/Kbuild
+++ b/arch/tile/include/uapi/asm/Kbuild
@@ -2,5 +2,3 @@
 include include/uapi/asm-generic/Kbuild.asm
 
 generic-y += ucontext.h
-
-subdir-y += ../arch
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 20be1fbc19cc..6ba97a1f9c5a 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -2,7 +2,7 @@
 # Installing headers
 #
 # All headers under include/uapi, include/generated/uapi,
-# arch/<arch>/include/uapi/asm and arch/<arch>/include/generated/uapi/asm are
+# arch/<arch>/include/uapi and arch/<arch>/include/generated/uapi are
 # exported.
 # They are preprocessed to remove __KERNEL__ section of the file.
 #
@@ -30,7 +30,6 @@ installdir    := $(INSTALL_HDR_PATH)/$(subst uapi/,,$(_dst))
 srcdir        := $(srctree)/$(obj)
 gendir        := $(objtree)/$(gen)
 subdirs       := $(patsubst $(srcdir)/%/.,%,$(wildcard $(srcdir)/*/.))
-subdirs       += $(subdir-y)
 header-files  := $(notdir $(wildcard $(srcdir)/*.h))
 header-files  += $(notdir $(wildcard $(srcdir)/*.agh))
 header-files  := $(filter-out $(no-export-headers), $(header-files))
-- 
2.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
