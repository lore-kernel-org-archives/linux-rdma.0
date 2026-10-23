Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792758957;
	b=5J0AU8yFVQJ2A+Z9RL9NMgD8hU9jg/fSPwEpQfCUzeJH1+fDqpC6UcE2F1rKTAOGi2c4
	 OeM0C39qYIHSwrkHiLr4KUWEUbDJmKsxKcRxGxgvtLGfkFdgNpCQKCICbCDJzvrqtphJR
	 VDs8ok9R6hVsiISpbnbpkneQs1KG3pOKwG2Pf8mYCHc3jkTxEawh4NAF78alH/J1jc2Ur
	 TG47UlvZSy3PdWOu148P1gGF2OGiN4flZOxQpRy7omd/hQ6Oc5KwUoIuE/+fobCUFf9Tx
	 dljLGKMeIwkWD0ryCCSg4fbkWSoIdLJTxbo/mxNsnyY9XkIq0eIrJ4Am/Hl7/Y8+Ybw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792758957;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=RgmnbZuXKYWtnIJRvSR+ux3Op+h0Pygq2TggjNldeso=;
	b=LAIOwW9Ubw70JVAi2h5dUkqGM78ln14wBk7xL/tMGkUIizFMl0zzue5ryUHik7NPE1Aw
	 LZID5daleDSWxeNlHkxtuBXzMmL9Bzb1Vqg8spBIssxF9sYrJyJ4txAd7T45s9F6u6L17
	 vCPQECK/vuRsskS4F7xxo2cawO2w9ywCZbHxg2Pn2ZpLIJrUrTxHPT76yQqP3Yj+2KBPi
	 2tsJAffjQoJfEkAgWxmwH55DTWcifkH9ULDP13IvCJOMSqurOlpOmn6cNdwF2i7QO0PGK
	 hygVozz2FoSxEW3D5dZnTNh2R1qdr78nX0IxvcoCDyGIzFTxJmrCKh12LgH2wT/9Puw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F5C606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 12:35:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12F5C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-54dbbf252cdso1293253b6e.2
        for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 05:35:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792758956; x=1793363756;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RgmnbZuXKYWtnIJRvSR+ux3Op+h0Pygq2TggjNldeso=;
        b=V0VJn7wrmz0qh3EDf3b8niFVoPT8RnFln6AdBjME/L/x6yBIYWLl+GxhChjtqy60av
         lBfIhTg5zqKgqt3HvT8gv+bLb2CljQhzoxmZtngfDFAEX7y66Soaw+PpbbGXTgHvaVMJ
         kSWCJDW1Su75RoV04du3XsuDlonnfjPKo05dAPcqExbucGdl3UHHWZ62/NrHoBQv1xIV
         6n5IPiHMZPn2dNKL0c0FWv5EZm75IaLqWFtT0eJ4nuojqpNQkKqDKqxrRHWOyP9LlM+a
         Ej3+Pd7AWy4BjyZZN18xl07TWN2zmNz8hNYps2AHTLRSNuIATTtfeyLV6IeFHHaMUjtb
         cjQQ==
X-Forwarded-Encrypted: i=1; AKwUvBwJnTXguIrbxDwg36YGsv9ekh/zJRU+RuW0traS0tSIRpJz0UkaDDnw6+5RpzlIQz5s6GrhMUj7KPk9@vger.kernel.org
X-Gm-Message-State: AFq9FYKzx4QZuMC6K2w8ip9JhtA/c9NI/Sg9PurIiIfYQBm/dP7gkDkf
	VLsf9Z61BBvPwTrONHBrRFIKoyl7CyLpZ0D2gHFIVviShLhVR+xlPpA5HGL1LnUcbAWkTaq6XEz
	7cuuNeeWEmc+449ezKfkJjqAcRUZOxHm8lbbU0Hr6xPhg3OvZ5L1MOYuwSDg=
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:130a:b0:4e9:cbdd:457d with SMTP id
 5614622812f47-55be85a6243mr1323057b6e.11.1792758956107; Fri, 23 Oct 2026
 05:35:56 -0700 (PDT)
Date: Fri, 23 Oct 2026 05:35:56 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6adb54ac.d1cee5ca.8df35.0007.GAE@google.com>
Subject: [syzbot] [rdma?] WARNING in __rxe_cleanup
From: syzbot <syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com>
To: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	zyjzyj2000@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c03c1a14507d Linux 7.3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1796a621580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c4b098695335c89f
dashboard link: https://syzkaller.appspot.com/bug?extid=fef38133c495aeb48297
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c9d4a36731a6/disk-c03c1a14.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3c00e4e185bb/vmlinux-c03c1a14.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1f95d3156291/bzImage-c03c1a14.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com

------------[ cut here ]------------
!ret
WARNING: drivers/infiniband/sw/rxe/rxe_pool.c:212 at __rxe_cleanup+0x311/0x350 drivers/infiniband/sw/rxe/rxe_pool.c:212, CPU#0: kworker/u8:9/3389
Modules linked in:
CPU: 0 UID: 0 PID: 3389 Comm: kworker/u8:9 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2026
Workqueue: krds_cp_wq#0/0 rds_shutdown_worker
RIP: 0010:__rxe_cleanup+0x311/0x350 drivers/infiniband/sw/rxe/rxe_pool.c:212
Code: f7 be 03 00 00 00 e8 7e 15 e8 fb 40 84 ed 0f 85 26 fe ff ff e9 5b fe ff ff e8 5b 89 cf f8 90 0f 0b 90 eb 09 e8 50 89 cf f8 90 <0f> 0b 90 41 be 92 ff ff ff e9 47 ff ff ff 44 89 f1 80 e1 07 80 c1
RSP: 0018:ffffc9000f2ff6d0 EFLAGS: 00010293
RAX: ffffffff88f888b0 RBX: ffff88807f162250 RCX: ffff888034160000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff917a757f R09: 1ffffffff22f4eaf
R10: dffffc0000000000 R11: fffffbfff22f4eb0 R12: ffff88807e7615a0
R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888123abf000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd5380382c CR3: 000000003558f000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 rxe_destroy_qp+0x74/0x270 drivers/infiniband/sw/rxe/rxe_verbs.c:661
 ib_destroy_qp_user+0x354/0x5a0 drivers/infiniband/core/verbs.c:2182
 ib_destroy_qp include/rdma/ib_verbs.h:4103 [inline]
 rdma_destroy_qp+0xd0/0x250 drivers/infiniband/core/cma.c:1170
 rds_ib_conn_path_shutdown+0x9bd/0x1820 net/rds/ib_cm.c:1113
 rds_conn_shutdown+0x477/0xb20 net/rds/connection.c:440
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
