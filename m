From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/4] Makefile.am: Remove the undefined variable
 MFT_EXT_LIBS_INC_DIR
Date: Sun, 29 Nov 2015 11:44:40 -0800
Message-ID: <565B55A8.8080302@sandisk.com>
References: <565B553C.6020005@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <565B553C.6020005-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Chiris <adrianc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This avoids that the option sequence "-I -I" is passed to the compiler,
a sequence that causes weird error messages to be printed.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 mlxconfig/Makefile.am    | 2 +-
 mlxfwops/lib/Makefile.am | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mlxconfig/Makefile.am b/mlxconfig/Makefile.am
index 2b2fd3e..c9189aa 100755
--- a/mlxconfig/Makefile.am
+++ b/mlxconfig/Makefile.am
@@ -43,7 +43,7 @@ CMDIF_DIR = $(USER_DIR)/cmdif
 
 
 AM_CPPFLAGS = -I. -I$(USER_DIR) -I$(top_srcdir)/include/mtcr_ul -I$(MTCR_DIR) -I$(COMMON_DIR) $(WIN64_INC)\
-           -I$(MFT_EXT_LIBS_INC_DIR) -I $(LAYOUTS_DIR) -I$(MFT_EXT_LIBS_INC_DIR)/zlib -I $(UTILS_DIR) -I$(DEV_MGT_DIR) -I$(CMDIF_DIR)
+           -I $(LAYOUTS_DIR) -I $(UTILS_DIR) -I$(DEV_MGT_DIR) -I$(CMDIF_DIR)
 
 AM_CXXFLAGS = -Wall -W -g -MP -MD -pipe
 bin_PROGRAMS = mstconfig
diff --git a/mlxfwops/lib/Makefile.am b/mlxfwops/lib/Makefile.am
index 8690345..c04d333 100755
--- a/mlxfwops/lib/Makefile.am
+++ b/mlxfwops/lib/Makefile.am
@@ -41,7 +41,7 @@ UTILS_LIB = $(top_srcdir)/mft_utils
 UEFI_COMMON_DIR = $(top_srcdir)/mlxfwops/uefi_c
 
 AM_CPPFLAGS = -I$(srcdir) -I$(MTCR_INC_DIR) -I$(MFLASH_DIR) -I$(top_srcdir)/ext_libs/json -I$(MINIXZ_DIR)\
-           -I$(COMMON_DIR) -I$(MFT_EXT_LIBS_INC_DIR)/zlib -I $(LAYOUTS_DIR) -I$(top_srcdir)/common -I$(UTILS_LIB) -I$(UEFI_COMMON_DIR)
+           -I$(COMMON_DIR) -I $(LAYOUTS_DIR) -I$(top_srcdir)/common -I$(UTILS_LIB) -I$(UEFI_COMMON_DIR)
 
 MLXFWOPS_VERSION = 1
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
