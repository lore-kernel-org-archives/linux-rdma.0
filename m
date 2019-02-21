From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v1 iproute2-next 4/4] rdma: man page update for link
 add/delete
Date: Thu, 21 Feb 2019 08:19:18 -0800
Message-ID: <af4a6e6e2926e600150e7c2bb73db9b706507550.1550773362.git.swise@opengridcomputing.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1550773362.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Update the 'rdma link' man page with 'link add/delete' info.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 man/man8/rdma-link.8 | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/man/man8/rdma-link.8 b/man/man8/rdma-link.8
index bddf34746e8b..b3b40de75852 100644
--- a/man/man8/rdma-link.8
+++ b/man/man8/rdma-link.8
@@ -23,6 +23,18 @@ rdma-link \- rdma link configuration
 .RI "[ " DEV/PORT_INDEX " ]"
 
 .ti -8
+.B rdma link add
+.BR NAME
+.BR type
+.BR TYPE
+.BR netdev
+.BR NETDEV
+
+.ti -8
+.B rdma link delete
+.RI NAME
+
+.ti -8
 .B rdma link help
 
 .SH "DESCRIPTION"
@@ -33,6 +45,31 @@ rdma-link \- rdma link configuration
 - specifies the RDMA link to show.
 If this argument is omitted all links are listed.
 
+.SS rdma link add NAME type TYPE netdev NETDEV - add an rdma link for the specified type to the network device
+.sp
+.BR NAME
+- specifies the new name of the rdma link to add
+
+.BR TYPE
+- specifies which rdma type to use.  Link types:
+.sp
+.in +8
+.B rxe
+- Soft RoCE driver
+.sp
+.B siw
+- Soft iWARP driver
+.in -8
+
+.BR NETDEV
+- specifies the network device to which the link is bound
+
+.SS rdma link delete NAME - delete an rdma link
+.PP
+.BR NAME
+- specifies the name of the rdma link to delete
+.PP
+
 .SH "EXAMPLES"
 .PP
 rdma link show
@@ -45,6 +82,16 @@ rdma link show mlx5_2/1
 Shows the state of specified rdma link.
 .RE
 .PP
+rdma link add rxe_eth0 type rxe netdev eth0
+.RS 4
+Adds a RXE link named rxe_eth0 to network device eth0
+.RE
+.PP
+rdma link del rxe_eth0
+.RS 4
+Removes RXE link rxe_eth0
+.RE
+.PP
 
 .SH SEE ALSO
 .BR rdma (8),
-- 
1.8.3.1
