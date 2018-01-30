From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] verbs: Use correct type for printf from struct rlimit
Date: Tue, 30 Jan 2018 15:49:04 -0700
Message-ID: <20180130224904.GA11309@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The actual type of the members is rlim_t which only happens to be
unsigned long on the platforms we have tested so far. x32 uses something
else.

Casting to unsigned long long for printing is the safe solution.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libibverbs/init.c b/libibverbs/init.c
index ff2c60ffcbc963..cda628b9e0544d 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -552,9 +552,9 @@ static void check_memlock_limit(void)
 	}
 
 	if (rlim.rlim_cur <= 32768)
-		fprintf(stderr, PFX "Warning: RLIMIT_MEMLOCK is %lu bytes.\n"
+		fprintf(stderr, PFX "Warning: RLIMIT_MEMLOCK is %llu bytes.\n"
 			"    This will severely limit memory registrations.\n",
-			rlim.rlim_cur);
+			(unsigned long long)rlim.rlim_cur);
 }
 
 static int same_sysfs_dev(struct verbs_sysfs_dev *sysfs1,
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
