From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v3 iproute2-next 3/3] rdma: update man pages
Date: Tue, 15 May 2018 13:41:15 -0700
Message-ID: <a819960c3b3b74796bf1fb63719e981314cad240.1526483157.git.swise@opengridcomputing.com>
References: <cover.1526483157.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1526483157.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Update the man pages for the resource attributes as well
as the driver-specific attributes.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 man/man8/rdma-resource.8 | 29 ++++++++++++++++++++++++++---
 man/man8/rdma.8          |  2 +-
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/man/man8/rdma-resource.8 b/man/man8/rdma-resource.8
index ff5d25d..40b073d 100644
--- a/man/man8/rdma-resource.8
+++ b/man/man8/rdma-resource.8
@@ -7,13 +7,16 @@ rdma-resource \- rdma resource configuration
 .in +8
 .ti -8
 .B rdma
-.RI "[ " OPTIONS " ]"
-.B resource
-.RI  " { " COMMAND " | "
+.RI "[ " OPTIONS " ] " RESOURCE " { " COMMAND " | "
 .BR help " }"
 .sp
 
 .ti -8
+.IR RESOURCE " := { "
+.BR cm_id " | " cq " | " mr " | " pd " | " qp " }"
+.sp
+
+.ti -8
 .IR OPTIONS " := { "
 \fB\-j\fR[\fIson\fR] |
 \fB\-d\fR[\fIetails\fR] }
@@ -70,11 +73,31 @@ rdma res show qp link mlx5_4/- -d
 Detailed view.
 .RE
 .PP
+rdma res show qp link mlx5_4/- -dd
+.RS 4
+Detailed view including driver-specific details.
+.RE
+.PP
 rdma res show qp link mlx5_4/1 lqpn 0-6
 .RS 4
 Limit to specific Local QPNs.
 .RE
 .PP
+rdma resource show cm_id dst-port 7174
+.RS 4
+Show CM_IDs with destination ip port of 7174.
+.RE
+.PP
+rdma resource show cm_id src-addr 172.16.0.100
+.RS 4
+Show CM_IDs bound to local ip address 172.16.0.100
+.RE
+.PP
+rdma resource show cq pid 30489
+.RS 4
+Show CQs belonging to pid 30489
+.RE
+.PP
 
 .SH SEE ALSO
 .BR rdma (8),
diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
index 6f88f37..12aa149 100644
--- a/man/man8/rdma.8
+++ b/man/man8/rdma.8
@@ -49,7 +49,7 @@ If there were any errors during execution of the commands, the application retur
 
 .TP
 .BR "\-d" , " --details"
-Output detailed information.
+Output detailed information.  Adding a second \-d includes driver-specific details.
 
 .TP
 .BR "\-p" , " --pretty"
-- 
1.8.3.1
