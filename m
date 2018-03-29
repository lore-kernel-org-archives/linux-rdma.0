From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v4 iproute2-next 3/7] rdma: initialize the rd struct
Date: Thu, 29 Mar 2018 09:10:35 -0700
Message-ID: <0459489667e983bb3a6f9ecaf25daff6a329f2da.1522359537.git.swise@opengridcomputing.com>
References: <cover.1522359537.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1522359537.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Initialize the rd struct so port_idx is 0 unless set otherwise.
Otherwise, strict_port queries end up passing an uninitialized PORT
nlattr.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rdma/rdma.c b/rdma/rdma.c
index ab2c960..b43e538 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -135,7 +135,7 @@ int main(int argc, char **argv)
 	bool json_output = false;
 	bool force = false;
 	char *filename;
-	struct rd rd;
+	struct rd rd = {};
 	int opt;
 	int err;
 
-- 
1.8.3.1
