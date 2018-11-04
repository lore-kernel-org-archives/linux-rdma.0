From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v3] rdma: Document IB device renaming option
Date: Sun,  4 Nov 2018 21:11:22 +0200
Message-ID: <20181104191122.11979-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[leonro@server /]$ lspci |grep -i Ether
00:08.0 Ethernet controller: Red Hat, Inc. Virtio network device
00:09.0 Ethernet controller: Mellanox Technologies MT27700 Family [ConnectX-4]
[leonro@server /]$ sudo rdma dev
1: mlx5_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455
sys_image_guid 5254:00c0:fe12:3455
[leonro@server /]$ sudo rdma dev set mlx5_0 name hfi1_0
[leonro@server /]$ sudo rdma dev
1: hfi1_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455
sys_image_guid 5254:00c0:fe12:3455

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
Changelog:
v2->v3:
 * Dropped "to be named" words from example section of man
---
 man/man8/rdma-dev.8 | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/man/man8/rdma-dev.8 b/man/man8/rdma-dev.8
index 461681b6..7c275180 100644
--- a/man/man8/rdma-dev.8
+++ b/man/man8/rdma-dev.8
@@ -1,6 +1,6 @@
 .TH RDMA\-DEV 8 "06 Jul 2017" "iproute2" "Linux"
 .SH NAME
-rdmak-dev \- RDMA device configuration
+rdma-dev \- RDMA device configuration
 .SH SYNOPSIS
 .sp
 .ad l
@@ -22,10 +22,18 @@ rdmak-dev \- RDMA device configuration
 .B rdma dev show
 .RI "[ " DEV " ]"

+.ti -8
+.B rdma dev set
+.RI "[ " DEV " ]"
+.BR name
+.BR NEWNAME
+
 .ti -8
 .B rdma dev help

 .SH "DESCRIPTION"
+.SS rdma dev set - rename rdma device
+
 .SS rdma dev show - display rdma device attributes

 .PP
@@ -45,6 +53,11 @@ rdma dev show mlx5_3
 Shows the state of specified RDMA device.
 .RE
 .PP
+rdma dev set mlx5_3 name rdma_0
+.RS 4
+Renames the mlx5_3 device to rdma_0.
+.RE
+.PP

 .SH SEE ALSO
 .BR rdma (8),
