From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 5/5] infiniband-diags: move deprecated scripts to compat rpm
Date: Mon, 21 Nov 2011 16:03:18 -0800
Message-ID: <20111121160318.9e85384b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



In addition remove them from the make install target unless autoconf'ed on.

Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am               |   77 +++++++++++++++++-------------
 configure.in              |   12 +++++
 infiniband-diags.spec.in  |  113 +++++++++++++++++++++++++++++++++++++++++++--
 man/infiniband-diags.8.in |    3 +-
 4 files changed, 166 insertions(+), 39 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index b738806..3a8dbc4 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -25,21 +25,49 @@ if ENABLE_TEST_UTILS
 sbin_PROGRAMS += src/ibsendtrap src/mcm_rereg_test
 endif
 
-sbin_SCRIPTS = scripts/ibcheckerrs scripts/ibchecknet scripts/ibchecknode \
-               scripts/ibcheckport scripts/ibhosts scripts/ibstatus \
-	       scripts/ibswitches scripts/ibnodes scripts/ibrouters \
-	       scripts/ibcheckwidth scripts/ibcheckportwidth \
-	       scripts/ibcheckstate scripts/ibcheckportstate \
-	       scripts/ibcheckerrors scripts/ibclearerrors \
-	       scripts/ibclearcounters scripts/ibdatacounts \
-	       scripts/ibdatacounters scripts/ibdiscover.pl \
-	       scripts/dump_lfts.sh scripts/dump_mfts.sh \
-	       scripts/set_nodedesc.sh \
-	       scripts/ibqueryerrors.pl scripts/ibswportwatch.pl \
-	       scripts/iblinkinfo.pl scripts/ibprintswitch.pl \
-	       scripts/ibprintca.pl scripts/ibprintrt.pl \
-	       scripts/ibfindnodesusing.pl scripts/ibidsverify.pl \
-	       scripts/check_lft_balance.pl
+sbin_SCRIPTS = scripts/ibhosts \
+		scripts/ibswitches scripts/ibnodes scripts/ibrouters \
+		scripts/ibfindnodesusing.pl scripts/ibidsverify.pl \
+		scripts/set_nodedesc.sh scripts/check_lft_balance.pl \
+		scripts/ibclearerrors scripts/ibclearcounters
+
+if ENABLE_COMPAT_UTILS
+sbin_SCRIPTS += scripts/ibcheckerrs scripts/ibchecknet scripts/ibchecknode \
+		scripts/ibcheckport scripts/ibstatus \
+		scripts/ibcheckwidth scripts/ibcheckportwidth \
+		scripts/ibcheckstate scripts/ibcheckportstate \
+		scripts/ibcheckerrors scripts/ibdatacounts \
+		scripts/ibdatacounters scripts/ibdiscover.pl \
+		scripts/dump_lfts.sh scripts/dump_mfts.sh \
+		scripts/ibqueryerrors.pl scripts/ibswportwatch.pl \
+		scripts/iblinkinfo.pl scripts/ibprintswitch.pl \
+		scripts/ibprintca.pl scripts/ibprintrt.pl
+endif
+
+man_MANS = man/ibaddr.8 man/ibping.8 \
+		man/ibnodes.8 man/ibhosts.8 man/ibnetdiscover.8 \
+		man/ibportstate.8 man/ibroute.8 man/ibstat.8 \
+		man/ibswitches.8 man/ibtracert.8 man/perfquery.8 man/sminfo.8 \
+		man/smpdump.8 man/smpquery.8 man/saquery.8 man/vendstat.8 \
+		man/dump_lfts.8 man/dump_mfts.8 man/ibsysstat.8 \
+		man/iblinkinfo.8 man/ibqueryerrors.8 man/ibfindnodesusing.8 \
+		man/ibrouters.8 man/check_lft_balance.8 man/ibcacheedit.8 \
+		man/infiniband-diags.8 man/ibclearcounters.8 man/ibclearerrors.8 \
+		man/ibccquery.8
+
+# define this for the dist target
+compat_man_pages = man/ibdiscover.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
+		man/ibchecknet.8 man/ibchecknode.8 man/ibcheckport.8 \
+		man/ibcheckportstate.8 man/ibcheckportwidth.8 \
+		man/ibcheckstate.8 man/ibcheckwidth.8 \
+		man/ibstatus.8 man/ibswportwatch.8 \
+		man/ibprintswitch.8 man/ibprintca.8 man/ibdatacounts.8 \
+		man/ibdatacounters.8 man/ibprintrt.8 man/ibidsverify.8
+
+# but only actually install them if specified
+if ENABLE_COMPAT_UTILS
+man_MANS += $(compat_man_pages)
+endif
 
 noinst_LIBRARIES = libcommon.a
 
@@ -86,23 +114,6 @@ src_ibqueryerrors_SOURCES = src/ibqueryerrors.c
 src_ibqueryerrors_LDFLAGS = -L$(top_builddir)/libibnetdisc -libnetdisc
 endif
 
-man_MANS = man/ibaddr.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
-	man/ibchecknet.8 man/ibchecknode.8 man/ibcheckport.8 \
-	man/ibcheckportstate.8 man/ibcheckportwidth.8 man/ibcheckstate.8 \
-	man/ibcheckwidth.8 man/ibclearcounters.8 man/ibclearerrors.8 \
-	man/ibhosts.8 man/ibnetdiscover.8 man/ibnodes.8 man/ibping.8 \
-	man/ibportstate.8 man/ibroute.8 man/ibstat.8 man/ibstatus.8 \
-	man/ibswitches.8 man/ibtracert.8 man/perfquery.8 man/sminfo.8 \
-	man/smpdump.8 man/smpquery.8 man/saquery.8 man/vendstat.8 \
-	man/dump_lfts.8 man/dump_mfts.8 man/ibdiscover.8 man/ibsysstat.8 \
-	man/iblinkinfo.8 man/ibqueryerrors.8 man/ibswportwatch.8 \
-	man/ibprintswitch.8 man/ibprintca.8 man/ibfindnodesusing.8 \
-	man/ibdatacounts.8 man/ibdatacounters.8 \
-	man/ibrouters.8 man/ibprintrt.8 man/ibidsverify.8 \
-	man/check_lft_balance.8 man/ibcacheedit.8 \
-	man/infiniband-diags.8 man/ibccquery.8
-
-
 BUILT_SOURCES = ibdiag_version
 ibdiag_version:
 	if [ -x $(top_srcdir)/gen_ver.sh ] ; then \
@@ -116,7 +127,7 @@ ibdiag_version:
 	fi
 
 EXTRA_DIST = scripts include infiniband-diags.spec.in infiniband-diags.spec \
-	$(man_MANS) autogen.sh etc/*
+	$(man_MANS) $(compat_man_pages) autogen.sh etc/*
 
 dist-hook:
 	if [ -x $(top_srcdir)/gen_chlog.sh ] ; then \
diff --git a/configure.in b/configure.in
index 0652948..e0af657 100644
--- a/configure.in
+++ b/configure.in
@@ -79,6 +79,18 @@ esac],[tutils=no])
 AM_CONDITIONAL(ENABLE_TEST_UTILS, test x$tutils = xyes)
 AC_MSG_RESULT(${tutils=no})
 
+dnl Check if we should include compat utils
+AC_MSG_CHECKING(for --enable-compat-utils)
+AC_ARG_ENABLE(compat-utils,
+[  --enable-compat-utils build deprecated compatibility utilities (default=no)],
+[case "${enableval}" in
+  yes) cutils=yes ;;
+  no)  cutils=no ;;
+  *) AC_MSG_ERROR(bad value ${enableval} for --enable-compat-utils) ;;
+esac],[cutils=no])
+AM_CONDITIONAL(ENABLE_COMPAT_UTILS, test x$cutils = xyes)
+AC_MSG_RESULT(${cutils=no})
+
 dnl Check for perl and perl install location
 AC_MSG_CHECKING(for --with-perl-path )
 AC_ARG_WITH(perl-path,
diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index af94277..d97eed5 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -20,11 +20,22 @@ Obsoletes: openib-diags
 This package provides IB diagnostic programs and scripts needed to
 diagnose an IB subnet.
 
+%package compat
+Summary: OpenFabrics Alliance InfiniBand Diagnostic Tools
+Group: System Environment/Libraries
+BuildRequires: libibmad-devel, opensm-devel, libibumad-devel
+Requires: libibmad, opensm-libs, libibumad
+
+%description compat
+Deprecated scripts and utilities which provide duplicated functionality, most
+often at a reduced performance.  These are maintained for the time being for
+compatibility reasons.
+
 %prep
 %setup -q
 
 %build
-%configure
+%configure --enable-compat-utils
 make
 
 %install
@@ -36,24 +47,116 @@ rm -f $RPM_BUILD_ROOT%{_libdir}/*.la
 %clean
 rm -rf $RPM_BUILD_ROOT
 
+%files compat
+%defattr(-,root,root)
+%{_sbindir}/iblinkinfo.pl
+%{_sbindir}/ibqueryerrors.pl
+%{_sbindir}/ibdiscover.pl
+%{_mandir}/man8/ibdiscover.8.gz
+%{_sbindir}/ibprintswitch.pl
+%{_mandir}/man8/ibprintswitch.8.gz
+%{_sbindir}/ibprintrt.pl
+%{_mandir}/man8/ibprintrt.8.gz
+%{_sbindir}/ibprintca.pl
+%{_mandir}/man8/ibprintca.8.gz
+%{_sbindir}/ibswportwatch.pl
+%{_mandir}/man8/ibswportwatch.8.gz
+%{_sbindir}/ibcheckerrors
+%{_mandir}/man8/ibcheckerrors.8.gz
+%{_sbindir}/ibcheckerrs
+%{_mandir}/man8/ibcheckerrs.8.gz
+%{_sbindir}/ibchecknet
+%{_mandir}/man8/ibchecknet.8.gz
+%{_sbindir}/ibchecknode
+%{_mandir}/man8/ibchecknode.8.gz
+%{_sbindir}/ibcheckport
+%{_mandir}/man8/ibcheckport.8.gz
+%{_sbindir}/ibcheckportstate
+%{_mandir}/man8/ibcheckportstate.8.gz
+%{_sbindir}/ibcheckportwidth
+%{_mandir}/man8/ibcheckportwidth.8.gz
+%{_sbindir}/ibcheckstate
+%{_mandir}/man8/ibcheckstate.8.gz
+%{_sbindir}/ibcheckwidth
+%{_mandir}/man8/ibcheckwidth.8.gz
+%{_sbindir}/ibstatus
+%{_mandir}/man8/ibstatus.8.gz
+%{_sbindir}/ibdatacounts
+%{_mandir}/man8/ibdatacounts.8.gz
+%{_sbindir}/ibdatacounters
+%{_mandir}/man8/ibdatacounters.8.gz
+%{_sbindir}/ibparsefabricconf
+%{_mandir}/man8/ibparsefabricconf.8.gz
+%{_sbindir}/ibccquery
+%{_mandir}/man8/ibccquery.8.gz
+
+
 %files
 %defattr(-,root,root)
-%{_sbindir}/ib*
+%{_sbindir}/ibfindnodesusing.pl
+%{_mandir}/man8/ibfindnodesusing.8.gz
+%{_sbindir}/ibidsverify.pl
+%{_mandir}/man8/ibidsverify.8.gz
+%{_sbindir}/ibhosts
+%{_mandir}/man8/ibhosts.8.gz
+%{_sbindir}/ibswitches
+%{_mandir}/man8/ibswitches.8.gz
+%{_sbindir}/ibnodes
+%{_mandir}/man8/ibnodes.8.gz
+%{_sbindir}/ibrouters
+%{_mandir}/man8/ibrouters.8.gz
+%{_sbindir}/ibaddr
+%{_mandir}/man8/ibaddr.8.gz
+%{_sbindir}/ibnetdiscover
+%{_mandir}/man8/ibnetdiscover.8.gz
+%{_sbindir}/ibping
+%{_mandir}/man8/ibping.8.gz
+%{_sbindir}/ibportstate
+%{_mandir}/man8/ibportstate.8.gz
+%{_sbindir}/ibroute
+%{_mandir}/man8/ibroute.8.gz
+%{_sbindir}/ibstat
+%{_mandir}/man8/ibstat.8.gz
+%{_sbindir}/ibsysstat
+%{_mandir}/man8/ibsysstat.8.gz
+%{_sbindir}/ibtracert
+%{_mandir}/man8/ibtracert.8.gz
 %{_sbindir}/perfquery
+%{_mandir}/man8/perfquery.8.gz
+%{_sbindir}/sminfo
+%{_mandir}/man8/sminfo.8.gz
+%{_sbindir}/smpdump
+%{_mandir}/man8/smpdump.8.gz
+%{_sbindir}/smpquery
+%{_mandir}/man8/smpquery.8.gz
 %{_sbindir}/saquery
+%{_mandir}/man8/saquery.8.gz
 %{_sbindir}/vendstat
+%{_mandir}/man8/vendstat.8.gz
+%{_sbindir}/iblinkinfo
+%{_mandir}/man8/iblinkinfo.8.gz
+%{_sbindir}/ibqueryerrors
+%{_mandir}/man8/ibqueryerrors.8.gz
+%{_sbindir}/ibcacheedit
+%{_mandir}/man8/ibcacheedit.8.gz
+%{_sbindir}/ibclearcounters
+%{_mandir}/man8/ibclearcounters.8.gz
+%{_sbindir}/ibclearerrors
+%{_mandir}/man8/ibclearerrors.8.gz
 %{_sbindir}/dump_mfts.sh
+%{_mandir}/man8/dump_mfts.8.gz
 %{_sbindir}/dump_lfts.sh
+%{_mandir}/man8/dump_lfts.8.gz
 %{_sbindir}/check_lft_balance.pl
+%{_mandir}/man8/check_lft_balance.8.gz
+%{_mandir}/man8/infiniband-diags.8.gz
 %{_sbindir}/set_nodedesc.sh
-%{_sbindir}/sm*
 %{_libdir}/*.a
 %{_libdir}/*.so*
+%{_mandir}/man3/*
 %{_includedir}/infiniband/*.h
 %define _perldir %(perl -e 'use Config; $T=$Config{installvendorlib}; print $T;')
 %{_perldir}/*
-%{_mandir}/man8/*
-%{_mandir}/man3/*
 %{_sysconfdir}/*
 %doc README COPYING ChangeLog
 
diff --git a/man/infiniband-diags.8.in b/man/infiniband-diags.8.in
index 8ac2ca9..3e07190 100644
--- a/man/infiniband-diags.8.in
+++ b/man/infiniband-diags.8.in
@@ -191,7 +191,8 @@ perform the lookup.
 .SH Backwards compatibility scripts
 
 The following scripts have been identified as redundant and/or lower performing
-as compared to the above scripts.  They are provided as legacy scripts.
+as compared to the above scripts.  They are provided as legacy scripts when
+--enable-compat-utils is specified at build time.
 
 ibcheckerrors, ibclearcounters, ibclearerrors, ibdatacounters
 ibchecknet, ibchecknode, ibcheckport, ibcheckportstate,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
