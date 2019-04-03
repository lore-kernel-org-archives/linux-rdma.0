From: Steve Wise <larrystevenwise@gmail.com>
Subject: [PATCH v3 iproute2-next 4/4] rdma: man page update for link add/delete
Date: Wed,  3 Apr 2019 12:10:32 -0500
Message-ID: <abace9bd8aa00aaaaf9cdc1ecf1fc2f91e1f4f05.1554304142.git.larrystevenwise@gmail.com>
References: <cover.1554304142.git.larrystevenwise@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1554304142.git.larrystevenwise@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: Steve Wise <larrystevenwise@gmail.com>, leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Update the 'rdma link' man page with 'link add/delete' info.

Signed-off-by: Steve Wise <larrystevenwise@gmail.com>
---
 man/man8/rdma-link.8 | 47 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/man/man8/rdma-link.8 b/man/man8/rdma-link.8
index bddf3474..b3b40de7 100644
--- a/man/man8/rdma-link.8
+++ b/man/man8/rdma-link.8
@@ -22,6 +22,18 @@ rdma-link \- rdma link configuration
 .B rdma link show
 .RI "[ " DEV/PORT_INDEX " ]"
 
+.ti -8
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
 .ti -8
 .B rdma link help
 
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
2.20.1
