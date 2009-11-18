From: Jiri Slaby <jslaby-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/16] misc: use ACCESS_ONCE for rlimits
Date: Wed, 18 Nov 2009 15:51:57 +0100
Message-ID: <1258555922-2064-11-git-send-email-jslaby@novell.com>
References: <4B040A03.2020508@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B040A03.2020508-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jirislaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: mingo-X9Un+BFzKDI@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, marcin.slusarz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Jiri Slaby <jslaby-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

Signed-off-by: Jiri Slaby <jslaby-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/core/umem.c                 |    3 ++-
 drivers/infiniband/hw/ipath/ipath_user_pages.c |    4 ++--
 ipc/mqueue.c                                   |    4 ++--
 ipc/shm.c                                      |    4 ++--
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 6f7c096..90d806b 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -136,7 +136,8 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	down_write(&current->mm->mmap_sem);
 
 	locked     = npages + current->mm->locked_vm;
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >> PAGE_SHIFT;
+	lock_limit = ACCESS_ONCE(current->signal->
+			rlim[RLIMIT_MEMLOCK].rlim_cur) >> PAGE_SHIFT;
 
 	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
 		ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/ipath/ipath_user_pages.c b/drivers/infiniband/hw/ipath/ipath_user_pages.c
index 82878e3..f7db156 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_pages.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -59,8 +59,8 @@ static int __get_user_pages(unsigned long start_page, size_t num_pages,
 	size_t got;
 	int ret;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur >>
-		PAGE_SHIFT;
+	lock_limit = ACCESS_ONCE(current->signal->
+			rlim[RLIMIT_MEMLOCK].rlim_cur) >> PAGE_SHIFT;
 
 	if (num_pages > lock_limit) {
 		ret = -ENOMEM;
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index ee9d697..d04869f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -152,8 +152,8 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 
 			spin_lock(&mq_lock);
 			if (u->mq_bytes + mq_bytes < u->mq_bytes ||
-		 	    u->mq_bytes + mq_bytes >
-			    p->signal->rlim[RLIMIT_MSGQUEUE].rlim_cur) {
+			    u->mq_bytes + mq_bytes > ACCESS_ONCE(p->signal->
+			    rlim[RLIMIT_MSGQUEUE].rlim_cur)) {
 				spin_unlock(&mq_lock);
 				goto out_inode;
 			}
diff --git a/ipc/shm.c b/ipc/shm.c
index 464694e..99de87c 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -761,8 +761,8 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int, cmd, struct shmid_ds __user *, buf)
 			if (euid != shp->shm_perm.uid &&
 			    euid != shp->shm_perm.cuid)
 				goto out_unlock;
-			if (cmd == SHM_LOCK &&
-			    !current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
+			if (cmd == SHM_LOCK && !ACCESS_ONCE(current->signal->
+					rlim[RLIMIT_MEMLOCK].rlim_cur))
 				goto out_unlock;
 		}
 
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
