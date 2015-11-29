From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/4] Fix several automake warnings
Date: Sun, 29 Nov 2015 11:44:06 -0800
Message-ID: <565B5586.80005@sandisk.com>
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

Avoid that automake reports the following warning messages:

configure.ac:13: warning: AM_INIT_AUTOMAKE: two- and three-arguments forms are deprecated.  For more info, see:
configure.ac:13: http://www.gnu.org/software/automake/manual/automake.html#Modernize-AM_005fINIT_005fAUTOMAKE-invocation
small_utils/Makefile.am:50: warning: compiling 'mtserver.c' with per-target flags requires 'AM_PROG_CC_C_O' in 'configure.ac'
warning: 'libdev_mgt.a': linking libraries using a non-POSIX archiver requires 'AM_PROG_AR' in 'configure.ac'
warning: 'INCLUDES' is the old name for 'AM_CPPFLAGS' (or '*_CPPFLAGS')

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 cmdif/Makefile.am            | 2 +-
 cmdparser/Makefile.am        | 2 --
 configure.ac                 | 4 +++-
 dev_mgt/Makefile.am          | 2 +-
 flint/Makefile.am            | 2 +-
 mflash/Makefile.am           | 2 +-
 mft_utils/Makefile.am        | 2 +-
 mlxconfig/Makefile.am        | 2 +-
 mlxfwops/lib/Makefile.am     | 2 +-
 mstdump/crd_lib/Makefile.am  | 2 +-
 mstdump/crd_main/Makefile.am | 2 +-
 mtcr_ul/Makefile.am          | 2 +-
 reg_access/Makefile.am       | 2 +-
 small_utils/Makefile.am      | 2 +-
 tools_layouts/Makefile.am    | 2 +-
 tools_res_mgmt/Makefile.am   | 2 +-
 16 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/cmdif/Makefile.am b/cmdif/Makefile.am
index 78aba47..8c03fe9 100644
--- a/cmdif/Makefile.am
+++ b/cmdif/Makefile.am
@@ -34,7 +34,7 @@
 USER_DIR = $(top_srcdir)
 MTCR_DIR = $(USER_DIR)/include/mtcr_ul
 TOOLS_LAYOUTS_DIR = $(USER_DIR)/tools_layouts
-INCLUDES = -I. -I../common -I../tools_layouts  -I$(MTCR_DIR) -I.. -I$(USER_DIR)/mtcr_ul
+AM_CPPFLAGS = -I. -I../common -I../tools_layouts  -I$(MTCR_DIR) -I.. -I$(USER_DIR)/mtcr_ul
 
 AM_CFLAGS = -W -Wall -Werror -g -MP -MD $(COMPILER_FPIC) -DCMDIF_EXPORTS
 CMDIF_VERSION = 1
diff --git a/cmdparser/Makefile.am b/cmdparser/Makefile.am
index 9696f71..952a074 100644
--- a/cmdparser/Makefile.am
+++ b/cmdparser/Makefile.am
@@ -32,8 +32,6 @@
 
 # Makefile.am -- Process this file with automake to produce Makefile.in
 
-INCLUDES =
-
 AM_CPPFLAGS = -W  -g -MP -MD -fPIC
 
 noinst_LIBRARIES = libcmdparser.a
diff --git a/configure.ac b/configure.ac
index be0f9d1..04fb61d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -10,11 +10,13 @@ AC_SUBST([VERSION])
 
 AC_CONFIG_AUX_DIR(config)
 AC_CONFIG_SRCDIR([README])
-AM_INIT_AUTOMAKE(mstflint, 4.1.0)
+AM_INIT_AUTOMAKE([-Wall foreign])
 
 dnl Checks for programs
 AC_PROG_CC
+AM_PROG_CC_C_O
 AC_PROG_CXX
+AM_PROG_AR
 AC_PROG_LIBTOOL
 AC_CONFIG_HEADERS( config.h )
 
diff --git a/dev_mgt/Makefile.am b/dev_mgt/Makefile.am
index 703a27a..147f7aa 100644
--- a/dev_mgt/Makefile.am
+++ b/dev_mgt/Makefile.am
@@ -32,7 +32,7 @@
 
 # Makefile.am -- Process this file with automake to produce Makefile.in
 
-INCLUDES = -I$(srcdir) -I$(top_srcdir) -I$(top_srcdir)/common  -I$(top_srcdir)/include/mtcr_ul
+AM_CPPFLAGS = -I$(srcdir) -I$(top_srcdir) -I$(top_srcdir)/common  -I$(top_srcdir)/include/mtcr_ul
 
 AM_CFLAGS = -W -Wall -g -MP -MD -Wswitch-enum $(COMPILER_FPIC) -DMTCR_EXPORT
 noinst_LIBRARIES = libdev_mgt.a
diff --git a/flint/Makefile.am b/flint/Makefile.am
index f001515..96bb6ad 100755
--- a/flint/Makefile.am
+++ b/flint/Makefile.am
@@ -38,7 +38,7 @@ LAYOUTS_DIR = $(top_srcdir)/tools_layouts
 MFT_UTILS_DIR = $(top_srcdir)/mft_utils
 CMDIF_DIR   = $(top_srcdir)/cmdif
 
-INCLUDES = -I$(top_srcdir) -I$(srcdir) -I$(MTCR_DIR) -I$(MFLASH_DIR) -I$(COMMON_DIR) \
+AM_CPPFLAGS = -I$(top_srcdir) -I$(srcdir) -I$(MTCR_DIR) -I$(MFLASH_DIR) -I$(COMMON_DIR) \
            -I$(LAYOUTS_DIR) -I$(MFT_UTILS_DIR)
 
 mstflint_CXXFLAGS = -Wall -W -g -MP -MD -pipe -DEXTERNAL
diff --git a/mflash/Makefile.am b/mflash/Makefile.am
index 950cabd..c45351a 100644
--- a/mflash/Makefile.am
+++ b/mflash/Makefile.am
@@ -31,7 +31,7 @@
 #--
 
 # Makefile.am -- Process this file with automake to produce Makefile.in
-INCLUDES= -I. -I$(top_srcdir)/include/mtcr_ul -I$(top_srcdir)/common -I$(top_srcdir)/tools_layouts -I$(top_srcdir)/reg_access \
+AM_CPPFLAGS= -I. -I$(top_srcdir)/include/mtcr_ul -I$(top_srcdir)/common -I$(top_srcdir)/tools_layouts -I$(top_srcdir)/reg_access \
           -I$(top_srcdir)/cmdif -I$(top_srcdir)/tools_res_mgmt
 
 AM_CFLAGS = -MD -pipe -Wall -W -DMST_UL -g ${MFLASH_INBAND_FLAG}
diff --git a/mft_utils/Makefile.am b/mft_utils/Makefile.am
index ad9ad8e..ebb3bf3 100644
--- a/mft_utils/Makefile.am
+++ b/mft_utils/Makefile.am
@@ -32,7 +32,7 @@
 
 # Makefile.am -- Process this file with automake to produce Makefile.in
 USER_DIR = $(top_srcdir)
-INCLUDES = -I. -I$(USER_DIR)/common
+AM_CPPFLAGS = -I. -I$(USER_DIR)/common
 
 AM_CFLAGS = -MD -pipe -Wall -W -Werror
 
diff --git a/mlxconfig/Makefile.am b/mlxconfig/Makefile.am
index f4ce674..2b2fd3e 100755
--- a/mlxconfig/Makefile.am
+++ b/mlxconfig/Makefile.am
@@ -42,7 +42,7 @@ UTILS_LIB = $(USER_DIR)/mft_utils/libmftutils.a
 CMDIF_DIR = $(USER_DIR)/cmdif
 
 
-INCLUDES = -I. -I$(USER_DIR) -I$(top_srcdir)/include/mtcr_ul -I$(MTCR_DIR) -I$(COMMON_DIR) $(WIN64_INC)\
+AM_CPPFLAGS = -I. -I$(USER_DIR) -I$(top_srcdir)/include/mtcr_ul -I$(MTCR_DIR) -I$(COMMON_DIR) $(WIN64_INC)\
            -I$(MFT_EXT_LIBS_INC_DIR) -I $(LAYOUTS_DIR) -I$(MFT_EXT_LIBS_INC_DIR)/zlib -I $(UTILS_DIR) -I$(DEV_MGT_DIR) -I$(CMDIF_DIR)
 
 AM_CXXFLAGS = -Wall -W -g -MP -MD -pipe
diff --git a/mlxfwops/lib/Makefile.am b/mlxfwops/lib/Makefile.am
index 050c2fc..8690345 100755
--- a/mlxfwops/lib/Makefile.am
+++ b/mlxfwops/lib/Makefile.am
@@ -40,7 +40,7 @@ LAYOUTS_DIR = $(top_srcdir)/tools_layouts
 UTILS_LIB = $(top_srcdir)/mft_utils
 UEFI_COMMON_DIR = $(top_srcdir)/mlxfwops/uefi_c
 
-INCLUDES = -I$(srcdir) -I$(MTCR_INC_DIR) -I$(MFLASH_DIR) -I$(top_srcdir)/ext_libs/json -I$(MINIXZ_DIR)\
+AM_CPPFLAGS = -I$(srcdir) -I$(MTCR_INC_DIR) -I$(MFLASH_DIR) -I$(top_srcdir)/ext_libs/json -I$(MINIXZ_DIR)\
            -I$(COMMON_DIR) -I$(MFT_EXT_LIBS_INC_DIR)/zlib -I $(LAYOUTS_DIR) -I$(top_srcdir)/common -I$(UTILS_LIB) -I$(UEFI_COMMON_DIR)
 
 MLXFWOPS_VERSION = 1
diff --git a/mstdump/crd_lib/Makefile.am b/mstdump/crd_lib/Makefile.am
index f3e405b..c884184 100755
--- a/mstdump/crd_lib/Makefile.am
+++ b/mstdump/crd_lib/Makefile.am
@@ -33,7 +33,7 @@
 # Makefile.am -- Process this file with automake to produce Makefile.in
 
 
-INCLUDES =	-I$(top_srcdir) -I$(top_srcdir)/include/mtcr_ul -I$(top_srcdir)/common
+AM_CPPFLAGS =	-I$(top_srcdir) -I$(top_srcdir)/include/mtcr_ul -I$(top_srcdir)/common
 AM_CFLAGS = -Wall -W -g -MP -MD -pipe -Wno-unused-function  $(COMPILER_FPIC) -DMTCR_EXPORT -DMST_UL -DDATA_PATH=\"$(pkgdatadir)\"
 
 noinst_LIBRARIES = libcrdump.a
diff --git a/mstdump/crd_main/Makefile.am b/mstdump/crd_main/Makefile.am
index 0c096d4..dd7b32e 100755
--- a/mstdump/crd_main/Makefile.am
+++ b/mstdump/crd_main/Makefile.am
@@ -31,7 +31,7 @@
 #--
 
 # Makefile.am -- Process this file with automake to produce Makefile.in
-INCLUDES = -I$(top_srcdir) -I$(srcdir)/../crd_lib -I$(top_srcdir)/include/mtcr_ul
+AM_CPPFLAGS = -I$(top_srcdir) -I$(srcdir)/../crd_lib -I$(top_srcdir)/include/mtcr_ul
 AM_CFLAGS = -MD -pipe -g -Wall -W
 
 bin_PROGRAMS = mstregdump
diff --git a/mtcr_ul/Makefile.am b/mtcr_ul/Makefile.am
index dd1b68d..63c7d72 100644
--- a/mtcr_ul/Makefile.am
+++ b/mtcr_ul/Makefile.am
@@ -31,7 +31,7 @@
 #--
 
 # Makefile.am -- Process this file with automake to produce Makefile.in
-INCLUDES = -I$(top_srcdir)/include/mtcr_ul -I$(top_srcdir)/common
+AM_CPPFLAGS = -I$(top_srcdir)/include/mtcr_ul -I$(top_srcdir)/common
 
 lib_LIBRARIES = libmtcr_ul.a
 
diff --git a/reg_access/Makefile.am b/reg_access/Makefile.am
index 3e56406..05e5bfe 100644
--- a/reg_access/Makefile.am
+++ b/reg_access/Makefile.am
@@ -36,7 +36,7 @@ COMMON_DIR = $(top_srcdir)/common
 LAYOUTS_DIR = $(top_srcdir)/tools_layouts
 USER_DIR = $(top_srcdir)
 
-INCLUDES = -I. -I$(USER_DIR) -I$(srcdir) -I$(LAYOUTS_DIR) -I$(USER_DIR)/include/mtcr_ul
+AM_CPPFLAGS = -I. -I$(USER_DIR) -I$(srcdir) -I$(LAYOUTS_DIR) -I$(USER_DIR)/include/mtcr_ul
 
 AM_CFLAGS = -W -Wall -Werror -g -MP -MD $(COMPILER_FPIC)
 
diff --git a/small_utils/Makefile.am b/small_utils/Makefile.am
index 838a724..d7d8ff4 100644
--- a/small_utils/Makefile.am
+++ b/small_utils/Makefile.am
@@ -30,7 +30,7 @@
 # SOFTWARE.
 #--
 
-INCLUDES= -I$(top_srcdir)/include/mtcr_ul -I$(top_srcdir)/common
+AM_CPPFLAGS = -I$(top_srcdir)/include/mtcr_ul -I$(top_srcdir)/common
 
 LDADD= ../mtcr_ul/libmtcr_ul.a -ldl
 
diff --git a/tools_layouts/Makefile.am b/tools_layouts/Makefile.am
index f085849..2bd623e 100644
--- a/tools_layouts/Makefile.am
+++ b/tools_layouts/Makefile.am
@@ -31,7 +31,7 @@
 #--
 
 # Makefile.am -- Process this file with automake to produce Makefile.in
-INCLUDES = -I$(top_srcdir)/mtcr_ul -I$(top_srcdir)/common
+AM_CPPFLAGS = -I$(top_srcdir)/mtcr_ul -I$(top_srcdir)/common
 AM_CFLAGS = -Wall -W -g -MP -MD -pipe $(COMPILER_FPIC)
 noinst_LIBRARIES = libtools_layouts.a
 
diff --git a/tools_res_mgmt/Makefile.am b/tools_res_mgmt/Makefile.am
index e155ed4..64d5b71 100644
--- a/tools_res_mgmt/Makefile.am
+++ b/tools_res_mgmt/Makefile.am
@@ -33,7 +33,7 @@
 
 USER_DIR = $(top_srcdir)
 MTCR_DIR = $(USER_DIR)/include/mtcr_ul
-INCLUDES = -I. -I../common -I$(MTCR_DIR) -I.. -I$(USER_DIR)/mtcr_ul
+AM_CPPFLAGS = -I. -I../common -I$(MTCR_DIR) -I.. -I$(USER_DIR)/mtcr_ul
 
 AM_CFLAGS = -W -Wall -Werror -g -MP -MD $(COMPILER_FPIC) 
 noinst_LIBRARIES = libtools_res_mgmt.a
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
