From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v11 05/12] Makefile.headersinst: remove destination-y option
Date: Mon, 27 Mar 2017 14:20:10 +0200
Message-ID: <1490617217-30192-6-git-send-email-nicolas.dichtel@6wind.com>
References: <CAK7LNAR_yp+O9jUZC8mKdaHgTiCkE7p2-ZbA9YZ8OGyp+uxhBQ@mail.gmail.com>
 <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1490617217-30192-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-arch-owner@vger.kernel.org
To: yamada.masahiro@socionext.com
Cc: arnd@arndb.de, mmarek@suse.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This option was added in commit c7bb349e7c25 ("kbuild: introduce destination-y
for exported headers") but never used in-tree.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/kbuild/makefiles.txt | 23 ++++-------------------
 scripts/Makefile.headersinst       |  2 +-
 2 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 9b9c4797fc55..37b525d329ae 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -46,9 +46,8 @@ This document describes the Linux kernel Makefiles.
 	=== 7 Kbuild syntax for exported headers
 		--- 7.1 header-y
 		--- 7.2 genhdr-y
-		--- 7.3 destination-y
-		--- 7.4 generic-y
-		--- 7.5 generated-y
+		--- 7.3 generic-y
+		--- 7.4 generated-y
 
 	=== 8 Kbuild Variables
 	=== 9 Makefile language
@@ -1295,21 +1294,7 @@ See subsequent chapter for the syntax of the Kbuild file.
 			#include/linux/Kbuild
 			genhdr-y += version.h
 
-	--- 7.3 destination-y
-
-	When an architecture has a set of exported headers that needs to be
-	exported to a different directory destination-y is used.
-	destination-y specifies the destination directory for all exported
-	headers in the file where it is present.
-
-		Example:
-			#arch/xtensa/platforms/s6105/include/platform/Kbuild
-			destination-y := include/linux
-
-	In the example above all exported headers in the Kbuild file
-	will be located in the directory "include/linux" when exported.
-
-	--- 7.4 generic-y
+	--- 7.3 generic-y
 
 	If an architecture uses a verbatim copy of a header from
 	include/asm-generic then this is listed in the file
@@ -1336,7 +1321,7 @@ See subsequent chapter for the syntax of the Kbuild file.
 		Example: termios.h
 			#include <asm-generic/termios.h>
 
-	--- 7.5 generated-y
+	--- 7.4 generated-y
 
 	If an architecture generates other header files alongside generic-y
 	wrappers, and not included in genhdr-y, then generated-y specifies
diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 7bd9df6efe2f..ca5d439c9abf 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -14,7 +14,7 @@ kbuild-file := $(srctree)/$(obj)/Kbuild
 include $(kbuild-file)
 
 # called may set destination dir (when installing to asm/)
-_dst := $(if $(destination-y),$(destination-y),$(if $(dst),$(dst),$(obj)))
+_dst := $(if $(dst),$(dst),$(obj))
 
 old-kbuild-file := $(srctree)/$(subst uapi/,,$(obj))/Kbuild
 ifneq ($(wildcard $(old-kbuild-file)),)
-- 
2.8.1
