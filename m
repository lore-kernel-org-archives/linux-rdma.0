Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E566B3939B3
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 02:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792118739; cv=none; b=O551azXocFBdd3ECSGMfYK9dYj6HKJ+iqHaxWH/BQsK7SVC7fw44w3UnOLyAT/Ht/paouGyhR72GtWg0TD+i8XCEcGjhOZLvJrCgGBYV3tKXrBSnXpROTysv8mjReXFO2xoxtYTjShfS9Wo93YDHj4lHWNUrKh9z3TsKN2H1pJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792118739; c=relaxed/simple;
	bh=QqmRt76cw0feAYYdqgTzhiJexD1f/46qnCyzzSgGQOY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TRGR2GpvFqZB82HN5zbmJj1FljOz3nS2aGCv+rzwDryC4luUqHTKlv/uX/uF2tlqT6+l74+fjms6qfiDoDXIQJdNd2USvzaI+lRADkR9CrdNjYaRWY2zgI5P+xMdBYwbgIspOPtWGYxX2OwyLiOt783fNdXi7QE5xEj5cv/JI6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b2f2b8d88fso10084793b6e.2
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 19:45:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792118737; x=1792723537;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=seQXTxHTBDCS8PCf+EWgSHwzgEZlNkH5MH0J2kC2r+M=;
        b=OqB3qLUUnI332RcjmB1epm/C9wmENDoL4oHaDIcQCQF26TJYOVKQaxQTriz15yj1zM
         vOXQGMVMlSUp2TqhJztNiXkHZxue4as2O1cbFGWUh4ouGBFwGkEZCwVzpyfutQAvWeHW
         P8dQ6lEm4gCVDeYURAlkVJ0K9q9+t0K7sUGuHLJqDNViUKw3ar6/6t9iu2mdruxApxGd
         G3qUxg1llvkPfRoKw6Ap9aKJpZ1g3t1RL3Ru9dQ/9QqfNWX6kA5+onq+msVlFMlSa7nO
         +ZfcUZpIkAEYiUOiBawuvSpgZL4m2FnHwbO5gAhssB9eLJGm2GYM9w8QEn7hQyC9ySZ1
         L7rA==
X-Forwarded-Encrypted: i=1; AKwUvBwwNCTnswErSSiFSi7cE2tlnuKZB4D4ef3FihKUSRl8VTTWFE9Ki9WbowpPEP9Dm3pFUp06cBFl2sN1@vger.kernel.org
X-Gm-Message-State: AFq9FYIGXw9QI9qBp1U6RuOQGxTMZaG4eBWq31oAu7kmq7r1dLPmY5ke
	zVfCTY872XBNSoiFzKoSzoORus+Ofd7PE9Y+8x3sB697O+UFEvpPx8itdOfCEddR6criyj2y2MX
	p0otGHaYIG+dw9yD4aw2JDJFd7bcwOxRM6L0zjkbX/ueA6hcx+UXqTuvLUsY=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4fdf:b0:4f5:6fff:3ac4 with SMTP id
 5614622812f47-50c516e42b7mr22514191b6e.41.1792118736843; Thu, 15 Oct 2026
 19:45:36 -0700 (PDT)
Date: Thu, 15 Oct 2026 19:45:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad18fd0.7514cce4.1ece07.011f.GAE@google.com>
Subject: [syzbot] [rds?] WARNING in __rds_conn_create (2)
From: syzbot <syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com>
To: achender@kernel.org, allison.henderson@oracle.com, davem@davemloft.net, 
	edumazet@kernel.org, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, rds-devel@oss.oracle.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0fcb05b72344 Merge tag 'libcrypto-fixes-for-linus' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11e64dd1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ccb65e03706547e
dashboard link: https://syzkaller.appspot.com/bug?extid=c3741bb338b5c6d6a4aa
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ef43c9580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-0fcb05b7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d63a4093e9d7/vmlinux-0fcb05b7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/238bf14f8b3f/bzImage-0fcb05b7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b883c5a2bb3e/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=13f70fd1580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com

XFS (loop0): Quotacheck: Done.
------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: kernel/locking/irqflag-debug.c:10 at warn_bogus_irq_restore+0xc/0x20 kernel/locking/irqflag-debug.c:10, CPU#0: syz.0.18/5745
Modules linked in:
CPU: 0 UID: 0 PID: 5745 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:warn_bogus_irq_restore+0xc/0x20 kernel/locking/irqflag-debug.c:10
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 90 48 8d 3d c4 18 93 05 <67> 48 0f b9 3a 90 e9 99 04 03 00 cc cc cc cc cc cc cc cc cc 90 90
RSP: 0018:ffffc9000797f8c0 EFLAGS: 00010206
RAX: 0000000000000202 RBX: 0000000000000287 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffffff917dce80
RBP: ffffc9000797fa40 R08: ffffffff914a10e3 R09: 1ffffffff229421c
R10: dffffc0000000000 R11: fffffbfff229421d R12: ffffffff8b2acb15
R13: ffff888051146318 R14: ffffffff914a10e0 R15: 0000000000000287
FS:  00007f7afe2f56c0(0000) GS:ffff88808b0b4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7afd3ebc40 CR3: 000000004db87000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:210 [inline]
 _raw_spin_unlock_irqrestore+0x67/0x80 kernel/locking/spinlock.c:221
 spin_unlock_irqrestore include/linux/spinlock.h:425 [inline]
 __rds_conn_create+0x1de5/0x2290 net/rds/connection.c:364
 rds_conn_create_outgoing+0x43/0x60 net/rds/connection.c:394
 rds_sendmsg+0xfca/0x20e0 net/rds/send.c:1348
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 __sys_sendto+0x408/0x5a0 net/socket.c:2281
 __do_sys_sendto net/socket.c:2288 [inline]
 __se_sys_sendto net/socket.c:2284 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2284
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7afd39e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7afe2f5028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f7afd625fa0 RCX: 00007f7afd39e559
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f7afd4358b0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7afd626038 R14: 00007f7afd625fa0 R15: 00007ffd156f7018
 </TASK>
----------------
Code disassembly (best guess):
   0:	cc                   	int3
   1:	cc                   	int3
   2:	cc                   	int3
   3:	cc                   	int3
   4:	cc                   	int3
   5:	cc                   	int3
   6:	cc                   	int3
   7:	cc                   	int3
   8:	cc                   	int3
   9:	cc                   	int3
   a:	cc                   	int3
   b:	cc                   	int3
   c:	cc                   	int3
   d:	cc                   	int3
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	90                   	nop
  18:	90                   	nop
  19:	90                   	nop
  1a:	90                   	nop
  1b:	90                   	nop
  1c:	90                   	nop
  1d:	90                   	nop
  1e:	f3 0f 1e fa          	endbr64
  22:	90                   	nop
  23:	48 8d 3d c4 18 93 05 	lea    0x59318c4(%rip),%rdi        # 0x59318ee
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	90                   	nop
  30:	e9 99 04 03 00       	jmp    0x304ce
  35:	cc                   	int3
  36:	cc                   	int3
  37:	cc                   	int3
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	cc                   	int3
  3b:	cc                   	int3
  3c:	cc                   	int3
  3d:	cc                   	int3
  3e:	90                   	nop
  3f:	90                   	nop


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
