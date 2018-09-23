From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] RDS: IB: Use DEFINE_PER_CPU_SHARED_ALIGNED for
 rds_ib_stats
Date: Sun, 23 Sep 2018 12:26:22 -0700 (PDT)
Message-ID: <20180923.122622.2033570349162784418.davem@davemloft.net>
References: <20180921180451.18711-1-natechancellor@gmail.com>
        <20180923064445.GC12338@flashbox>
        <20180923.121927.436285462706036460.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180923.121927.436285462706036460.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: natechancellor@gmail.com
Cc: santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, ndesaulniers@google.com
List-Id: linux-rdma@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 23 Sep 2018 12:19:27 -0700 (PDT)

> From: Nathan Chancellor <natechancellor@gmail.com>
> Date: Sat, 22 Sep 2018 23:44:45 -0700
> 
>> I have sent a v2 because this should be DECLARE_PER_CPU_SHARED_ALIGNED,
>> not DEFINE (thanks to 0day for catching it).
> 
> Your first version was already applied to the networking GIT tree, so
> you will need to submit a relative fixup with a proper "Fixes: " tag.

Nevermind, I took care of it myself.

====================
>From 16fdf8ba98391650ce4bc4f3f71629d8a413bc21 Mon Sep 17 00:00:00 2001
From: "David S. Miller" <davem@davemloft.net>
Date: Sun, 23 Sep 2018 12:25:15 -0700
Subject: [PATCH] rds: Fix build regression.

Use DECLARE_* not DEFINE_*

Fixes: 8360ed6745df ("RDS: IB: Use DEFINE_PER_CPU_SHARED_ALIGNED for rds_ib_stats")
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/rds/ib.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/ib.h b/net/rds/ib.h
index fd483760c910..71ff356ee702 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -443,7 +443,7 @@ int rds_ib_send_grab_credits(struct rds_ib_connection *ic, u32 wanted,
 int rds_ib_xmit_atomic(struct rds_connection *conn, struct rm_atomic_op *op);
 
 /* ib_stats.c */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_ib_statistics, rds_ib_stats);
+DECLARE_PER_CPU_SHARED_ALIGNED(struct rds_ib_statistics, rds_ib_stats);
 #define rds_ib_stats_inc(member) rds_stats_inc_which(rds_ib_stats, member)
 #define rds_ib_stats_add(member, count) \
 		rds_stats_add_which(rds_ib_stats, member, count)
-- 
2.13.6
