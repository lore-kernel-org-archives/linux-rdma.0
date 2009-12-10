From: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [infiniband-diags] [PATCH] correct manpages for tools that are no
	longer scripts
Date: Thu, 10 Dec 2009 13:24:01 -0800
Message-ID: <1260480241.4557.100.camel@auk31.llnl.gov>
Reply-To: chu11-i2BcT+NCU+M@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-EcT12Gts7qcFppE9Eo1U"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-EcT12Gts7qcFppE9Eo1U
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hey Sasha,

Another set of typos I found.  Nothing fancy.

Al

-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--=-EcT12Gts7qcFppE9Eo1U
Content-Disposition: attachment; filename*0=0002-correct-manpages-for-tools-that-are-no-longer-script.pat; filename*1=ch
Content-Type: text/plain; name=0002-correct-manpages-for-tools-that-are-no-longer-script.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Date: Thu, 10 Dec 2009 13:21:02 -0800
Subject: [PATCH] correct manpages for tools that are no longer scripts


Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 infiniband-diags/man/iblinkinfo.8    |    6 +++---
 infiniband-diags/man/ibqueryerrors.8 |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/infiniband-diags/man/iblinkinfo.8 b/infiniband-diags/man/iblinkinfo.8
index de8676a..0f53b00 100644
--- a/infiniband-diags/man/iblinkinfo.8
+++ b/infiniband-diags/man/iblinkinfo.8
@@ -1,16 +1,16 @@
 .TH IBLINKINFO 8 "Jan 24, 2008" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
-iblinkinfo.pl \- report link info for all links in the fabric
+iblinkinfo \- report link info for all links in the fabric
 
 .SH SYNOPSIS
-.B iblinkinfo.pl
+.B iblinkinfo
    [-hcdl -C <ca_name> -P <ca_port> -v <lt,hoq,vlstall> -S <guid>
 -D <direct_route>]
 
 .SH DESCRIPTION
 .PP
-iblinkinfo.pl reports the link info for each port of each switch active in the
+iblinkinfo reports the link info for each port of each switch active in the
 IB fabric.
 
 .SH OPTIONS
diff --git a/infiniband-diags/man/ibqueryerrors.8 b/infiniband-diags/man/ibqueryerrors.8
index d5a499e..83a2b5a 100644
--- a/infiniband-diags/man/ibqueryerrors.8
+++ b/infiniband-diags/man/ibqueryerrors.8
@@ -1,16 +1,16 @@
 .TH IBQUERYERRORS 8 "Oct 30, 2009" "OpenIB" "OpenIB Diagnostics"
 
 .SH NAME
-ibqueryerrors.pl \- query and report non-zero IB port counters
+ibqueryerrors \- query and report non-zero IB port counters
 
 .SH SYNOPSIS
-.B ibqueryerrors.pl
+.B ibqueryerrors
 [-s <err1,err2,...> -c -r -C <ca_name> -P <ca_port> -G <node_guid>
 -D <direct_route> -d -k -K]
 
 .SH DESCRIPTION
 .PP
-ibqueryerrors.pl reports port counters.  This is similar to ibcheckerrors with
+ibqueryerrors reports port counters.  This is similar to ibcheckerrors with
 the additional ability to filter out selected errors, include the optional
 transmit and receive data counters, and report full link information for the
 link reported.
-- 
1.5.4.5


--=-EcT12Gts7qcFppE9Eo1U--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
