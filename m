From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH RFC iproute2-next 2/2] rdma: man page update for link
 add/delete
Date: Wed, 28 Nov 2018 07:16:38 -0800
Message-ID: <a241e151b862f7d3b590be3df125cb05525e6b72.1543422310.git.swise@opengridcomputing.com>
References: <cover.1543422310.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1543422310.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leon@kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org

Update the 'rdma link' man page with 'link add/delete' info.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 man/man8/rdma-link.8 | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/man/man8/rdma-link.8 b/man/man8/rdma-link.8
index 97dd8bb994d2..b994c326dc34 100644
--- a/man/man8/rdma-link.8
+++ b/man/man8/rdma-link.8
@@ -23,6 +23,20 @@ rdma-link \- rdma link configuration
 .RI "[ " DEV/PORT_INDEX " ]"
 
 .ti -8
+.B rdma link add
+.BR NAME
+.BR type
+.BR TYPE
+.BR dev
+.BR NETDEV
+
+.ti -8
+.B rdma link delete
+.RI NAME
+.BR type
+.BR TYPE
+
+.ti -8
 .B rdma link help
 
 .SH "DESCRIPTION"
@@ -33,6 +47,33 @@ rdma-link \- rdma link configuration
 - specifies the RDMA link to show.
 If this argument is omitted all links are listed.
 
+.SS rdma link add NAME type TYPE dev NETDEV - add an rdma link for the specified type to the network device
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
+.SS rdma link delete NAME type TYPE - delete an rdma link for the specified type
+.PP
+.BR NAME
+- specifies the name of the rdma link to delete
+.PP
+.BR TYPE
+- specifies which rdma type to use
+
 .SH "EXAMPLES"
 .PP
 rdma link show
@@ -45,6 +86,16 @@ rdma link show mlx5_2/1
 Shows the state of specified rdma link.
 .RE
 .PP
+rdma link add siw_eth0 type rxe dev eth0
+.RS 4
+Adds a RXE link named siw_eth0 to network device eth0
+.RE
+.PP
+rdma link del siw_eth0 type rxe
+.RS 4
+Removes RXE link siw_eth0
+.RE
+.PP
 
 .SH SEE ALSO
 .BR rdma (8),
-- 
1.8.3.1
