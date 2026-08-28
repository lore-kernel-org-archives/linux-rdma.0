Received: from mail-oi2-f4.google.com (mail-oi2-f4.google.com [74.125.231.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4AD199920
	for <linux-rdma@vger.kernel.org>; Fri, 28 Aug 2026 00:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787876612; cv=none; b=bRV2SOZwEQj0jL+4W7AGeJUAPM2d3eYhSw5B1sSx5wrcPP4qBK+moQX92xaO+jINRRyShO8v7yCu47qLTDiSHVxT106kIXvW7RNfkj1mC1wuXS1UC3l3qYHOpGxpRg6e8gLHFlASYIgPPTvp9BsUhJb4xnivY8iUVeKMtn/jBgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787876612; c=relaxed/simple;
	bh=caimQNcN2rW3DEi03DRHEGcEBfK6kOJ0DZblAcU+G0Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sGSZSot2vq2I6EDWyVP/r1u3fngxvm0+U2cprBblPHXBTAZBBjZyykMls9NO/Cbb6hhd5xWwPdEZeeG6j0W482KLE52U9710AoVv2xrrVzY97N/mum4w5XHqFVChXH4BujUw6PPzSeB8u0oaivIgvs4jEu6H6WCl4ptOYybqmsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f4.google.com with SMTP id 5614622812f47-4a4d46eea77so220963b6e.1
        for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 17:23:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787876609; x=1788481409;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=riI6xZ5vVUH4NJYPmz62/YJnB7GrfXBnz2sLACtuAeA=;
        b=gc9dS+wmO4l8fzmfKpumRLLrSJIvQa46oa5Nqs4CmBGTu+dwRygsrcd4r/qgBvC3Sj
         bKSJ/MDTMN4JzFwWiI2JgS7fHQ3XDr95CthXtfqytoq2q61ATJ1JsqlozsYmGS46Ydj1
         yH9IlhX4G1cCFeX2dqg4QsZIDHYHfyQ9M/+BrtmA5kfusq6rmsV7bnFWO6i7Gad57XuD
         W+1tujf7A5Hss4sqiq80EaUZbp7ZFYeVhqVBoViD1ehhRQK0frdw+EP3hHgbrUFo2CPV
         2uejt6yxfE3wa54AFwe4MLIXMa0TAOPR4XhNYk3vJ8fpI9XwHPrFwLWJVAr+3Ie59uRs
         UNow==
X-Forwarded-Encrypted: i=1; AHgh+RqQR65fr9jhC63geN5KIIWooCcTJy2JvTr0LWfrVjk6sD532rRkT4mjmbLwwJJZNbvdd2C6uBLrhy3t@vger.kernel.org
X-Gm-Message-State: AFuF++m4BlfieiEYfGBkrXLTDC5jD1I6sGYNwto4o3qgy/6C5AFcMBhB
	9q3EnptN2pY5BxbkF/Xyg3PZ+vrqJZB+FbyklAWZeEGxs0nsnQYsM6QZs/ywFWitsMOW0Y+Pdtf
	+IDfNmybN2EdldNjMH+04teYeW3/t0zxZqHDXLdYFHy2anx6H87ZLow1qcq0=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c165:b0:4ab:3210:b31a with SMTP id
 5614622812f47-4b398253454mr3588570b6e.14.1787876609677; Thu, 27 Aug 2026
 17:23:29 -0700 (PDT)
Date: Thu, 27 Aug 2026 17:23:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a90d501.1d9ded08.62e62.00df.GAE@google.com>
Subject: [syzbot] [rdma?] WARNING in ib_cq_pool_cleanup
From: syzbot <syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com>
To: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    73e3f0710014 Merge tag 'nfs-for-7.3-1' of git://git.linux-..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12977415580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2d3e2a7997c1d5c
dashboard link: https://syzkaller.appspot.com/bug?extid=d396918a29afb8543e1c
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/725c76492ae5/disk-73e3f071.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b4b32ef07d3c/vmlinux-73e3f071.xz
kernel image: https://storage.googleapis.com/syzbot-assets/afd59682ac03/bzImage-73e3f071.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com

smbdirect: ib_dev[syz2] removed
------------[ cut here ]------------
cq->cqe_used
WARNING: drivers/infiniband/core/cq.c:370 at ib_cq_pool_cleanup+0x248/0x370 drivers/infiniband/core/cq.c:370, CPU#1: kworker/u8:22/17817
Modules linked in:
CPU: 1 UID: 0 PID: 17817 Comm: kworker/u8:22 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
Workqueue: ib-unreg-wq ib_unregister_work
RIP: 0010:ib_cq_pool_cleanup+0x248/0x370 drivers/infiniband/core/cq.c:370
Code: 41 f9 41 83 fe 03 0f 85 01 fe ff ff e8 21 92 41 f9 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f e9 fe b1 06 03 e8 09 92 41 f9 90 <0f> 0b 90 eb 84 e8 3e 76 b4 f9 e9 67 ff ff ff 48 8b 34 24 48 c7 c7
RSP: 0018:ffffc90004bcfac8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff88802e53a580 RSI: ffffffff88ca43e7 RDI: ffff88802e53a580
RBP: ffff888028e1c000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000804 R11: 0000000000000000 R12: ffff888058b09840
R13: ffff88807d614ed0 R14: 0000000000000804 R15: ffff888058b09800
FS:  0000000000000000(0000) GS:ffff888123c6b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efff0e27dac CR3: 000000005a096000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 disable_device+0x161/0x280 drivers/infiniband/core/device.c:1328
 __ib_unregister_device+0x2b4/0x480 drivers/infiniband/core/device.c:1571
 ib_unregister_work+0x19/0x30 drivers/infiniband/core/device.c:1683
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3387
 process_scheduled_works kernel/workqueue.c:3470 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3551
 kthread+0x373/0x450 kernel/kthread.c:436
 ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
