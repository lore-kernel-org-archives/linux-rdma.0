From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: [PATCH 1/2] mstflint: Fix make dist-xx Makefile targets
Date: Tue, 20 Jan 2015 10:45:00 +0100
Message-ID: <20150120104500.779f8ebd@b012350-ux>
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


  Add some needed headers that make dist-xx left out of the generated
archive.

Signed-off-by: S=C3=A9bastien Dugu=C3=A9 <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
---
 cmdif/Makefile.am      | 2 +-
 mflash/Makefile.am     | 2 +-
 mft_utils/Makefile.am  | 3 ++-
 reg_access/Makefile.am | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/cmdif/Makefile.am b/cmdif/Makefile.am
index b3ac612..60be402 100644
--- a/cmdif/Makefile.am
+++ b/cmdif/Makefile.am
@@ -40,5 +40,5 @@ AM_CFLAGS =3D -W -Wall -Werror -g -MP -MD $(COMPILER_=
=46PIC) -DCMDIF_EXPORTS
 CMDIF_VERSION =3D 1
 noinst_LIBRARIES =3D libcmdif.a
=20
-libcmdif_a_SOURCES =3D tools_cif.c
+libcmdif_a_SOURCES =3D tools_cif.c tools_cif.h
=20
diff --git a/mflash/Makefile.am b/mflash/Makefile.am
index b4a87cf..632539c 100644
--- a/mflash/Makefile.am
+++ b/mflash/Makefile.am
@@ -39,4 +39,4 @@ noinst_LIBRARIES =3D libmflash.a
=20
 libmflash_a_SOURCES =3D  mflash.c mflash.h\
 			mflash_pack_layer.c mflash_pack_layer.h mflash_access_layer.c mflas=
h_access_layer.h\
-			mflash_types.h mlash_common_structs.h
+			mflash_types.h mflash_common_structs.h
diff --git a/mft_utils/Makefile.am b/mft_utils/Makefile.am
index ad9ad8e..4cd121c 100644
--- a/mft_utils/Makefile.am
+++ b/mft_utils/Makefile.am
@@ -40,5 +40,6 @@ noinst_HEADERS =3D mft_sig_handler.h errmsg.h
=20
 noinst_LIBRARIES =3D libmftutils.a
=20
-libmftutils_a_SOURCES =3D  mft_sig_handler.c errmsg.cpp
+libmftutils_a_SOURCES =3D  mft_sig_handler.c errmsg.cpp \
+		$(top_srcdir)/common/tools_utils.h
=20
diff --git a/reg_access/Makefile.am b/reg_access/Makefile.am
index 3e56406..7f78060 100644
--- a/reg_access/Makefile.am
+++ b/reg_access/Makefile.am
@@ -42,7 +42,7 @@ AM_CFLAGS =3D -W -Wall -Werror -g -MP -MD $(COMPILER_=
=46PIC)
=20
 noinst_LIBRARIES =3D libreg_access.a
=20
-libreg_access_a_SOURCES =3D reg_access.c
+libreg_access_a_SOURCES =3D reg_access.c reg_access.h
 libreg_access_a_DEPENDENCIES =3D $(USER_DIR)/tools_layouts/libtools_la=
youts.a
 libreg_access_a_LIBADD =3D $(libreg_access_a_DEPENDENCIES)
=20
--=20
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
