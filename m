From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v8 11/11] uapi: export all arch specifics directories
Date: Tue, 28 Feb 2017 21:47:37 +0100
Message-ID: <1488314857-28327-12-git-send-email-nicolas.dichtel@6wind.com>
References: <20170228024844.GA28691@altlinux.org>
 <1488314857-28327-1-git-send-email-nicolas.dichtel@6wind.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1488314857-28327-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-arch-owner@vger.kernel.org
To: arnd@arndb.de, mmarek@suse.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This patch removes the need of subdir-y. Now all files/directories under
arch/<arch>/include/uapi/ are exported.

The only change for userland is the layout of the command 'make
headers_install_all': directories asm-<arch> are replaced by arch-<arch>/.
Those new directories contains all files/directories of the specified arch.

Note that only cris and tile have more directories than only asm:
 - arch-v[10|32] for cris;
 - arch for tile.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 Documentation/kbuild/makefiles.txt | 15 +--------------
 Makefile                           |  6 +++---
 arch/cris/include/uapi/asm/Kbuild  |  3 ---
 arch/tile/include/uapi/asm/Kbuild  |  2 --
 scripts/Makefile.headersinst       |  3 +--
 5 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 91ffb391ed54..223b33d5195a 100644
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
index b83109b5d217..ecb319dd6675 100644
--- a/Makefile
+++ b/Makefile
@@ -1128,7 +1128,7 @@ firmware_install:
 export INSTALL_HDR_PATH = $(objtree)/usr
 
 # If we do an all arch process set dst to asm-$(hdr-arch)
-hdr-dst = $(if $(KBUILD_HEADERS), dst=include/asm-$(hdr-arch), dst=include/asm)
+hdr-dst = $(if $(KBUILD_HEADERS), dst=include/arch-$(hdr-arch), dst=include)
 
 PHONY += archheaders
 archheaders:
@@ -1149,7 +1149,7 @@ headers_install: __headers
 	$(if $(wildcard $(srctree)/arch/$(hdr-arch)/include/uapi/asm/Kbuild),, \
 	  $(error Headers not exportable for the $(SRCARCH) architecture))
 	$(Q)$(MAKE) $(hdr-inst)=include/uapi
-	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst)
+	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi $(hdr-dst)
 
 PHONY += headers_check_all
 headers_check_all: headers_install_all
@@ -1158,7 +1158,7 @@ headers_check_all: headers_install_all
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
index 122945618ae2..1aeb4f45208f 100644
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
 header-files  := $(filter-out $(header-n), $(header-files))
-- 
2.8.1
