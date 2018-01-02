From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 5/9] rdma: Allow external usage of compare string routine
Date: Tue,  2 Jan 2018 11:37:21 +0200
Message-ID: <20180102093725.6172-6-leon@kernel.org>
References: <20180102093725.6172-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180102093725.6172-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/rdma.h  | 2 ++
 rdma/utils.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index e842d076..816c8ddd 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -84,6 +84,8 @@ void rd_free(struct rd *rd);
 int rd_set_arg_to_devname(struct rd *rd);
 int rd_argc(struct rd *rd);
 
+int strcmpx(const char *str1, const char *str2);
+
 /*
  * Device manipulation
  */
diff --git a/rdma/utils.c b/rdma/utils.c
index fbeffa08..a63a7c2f 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -24,7 +24,7 @@ char *rd_argv(struct rd *rd)
 	return *rd->argv;
 }
 
-static int strcmpx(const char *str1, const char *str2)
+int strcmpx(const char *str1, const char *str2)
 {
 	if (strlen(str1) > strlen(str2))
 		return -1;
-- 
2.15.1
