Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFD04CF468
	for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 19:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792350879; cv=none; b=d/+SDeQ772VAzVIMjRG2kzst1shjqasCgRJLzzkhb6Tekx8iglmOX5q5kk/xyOZafolNQTwDnQDk1hCQuZEZ/kjAHwVeke9+srXi3xDr6B0GT0dg703upgIbxeKrPIkfunc9i/JRfatt4+Y6wEvUMt+hFJCm+RqLxDNxqokaMZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792350879; c=relaxed/simple;
	bh=dv3THeCUFr1makUliMH5EFDp2IAiW1kqgoej/IOkhyU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SqwGsDUu5ilQCboN578Hj1UGlQv1g9rgiVk6pYMJaC/HqMCUkuW613b3LX6cD780F5l25tYbg8ZyAPGQsdKs8bQoFJDlZMkK0oFluSfim9nIgCyv+cDzQ/2hFUEz14tIauswGjNyVg3EsnMdhaBsU9TZ4F5mea+diy8zEmRjTB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b28d7ffab1so2952673b6e.1
        for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 12:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792350876; x=1792955676;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7lKzvKHoU99MM8OfPBlNDx5jzmgLz/gxzBoi65FPbRE=;
        b=oA3sZmEd1krLUIR2q3Twcx0Rqkti3/i8rNhc87WKolc2k4YLYsq84YpacKuKphIfLM
         e2kmh5iV1mRf01hTjLW8n7aLMUMM50X8UiWavt03tQT7sUMAcJlyvMosHiWYK8/u0Rd+
         5z2iXvLkJVL9+ZBVlLvTds8PJFpPNCVdGltmYEmez21/cAs0e+B/iLMzHJ9UESsOHScv
         eiFhQcwvFUCw3E/3Q+k8em+PZuEO9v3TZb7OdyqjGojUL5Tk96oX8y3nyWNdqgBq4/aM
         YILHmipaMY2o2hsoVHEJcGvxdZX48pSslngPbXtS0QN9xnYd4sB8AylwscrPbFd/hmnC
         t2nw==
X-Forwarded-Encrypted: i=1; AKwUvBxfQAWlY1zvxVj0H+ANppqUu9OcvvDpeG7vQQW/ENGUxDhxjPaNA1LeICWPNG3cbe7Sk/8lkSdbSt9S@vger.kernel.org
X-Gm-Message-State: AFq9FYLlRNuJu4hMRWfviwMBR/8YYeN6t0XzdXyKyFEB5hjvfjFHxNEL
	hrF0LjFZV21HS7dd5FaMYFctpdfG/UV1batMmaz9xw1HsWgJ+iFhRh+x6SF9A1PXivUxdQv4e4i
	c9sTs0J7bzme+2yXTFGEazUvfIIZ91BSWZAOa0k8M4ZdC6F4nCLiI5QA9tJU=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a0d:b0:4b8:4703:db90 with SMTP id
 5614622812f47-536fda8b0a9mr5366394b6e.25.1792350876373; Sun, 18 Oct 2026
 12:14:36 -0700 (PDT)
Date: Sun, 18 Oct 2026 12:14:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad51a9c.a6d1a155.34a93f.00bb.GAE@google.com>
Subject: [syzbot] [rdma?] possible deadlock in rds_trans_get_preferred
From: syzbot <syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    70dd4ee72eb2 Merge tag 'pinctrl-v7.3-3' of git://git.kerne..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1271a69c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=44ac479246d4559b
dashboard link: https://syzkaller.appspot.com/bug?extid=ccdb5058c3df2d94811c
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b9618e580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ccdb5058c3df2d94811c@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kworker/2:3/5905 is trying to acquire lock:
ffffffff9205e888 (rds_trans_sem){++++}-{4:4}, at: rds_trans_get_preferred+0xf7/0x2c0 net/rds/transport.c:100

but task is already holding lock:
ffff888014aed420 (&id_priv->handler_mutex/1){+.+.}-{4:4}, at: cma_ib_req_handler+0x16ff/0x5700 drivers/infiniband/core/cma.c:2450

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&id_priv->handler_mutex/1){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       cma_ib_req_handler+0x16ff/0x5700 drivers/infiniband/core/cma.c:2450
       cm_process_work+0x46/0x440 drivers/infiniband/core/cm.c:1869
       cm_queue_work_unlock+0x5d/0x250 drivers/infiniband/core/cm.c:933
       cm_req_handler drivers/infiniband/core/cm.c:2235 [inline]
       cm_work_handler+0x638d/0xc860 drivers/infiniband/core/cm.c:3849
       process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396
       process_scheduled_works kernel/workqueue.c:3479 [inline]
       worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
       kthread+0x373/0x450 kernel/kthread.c:436
       ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 (&id_priv->handler_mutex){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
       rdma_destroy_id+0x1b/0x30 drivers/infiniband/core/cma.c:2124
       rds_ib_laddr_check_cm net/rds/ib.c:489 [inline]
       rds_ib_laddr_check+0x38b/0x730 net/rds/ib.c:511
       rds_trans_get_preferred+0x15f/0x2c0 net/rds/transport.c:104
       rds_bind+0x1a4a/0x2420 net/rds/bind.c:254
       __sys_bind_socket net/socket.c:1945 [inline]
       __sys_bind_socket net/socket.c:1937 [inline]
       __sys_bind+0x1a9/0x260 net/socket.c:1976
       __do_compat_sys_socketcall net/compat.c:450 [inline]
       __se_compat_sys_socketcall net/compat.c:422 [inline]
       __ia32_compat_sys_socketcall+0x4c7/0x770 net/compat.c:422
       do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:79 [inline]
       __do_fast_syscall_32+0x13a/0x8b0 arch/x86/entry/syscall_32.c:291
       do_fast_syscall_32+0x32/0x70 arch/x86/entry/syscall_32.c:316
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #0 (rds_trans_sem){++++}-{4:4}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
       lock_acquire kernel/locking/lockdep.c:5942 [inline]
       lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
       down_read+0x99/0x4c0 kernel/locking/rwsem.c:1574
       rds_trans_get_preferred+0xf7/0x2c0 net/rds/transport.c:100
       __rds_conn_create+0xad5/0x2650 net/rds/connection.c:252
       rds_conn_create+0x44/0x60 net/rds/connection.c:384
       rds_ib_cm_handle_connect+0x62b/0x1220 net/rds/ib_cm.c:860
       rds_rdma_cm_event_handler_cmn+0x59f/0x9b0 net/rds/rdma_transport.c:91
       cma_listen_handler+0x11a/0x180 drivers/infiniband/core/cma.c:2716
       cma_cm_event_handler+0x99/0x300 drivers/infiniband/core/cma.c:2181
       cma_ib_req_handler+0x1be2/0x5700 drivers/infiniband/core/cma.c:2461
       cm_process_work+0x46/0x440 drivers/infiniband/core/cm.c:1869
       cm_queue_work_unlock+0x5d/0x250 drivers/infiniband/core/cm.c:933
       cm_req_handler drivers/infiniband/core/cm.c:2235 [inline]
       cm_work_handler+0x638d/0xc860 drivers/infiniband/core/cm.c:3849
       process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396
       process_scheduled_works kernel/workqueue.c:3479 [inline]
       worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
       kthread+0x373/0x450 kernel/kthread.c:436
       ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  rds_trans_sem --> &id_priv->handler_mutex --> &id_priv->handler_mutex/1

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&id_priv->handler_mutex/1);
                               lock(&id_priv->handler_mutex);
                               lock(&id_priv->handler_mutex/1);
  rlock(rds_trans_sem);

 *** DEADLOCK ***

locks held by kworker/2:3/5905: 4, last CPU#2:
 #0: ffff88804c131140 ((wq_completion)ib_cm){+.+.}-{0:0}, at: process_one_work+0x1466/0x1b10 kernel/workqueue.c:3371
 #1: ffffc900030dfd08 ((work_completion)(&(&work->work)->work)){+.+.}-{0:0}, at: process_one_work+0xa2c/0x1b10 kernel/workqueue.c:3372
 #2: ffff88802a6fc420 (&id_priv->handler_mutex){+.+.}-{4:4}, at: cma_ib_req_handler+0xef1/0x5700 drivers/infiniband/core/cma.c:2427
 #3: ffff888014aed420 (&id_priv->handler_mutex/1){+.+.}-{4:4}, at: cma_ib_req_handler+0x16ff/0x5700 drivers/infiniband/core/cma.c:2450

stack backtrace:
CPU: 2 UID: 0 PID: 5905 Comm: kworker/2:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: ib_cm cm_work_handler
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1be kernel/locking/lockdep.c:2087
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2219
 check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3209
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x1528/0x1f40 kernel/locking/lockdep.c:5288
 lock_acquire kernel/locking/lockdep.c:5942 [inline]
 lock_acquire+0x1d1/0x380 kernel/locking/lockdep.c:5899
 down_read+0x99/0x4c0 kernel/locking/rwsem.c:1574
 rds_trans_get_preferred+0xf7/0x2c0 net/rds/transport.c:100
 __rds_conn_create+0xad5/0x2650 net/rds/connection.c:252
 rds_conn_create+0x44/0x60 net/rds/connection.c:384
 rds_ib_cm_handle_connect+0x62b/0x1220 net/rds/ib_cm.c:860
 rds_rdma_cm_event_handler_cmn+0x59f/0x9b0 net/rds/rdma_transport.c:91
 cma_listen_handler+0x11a/0x180 drivers/infiniband/core/cma.c:2716
 cma_cm_event_handler+0x99/0x300 drivers/infiniband/core/cma.c:2181
 cma_ib_req_handler+0x1be2/0x5700 drivers/infiniband/core/cma.c:2461
 cm_process_work+0x46/0x440 drivers/infiniband/core/cm.c:1869
 cm_queue_work_unlock+0x5d/0x250 drivers/infiniband/core/cm.c:933
 cm_req_handler drivers/infiniband/core/cm.c:2235 [inline]
 cm_work_handler+0x638d/0xc860 drivers/infiniband/core/cm.c:3849
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3396
 process_scheduled_works kernel/workqueue.c:3479 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3560
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
RDS/IB: Active conn connected <::ffff:172.20.20.170,::ffff:172.20.20.170,0> version 3.1


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
