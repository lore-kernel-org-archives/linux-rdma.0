Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793877044;
	b=rxvb++mqr39pKUknrz1PkR6ksWRcXxgc3WbgNIwDqYKu8HvjE+UX0wSC1djeuTbeBpSi
	 Br/V2AWSZc2BE+bbiJw7q2CzIFb0Nq2cOhfZJVoePwVeRE6+fyA4IQ7LX28MHJPvBVN56
	 GEQsBI+L1aTu3pcSp+5kdDLFTInkARCmrF2Vrrys/FjYPXNlPrKSGAHZWne3oEqNfvnqb
	 UHr+5TNKe4CzUFRsPC8VvJYUh5y3nmuC8Egipo5aYrpMcNQJQuyD3Zcz6c6C/zUZLzJjC
	 NyWT6XPpu0mzFaUu9WZtnaQNKS43/j0LjjkHphxEkWHpHFMUU5fR3vTzB5OyECokwQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793877044;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=QOIwjIRpeVDqlXAgbw2FLrO0KLt63dq5HpsWbh7v4l4=;
	b=YbAZ8oiopKV/elSh00xjyZlcqCRHu6F5x+JpyjpOXLrZxuCja/AjwEV5HLwaFgfiNRYi
	 UO+lceRHU6GbiEtes3NWdtkdIJGLTrq5nGWOK0/PQYxenvCJLnqtVNWmyYFMtSv2+sQ/4
	 8DItLuVEXxQYQlaSlGTNc+jxiFwCaS8GKCXRQWzNXQxbjiPUlX/Wua5EUTDuZDkDzSbat
	 PsC6IF6Bt+McD3A++JmJ1ZKutzPKhDXrFFULNDg/YTPGt5p5SRxCUdh8NjhjERJ8rAF77
	 NWHfdHT3Gg+2sQVAqV+tv73OENOS7g06hYJD5dPQ/5Hh50ba5In/il3Jwtj79R6Kj3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5006C606A329
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 11:10:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5006C606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-5641cd2cc13so1868299b6e.0
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 03:10:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793877043; x=1794481843;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QOIwjIRpeVDqlXAgbw2FLrO0KLt63dq5HpsWbh7v4l4=;
        b=xw9mNaNzT6OevcGFvJShOj+zj+gou9I2/mHePX7nX4p4u3+nMGJGOD/y0qZMvONlYh
         RWRuLoT2mgba7jZX0Gn+nymL+1FALAN5/fasnRRvnOKY/aLQPFazMomE0f6uV2wHTc47
         is9u8lnowoX6ejxaoq1j28GMwcfbfiDSWfEGKYxWl/HHtpRxgyngPZ/GuHMPD2GwebBs
         rpfmqw9Lm6oUAK2si8eD0zJFrqm50ZG2gRFIi/LqCIo11bAShu/hfaQgYBPDpKqkD9OT
         +bfvLl6vi6KhU7PPRPg8Ep3sbrBIwtcIg4o0Vuyzwy4fc3P3cBek52Yq3Di5Buai3Bfj
         eL6g==
X-Forwarded-Encrypted: i=1; AKwUvBz4Oikh+1V4cy2kin2yifgG9CfZ3IJ+Uj7o9GyFweQtnMOz6Oui+7JvHmk2kxlPYXGIoaPT2JxL83tY@vger.kernel.org
X-Gm-Message-State: APuU4Z8cVTr4xqQTN6wCyz+6jXt/tic7vYYts0hbfXodxhV7dEnSkZjE
	KZQmW4XeaT2cv+IwgrssMQ6tHKpZccIKC1stf3Y/tSKFuErdVrnxYeDx2T9YF7zNerOGdiMFAUG
	2DbfTqUfL3i8+7Pm1t4Um9039MxAfi86iDKx4a8Gey0ZWATzyO8twSCMfdpE=
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1783:b0:4fb:ac9b:b06a with SMTP id
 5614622812f47-5640de0fc9emr14499827b6e.48.1793877043501; Thu, 05 Nov 2026
 03:10:43 -0800 (PST)
Date: Thu, 05 Nov 2026 03:10:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aec6433.0ce67c00.35143.0002.GAE@google.com>
Subject: [syzbot] [rdma?] [f2fs?] memory leak in radix_tree_insert (3)
From: syzbot <syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com>
To: chao@kernel.org, jaegeuk@kernel.org, jgg@ziepe.ca, leon@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6628e7d4c6b2 Linux 7.4-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=149fc6b1580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=441b6cc593d83cc4
dashboard link: https://syzkaller.appspot.com/bug?extid=d60be66dd00b4490fa96
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1613be2d580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bd1857dac9bc/disk-6628e7d4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0750834263ca/vmlinux-6628e7d4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ef4090776a72/bzImage-6628e7d4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/b8af1c9e7f1c/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=16e69cdd580000)

AI-generated root cause summary:
In lib/radix-tree.c:__radix_tree_create(), intermediate radix_tree_node
(xa_node) structures are allocated and linked into parent slots as the function
descends through tree levels (shift -= RADIX_TREE_MAP_SHIFT). If a subsequent
node allocation fails with -ENOMEM before reaching the leaf slot,
__radix_tree_create() returns the error immediately without unwinding or
deleting the newly allocated empty intermediate nodes. Consequently, slot-based
iterators such as radix_tree_for_each_slot() used during cleanup (e.g. in
uverbs_destroy_api() -> uapi_remove_range()) never encounter the empty nodes
(which have count == 0), causing those radix_tree_node objects to leak when the
containing object is destroyed.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=d60be66dd00b4490fa96

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com

BUG: memory leak
unreferenced object 0xffff88810d78f488 (size 576):
  comm "syz.1.32", pid 7505, jiffies 4294948085
  hex dump (first 32 bytes):
    0c 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    40 e5 f3 11 81 88 ff ff a0 f4 78 0d 81 88 ff ff  @.........x.....
  backtrace (crc d8883653):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    kmem_cache_alloc_noprof+0x35b/0x3e0 mm/slub.c:5047
    radix_tree_node_alloc.constprop.0+0x81/0x1a0 lib/radix-tree.c:276
    __radix_tree_create lib/radix-tree.c:624 [inline]
    radix_tree_insert+0x140/0x390 lib/radix-tree.c:712
    uapi_add_elm drivers/infiniband/core/uverbs_uapi.c:27 [inline]
    uapi_add_elm drivers/infiniband/core/uverbs_uapi.c:16 [inline]
    uapi_add_get_elm+0x61/0x140 drivers/infiniband/core/uverbs_uapi.c:41
    uapi_merge_obj_tree drivers/infiniband/core/uverbs_uapi.c:178 [inline]
    uapi_merge_def+0x4c4/0xb60 drivers/infiniband/core/uverbs_uapi.c:297
    uapi_merge_def+0xf0/0xb60 drivers/infiniband/core/uverbs_uapi.c:286
    uverbs_alloc_api+0x85/0xc50 drivers/infiniband/core/uverbs_uapi.c:659
    ib_uverbs_create_uapi drivers/infiniband/core/uverbs_main.c:1140 [inline]
    ib_uverbs_add_one+0x1b1/0x350 drivers/infiniband/core/uverbs_main.c:1196
    add_client_context+0x290/0x480 drivers/infiniband/core/device.c:755
    enable_device_and_get+0x106/0x250 drivers/infiniband/core/device.c:1375
    ib_register_device drivers/infiniband/core/device.c:1503 [inline]
    ib_register_device+0x4fe/0x7f0 drivers/infiniband/core/device.c:1441
    siw_device_register drivers/infiniband/sw/siw/siw_main.c:71 [inline]
    siw_newlink drivers/infiniband/sw/siw/siw_main.c:433 [inline]
    siw_newlink+0x36a/0x3f0 drivers/infiniband/sw/siw/siw_main.c:415
    nldev_newlink+0x26f/0x3e0 drivers/infiniband/core/nldev.c:1859
    rdma_nl_rcv_msg+0x1ad/0x2d0 drivers/infiniband/core/netlink.c:195
    rdma_nl_rcv_skb.constprop.0.isra.0+0x175/0x1f0 drivers/infiniband/core/netlink.c:239
    netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
    netlink_unicast+0x3e0/0x530 net/netlink/af_netlink.c:1361

BUG: memory leak
unreferenced object 0xffff88810d792920 (size 576):
  comm "syz.1.32", pid 7505, jiffies 4294948085
  hex dump (first 32 bytes):
    06 09 00 00 00 00 00 00 88 f4 78 0d 81 88 ff ff  ..........x.....
    40 e5 f3 11 81 88 ff ff 38 29 79 0d 81 88 ff ff  @.......8)y.....
  backtrace (crc 415aa5b6):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4733 [inline]
    slab_alloc_node mm/slub.c:5033 [inline]
    kmem_cache_alloc_noprof+0x35b/0x3e0 mm/slub.c:5047
    radix_tree_node_alloc.constprop.0+0x81/0x1a0 lib/radix-tree.c:276
    __radix_tree_create lib/radix-tree.c:624 [inline]
    radix_tree_insert+0x140/0x390 lib/radix-tree.c:712
    uapi_add_elm drivers/infiniband/core/uverbs_uapi.c:27 [inline]
    uapi_add_elm drivers/infiniband/core/uverbs_uapi.c:16 [inline]
    uapi_add_get_elm+0x61/0x140 drivers/infiniband/core/uverbs_uapi.c:41
    uapi_merge_obj_tree drivers/infiniband/core/uverbs_uapi.c:178 [inline]
    uapi_merge_def+0x4c4/0xb60 drivers/infiniband/core/uverbs_uapi.c:297
    uapi_merge_def+0xf0/0xb60 drivers/infiniband/core/uverbs_uapi.c:286
    uverbs_alloc_api+0x85/0xc50 drivers/infiniband/core/uverbs_uapi.c:659
    ib_uverbs_create_uapi drivers/infiniband/core/uverbs_main.c:1140 [inline]
    ib_uverbs_add_one+0x1b1/0x350 drivers/infiniband/core/uverbs_main.c:1196
    add_client_context+0x290/0x480 drivers/infiniband/core/device.c:755
    enable_device_and_get+0x106/0x250 drivers/infiniband/core/device.c:1375
    ib_register_device drivers/infiniband/core/device.c:1503 [inline]
    ib_register_device+0x4fe/0x7f0 drivers/infiniband/core/device.c:1441
    siw_device_register drivers/infiniband/sw/siw/siw_main.c:71 [inline]
    siw_newlink drivers/infiniband/sw/siw/siw_main.c:433 [inline]
    siw_newlink+0x36a/0x3f0 drivers/infiniband/sw/siw/siw_main.c:415
    nldev_newlink+0x26f/0x3e0 drivers/infiniband/core/nldev.c:1859
    rdma_nl_rcv_msg+0x1ad/0x2d0 drivers/infiniband/core/netlink.c:195
    rdma_nl_rcv_skb.constprop.0.isra.0+0x175/0x1f0 drivers/infiniband/core/netlink.c:239
    netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
    netlink_unicast+0x3e0/0x530 net/netlink/af_netlink.c:1361

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


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
