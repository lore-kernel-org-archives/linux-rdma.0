From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next] rdma: Move RDMA UAPI header file to be under RDMA responsibility
Date: Sun, 25 Mar 2018 09:38:56 +0300
Message-ID: <20180325063856.31709-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

In iproute2 package, the updates of UAPIs files are performed
after the needed feature lands in kernel's net-next tree.

Such development flow created delays to the rdma tool developers,
who uses rdma-next tree as a basis for their work.

Move RDMA UAPI file to be under rdma/ folder, so whole responsibility
of syncing this file will be on them.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile                                      | 1 +
 {include => rdma/include}/uapi/rdma/rdma_netlink.h | 0
 2 files changed, 1 insertion(+)
 rename {include => rdma/include}/uapi/rdma/rdma_netlink.h (100%)

diff --git a/rdma/Makefile b/rdma/Makefile
index 360f09b2..819fcbe3 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -4,6 +4,7 @@ include ../config.mk
 TARGETS :=

 ifeq ($(HAVE_MNL),y)
+CFLAGS += -I./include/uapi/

 RDMA_OBJ = rdma.o utils.o dev.o link.o res.o

diff --git a/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
similarity index 100%
rename from include/uapi/rdma/rdma_netlink.h
rename to rdma/include/uapi/rdma/rdma_netlink.h
