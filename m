From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v05 61/72] include/uapi/rdma/rdma_user_rxe.h: include in.h and in6.h
Date: Mon, 22 Aug 2016 20:33:18 +0200
Message-ID: <1471890809-4383-62-git-send-email-mikko.rapeli@iki.fi>
References: <1471890809-4383-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471890809-4383-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Fixes these userspace compilation errors when rdma_user_rxe.h is compiled
alone:

rdma/rdma_user_rxe.h:59:20: error: field ‘_sockaddr’ has incomplete type
   struct sockaddr  _sockaddr;
                    ^~~~~~~~~
rdma/rdma_user_rxe.h:60:22: error: field ‘_sockaddr_in’ has incomplete type
   struct sockaddr_in _sockaddr_in;
                      ^~~~~~~~~~~~
rdma/rdma_user_rxe.h:61:23: error: field ‘_sockaddr_in6’ has incomplete type
   struct sockaddr_in6 _sockaddr_in6;
                       ^~~~~~~~~~~~~

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/rdma/rdma_user_rxe.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_user_rxe.h
index 1de99cf..ce6c929 100644
--- a/include/uapi/rdma/rdma_user_rxe.h
+++ b/include/uapi/rdma/rdma_user_rxe.h
@@ -34,6 +34,8 @@
 #define RDMA_USER_RXE_H
 
 #include <linux/types.h>
+#include <linux/in.h>
+#include <linux/in6.h>
 
 union rxe_gid {
 	__u8	raw[16];
-- 
2.8.1
