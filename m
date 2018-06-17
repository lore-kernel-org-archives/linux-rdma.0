From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 03/20] kernel.h: Reuse u64_to_ptr macro to cast __user pointers
Date: Sun, 17 Jun 2018 12:59:49 +0300
Message-ID: <20180617100006.30663-4-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Redefine u64_to_user_ptr() macro to be implemented with u64_to_ptr().

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/linux/kernel.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 7d60a3472929..3012ae2f52f7 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -83,12 +83,7 @@ static inline u64 ptr_to_u64(const void *ptr)
 }					\
 )
 
-#define u64_to_user_ptr(x) (		\
-{					\
-	typecheck(u64, x);		\
-	(void __user *)(uintptr_t)x;	\
-}					\
-)
+#define u64_to_user_ptr(x)	u64_to_ptr(void __user, x)
 
 /*
  * This looks more complex than it should be. But we need to
-- 
2.14.4
