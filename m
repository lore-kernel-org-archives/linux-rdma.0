From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 3/3 fixed] infiniband-diags: Add mkey support to config file
Date: Tue, 06 Mar 2012 14:18:55 -0800
Message-ID: <1331072335.17729.17.camel@auk75.llnl.gov>
References: <1331065620.10889.16.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331065620.10889.16.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Support for "m_key=" parameter, plus config file
now installs user-read-only.

Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
---
 Makefile.am         |    2 +-
 etc/ibdiag.conf     |    2 ++
 src/ibdiag_common.c |    2 ++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 950f95b..ef59bd2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -112,4 +112,4 @@ install-data-hook:
 	fi
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/scripts/IBswcountlimits.pm $(DESTDIR)/$(PERL_INSTALLDIR)/IBswcountlimits.pm
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags
-	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
+	$(top_srcdir)/config/install-sh -c -m 400 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
diff --git a/etc/ibdiag.conf b/etc/ibdiag.conf
index 77f3ce9..2a2334f 100644
--- a/etc/ibdiag.conf
+++ b/etc/ibdiag.conf
@@ -15,3 +15,5 @@
 # Default = true
 #MLX_EPI=false
 
+# define a default m_key
+#m_key=0x00
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 0901231..2089847 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -155,6 +155,8 @@ void read_ibdiag_config(const char *file)
 			} else {
 				ibd_ibnetdisc_flags &= ~IBND_CONFIG_MLX_EPI;
 			}
+		} else if (strncmp(name, "m_key", strlen("m_key")) == 0) {
+			ibd_mkey = strtoull(val_str, 0, 0);
 		}
 	}
 
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
