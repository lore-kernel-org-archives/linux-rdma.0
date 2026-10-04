Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8792F39CD12
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 01:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791075991; cv=none; b=dSkD6s71LE05uf6B7zjtlx95kMMP78EJWDSvyOxLeHdcIWJdfYchArg32wv9Uspqx0f3toygUqf4q9CAGWQ0t8PP9l4NRH/+KE8aEcSMpn5nYOtrlRrNX6+hMKDbK0PebFwyM4klvCTx4Je305OrJj6WqlfT+c4Gjf13rbDc5rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791075991; c=relaxed/simple;
	bh=DBPueCII86TubAWeqKo024OoAQSv4qhFHq0xFTq6bBA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BY0Hw8/tSTT8TmPrPitHfuJkKzlI/Hkk/ZQ1VGcsZ7xQFDE0e1QRytj71L6HKGDjTlz3PbSSco5bx3um8xpw9bVVIy5Raf0q/SarqRODmGhtv6POx5I9XHt+PR237/68WNg8BKdeoTQypbV2ahsiytoQxyAczjVbajD0efo0JxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4cc89e86e4dso1165334b6e.2
        for <linux-rdma@vger.kernel.org>; Sat, 03 Oct 2026 18:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791075988; x=1791680788;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LtlDrk5XM1TNe6UhnllojCm0xyW0vuqat3D05iyMhkw=;
        b=mndTWM+F5NPADvJkDATFtWQS8pWoh5yiX10OrkdmmVrwJOMfuMTiL61R10I1EDq+nM
         8FNrpP0P/qmoOQ1SGxEUQVtIF9AXBlqdKDatzTrMOUS2EHKBIy18nEqEYC9DZfWeb7Gl
         VqhP/dKoUs2ayiKj8ebBOrRfCeHpBn12zVAZIqTbxQzlPpLNqqpKUkrR6UHLmSqGUV4R
         L2zLGrpg4WCBwDS2ZNVI33Y3TNNKeol/D9qw1MEJ/2DBQCowzOdbpqiPqGxmSW8mhwcQ
         3UzBZIqGzlinLyJ6BgtiLH0kXZ45TNXaXz6eFWrSJZNYNm9rTeWHJAuBGUReeNHGfYCD
         xG1w==
X-Forwarded-Encrypted: i=1; AKwUvByyrzay8S7MoICUWxbUG9oQMShVDqGqMmxVg+xgOV7mm+Kg+Li1ME3xkV5kjMPOoCrqudAkxH+lKSjk@vger.kernel.org
X-Gm-Message-State: AFuF++lM+psMES/hoEbGFG8dLPwC+/24U9dcuLNZf2X/SwOArh5+RU3M
	p54sGCk6xaAk0iuUCcdiWKKbeLWrx4tL68/9KIedpLn8nT2Cc8KOqXVZ/fPjm7B2KcxcoqqCA9y
	n6lQY4FptS7NQomGjZ/iD9w0BFtSv2i1kH5kPyV+aQntjJFquDX/PUzq3BJ4=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1813:b0:4b2:8d7b:41b8 with SMTP id
 5614622812f47-4f529202310mr7161890b6e.18.1791075988605; Sat, 03 Oct 2026
 18:06:28 -0700 (PDT)
Date: Sat, 03 Oct 2026 18:06:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ac1a694.01314a6c.556a8.0002.GAE@google.com>
Subject: [syzbot] [rdma?] KASAN: slab-use-after-free Read in debug_mutex_unlock
From: syzbot <syzbot+ae549381b4daac2895b1@syzkaller.appspotmail.com>
To: jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    48a5a7ab8d6a Merge tag 'v7.2-rc4-smb3-client-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=166922a9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f221a1b5d497ed15
dashboard link: https://syzkaller.appspot.com/bug?extid=ae549381b4daac2895b1
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-48a5a7ab.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f512830db6a9/vmlinux-48a5a7ab.xz
kernel image: https://storage.googleapis.com/syzbot-assets/13bb0e168566/bzImage-48a5a7ab.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ae549381b4daac2895b1@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in debug_mutex_unlock+0x124/0x140 kernel/locking/mutex-debug.c:74
Read of size 8 at addr ffff888024e65418 by task kworker/u33:9/1164

CPU: 1 UID: 0 PID: 1164 Comm: kworker/u33:9 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: ib_addr process_one_req
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x13d/0x4b0 mm/kasan/report.c:482
 kasan_report+0xdf/0x1c0 mm/kasan/report.c:595
 debug_mutex_unlock+0x124/0x140 kernel/locking/mutex-debug.c:74
 __mutex_unlock_slowpath+0x195/0x930 kernel/locking/mutex.c:1031
 addr_handler+0x12d/0x4d0 drivers/infiniband/core/cma.c:3555
 process_one_req+0x127/0x680 drivers/infiniband/core/addr.c:624
 process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
 process_scheduled_works kernel/workqueue.c:3405 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 9271:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x2e5/0x6c0 mm/slub.c:5515
 _kmalloc_noprof include/linux/slab.h:969 [inline]
 _kzalloc_noprof include/linux/slab.h:1290 [inline]
 __rdma_create_id+0x5b/0x8f0 drivers/infiniband/core/cma.c:1016
 rdma_create_user_id+0x7d/0xe0 drivers/infiniband/core/cma.c:1074
 ucma_create_id+0x189/0x380 drivers/infiniband/core/ucma.c:470
 ucma_write+0x1fb/0x330 drivers/infiniband/core/ucma.c:1856
 vfs_write+0x2aa/0x1050 fs/read_write.c:685
 ksys_write+0x1f8/0x250 fs/read_write.c:739
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0xe7/0x970 arch/x86/entry/syscall_32.c:307
 do_fast_syscall_32+0x32/0x70 arch/x86/entry/syscall_32.c:332
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

Freed by task 9270:
 kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2705 [inline]
 slab_free mm/slub.c:6405 [inline]
 kfree+0x22b/0x6c0 mm/slub.c:6720
 ucma_close_id drivers/infiniband/core/ucma.c:188 [inline]
 ucma_destroy_private_ctx+0xb30/0xe90 drivers/infiniband/core/ucma.c:585
 ucma_close+0x1aa/0x240 drivers/infiniband/core/ucma.c:1921
 __fput+0x3ff/0xb50 fs/file_table.c:512
 task_work_run+0x150/0x240 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x1d8/0x6f0 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 __do_fast_syscall_32+0x701/0x970 arch/x86/entry/syscall_32.c:310
 do_fast_syscall_32+0x32/0x70 arch/x86/entry/syscall_32.c:332
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

The buggy address belongs to the object at ffff888024e65000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 1048 bytes inside of
 freed 2048-byte region [ffff888024e65000, ffff888024e65800)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x24e60
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801bc42f00 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801bc42f00 dead000000000100 dead000000000122
head: 0000000000000000 0000000800080008 00000000f5000000 0000000000000000
head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5143, tgid 5143 (klogd), ts 50831000983, free_ts 47183968045
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0xfd/0x120 mm/page_alloc.c:1859
 prep_new_page mm/page_alloc.c:1867 [inline]
 get_page_from_freelist+0xf48/0x3530 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x299/0x2dc0 mm/page_alloc.c:5304
 alloc_slab_page mm/slub.c:3294 [inline]
 allocate_slab mm/slub.c:3408 [inline]
 new_slab+0xa2/0x650 mm/slub.c:3454
 refill_objects+0xe3/0x410 mm/slub.c:7338
 refill_sheaf mm/slub.c:2832 [inline]
 __pcs_replace_empty_main+0x376/0x680 mm/slub.c:4703
 alloc_from_pcs mm/slub.c:4801 [inline]
 slab_alloc_node mm/slub.c:4933 [inline]
 __kmalloc_cache_noprof+0x479/0x6c0 mm/slub.c:5511
 _kmalloc_noprof include/linux/slab.h:969 [inline]
 syslog_print+0xf8/0x620 kernel/printk/printk.c:1585
 do_syslog+0x5bd/0x6d0 kernel/printk/printk.c:1763
 __do_sys_syslog kernel/printk/printk.c:1855 [inline]
 __se_sys_syslog kernel/printk/printk.c:1853 [inline]
 __x64_sys_syslog+0x74/0xb0 kernel/printk/printk.c:1853
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x840 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5656 tgid 5656 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0x79f/0x1090 mm/page_alloc.c:2950
 __folio_put+0x3b4/0x5f0 mm/swap.c:112
 folio_put include/linux/mm.h:2124 [inline]
 put_page include/linux/mm.h:2193 [inline]
 put_netmem include/net/netmem.h:394 [inline]
 skb_page_unref include/linux/skbuff_ref.h:43 [inline]
 __skb_frag_unref include/linux/skbuff_ref.h:56 [inline]
 skb_release_data+0x649/0x8e0 net/core/skbuff.c:1110
 skb_release_all net/core/skbuff.c:1191 [inline]
 __napi_kfree_skb net/core/skbuff.c:1485 [inline]
 kfree_skb_napi_cache net/core/skbuff.c:7286 [inline]
 skb_attempt_defer_free+0x2ed/0x830 net/core/skbuff.c:7319
 tcp_eat_recv_skb net/ipv4/tcp.c:1621 [inline]
 tcp_recvmsg_locked+0x11ed/0x2a30 net/ipv4/tcp.c:2899
 tcp_recvmsg+0x141/0x630 net/ipv4/tcp.c:2944
 inet_recvmsg+0xd5/0x4c0 net/ipv4/af_inet.c:894
 sock_recvmsg_nosec net/socket.c:1126 [inline]
 sock_recvmsg+0x1b8/0x220 net/socket.c:1148
 sock_read_iter+0x2b0/0x3a0 net/socket.c:1217
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x960/0xb40 fs/read_write.c:574
 ksys_read+0x1f8/0x250 fs/read_write.c:716
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x115/0x840 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888024e65300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888024e65380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888024e65400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff888024e65480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888024e65500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


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
