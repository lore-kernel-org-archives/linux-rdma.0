From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v3 iproute2-next 2/8] rdma: Makefile change to find
 <rdma/rdma_cma.h>
Date: Mon, 26 Mar 2018 13:57:33 -0700
Message-ID: <a0f4455c51a4d19d3eab4b9ccd9426e7baf150d8.1522097991.git.swise@opengridcomputing.com>
References: <cover.1522097991.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1522097991.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 rdma/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma/Makefile b/rdma/Makefile
index 819fcbe..2cb46b6 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -4,7 +4,7 @@ include ../config.mk
 TARGETS :=
 
 ifeq ($(HAVE_MNL),y)
-CFLAGS += -I./include/uapi/
+CFLAGS += -I./include/uapi/ -I./include/
 
 RDMA_OBJ = rdma.o utils.o dev.o link.o res.o
 
-- 
1.8.3.1
