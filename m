Received: from mail-oo2-f6.google.com (mail-oo2-f6.google.com [74.125.231.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF33E2EB10
	for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2026 00:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788308614; cv=none; b=pA+mmwqYGuhVbkhFMNSyJT7gTJu7ETuRvSTnvq2zgtpCeQN4lZ1i7c06Yl9d4oTn6Ruo3LpeZyBJqOEMg88N1dXwAm2KE6TB08rU1YNbUUrAyN6qYQrAq2YLQNofzNXPZ92C5Rt3Vh45F8KA0WPKzaQOG21dcSSVvdtsLGUV+us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788308614; c=relaxed/simple;
	bh=/y6NWVFREyIb7dyi4XE6+zQbOzqGko5Ub0NX5ovQpYY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cYpY1dX9XfPCUH48DYQjNnVa6bZbwgK+wwcfrxFaRqUOlYp5U2MP+AN4NU0j6y/B29GBZG45GM5BqguCn8uFECc9O2tfae9bUC6/AEJczPLfcexJNQMKKTFluUMqg/8Y5kbB/U5pwQAayKizFstZOx1oDLOv4SodARhk3K3z3Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo2-f6.google.com with SMTP id 006d021491bc7-6aafac56856so112214eaf.1
        for <linux-rdma@vger.kernel.org>; Tue, 01 Sep 2026 17:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788308611; x=1788913411;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8JSmnxQApi8XjQdw22ipTDSC+e2v8+0n5C7epgLYDig=;
        b=m1nv49rJvZKGIS7J9LhGgXzV44D//WkI58dOQmP6bvFIEnpx6b1prvI1PpmPWuIhwb
         VwlplKAnsIUpDQfxQW1rt36f5Kne6o2R/SWg750hk5eipKkVDzCSuihXYfkFtigShQuV
         93RTFMdLVoqKQ2Y52RtjNCjMhbY8JfIJouWftcNH1kVz7XwloiJs/D0GLAS9Ch65N8TZ
         eQ6kaDHQnhEnAHGtv4Yu61IeiZ8o3+gpTElP6OTzWoPmDCEOd9/JjCrt5UJX+o7U3Dbg
         Dae1jLAmGBXv8hFXHnzrgl+6FW9j9WJ3Y0WCTXXumBb+DYBQKjTO2iXka7QM9lEnC8DC
         ycCA==
X-Forwarded-Encrypted: i=1; AHgh+RrZU7x681xGWze+8G0k5Uw+7Iey4NRKapCVO4r7sDGtl1niXkLTDHdhw0F3kfnQPfalB/w8+igtvb2S@vger.kernel.org
X-Gm-Message-State: AFuF++kZWOZYoROSVMc48C35w8aqIjsvEI2+BC9XrfcDCye9UcGK35nn
	za/NonEDnxJcFXMSTtUexBGriKuloKAYQutVGYiFvgow6x4E0znEa5M0xmkn7tr9/gsALkJlXBI
	mEO4X1usnKxk97Hc9GWfqh2znUUW7w/10JInqX+5mn3rUdcVWal0os8JOKIs=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:161e:b0:6ac:b178:97f9 with SMTP id
 006d021491bc7-6b48193f585mr620743eaf.31.1788308611663; Tue, 01 Sep 2026
 17:23:31 -0700 (PDT)
Date: Tue, 01 Sep 2026 17:23:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a976c83.9266084e.bf0d7.0003.GAE@google.com>
Subject: [syzbot] [rdma?] WARNING: refcount bug in iwpm_find_nlmsg_request
From: syzbot <syzbot+bd317784d628820741b5@syzkaller.appspotmail.com>
To: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    548e7bcd0c54 Merge tag 'ceph-for-7.3-rc1' of https://githu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11644c15580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=85bc5cc2fc7394d9
dashboard link: https://syzkaller.appspot.com/bug?extid=bd317784d628820741b5
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-548e7bcd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/33981fd8947d/vmlinux-548e7bcd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d17bd4bd3299/bzImage-548e7bcd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bd317784d628820741b5@syzkaller.appspotmail.com

netlink: 16 bytes leftover after parsing attributes in process `syz.2.3511'.
iwpm_mapping_error_cb: Received msg seq = 0 err code = 5 client = 2
------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x111/0x130 lib/refcount.c:25, CPU#0: syz.2.3511/18531
Modules linked in:
CPU: 0 UID: 0 PID: 18531 Comm: syz.2.3511 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:refcount_warn_saturate+0x111/0x130 lib/refcount.c:25
Code: 06 e8 53 6d e3 fc 48 8d 3d dc 53 28 0c 67 48 0f b9 3a e8 42 6d e3 fc 5b 5d c3 cc cc cc cc e8 36 6d e3 fc 48 8d 3d cf 53 28 0c <67> 48 0f b9 3a e8 25 6d e3 fc 5b 5d e9 ce 8f a8 06 48 89 df e8 46
RSP: 0000:ffffc90007ddf448 EFLAGS: 00010087
RAX: 0000000000001c55 RBX: ffff888024890878 RCX: ffffc9000c001000
RDX: 0000000000080000 RSI: ffffffff8527c5fa RDI: ffffffff915019d0
RBP: 0000000000000002 R08: 0000000000000005 R09: 0000000000000004
R10: 0000000000000002 R11: 000000000000001f R12: ffff888024890878
R13: dffffc0000000000 R14: 0000000000000283 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888096968000(0063) knlGS:00000000f5456b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000f73d8568 CR3: 00000000774e3000 CR4: 0000000000352ef0
DR0: 0000000000000009 DR1: 0000000000000009 DR2: 0000000000000003
DR3: 0000000000000008 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:289 [inline]
 __refcount_inc include/linux/refcount.h:366 [inline]
 refcount_inc include/linux/refcount.h:383 [inline]
 kref_get include/linux/kref.h:45 [inline]
 iwpm_find_nlmsg_request+0x13d/0x160 drivers/infiniband/core/iwpm_util.c:360
 iwpm_mapping_error_cb.cold+0x97/0x277 drivers/infiniband/core/iwpm_msg.c:794
 netlink_dump+0x532/0xd00 net/netlink/af_netlink.c:2331
 __netlink_dump_start+0x6d6/0x990 net/netlink/af_netlink.c:2446
 netlink_dump_start include/linux/netlink.h:341 [inline]
 rdma_nl_rcv_msg+0x568/0x6f0 drivers/infiniband/core/netlink.c:190
 rdma_nl_rcv_skb.constprop.0.isra.0+0x2cb/0x410 drivers/infiniband/core/netlink.c:239
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x585/0x850 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x8b0/0xda0 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:800 [inline]
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0xa4d/0xbe0 net/socket.c:2713
 ___sys_sendmsg+0x190/0x1e0 net/socket.c:2767
 __sys_sendmsg+0x160/0x210 net/socket.c:2799
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:79 [inline]
 __do_fast_syscall_32+0x13a/0x8b0 arch/x86/entry/syscall_32.c:291
 do_fast_syscall_32+0x32/0x70 arch/x86/entry/syscall_32.c:316
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf7f94fec
Code: Unable to access opcode bytes at 0xf7f94fc2.
RSP: 002b:00000000f545650c EFLAGS: 00000292 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 0000000080000100
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	e8 53 6d e3 fc       	call   0xfce36d58
   5:	48 8d 3d dc 53 28 0c 	lea    0xc2853dc(%rip),%rdi        # 0xc2853e8
   c:	67 48 0f b9 3a       	ud1    (%edx),%rdi
  11:	e8 42 6d e3 fc       	call   0xfce36d58
  16:	5b                   	pop    %rbx
  17:	5d                   	pop    %rbp
  18:	c3                   	ret
  19:	cc                   	int3
  1a:	cc                   	int3
  1b:	cc                   	int3
  1c:	cc                   	int3
  1d:	e8 36 6d e3 fc       	call   0xfce36d58
  22:	48 8d 3d cf 53 28 0c 	lea    0xc2853cf(%rip),%rdi        # 0xc2853f8
* 29:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2e:	e8 25 6d e3 fc       	call   0xfce36d58
  33:	5b                   	pop    %rbx
  34:	5d                   	pop    %rbp
  35:	e9 ce 8f a8 06       	jmp    0x6a89008
  3a:	48 89 df             	mov    %rbx,%rdi
  3d:	e8                   	.byte 0xe8
  3e:	46                   	rex.RX


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
