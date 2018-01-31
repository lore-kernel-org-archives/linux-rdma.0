From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 09/10] rdma: Document resource tracking
Date: Wed, 31 Jan 2018 10:11:55 +0200
Message-ID: <20180131081156.19607-10-leon@kernel.org>
References: <20180131081156.19607-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180131081156.19607-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Spartan version of resource tracking documentation.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 man/man8/rdma-resource.8 | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)
 create mode 100644 man/man8/rdma-resource.8

diff --git a/man/man8/rdma-resource.8 b/man/man8/rdma-resource.8
new file mode 100644
index 00000000..ff5d25d7
--- /dev/null
+++ b/man/man8/rdma-resource.8
@@ -0,0 +1,86 @@
+.TH RDMA\-RESOURCE 8 "26 Dec 2017" "iproute2" "Linux"
+.SH NAME
+rdma-resource \- rdma resource configuration
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.B rdma
+.RI "[ " OPTIONS " ]"
+.B resource
+.RI  " { " COMMAND " | "
+.BR help " }"
+.sp
+
+.ti -8
+.IR OPTIONS " := { "
+\fB\-j\fR[\fIson\fR] |
+\fB\-d\fR[\fIetails\fR] }
+
+.ti -8
+.B rdma resource show
+.RI "[ " DEV/PORT_INDEX " ]"
+
+.ti -8
+.B rdma resource help
+
+.SH "DESCRIPTION"
+.SS rdma resource show - display rdma resource tracking information
+
+.PP
+.I "DEV/PORT_INDEX"
+- specifies the RDMA link to show.
+If this argument is omitted all links are listed.
+
+.SH "EXAMPLES"
+.PP
+rdma resource show
+.RS 4
+Shows summary for all devices on the system.
+.RE
+.PP
+rdma resource show mlx5_2
+.RS 4
+Shows the state of specified rdma device.
+.RE
+.PP
+rdma res show qp link mlx5_4
+.RS 4
+Get all QPs for the specific device.
+.RE
+.PP
+rdma res show qp link mlx5_4/1
+.RS 4
+Get QPs of specific port.
+.RE
+.PP
+rdma res show qp link mlx5_4/0
+.RS 4
+Provide illegal port number (0 is illegal).
+.RE
+.PP
+rdma res show qp link mlx5_4/-
+.RS 4
+Get QPs which have not assigned port yet.
+.RE
+.PP
+rdma res show qp link mlx5_4/- -d
+.RS 4
+Detailed view.
+.RE
+.PP
+rdma res show qp link mlx5_4/1 lqpn 0-6
+.RS 4
+Limit to specific Local QPNs.
+.RE
+.PP
+
+.SH SEE ALSO
+.BR rdma (8),
+.BR rdma-dev (8),
+.BR rdma-link (8),
+.br
+
+.SH AUTHOR
+Leon Romanovsky <leonro@mellanox.com>
-- 
2.16.1
