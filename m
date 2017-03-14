From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH v10 04/11] Makefile.headersinst: cleanup input files
Date: Tue, 14 Mar 2017 13:54:46 +0100
Message-ID: <1489496093-15315-5-git-send-email-nicolas.dichtel@6wind.com>
References: <CAK7LNARpx7f0eV5_AiPmNYT7MsRbGFOygJwjfAzX_7aCpuHwuw@mail.gmail.com>
 <1489496093-15315-1-git-send-email-nicolas.dichtel@6wind.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1489496093-15315-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
To: yamada.masahiro@socionext.com
Cc: arnd@arndb.de, mmarek@suse.com, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, airlied@linux.ie, davem@davemloft.net, linux@armlinux.org.uk, bp@alien8.de, slash.tmp@free.fr, daniel.vetter@ffwll.ch, rmk+kernel@armlinux.org.uk, msalter@redhat.com, jengelh@inai.de, hch@infradead.org, tklauser@distanz.ch, mpe@ellerman.id.au, mingo@kernel.org, tglx@linutronix.de, ldv@altlinux.org, nicolas.dichtel@6wind.com, herbert@gondor.apana.org.au, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

After the last three patches, all exported headers are under uapi/, thus
input-files2 are not needed anymore.
The side effect is that input-files1-name is exactly header-y.

Note also that input-files3-name is genhdr-y.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 scripts/Makefile.headersinst | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 1106d6ca3a38..7bd9df6efe2f 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -40,31 +40,20 @@ wrapper-files := $(filter $(header-y), $(generic-y))
 srcdir        := $(srctree)/$(obj)
 gendir        := $(objtree)/$(gen)
 
-oldsrcdir     := $(srctree)/$(subst /uapi,,$(obj))
-
 # all headers files for this dir
 header-y      := $(filter-out $(generic-y), $(header-y))
 all-files     := $(header-y) $(genhdr-y) $(wrapper-files)
 output-files  := $(addprefix $(installdir)/, $(all-files))
 
-input-files1  := $(foreach hdr, $(header-y), \
-		   $(if $(wildcard $(srcdir)/$(hdr)), \
-			$(wildcard $(srcdir)/$(hdr))) \
-		   )
-input-files1-name := $(notdir $(input-files1))
-input-files2  := $(foreach hdr, $(header-y), \
-		   $(if  $(wildcard $(srcdir)/$(hdr)),, \
-			$(if $(wildcard $(oldsrcdir)/$(hdr)), \
-				$(wildcard $(oldsrcdir)/$(hdr)), \
-				$(error Missing UAPI file $(srcdir)/$(hdr))) \
-		   ))
-input-files2-name := $(notdir $(input-files2))
-input-files3  := $(foreach hdr, $(genhdr-y), \
-		   $(if	$(wildcard $(gendir)/$(hdr)), \
-			$(wildcard $(gendir)/$(hdr)), \
-			$(error Missing generated UAPI file $(gendir)/$(hdr)) \
-		   ))
-input-files3-name := $(notdir $(input-files3))
+# Check that all expected files exist
+$(foreach hdr, $(header-y), \
+  $(if $(wildcard $(srcdir)/$(hdr)),, \
+       $(error Missing UAPI file $(srcdir)/$(hdr)) \
+   ))
+$(foreach hdr, $(genhdr-y), \
+  $(if	$(wildcard $(gendir)/$(hdr)),, \
+       $(error Missing generated UAPI file $(gendir)/$(hdr)) \
+  ))
 
 # Work out what needs to be removed
 oldheaders    := $(patsubst $(installdir)/%,%,$(wildcard $(installdir)/*.h))
@@ -78,9 +67,8 @@ printdir = $(patsubst $(INSTALL_HDR_PATH)/%/,%,$(dir $@))
 quiet_cmd_install = INSTALL $(printdir) ($(words $(all-files))\
                             file$(if $(word 2, $(all-files)),s))
       cmd_install = \
-        $(CONFIG_SHELL) $< $(installdir) $(srcdir) $(input-files1-name); \
-        $(CONFIG_SHELL) $< $(installdir) $(oldsrcdir) $(input-files2-name); \
-        $(CONFIG_SHELL) $< $(installdir) $(gendir) $(input-files3-name); \
+        $(CONFIG_SHELL) $< $(installdir) $(srcdir) $(header-y); \
+        $(CONFIG_SHELL) $< $(installdir) $(gendir) $(genhdr-y); \
         for F in $(wrapper-files); do                                   \
                 echo "\#include <asm-generic/$$F>" > $(installdir)/$$F;    \
         done;                                                           \
@@ -106,7 +94,9 @@ __headersinst: $(subdirs) $(install-file)
 	@:
 
 targets += $(install-file)
-$(install-file): scripts/headers_install.sh $(input-files1) $(input-files2) $(input-files3) FORCE
+$(install-file): scripts/headers_install.sh \
+		 $(addprefix $(srcdir)/,$(header-y)) \
+		 $(addprefix $(gendir)/,$(genhdr-y)) FORCE
 	$(if $(unwanted),$(call cmd,remove),)
 	$(if $(wildcard $(dir $@)),,$(shell mkdir -p $(dir $@)))
 	$(call if_changed,install)
-- 
2.8.1
