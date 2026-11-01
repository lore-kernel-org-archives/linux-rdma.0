Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793511152;
	b=hndICMnPtgXpGLR9gP/+2yFrdlhYGoIVXqpCbVK45Wg+1j+lYlc/jp6APL5sxIQkC3Ej
	 R/YCs26H0mY+kyE/cXz1Qge1KSWkjEjba6oeuOdfdV1AO/hswDgwV9MxDfq6GADXTXgMi
	 ThiF2vF63yjspq/TUHRaDToEi5zwYIrCDTTiLG2snQpAoGiX1L9/xUSBaiy/xPAT/GA0i
	 O+GH4Uz9rKOLqngy06W9EotSZs2yNifZWmPjUGaiZbGYZLMfTUekdg6eQb1foTN6dfaEa
	 2CS1OmQes2ISIeBZJezIsp5AECy8CF7Hkhc5mM4cF3CCituqM8FA+dml7EMx3kFcx1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793511152;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=DtfoQkKFNHju33US5sxuA85MuGRl6NXBwcxSzKvpS64=;
	b=eY3ridxZ7Zp0b6TEGmh+7C0nGR8WD/aemb2qoXWmhupazWXP5b/9ZvJj2p8Hko8ZSYgD
	 GX8SiZV329KfY2rfDikt9XjZ6nn03gXIY18FaIokNe567KwETmvLAWXuk3e5HVUeiDBHT
	 KFrO97JllM6bELDbhKORtjd/flgHjTTRiXh1v6zI2hMv/RAkl7DKWjifaEcIb3bZCjoDS
	 9T5JsJp3/6/I/QzFzmNTlvgwgoREwTjJ+2y3EqSAqr5Yc4WVOO10bIemnVL1zO+5go92c
	 ry+I3eA6KwnIxGfrilbfSwvlZ3SWJJKiCJlc1dPmLZ60AbSoLifYulaxl9UP2K7s4nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A069D606A324
	for <linux-rdma@vger.kernel.org>; Sun,  1 Nov 2026 05:32:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A069D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-823d73ffca1so3064029a34.2
        for <linux-rdma@vger.kernel.org>; Sat, 31 Oct 2026 22:32:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793511150; x=1794115950;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DtfoQkKFNHju33US5sxuA85MuGRl6NXBwcxSzKvpS64=;
        b=iGnP3TInLMpapTrjfVClIw7ke+h15+xtK2YK1/spPi4PDtmfhd3OdK8B+EV6n4GIbH
         9csTdxFlqNJyecmKCp/OM1uvOe8I5H2o/3UCkhBatXlqpnsOoi7gVf8xkgFIBljKBMwg
         t5b2WTwDLt0CrxQ4iPRxCWDpGeaOClTWmsGheFIrTvYTX02+Q5mCY/vmxVq3RyzZUX2A
         HTrcHlE+jU+JOkGD3v/Aa7ZpipW0J0PQwzgEjhYnJ7amAsWEG+z5IpQxpFljeE9JeH1Z
         +xWWj/kwcQwjcw8NcRbvL7uU/yX4cmcaNtjaibYXji/ewy8hLPlEPVDKUhhz16b7N2rn
         fr7w==
X-Forwarded-Encrypted: i=1; AKwUvBwOQwXhIRgxSPBbzT/CL3AbOwtA16vCQ4OWjK/w5EL74cFnyuKG90Sk131mhaYdIgTyhpKpkafaKLxB@vger.kernel.org
X-Gm-Message-State: AFq9FYIR1+I5zv2TLDtKvaDGajSWD/G7rYYI0c6yMogvgJdeQqkuivWF
	7V2vqrWkSNfjCo3AzcQyrxidYZBwnQeK5DRGeEP61/BEufdEJbEMOdBPhxd/XB5+wYBQ7j/XQzV
	Ic6ZyW+Vb8WQ/TaGssHuscSLkbyIPhP7qqjSV9Lws9r5hiplvFJk1x33WqaU=
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f13:b0:4f4:813c:6a21 with SMTP id
 5614622812f47-5640dcb87admr4413209b6e.20.1793511150467; Sat, 31 Oct 2026
 22:32:30 -0700 (PDT)
Date: Sat, 31 Oct 2026 22:32:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae6ceee.67782f90.13afb0.0053.GAE@google.com>
Subject: [syzbot] [rdma?] WARNING in rdma_resolve_addr
From: syzbot <syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    36aad21d50d1 Merge tag 'ksmbd-for-7.4-rc1-part2' of git://..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1364b795580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37ec6334ca3b8e94
dashboard link: https://syzkaller.appspot.com/bug?extid=6699995b421c8ec7d2fe
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1752b159580000

AI-generated root cause summary:
A race condition exists in resolve_prepare_src() in
drivers/infiniband/core/cma.c when binding an address during
rdma_resolve_addr(). Calling cma_bind_addr() transitions id_priv->state to
RDMA_CM_ADDR_BOUND and attaches id_priv to cma_dev->id_list, exposing it to
concurrent device removal via cma_process_remove() /
cma_send_device_removal_put(), which sets id_priv->state to
RDMA_CM_DEVICE_REMOVAL. When this occurs before resolve_prepare_src() executes
cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY), the state check
fails and triggers a false-positive WARN_ON(), returning -EINVAL which is
handled cleanly by callers without memory corruption or DoS.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=6699995b421c8ec7d2fe

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com

------------[ cut here ]------------
!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY)
WARNING: drivers/infiniband/core/cma.c:4120 at resolve_prepare_src drivers/infiniband/core/cma.c:4120 [inline], CPU#1: kworker/u8:8/1176
WARNING: drivers/infiniband/core/cma.c:4120 at rdma_resolve_addr+0x3f1/0x20e0 drivers/infiniband/core/cma.c:4146, CPU#1: kworker/u8:8/1176
Modules linked in:
CPU: 1 UID: 0 PID: 1176 Comm: kworker/u8:8 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/05/2026
Workqueue: krds_cp_wq#43/0 rds_connect_worker
RIP: 0010:resolve_prepare_src drivers/infiniband/core/cma.c:4120 [inline]
RIP: 0010:rdma_resolve_addr+0x3f1/0x20e0 drivers/infiniband/core/cma.c:4146
Code: 02 00 00 44 89 f6 e8 3e f2 14 f9 41 83 fe 07 0f 84 09 07 00 00 e8 bf f7 14 f9 48 8b bd 18 ff ff ff 48 89 de e8 10 3f f7 02 90 <0f> 0b 90 bb ea ff ff ff e9 57 fd ff ff e8 9d f7 14 f9 49 8d 7c 24
RSP: 0018:ffffc900052ff8b0 EFLAGS: 00010286
RAX: 8000000000000001 RBX: 0000000000000293 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff8e6277e2 RDI: 0000000000000001
RBP: ffffc900052ffa00 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffffc900052ffb00
R13: 0000000000001388 R14: 0000000000000009 R15: ffffc900052ffa60
FS:  0000000000000000(0000) GS:ffff88812257f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000560c3d47e9f8 CR3: 0000000020ebc000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 rds_ib_conn_path_connect+0x415/0x5d0 net/rds/ib_cm.c:1044
 rds_connect_worker+0x1b4/0x2d0 net/rds/threads.c:176
 process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495
 process_scheduled_works kernel/workqueue.c:3578 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3659
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
