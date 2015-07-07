From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/2] IB/ucma: Fix lockdep warning in ucma_lock_files
Date: Tue,  7 Jul 2015 17:45:12 +0300
Message-ID: <1436280313-21451-2-git-send-email-haggaie@mellanox.com>
References: <1436280313-21451-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436280313-21451-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The ucma_lock_files() locks the mut mutex on two files, e.g. for migrating
an ID. Use mutex_lock_nested() to prevent the warning below.

 =============================================
 [ INFO: possible recursive locking detected ]
 4.1.0-rc6-hmm+ #40 Tainted: G           O
 ---------------------------------------------
 pingpong_rpc_se/10260 is trying to acquire lock:
  (&file->mut){+.+.+.}, at: [<ffffffffa047ac55>] ucma_migrate_id+0xc5/0x248 [rdma_ucm]

 but task is already holding lock:
  (&file->mut){+.+.+.}, at: [<ffffffffa047ac4b>] ucma_migrate_id+0xbb/0x248 [rdma_ucm]

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&file->mut);
   lock(&file->mut);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 1 lock held by pingpong_rpc_se/10260:
  #0:  (&file->mut){+.+.+.}, at: [<ffffffffa047ac4b>] ucma_migrate_id+0xbb/0x248 [rdma_ucm]

 stack backtrace:
 CPU: 0 PID: 10260 Comm: pingpong_rpc_se Tainted: G           O    4.1.0-rc6-hmm+ #40
 Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
  ffff8801f85b63d0 ffff880195677b58 ffffffff81668f49 0000000000000001
  ffffffff825cbbe0 ffff880195677c38 ffffffff810bb991 ffff880100000000
  ffff880100000000 ffff880100000001 ffff8801f85b7010 ffffffff8121bee9
 Call Trace:
  [<ffffffff81668f49>] dump_stack+0x4f/0x6e
  [<ffffffff810bb991>] __lock_acquire+0x741/0x1820
  [<ffffffff8121bee9>] ? dput+0x29/0x320
  [<ffffffff810bcb38>] lock_acquire+0xc8/0x240
  [<ffffffffa047ac55>] ? ucma_migrate_id+0xc5/0x248 [rdma_ucm]
  [<ffffffff8166b901>] ? mutex_lock_nested+0x291/0x3e0
  [<ffffffff8166b6d5>] mutex_lock_nested+0x65/0x3e0
  [<ffffffffa047ac55>] ? ucma_migrate_id+0xc5/0x248 [rdma_ucm]
  [<ffffffff810baeed>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff8166b66e>] ? mutex_unlock+0xe/0x10
  [<ffffffffa047ac55>] ucma_migrate_id+0xc5/0x248 [rdma_ucm]
  [<ffffffffa0478474>] ucma_write+0xa4/0xb0 [rdma_ucm]
  [<ffffffff81200674>] __vfs_write+0x34/0x100
  [<ffffffff8112427c>] ? __audit_syscall_entry+0xac/0x110
  [<ffffffff810ec055>] ? current_kernel_time+0xc5/0xe0
  [<ffffffff812aa4d3>] ? security_file_permission+0x23/0x90
  [<ffffffff8120088d>] ? rw_verify_area+0x5d/0xe0
  [<ffffffff812009bb>] vfs_write+0xab/0x120
  [<ffffffff81201519>] SyS_write+0x59/0xd0
  [<ffffffff8112427c>] ? __audit_syscall_entry+0xac/0x110
  [<ffffffff8166ffee>] system_call_fastpath+0x12/0x76

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/ucma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index ad45469f7582..a700cdb13f3d 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1354,10 +1354,10 @@ static void ucma_lock_files(struct ucma_file *file1, struct ucma_file *file2)
 	/* Acquire mutex's based on pointer comparison to prevent deadlock. */
 	if (file1 < file2) {
 		mutex_lock(&file1->mut);
-		mutex_lock(&file2->mut);
+		mutex_lock_nested(&file2->mut, SINGLE_DEPTH_NESTING);
 	} else {
 		mutex_lock(&file2->mut);
-		mutex_lock(&file1->mut);
+		mutex_lock_nested(&file1->mut, SINGLE_DEPTH_NESTING);
 	}
 }
 
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
