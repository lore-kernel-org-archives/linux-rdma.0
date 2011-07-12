From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: change perl install to vendorlib
Date: Tue, 12 Jul 2011 14:43:21 -0700
Message-ID: <20110712144321.4c1bcbf3.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 configure.in             |    2 +-
 infiniband-diags.spec.in |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index dfb6ba2..183223d 100644
--- a/configure.in
+++ b/configure.in
@@ -132,7 +132,7 @@ AC_SUBST(PERL_INSTALLDIR)
 
 if test $withperlinstalldir = "no"
 then
-    PERL_INSTALLDIR=`$PERL -e 'use Config; $T=$Config{installsitearch}; print $T;'`
+    PERL_INSTALLDIR=`$PERL -e 'use Config; $T=$Config{installvendorlib}; print $T;'`
 fi
 AC_SUBST(PERL_INSTALLDIR)
 
diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index bcdd250..6b05483 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -50,7 +50,7 @@ rm -rf $RPM_BUILD_ROOT
 %{_libdir}/*.a
 %{_libdir}/*.so*
 %{_includedir}/infiniband/*.h
-%define _perldir %(perl -e 'use Config; $T=$Config{installsitearch}; $T=~/(.*)\\/site_perl.*/; print $1;')
+%define _perldir %(perl -e 'use Config; $T=$Config{installvendorlib}; print $T;')
 %{_perldir}/*
 %{_mandir}/man8/*
 %{_mandir}/man3/*
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
