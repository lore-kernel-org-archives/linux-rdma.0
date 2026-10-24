Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792812725;
	b=quqWSNwpyvXPe+W2dkassMma1eW42HXIWvXPKuVUDAftHeiWtdp4ADcSKxCSzQTSMkPL
	 lTgxzfCIFVbDibwyF+Kx5b4PIrRY7XAQ7BVHHudJmUTr6d3WPNfzMD8SfZB0H3UqOzUFZ
	 i9as9Fow+eEmSISiQfRUHFj7rG00FkfA7/knbC8nRvuecPLZMLWmnF/EOnstIsM1wScZx
	 2d4RTXr/kf36jzRapefC8a/szztgCtNch0/3psq8NNiExTGlaDzEFeTKrcX5yL+OQDlPX
	 +Hw3UA1NJViafJIDhKwdcyypEfMlrfcz6pj4yu1vJug4wADCHzIFj59zP94jdH3Kxfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812725;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=TRDvZq2SHT+aDt9EJj+nR03z379cD3vR6Hr6yZB6kOw=;
	b=e8zk6QIorm46gN7IUrm+lZ7R9DHuft9aP1kOEsXKXjd16Fiexz1RLxTUE+jUf4PGGgKI
	 8EiO2yTHFvsteRAopWt44uiy3H9/pnqQlSxnm6N/U05M2YG6AD+vVh9xn6T7ltmAJCxWz
	 O2p5/KX3uPEiyKUc3b1uvadLd5A4K32yz9WhRTTnSjhXMRfg7KblJ9FtRnKDHwuyr8eC9
	 Go899vwaWozdgs7WQIQLfdMxI8Yx9awgA+HguIy0lpf+MQrV/0/41iknWNUEjXZD52pOF
	 cIVvJR+TEFg3/DPSmU7YvcRenuWWoc4mCb+VZBVMmmGSoBjeThNA1UKXP8J5F9wCiyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NvooyQwj;
	arc=none smtp.remote-ip=91.218.175.13
Received: from mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D1D606A31B
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 03:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36D1D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NvooyQwj
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qpsR5uNxn2W8gPQgV5MSbXHu1Mv18oSF9sQu+dRz/54=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792812721; v=1; x=1793417521;
 b=NvooyQwje/UxBd91HWR/lP9HoazFTS37n2Yp4l9I+g2LU2D+ElLonblKGpC1pIGbbakcEcOm
 YKjO965SULozUJb7r1bb3JG5zuq18lWVRMXef90SJWicU5pGTs6myLSRYmPQtwUwAKEbULdv/Nz
 tTg0o2eow0utClftEarJGfCU=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 18b050aee73788f3;
	Sat, 24 Oct 2026 03:32:00 +0000
X-Mizu-Trace-ID: 18b050aee73788f3
X-Migadu-Flow: FLOW_OUT
Message-ID: <5da8af66-b180-4bea-8851-273b669f1a3c@linux.dev>
Date: Fri, 23 Oct 2026 20:31:54 -0700
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [rdma?] WARNING in __rxe_cleanup
To: syzbot <syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com>,
 jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 zyjzyj2000@gmail.com, "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
References: <6adb54ac.d1cee5ca.8df35.0007.GAE@google.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <6adb54ac.d1cee5ca.8df35.0007.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/10/23 5:35, syzbot 写道:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c03c1a14507d Linux 7.3
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1796a621580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c4b098695335c89f
> dashboard link: https://syzkaller.appspot.com/bug?extid=fef38133c495aeb48297
> compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c9d4a36731a6/disk-c03c1a14.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/3c00e4e185bb/vmlinux-c03c1a14.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/1f95d3156291/bzImage-c03c1a14.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> !ret
> WARNING: drivers/infiniband/sw/rxe/rxe_pool.c:212 at __rxe_cleanup+0x311/0x350 drivers/infiniband/sw/rxe/rxe_pool.c:212, CPU#0: kworker/u8:9/3389
> Modules linked in:
> CPU: 0 UID: 0 PID: 3389 Comm: kworker/u8:9 Tainted: G             L      syzkaller #0 PREEMPT(full)
> Tainted: [L]=SOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2026
> Workqueue: krds_cp_wq#0/0 rds_shutdown_worker
> RIP: 0010:__rxe_cleanup+0x311/0x350 drivers/infiniband/sw/rxe/rxe_pool.c:212

Hi,

Looking at the stack trace and rxe_pool.c:212:

203     if (sleepable) {
204         if (!completion_done(&elem->complete)) {
205             ret = wait_for_completion_timeout(&elem->complete,
206                     msecs_to_jiffies(50000));
207
208             /* Shouldn't happen. There are still references to
209              * the object but, rather than deadlock, free the
210              * object or pass back to rdma-core.
211              */
212             if (WARN_ON(!ret))
213                 err = -ETIMEDOUT;
214         }
215     }

The WARNING triggers because __rxe_cleanup() timed out waiting 50s for 
the QP reference count to drop to zero during destruction.

This indicates an unreleased QP reference leak on the upper layer side 
(RDS) during connection teardown (rds_shutdown_worker -> 
rds_ib_conn_path_shutdown).

While RXE forces object cleanup after 50 seconds to prevent a deadlock, 
the root cause lies in net/rds failing to drop all held QP references 
prior to calling rdma_destroy_qp(). This needs to be addressed on the 
RDS layer.

Thanks.

Yanjun Zhu

> Code: f7 be 03 00 00 00 e8 7e 15 e8 fb 40 84 ed 0f 85 26 fe ff ff e9 5b fe ff ff e8 5b 89 cf f8 90 0f 0b 90 eb 09 e8 50 89 cf f8 90 <0f> 0b 90 41 be 92 ff ff ff e9 47 ff ff ff 44 89 f1 80 e1 07 80 c1
> RSP: 0018:ffffc9000f2ff6d0 EFLAGS: 00010293
> RAX: ffffffff88f888b0 RBX: ffff88807f162250 RCX: ffff888034160000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffffffff917a757f R09: 1ffffffff22f4eaf
> R10: dffffc0000000000 R11: fffffbfff22f4eb0 R12: ffff88807e7615a0
> R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff888123abf000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd5380382c CR3: 000000003558f000 CR4: 0000000000350ef0
> Call Trace:
>   <TASK>
>   rxe_destroy_qp+0x74/0x270 drivers/infiniband/sw/rxe/rxe_verbs.c:661
>   ib_destroy_qp_user+0x354/0x5a0 drivers/infiniband/core/verbs.c:2182
>   ib_destroy_qp include/rdma/ib_verbs.h:4103 [inline]
>   rdma_destroy_qp+0xd0/0x250 drivers/infiniband/core/cma.c:1170
>   rds_ib_conn_path_shutdown+0x9bd/0x1820 net/rds/ib_cm.c:1113
>   rds_conn_shutdown+0x477/0xb20 net/rds/connection.c:440
>   process_one_work kernel/workqueue.c:3396 [inline]
>   process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
>   worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
>   kthread+0x38b/0x480 kernel/kthread.c:436
>   ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>   </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

