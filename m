From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] fix rpmbuild with and w/o ibmgtsim build
Date: Wed, 5 Jan 2011 16:57:03 -0800
Message-ID: <20110105165703.06ac4526.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


[PATCH] fix rpmbuild with and w/o ibmgtsim build


Signed-off-by: Ira Weiny <weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
---
 Makefile.am     |    2 +-
 ibutils.spec.in |   14 ++++++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 87b071d..cb13dbd 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -45,7 +45,7 @@ MAINTAINERCLEANFILES = Makefile.in aclocal.m4 configure config-h.in
 
 ACLOCAL			= aclocal -I $(ac_aux_dir)
 
-EXTRA_DIST = ibutils.spec.in
+EXTRA_DIST = ibutils.spec.in ibmgtsim
 
 dist-hook: ibutils.spec
 	cp ibutils.spec $(distdir)
diff --git a/ibutils.spec.in b/ibutils.spec.in
index f044aff..a5d7b76 100644
--- a/ibutils.spec.in
+++ b/ibutils.spec.in
@@ -31,6 +31,7 @@
 #--
 
 %{?build_ibmgtsim: %define ibmgtsim --enable-ibmgtsim}
+%{?build_ibmgtsim: %define ibmgtsim_files 1}
 
 Summary: OpenIB Mellanox InfiniBand Diagnostic Tools
 Name: ibutils
@@ -128,17 +129,20 @@ rm -rf $RPM_BUILD_DIR/%{name}-%{version}
 %{_mandir}/man1/ibdm-ibnl-file.1*
 /etc/profile.d/ibutils.sh
 /etc/profile.d/ibutils.csh
+%{_prefix}/bin/dump2slvl.pl
+%{_prefix}/bin/dump2psl.pl
+%{_libdir}/libibsysapi.so*
+%{_libdir}/libibsysapi.a
+
+# These are only installed when ibmgtsim is built
+%if %{?ibmgtsim_files:1}
 %{_prefix}/bin/mkSimNodeDir
 %{_prefix}/bin/ibmssh
 %{_prefix}/bin/ibmsquit
 %{_prefix}/bin/RunSimTest
 %{_prefix}/bin/IBMgtSim
-%{_prefix}/bin/dump2slvl.pl
-%{_prefix}/bin/dump2psl.pl
 %{_libdir}/libibmscli.so*
 %{_libdir}/libibmscli.a
-%{_libdir}/libibsysapi.so*
-%{_libdir}/libibsysapi.a
 %{_prefix}/include/ibmgtsim
 %{_prefix}/share/ibmgtsim
 %{_mandir}/man1/ibmssh.1*
@@ -146,6 +150,8 @@ rm -rf $RPM_BUILD_DIR/%{name}-%{version}
 %{_mandir}/man1/mkSimNodeDir.1*
 %{_mandir}/man1/RunSimTest.1*
 %{_mandir}/man1/IBMgtSim.1*
+%endif
+
 # END Files
 
 %changelog
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
