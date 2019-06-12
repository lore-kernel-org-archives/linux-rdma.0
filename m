From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] linux-next: DOC: RDS: Fix a typo in rds.txt
Date: Wed, 12 Jun 2019 21:29:34 +0900
Message-ID: <20190612122934.3515-1-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: santosh.shilimkar@oracle.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-rdma@vger.kernel.org

This patch fixes a spelling typo in rds.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/networking/rds.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/rds.txt b/Documentation/networking/rds.txt
index 0235ae69af2a..f2a0147c933d 100644
--- a/Documentation/networking/rds.txt
+++ b/Documentation/networking/rds.txt
@@ -389,7 +389,7 @@ Multipath RDS (mprds)
   a common (to all paths) part, and a per-path struct rds_conn_path. All
   I/O workqs and reconnect threads are driven from the rds_conn_path.
   Transports such as TCP that are multipath capable may then set up a
-  TPC socket per rds_conn_path, and this is managed by the transport via
+  TCP socket per rds_conn_path, and this is managed by the transport via
   the transport privatee cp_transport_data pointer.
 
   Transports announce themselves as multipath capable by setting the
-- 
2.22.0
