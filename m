Received: from mail-oi1-f205.google.com (mail-oi1-f205.google.com [209.85.167.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79233AB292
	for <linux-rdma@vger.kernel.org>; Sat,  8 Aug 2026 20:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786219715; cv=none; b=OVbdEs4yCtBiM8qVWf+tuL3kVMWTEfzyaHrYLT9m8DubqD1Df4u+zgNczvwvgLDHvE7lOd6yCyrDq30QPmeOapeEKpT7//wAqhcgeI08/BgUlWT+5vgBGkgOaWyHZ1Czyub1gmsDdWl9EtcgAXkg5CfrcofUhB5qkQ424t8pw5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786219715; c=relaxed/simple;
	bh=4AzFnwyVfA75dNJEZOC4EYosK+DoB2hWWe2ZOvxvU7s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=n1p4hj5dqoFvLjHHhBq3IJo+UE61p8vbac/Fle4f2a+vMwv1OAzKVdaMy/bRQFJar/3dmxsEII3TljSAyHOIsxIpJ1I9kzBwfbcBipCKRxj9rMYJrfhuGUUv8QsIshlVUlOZKH++uLwE4k05bpx81ek7REcvuDmjAVTd2jcseUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f205.google.com with SMTP id 5614622812f47-4a41f46d629so1012870b6e.3
        for <linux-rdma@vger.kernel.org>; Sat, 08 Aug 2026 13:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786219713; x=1786824513;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uyaezkbpMZMHe2SDtb/S2pbGZ6il3vwIp2u/o10JM2s=;
        b=q3xFYRgVDhY1rcUW4oPGnNZTTsFKntAxYWECqjOhVFUhm8FdFRRd5Yodo5fezMG5Mr
         OUIun7kfbVgLYt6bJB5953Ah4NuTURgO0WLAecyHRkXqTNc7zundRRfP4MKTuZn6rKpW
         81degoK7VFctcQGKwbomP0YxO0Kzz26VPjxRIzD6bbREYxTvwfl50nYg3FmoddFkbJhD
         1RcJZn0QrAZiKcsjVr8IUmCLlD9qgHcJU5bqHmRrYaWPSgHvnQtm9FuLfQO6f7OUfsWa
         uc+iMXQNxtGqPTvFYRsUu8FkcPEBafD55FHB++4qhAOKU6w+Rsgff/8h0mSXYtNRz/iF
         z8Eg==
X-Forwarded-Encrypted: i=1; AHgh+RpQuQYIuKsq0zoTzjQs/LMYuIBxYjynvo9fkm7TwxdbGJleLqErUntvlx9ApMCzS22Dccr0nJB9g+SV@vger.kernel.org
X-Gm-Message-State: AOJu0YwtiD7PiIEBORHo1NwmuIreyzmzcu52t5xfcN3y9B37hUCmNTIc
	3vxxLBsL//XLIProPBoa+YYqqbuzwMZFcrd8r48id4kwjCm9CllLPttUyo5KK3YH+1xbV4cz6GY
	I3Sdep5EWvzA4OPktadfhcvZK88F6rHLygcas1znIGBujBHa1TKyg+DRfcCk=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2512:b0:4ab:230c:5faa with SMTP id
 5614622812f47-4b1a101502fmr7706628b6e.18.1786219712889; Sat, 08 Aug 2026
 13:08:32 -0700 (PDT)
Date: Sat, 08 Aug 2026 13:08:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a778cc0.01d0871a.3a0d52.006e.GAE@google.com>
Subject: [syzbot] [rdma?] WARNING in res_to_rt
From: syzbot <syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com>
To: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ea2bff00da89 Add linux-next specific files for 20260806
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=142d2132580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b2f9169913eb6d73
dashboard link: https://syzkaller.appspot.com/bug?extid=72eddfbadda3e3928e72
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c72fb9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/473ce49245bc/disk-ea2bff00.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4d5bfcd186f5/vmlinux-ea2bff00.xz
kernel image: https://storage.googleapis.com/syzbot-assets/281694927321/bzImage-ea2bff00.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+72eddfbadda3e3928e72@syzkaller.appspotmail.com

------------[ cut here ]------------
!dev
WARNING: drivers/infiniband/core/restrack.c:138 at res_to_rt+0x1c4/0x230 drivers/infiniband/core/restrack.c:138, CPU#1: kworker/u8:4/59
Modules linked in:
CPU: 1 UID: 0 PID: 59 Comm: kworker/u8:4 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Workqueue: ib_addr process_one_req
RIP: 0010:res_to_rt+0x1c4/0x230 drivers/infiniband/core/restrack.c:138
Code: 41 5d 41 5e 41 5f c3 cc cc cc cc cc e8 b5 77 f7 f8 48 8d 3d 7e 23 97 07 43 0f b6 44 25 00 84 c0 75 48 8b 33 67 48 0f b9 3a 90 <0f> 0b 90 31 c0 eb cc 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 59 fe ff
RSP: 0018:ffffc9000201f850 EFLAGS: 00010293
RAX: ffffffff88d00ce5 RBX: ffff88807f0fd4f8 RCX: ffff88801e6e0000
RDX: 0000000000000000 RSI: ffffffff8fd996f0 RDI: 0000000000000003
RBP: 0000000000000000 R08: ffff88801e6e0000 R09: 000000000000000a
R10: 0000000000000009 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff1100fe1fa9f R14: 0000000000000000 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff888125012000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00001d559c3d2000 CR3: 0000000077c4c000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 rdma_restrack_add+0x5a/0x8a0 drivers/infiniband/core/restrack.c:236
 addr_handler+0x41a/0x5a0 drivers/infiniband/core/cma.c:3534
 process_one_req+0x2eb/0x540 drivers/infiniband/core/addr.c:624
 process_one_work kernel/workqueue.c:3375 [inline]
 process_scheduled_works+0xc4e/0x1630 kernel/workqueue.c:3458
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3539
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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
