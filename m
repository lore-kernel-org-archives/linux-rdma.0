Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C884B04BB
	for <linux-rdma@vger.kernel.org>; Fri,  7 Aug 2026 13:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110396; cv=none; b=OkyyBjQLqvHbODrbpS0CCO7TvCh7UUx+uxU/V+rA36tG3cu/+CoQDuL8YKnd9xHjcMA5lfbdHFjUA6TiJHTyrJkx03e6MvSBFV0KY+ntqIrZko3G3DcNI3A1s0pyOQKr4YPP3ob3al8ecRD6lIU/k4ujYY9/sKt7nwdk7fp6exA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110396; c=relaxed/simple;
	bh=IU2H+Z7RC8DDuRieZNBRe4n5tHIbWtACdNJ7PEktJyw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=NSZCwPpo4wWtpMW5bwq1BmkoeAJmcnyP4qZsPCdqWfW/Sq05Y8a5zzOnhoPOJJfCDUeY+PKKkEb88wNUmFjg99iIrZWj6nQVF1h8EI5OFDikkoBBiC2VGsFa59gCCqe7eQoyD+4F0lRpZ8Sm1YJVJ7K03BfhDM4LfXuUlWhorjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4a36606e230so3529544b6e.2
        for <linux-rdma@vger.kernel.org>; Fri, 07 Aug 2026 06:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786110381; x=1786715181;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oAdEYHP32x3+S6ceXQBbcor8N5Tem/MWy3ipglvmGXY=;
        b=eIBfl1zw55hqSsoVvM014LR5TaeCENSJcDgjBLl05Obpzm5pHvlCpik7/n6sEM5P3D
         Fz/VXt01f2O1pd33jGFS+aj0ACiWvn+QT2gogY0GXNXUGjOd6GWPcigj8VEdlXmH17vd
         ZOjHo4774dqhRz94GmoNOSilDdplkVpm+39+hZwQgkc41SWf4iiR6ckWF0JRZQ65xtv9
         K60aa9W3+bOqAYdU+oiVg4HWobf+CraKiQPxs/2eUh4IOQ4VVeGmu/bfloUhERIOm1R7
         dC2XxnQE2cWVwfaaaUyucL1dkW08YA57KU6mme/7lXBeL4ZlqhN+khif1ucEiXOj+Op8
         L8LQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq6pk21qF3xYITaDTPRQ10raeWs5d8qeuldigOYCcMxFHJIhTd4ej5XFPwntGmIRlRiwfGd4Swfywpm@vger.kernel.org
X-Gm-Message-State: AOJu0YwkitlvlVpHKUwz0ZeyewgVzoP0uXTBeE97SUkIjWNfv+0larcp
	2W/Tb+LZ02kxroV/A7mm18MSLO6xUTTYMex819sBOoTkwjz/6V+/fu+LdEtG9pCVCX2POcUSnk/
	pc7iLKJlUUrYLvoWpVBi1ns9p76FoLz4qt/DSeetniyMMQEDYABhaSURfRhc=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:320b:b0:496:a01:458b with SMTP id
 5614622812f47-4b1a0bcbf37mr2137767b6e.2.1786110381381; Fri, 07 Aug 2026
 06:46:21 -0700 (PDT)
Date: Fri, 07 Aug 2026 06:46:21 -0700
In-Reply-To: <671756af.050a0220.10f4f4.010f.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a75e1ad.b50370da.49fe0.001b.GAE@google.com>
Subject: Re: [syzbot] [rdma?] INFO: task hung in add_one_compat_dev (3)
From: syzbot <syzbot+6dee15fdb0606ef7b6ba@syzkaller.appspotmail.com>
To: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org, nogikh@google.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    f9a2394a2348 Merge tag 'mm-hotfixes-stable-2026-08-06-18-4..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13d50fb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8e21dcbdb02d4229
dashboard link: https://syzkaller.appspot.com/bug?extid=6dee15fdb0606ef7b6ba
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d037b9580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6dee15fdb0606ef7b6ba@syzkaller.appspotmail.com

INFO: task syz-executor222:6072 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:26880 pid:6072  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebbbac208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebbbacfb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebbbac6c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
INFO: task syz-executor222:6074 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:26904 pid:6074  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebbb6a208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebbb6afb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebbb6a6c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
INFO: task syz-executor222:6076 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:27368 pid:6076  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebbb28208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebbb28fb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebbb286c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
INFO: task syz-executor222:6077 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:26112 pid:6077  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebbb07208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebbb07fb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebbb076c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
INFO: task syz-executor222:6078 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:26376 pid:6078  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebbae6208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebbae6fb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebbae66c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
INFO: task syz-executor222:6079 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:26752 pid:6079  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebbac5208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebbac5fb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebbac56c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
INFO: task syz-executor222:6080 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:26432 pid:6080  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebbaa4208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebbaa4fb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebbaa46c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
INFO: task syz-executor222:6081 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:26952 pid:6081  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebba83208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebba83fb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebba836c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
INFO: task syz-executor222:6082 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:26496 pid:6082  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebba62208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebba62fb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebba626c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
INFO: task syz-executor222:6085 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:26592 pid:6085  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebb9ff208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebb9fffb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebb9ff6c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
INFO: task syz-executor222:6089 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:25776 pid:6089  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebb97b208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebb97bfb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebb97b6c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
INFO: task syz-executor222:6098 blocked for more than 15 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor222 state:D stack:26376 pid:6098  tgid:5946  ppid:5945   task_flags:0x400140 flags:0x00080800
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 rt_mutex_schedule+0x76/0xf0 kernel/sched/core.c:7607
 rt_mutex_slowlock_block+0x55c/0x680 kernel/locking/rtmutex.c:1670
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1747 [inline]
 __rt_mutex_slowlock_locked kernel/locking/rtmutex.c:1787 [inline]
 rt_mutex_slowlock+0x2d4/0x780 kernel/locking/rtmutex.c:1827
 __rt_mutex_lock kernel/locking/rtmutex.c:1842 [inline]
 __mutex_lock_common kernel/locking/rtmutex_api.c:560 [inline]
 mutex_lock_nested+0x168/0x1d0 kernel/locking/rtmutex_api.c:578
 add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 rdma_dev_init_net+0x243/0x2f0 drivers/infiniband/core/device.c:1195
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:446
 copy_net_ns+0x4f9/0x720 net/core/net_namespace.c:579
 create_new_namespaces+0x3f0/0x6b0 kernel/nsproxy.c:132
 unshare_nsproxy_namespaces+0x149/0x190 kernel/nsproxy.c:234
 ksys_unshare+0x57d/0xa00 kernel/fork.c:3269
 __do_sys_unshare kernel/fork.c:3343 [inline]
 __se_sys_unshare kernel/fork.c:3341 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3341
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ebbc64e57
RSP: 002b:00007f3ebb852208 EFLAGS: 00000293 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 000000006a75e0c0 RCX: 00007f3ebbc64e57
RDX: 0000000000000000 RSI: 00007f3ebb852fb0 RDI: 0000000040000000
RBP: 0000000000000021 R08: 0000000000000000 R09: 00007f3ebb8526c0
R10: 0000000000000008 R11: 0000000000000293 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffccc2960e0 R15: 00007ffccc2961c8
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings

Showing all locks held in the system:
3 locks held by kworker/0:1/10:
 #0: ffff88801a047938 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #0: ffff88801a047938 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #1: ffffc900000f7c40 (pcpu_balance_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #1: ffffc900000f7c40 (pcpu_balance_work){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #2: ffffffff8e0c6d58 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_balance_workfn+0x66/0x1000 mm/percpu.c:2210
4 locks held by pr/legacy/17:
1 lock held by khungtaskd/38:
 #0: ffffffff8dfc3000 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8dfc3000 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #0: ffffffff8dfc3000 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
6 locks held by kworker/0:2/199:
5 locks held by kworker/u8:15/1421:
6 locks held by kworker/u8:17/4282:
1 lock held by klogd/4956:
2 locks held by getty/5350:
 #0: ffff888028ba60a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90003cbe2e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x460/0x1360 drivers/tty/n_tty.c:2211
3 locks held by kworker/0:4/5740:
 #0: ffff88801a046538 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #0: ffff88801a046538 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #1: ffffc90003e37c40 ((reg_check_chans).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #1: ffffc90003e37c40 ((reg_check_chans).work){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #2: ffffffff8f374cf8 (rtnl_mutex){+.+.}-{4:4}, at: reg_check_chans_work+0xac/0x1110 net/wireless/reg.c:2469
1 lock held by syz-executor222/5946:
5 locks held by syz-executor222/6068:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff888029fb91c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 #4: ffffffff8f374cf8 (rtnl_mutex){+.+.}-{4:4}, at: ib_get_eth_speed+0x173/0x7f0 drivers/infiniband/core/verbs.c:2051
5 locks held by syz-executor222/6069:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803dcb91c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 #4: ffffffff8f374cf8 (rtnl_mutex){+.+.}-{4:4}, at: ib_get_eth_speed+0x173/0x7f0 drivers/infiniband/core/verbs.c:2051
4 locks held by syz-executor222/6070:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff888029fb91c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
5 locks held by syz-executor222/6071:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88802a5d51c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 #4: ffffffff8f374cf8 (rtnl_mutex){+.+.}-{4:4}, at: ib_get_eth_speed+0x173/0x7f0 drivers/infiniband/core/verbs.c:2051
4 locks held by syz-executor222/6072:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6073:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88801e2dd1c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6074:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
5 locks held by syz-executor222/6075:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88801e2dd1c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 #4: ffffffff8f374cf8 (rtnl_mutex){+.+.}-{4:4}, at: ib_get_eth_speed+0x173/0x7f0 drivers/infiniband/core/verbs.c:2051
4 locks held by syz-executor222/6076:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6077:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6078:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6079:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6080:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6081:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6082:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
5 locks held by syz-executor222/6083:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff888040bfd1c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 #4: ffffffff8f374cf8 (rtnl_mutex){+.+.}-{4:4}, at: ib_get_eth_speed+0x173/0x7f0 drivers/infiniband/core/verbs.c:2051
4 locks held by syz-executor222/6084:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6085:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6086:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6087:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6088:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6089:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6090:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6091:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
5 locks held by syz-executor222/6092:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 #4: ffffffff8f374cf8 (rtnl_mutex){+.+.}-{4:4}, at: ib_get_eth_speed+0x173/0x7f0 drivers/infiniband/core/verbs.c:2051
4 locks held by syz-executor222/6093:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6094:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6095:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6096:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6097:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6098:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6099:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6100:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6101:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6102:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6103:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6104:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6105:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6106:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6107:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6108:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6109:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6110:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6111:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6112:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6113:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6114:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6115:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6116:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6117:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6118:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6119:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6120:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6121:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6122:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6123:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6124:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6125:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6126:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6127:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6130:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6137:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
4 locks held by syz-executor222/6142:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6147:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
4 locks held by syz-executor222/6154:
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6157:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6159:
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6160:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6166:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
4 locks held by syz-executor222/6168:
4 locks held by syz-executor222/6172:
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
4 locks held by syz-executor222/6182:
 #0: ffffffff8f366140 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x4e2/0x720 net/core/net_namespace.c:575
4 locks held by syz-executor222/6184:
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 #1: ffffffff8f0c1500 (devices_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x200/0x2f0 drivers/infiniband/core/device.c:1189
 #3: ffff88803fa291c8 (&device->compat_devs_mutex){+.+.}-{4:4}, at: add_one_compat_dev+0xf0/0x650 drivers/infiniband/core/device.c:953
 #2: ffffffff8f0c1740 (rdma_nets_rwsem){++++}-{4:4}, at: rdma_dev_init_net+0x238/0x2f0 drivers/infiniband/core/device.c:1194
, at: copy_net_ns+0x4e2/0

---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
