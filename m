From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: [PATCH 2/2] mstflint: Install mflash/mtcr libraries & headers
Date: Tue, 20 Jan 2015 10:45:03 +0100
Message-ID: <20150120104503.5420c06c@b012350-ux>
References: <20150120104126.7f424116@b012350-ux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150120104126.7f424116@b012350-ux>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Adrian Chiris <adrianc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  This is necessary to be able to use libmflash & libmtcr from external=
 programs.

  This also installs the needed libreg_access.a and libtools_layouts.a.

Signed-off-by: S=C3=A9bastien Dugu=C3=A9 <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
---
 mflash/Makefile.am        | 8 +++++++-
 mstflint.spec.in          | 4 ++--
 mtcr_ul/Makefile.am       | 5 +++--
 reg_access/Makefile.am    | 3 ++-
 tools_layouts/Makefile.am | 4 +++-
 5 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/mflash/Makefile.am b/mflash/Makefile.am
index 632539c..68099e3 100644
--- a/mflash/Makefile.am
+++ b/mflash/Makefile.am
@@ -35,8 +35,14 @@ INCLUDES=3D -I. -I$(top_srcdir)/include/mtcr_ul -I$(=
top_srcdir)/common -I$(top_src
=20
 AM_CFLAGS =3D -MD -pipe -Wall -W -DMST_UL -g ${MFLASH_INBAND_FLAG}
=20
-noinst_LIBRARIES =3D libmflash.a
+
+libmflash_adir =3D $(libdir)/mstflint
+libmflash_a_LIBRARIES =3D libmflash.a
=20
 libmflash_a_SOURCES =3D  mflash.c mflash.h\
 			mflash_pack_layer.c mflash_pack_layer.h mflash_access_layer.c mflas=
h_access_layer.h\
 			mflash_types.h mflash_common_structs.h
+
+libraryincludedir=3D$(includedir)/mstflint
+libraryinclude_HEADERS =3D mflash.h mflash_types.h mflash_common_struc=
ts.h \
+			 $(top_srcdir)/common/compatibility.h
diff --git a/mstflint.spec.in b/mstflint.spec.in
index 0d9281b..966224c 100644
--- a/mstflint.spec.in
+++ b/mstflint.spec.in
@@ -78,8 +78,8 @@ rm -rf $RPM_BUILD_ROOT
 %{_bindir}/mstmcra
 %{_bindir}/mstconfig
 %{_bindir}/hca_self_test.ofed
-%{_includedir}/mtcr_ul/mtcr.h
-%{_libdir}/libmtcr_ul.a
+%{_includedir}/mstflint
+%{_libdir}/mstflint/*
 %{_datadir}/mstflint
 %{_mandir}/man1/*
=20
diff --git a/mtcr_ul/Makefile.am b/mtcr_ul/Makefile.am
index dd1b68d..59fc6c5 100644
--- a/mtcr_ul/Makefile.am
+++ b/mtcr_ul/Makefile.am
@@ -33,7 +33,8 @@
 # Makefile.am -- Process this file with automake to produce Makefile.i=
n
 INCLUDES =3D -I$(top_srcdir)/include/mtcr_ul -I$(top_srcdir)/common
=20
-lib_LIBRARIES =3D libmtcr_ul.a
+libmtcr_ul_adir =3D $(libdir)/mstflint
+libmtcr_ul_a_LIBRARIES =3D libmtcr_ul.a
=20
 libmtcr_ul_a_SOURCES =3D mtcr_ul.c mtcr_ib.h  mtcr_int_defs.h\
 			mtcr_tools_cif.c mtcr_tools_cif.h\
@@ -48,6 +49,6 @@ else
 libmtcr_ul_a_CFLAGS +=3D -DNO_INBAND
 endif
=20
-libraryincludedir=3D$(includedir)/mtcr_ul
+libraryincludedir=3D$(includedir)/mstflint
 libraryinclude_HEADERS =3D $(top_srcdir)/include/mtcr_ul/mtcr.h
=20
diff --git a/reg_access/Makefile.am b/reg_access/Makefile.am
index 7f78060..99a83af 100644
--- a/reg_access/Makefile.am
+++ b/reg_access/Makefile.am
@@ -40,7 +40,8 @@ INCLUDES =3D -I. -I$(USER_DIR) -I$(srcdir) -I$(LAYOUT=
S_DIR) -I$(USER_DIR)/include/
=20
 AM_CFLAGS =3D -W -Wall -Werror -g -MP -MD $(COMPILER_FPIC)
=20
-noinst_LIBRARIES =3D libreg_access.a
+libreg_access_adir =3D $(libdir)/mstflint
+libreg_access_a_LIBRARIES =3D libreg_access.a
=20
 libreg_access_a_SOURCES =3D reg_access.c reg_access.h
 libreg_access_a_DEPENDENCIES =3D $(USER_DIR)/tools_layouts/libtools_la=
youts.a
diff --git a/tools_layouts/Makefile.am b/tools_layouts/Makefile.am
index 17bdf6c..8880907 100644
--- a/tools_layouts/Makefile.am
+++ b/tools_layouts/Makefile.am
@@ -33,7 +33,9 @@
 # Makefile.am -- Process this file with automake to produce Makefile.i=
n
 INCLUDES =3D -I$(top_srcdir)/mtcr_ul -I$(top_srcdir)/common
 AM_CFLAGS =3D -Wall -W -g -MP -MD -pipe $(COMPILER_FPIC)
-noinst_LIBRARIES =3D libtools_layouts.a
+
+libtools_layouts_adir =3D $(libdir)/mstflint
+libtools_layouts_a_LIBRARIES =3D libtools_layouts.a
=20
 libtools_layouts_a_SOURCES =3D cibfw_layouts.c adb_to_c_utils.c adb_to=
_c_utils.h cibfw_layouts.h \
 								register_access_open_layouts.h register_access_open_layouts.c =
\
--=20
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
