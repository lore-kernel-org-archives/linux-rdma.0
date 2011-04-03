From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: infiniband-diags: Fixed dump2psl and dump2slvl script installation
Date: Sun, 03 Apr 2011 11:41:53 -0400
Message-ID: <4D989541.9000701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 Makefile.am  |    3 ++-
 configure.in |    2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index f9286a9..43d05f6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -34,7 +34,8 @@ sbin_SCRIPTS = scripts/ibcheckerrs scripts/ibchecknet
scripts/ibchecknode \
 	       scripts/iblinkinfo.pl scripts/ibprintswitch.pl \
 	       scripts/ibprintca.pl scripts/ibprintrt.pl \
 	       scripts/ibfindnodesusing.pl scripts/ibidsverify.pl \
-	       scripts/check_lft_balance.pl
+	       scripts/check_lft_balance.pl scripts/dump2psl.pl \
+	       scripts/dump2slvl.pl

 noinst_LIBRARIES = libcommon.a

diff --git a/configure.in b/configure.in
index eb01f9b..003369d 100644
--- a/configure.in
+++ b/configure.in
@@ -169,8 +169,6 @@ AC_CONFIG_FILES([\
 	scripts/ibrouters \
 	scripts/iblinkinfo.pl \
 	scripts/ibqueryerrors.pl \
-	scripts/dump2psl.pl \
-	scripts/dump2slvl.pl \
    libibnetdisc/Makefile
 ])
 AC_OUTPUT
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
