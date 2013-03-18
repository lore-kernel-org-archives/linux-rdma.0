From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] infiniband-diags: add skip-sl to default
 ibqueryerrors.8.in
Date: Mon, 18 Mar 2013 17:32:44 -0400
Message-ID: <514787fc.1zOlYy6iqYwdn3lW%ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 doc/man/ibqueryerrors.8.in |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/doc/man/ibqueryerrors.8.in b/doc/man/ibqueryerrors.8.in
index 31158aa..39cdafe 100644
--- a/doc/man/ibqueryerrors.8.in
+++ b/doc/man/ibqueryerrors.8.in
@@ -66,6 +66,9 @@ Specify an alternate threshold file.  The default is @IBDIAG_CONFIG_PATH@/error_
 .sp
 \fB\-\-ca\fP  print data for CA\(aqs only
 .sp
+\fB\-\-skip\-sl\fP  Use the default sl for queries. This is not recommended when
+using a QoS aware routing engine as it can cause a credit deadlock.
+.sp
 \fB\-\-router\fP  print data for routers only
 .sp
 \fB\-\-clear\-errors \-k\fP Clear error counters after read.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
