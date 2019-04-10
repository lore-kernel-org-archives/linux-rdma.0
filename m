From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 8/8] rdma: Document counter statistic
Date: Wed, 10 Apr 2019 14:21:21 +0300
Message-ID: <20190410112121.6790-9-leon@kernel.org>
References: <20190410112121.6790-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190410112121.6790-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, Mark Zhang <markz@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add document of accessing the QP counter, including bind/unbind a QP
to a counter manually or automatically, and dump counter statistics.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 man/man8/rdma-dev.8       |   1 +
 man/man8/rdma-link.8      |   1 +
 man/man8/rdma-resource.8  |   1 +
 man/man8/rdma-statistic.8 | 170 ++++++++++++++++++++++++++++++++++++++
 man/man8/rdma.8           |   5 ++
 5 files changed, 178 insertions(+)
 create mode 100644 man/man8/rdma-statistic.8

diff --git a/man/man8/rdma-dev.8 b/man/man8/rdma-dev.8
index 069f4717..f1b81033 100644
--- a/man/man8/rdma-dev.8
+++ b/man/man8/rdma-dev.8
@@ -63,6 +63,7 @@ Renames the mlx5_3 device to rdma_0.
 .BR rdma (8),
 .BR rdma-link (8),
 .BR rdma-resource (8),
+.BR rdma-statistic (8),
 .br
 
 .SH AUTHOR
diff --git a/man/man8/rdma-link.8 b/man/man8/rdma-link.8
index b3b40de7..32f80228 100644
--- a/man/man8/rdma-link.8
+++ b/man/man8/rdma-link.8
@@ -97,6 +97,7 @@ Removes RXE link rxe_eth0
 .BR rdma (8),
 .BR rdma-dev (8),
 .BR rdma-resource (8),
+.BR rdma-statistic (8),
 .br
 
 .SH AUTHOR
diff --git a/man/man8/rdma-resource.8 b/man/man8/rdma-resource.8
index 40b073db..05030d0a 100644
--- a/man/man8/rdma-resource.8
+++ b/man/man8/rdma-resource.8
@@ -103,6 +103,7 @@ Show CQs belonging to pid 30489
 .BR rdma (8),
 .BR rdma-dev (8),
 .BR rdma-link (8),
+.BR rdma-statistic (8),
 .br
 
 .SH AUTHOR
diff --git a/man/man8/rdma-statistic.8 b/man/man8/rdma-statistic.8
new file mode 100644
index 00000000..3a48ae8d
--- /dev/null
+++ b/man/man8/rdma-statistic.8
@@ -0,0 +1,170 @@
+.TH RDMA\-STATISTIC 8 "17 Mar 2019" "iproute2" "Linux"
+.SH NAME
+rdma-statistic \- RDMA statistic counter configuration
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B rdma
+.RI "[ " OPTIONS " ]"
+.B statistic
+.RI  " { " COMMAND " | "
+.BR help " }"
+.sp
+
+.ti -8
+.B rdma statistic
+.RI "[ " OBJECT " ]"
+.B show
+
+.ti -8
+.B rdma statistic
+.RI "[ " OBJECT " ]"
+.B show link
+.RI "[ " DEV/PORT_INDX " ]"
+
+.ti -8
+.B rdma statistic
+.IR OBJECT
+.B mode
+
+.ti -8
+.B rdma statistic
+.IR OBJECT
+.B set
+.IR COUNTER_SCOPE
+.RI "[ " DEV/PORT_INDEX "]"
+.B auto
+.RI "{ " CRITERIA " | "
+.BR off " }"
+
+.ti -8
+.B rdma statistic
+.IR OBJECT
+.B bind
+.IR COUNTER_SCOPE
+.RI "[ " DEV/PORT_INDEX "]"
+.RI "[ " OBJECT-ID " ]"
+.RI "[ " COUNTER-ID " ]"
+
+.ti -8
+.B rdma statistic
+.IR OBJECT
+.B unbind
+.IR COUNTER_SCOPE
+.RI "[ " DEV/PORT_INDEX "]"
+.RI "[ " COUNTER-ID " ]"
+.RI "[ " OBJECT-ID " ]"
+
+.ti -8
+.IR COUNTER_SCOPE " := "
+.RB "{ " link " | " dev " }"
+
+.ti -8
+.IR OBJECT " := "
+.RB "{ " qp " }"
+
+.ti -8
+.IR CRITERIA " := "
+.RB "{ " type " }"
+
+.SH "DESCRIPTION"
+.SS rdma statistic [object] show - Queries the specified RDMA device for RDMA and driver-specific statistics. Show the default counter if object is not specified
+
+.PP
+.I "DEV"
+- specifies counters on this RDMA device to show.
+
+.I "PORT_INDEX"
+- specifies counters on this RDMA port to show.
+
+.SS rdma statistic <object> set - configure counter statistic auto-mode for a specific device/port
+In auto mode all objects belong to one category are bind automatically to a single counter set.
+
+.SS rdma statistic <object> bind - manually bind an object (e.g., a qp) with a counter
+When bound the statistics of this object are available in this counter.
+
+.SS rdma statistic <object> unbind - manually unbind an object (e.g., a qp) from the counter previously bound
+When unbound the statistics of this object are no longer available in this counter; And if object id is not specified then all objects on this counter will be unbound.
+
+.I "LQPN"
+- specifies the qp number to be bound/unbind.
+
+.I "COUNTER-ID"
+- specifies the id of the counter to be bound.
+If this argument is omitted then a new counter will be allocated.
+
+.SH "EXAMPLES"
+.PP
+rdma statistic show
+.RS 4
+Shows the state of the default counter of all RDMA devices on the system.
+.RE
+.PP
+rdma statistic show link mlx5_2/1
+.RS 4
+Shows the state of the default counter of specified RDMA port
+.RE
+.PP
+rdma statistic qp show
+.RS 4
+Shows the state of all qp counters of all RDMA devices on the system.
+.RE
+.PP
+rdma statistic qp show link mlx5_2/1
+.RS 4
+Shows the state of all qp counters of specified RDMA port.
+.RE
+.PP
+rdma statistic qp show link mlx5_2 pid 30489
+.RS 4
+Shows the state of all qp counters of specified RDMA port and belonging to pid 30489
+.RE
+.PP
+rdma statistic qp mode
+.RS 4
+List current counter mode on all deivces
+.RE
+.PP
+rdma statistic qp mode link mlx5_2/1
+.RS 4
+List current counter mode of deivce mlx5_2 port 1
+.RE
+.PP
+rdma statistic qp set link mlx5_2/1 auto type on
+.RS 4
+On device mlx5_2 port 1, for each new QP bind it with a counter automatically. Per counter for QPs with same qp type in each process. Currently only "type" is supported.
+.RE
+.PP
+rdma statistic qp set link mlx5_2/1 auto off
+.RS 4
+Turn-off auto mode on device mlx5_2 port 1. The allocated counters can be manually accessed.
+.RE
+.PP
+rdma statistic qp bind link mlx5_2/1 lqpn 178
+.RS 4
+On device mlx5_2 port 1, allocate a counter and bind the specified qp on it
+.RE
+.PP
+rdma statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178
+.RS 4
+On device mlx5_2 port 1, bind the specified qp on the specified counter
+.RE
+.PP
+rdma statistic qp unbind link mlx5_2/1 cntn 4
+.RS 4
+On device mlx5_2 port 1, unbind all QPs on the specified counter. After that this counter will be released automatically by the kernel.
+
+.RE
+.PP
+
+.SH SEE ALSO
+.BR rdma (8),
+.BR rdma-dev (8),
+.BR rdma-link (8),
+.BR rdma-resource (8),
+.br
+
+.SH AUTHOR
+Mark Zhang <markz@mellanox.com>
diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
index b2b5aef8..63a2dd21 100644
--- a/man/man8/rdma.8
+++ b/man/man8/rdma.8
@@ -70,6 +70,10 @@ Generate JSON output.
 .B link
 - RDMA port related.
 
+.TP
+.B statistic
+- RDMA counter statistic related.
+
 .PP
 The names of all objects may be written in full or
 abbreviated form, for example
@@ -107,6 +111,7 @@ Exit status is 0 if command was successful or a positive integer upon failure.
 .BR rdma-dev (8),
 .BR rdma-link (8),
 .BR rdma-resource (8),
+.BR rdma-statistic (8),
 .br
 
 .SH REPORTING BUGS
-- 
2.20.1
