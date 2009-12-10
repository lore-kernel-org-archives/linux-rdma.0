From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] remove obsoleted option from iblinkinfo
	manpage
Date: Thu, 10 Dec 2009 11:38:38 -0800
Message-ID: <1260473918.4557.97.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-k/Jorf1YgiqXd9cM8QcH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-k/Jorf1YgiqXd9cM8QcH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sasha,

Nothing fancy, noticed the manpage still had this obsoleted option
listed.  I copied the documentation that was put into the ibqueryerrors
manpage.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-k/Jorf1YgiqXd9cM8QcH
Content-Disposition: attachment; filename=0001-remove-obsoleted-option-from-iblinkinfo-manpage.patch
Content-Type: text/plain; name=0001-remove-obsoleted-option-from-iblinkinfo-manpage.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

>From e0050396ddd4cbd611abef3ac74fca854c038b12 Mon Sep 17 00:00:00 2001
From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 10 Dec 2009 11:25:22 -0800
Subject: [PATCH] remove obsoleted option from iblinkinfo manpage


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/iblinkinfo.8 |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/infiniband-diags/man/iblinkinfo.8 b/infiniband-diags/man/iblinkinfo.8
index b9b4318..de8676a 100644
--- a/infiniband-diags/man/iblinkinfo.8
+++ b/infiniband-diags/man/iblinkinfo.8
@@ -5,7 +5,7 @@ iblinkinfo.pl \- report link info for all links in the fabric
 
 .SH SYNOPSIS
 .B iblinkinfo.pl
-   [-Rhcdl -C <ca_name> -P <ca_port> -v <lt,hoq,vlstall> -S <guid>
+   [-hcdl -C <ca_name> -P <ca_port> -v <lt,hoq,vlstall> -S <guid>
 -D <direct_route>]
 
 .SH DESCRIPTION
@@ -17,12 +17,6 @@ IB fabric.
 
 .PP
 .TP
-\fB\-R\fR
-Recalculate the ibnetdiscover information, ie do not use the cached
-information.  This option is slower but should be used if the diag tools have
-not been used for some time or if there are other reasons to believe the
-fabric has changed.
-.TP
 \fB\-S <guid>\fR
 Output only the switch specified by <guid> (hex format)
 .TP
@@ -46,6 +40,8 @@ Print port capabilities (enabled and supported values)
 \fB\-C <ca_name>\fR    use the specified ca_name for the search.
 .TP
 \fB\-P <ca_port>\fR    use the specified ca_port for the search.
+.TP
+\fB\-R\fR (This option is obsolete and does nothing)
 
 
 .SH AUTHOR
-- 
1.5.4.5


--=-k/Jorf1YgiqXd9cM8QcH--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
