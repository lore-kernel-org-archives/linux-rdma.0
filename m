From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 05/10] rdma: Allow external usage of compare string routine
Date: Wed, 31 Jan 2018 10:11:51 +0200
Message-ID: <20180131081156.19607-6-leon@kernel.org>
References: <20180131081156.19607-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180131081156.19607-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/rdma.h  | 2 ++
 rdma/utils.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/rdma/rdma.h b/rdma/rdma.h
index 35506a96..d2cde895 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -90,6 +90,8 @@ void rd_free(struct rd *rd);
 int rd_set_arg_to_devname(struct rd *rd);
 int rd_argc(struct rd *rd);
 
+int strcmpx(const char *str1, const char *str2);
+
 /*
  * Device manipulation
  */
diff --git a/rdma/utils.c b/rdma/utils.c
index f93f05e1..9e15b7cf 100644
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
2.16.1
