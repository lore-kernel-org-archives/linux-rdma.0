From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH V3 2/8] infiniband-diags: install config file mode 400
Date: Wed, 30 May 2012 10:21:31 -0700
Message-ID: <1338398497-12444-2-git-send-email-foraker1@llnl.gov>
References: <1338398414.11948.29.camel@auk75.llnl.gov>
 <1338398497-12444-1-git-send-email-foraker1@llnl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338398497-12444-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Necessary so that we may add credentials (ie, mkey) to it

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index f861000..33b5f90 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -148,4 +148,4 @@ install-data-hook:
 	fi
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/scripts/IBswcountlimits.pm $(DESTDIR)/$(PERL_INSTALLDIR)/IBswcountlimits.pm
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags
-	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
+	$(top_srcdir)/config/install-sh -c -m 400 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
-- 
1.7.9.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
