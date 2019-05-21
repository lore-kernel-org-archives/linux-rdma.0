From: Parav Pandit <parav@mellanox.com>
Subject: [PATCH iproute2-next 4/4] rdma: Add man page for rdma dev set netns command
Date: Tue, 21 May 2019 09:22:44 -0500
Message-ID: <20190521142244.8452-5-parav@mellanox.com>
References: <20190521142244.8452-1-parav@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190521142244.8452-1-parav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, stephen@networkplumber.org, leonro@mellanox.com, parav@mellanox.com
List-Id: linux-rdma@vger.kernel.org

Add man page to describe additional set netns command
for rdma device.

Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 man/man8/rdma-dev.8 | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/man/man8/rdma-dev.8 b/man/man8/rdma-dev.8
index 069f4717..38e34b3b 100644
--- a/man/man8/rdma-dev.8
+++ b/man/man8/rdma-dev.8
@@ -28,13 +28,19 @@ rdma-dev \- RDMA device configuration
 .BR name
 .BR NEWNAME
 
+.ti -8
+.B rdma dev set
+.RI "[ " DEV " ]"
+.BR netns
+.BR NSNAME
+
 .ti -8
 .B rdma dev help
 
 .SH "DESCRIPTION"
-.SS rdma dev set - rename rdma device
+.SS rdma dev set - rename RDMA device or set network namespace
 
-.SS rdma dev show - display rdma device attributes
+.SS rdma dev show - display RDMA device attributes
 
 .PP
 .I "DEV"
@@ -58,11 +64,19 @@ rdma dev set mlx5_3 name rdma_0
 Renames the mlx5_3 device to rdma_0.
 .RE
 .PP
+rdma dev set mlx5_3 netns foo
+.RS 4
+Changes the network namespace of RDMA device to foo where foo is
+previously created using iproute2 ip command.
+.RE
+.PP
 
 .SH SEE ALSO
+.BR ip (8),
 .BR rdma (8),
 .BR rdma-link (8),
 .BR rdma-resource (8),
+.BR rdma-system (8),
 .br
 
 .SH AUTHOR
-- 
2.19.2
