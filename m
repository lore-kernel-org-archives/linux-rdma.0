From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 06/15 ibacm] ibacm_opts.cfg: Sync default options file with
 generated output
Date: Fri, 21 Jun 2013 07:01:43 -0400
Message-ID: <51C43297.30303@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


from: ib_acme -D . -O

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 ibacm_opts.cfg |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/ibacm_opts.cfg b/ibacm_opts.cfg
index 58069b8..6f260da 100644
--- a/ibacm_opts.cfg
+++ b/ibacm_opts.cfg
@@ -30,7 +30,7 @@ log_level 0
 # Specifies the location of the ACM lock file used to ensure that only a
 # single instance of ACM is running.
 
-lock_file /var/lock/ibacm.pid
+lock_file /var/run/ibacm.pid
 
 # addr_prot:
 # Default resolution protocol to resolve IP addresses into IB GIDs.
@@ -39,6 +39,13 @@ lock_file /var/lock/ibacm.pid
 
 addr_prot acm
 
+# addr_timeout:
+# Number of minutes to maintain IP address to GID mapping before
+# repeating address resolution.  A value of -1 indicates that the
+# mapping will not time out.
+# 1 hour = 60, 1 day = 1440, 1 week = 10080, 1 month ~ 43200
+addr_timeout 1440
+
 # route_prot:
 # Default resolution protocol to resolve IB routing information.
 # Supported protocols are:
@@ -47,6 +54,14 @@ addr_prot acm
 
 route_prot sa
 
+# route_timeout:
+# Number of minutes to maintain IB routing information before
+# repeating route resolution.  A value of -1 indicates that the
+# mapping will not time out.  However, the route will
+# automatically time out when the address times out.
+# 1 hour = 60, 1 day = 1440, 1 week = 10080, 1 month ~ 43200
+route_timeout -1
+
 # loopback_prot:
 # Address and route resolution protocol to resolve local addresses
 # Supported protocols are:
@@ -97,12 +112,11 @@ resolve_depth 1
 sa_depth 1
 
 # send_depth:
-# Specifies the maximum number of outstanding requests that can be in
-# progress simultaneously.  A larger send depth allows for greater
-# parallelism, but increases system resource usage and subnet load.
-# If the number of pending requests is greater than the send_depth,
-# the additional requests will automatically be queued until some of
-# the previous requests complete.
+# Specifies the number of outstanding send operations that can
+# be in progress simultaneously.  A larger send depth consumes
+# more system resources, but increases subnet load.  The send_depth
+# is in addition to resolve_depth and sa_depth, and limits the
+# transfer of responses.
 
 send_depth 1
 
@@ -128,3 +142,4 @@ min_mtu 2048
 # min_rate be set to the largest rate supported by all nodes in a cluster.
 
 min_rate 10
+
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
