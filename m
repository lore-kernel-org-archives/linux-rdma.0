From: James A Simmons <uja-1Heg1YXhbW8@public.gmane.org>
Subject: Patch for rpm and --without-depcheck
Date: Wed, 01 Sep 2010 11:43:59 -0400
Message-ID: <1283355839.14487.88.camel@bohr.ornl.gov>
Reply-To: simmonsja-1Heg1YXhbW8@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-JF6JpBRbya++Zgh0Q9ze"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: OFED <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-JF6JpBRbya++Zgh0Q9ze
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch passes --nodeps to rpmbuild when --without-depcheck is set.
Sorry I don't know who the maintainer of install.pl is.

--=-JF6JpBRbya++Zgh0Q9ze
Content-Disposition: attachment; filename=deps.diff
Content-Type: text/x-patch; name=deps.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- install.pl.orig	2010-09-01 11:36:11.000000000 -0400
+++ install.pl	2010-09-01 11:40:08.000000000 -0400
@@ -1536,6 +1536,9 @@
 
 if ($distro eq "debian") {
     $check_linux_deps = 0;
+}
+
+if (not $check_linux_deps) {
     $rpmbuild_flags .= ' --nodeps';
     $rpminstall_flags .= ' --nodeps';
 }

--=-JF6JpBRbya++Zgh0Q9ze--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
