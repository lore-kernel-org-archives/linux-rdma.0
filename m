From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 4/4] rdma: Document IB device renaming option
Date: Wed, 31 Oct 2018 09:17:58 +0200
Message-ID: <20181031071758.6178-5-leon@kernel.org>
References: <20181031071758.6178-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181031071758.6178-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
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
 man/man8/rdma-dev.8 | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/man/man8/rdma-dev.8 b/man/man8/rdma-dev.8
index 461681b6..b2f9964a 100644
--- a/man/man8/rdma-dev.8
+++ b/man/man8/rdma-dev.8
@@ -22,6 +22,12 @@ rdmak-dev \- RDMA device configuration
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
 
@@ -33,6 +39,8 @@ rdmak-dev \- RDMA device configuration
 - specifies the RDMA device to show.
 If this argument is omitted all devices are listed.
 
+.SS rdma dev set - rename rdma device
+
 .SH "EXAMPLES"
 .PP
 rdma dev
@@ -45,6 +53,11 @@ rdma dev show mlx5_3
 Shows the state of specified RDMA device.
 .RE
 .PP
+rdma dev set mlx5_3 name rdma_0
+.RS 4
+Renames the mlx5_3 device to be named rdma_0.
+.RE
+.PP
 
 .SH SEE ALSO
 .BR rdma (8),
-- 
2.14.4
