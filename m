Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793954561;
	b=4zrHse3BEY7vn5H7gQ4RRo+NeNvFRAe3/6OK4vLUs3sFfdcByj/bZSmbr+Mxz55MeQAq
	 A54jLtEZuAEdlJTHLRb1UESbFFb7Sq/Awg0ISe/FJLHuDzaWmn0eytS+Z0WwM0PQE3ycg
	 R/nVFlkHYUqmgJ5w9XfAJ0u3Qa2DsAAGQi3QaoMFlOBusBxhdFuF6DVx2vHoClYMb87E6
	 bdsi3nJhGpxUNDnGg7aPwpThNzf/BjoPu3IXRS/mtKyOi7POG4Fx+yvvAXbdplqDoD5FV
	 xYQxxl1MFYaeiMdCahFF359adzWomp7WdKum+TOy5Bh/MB4BztHVTnmIVY/MEJcDNIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793954561;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=M8yDQ/yIYjf1yjkinMkq3f1GifKllueCDz6yFTcJFC8=;
	b=a+4EWuPDwMRlBnyvg8nIxCaT8AJyqguIHJUE1QUr9L9JXvHJ5x41XEsJPrRzymmN8A1U
	 y2PpKXM1sNd03LN6F47gKgK5qm1EYYpRWuv1k1VOJV/oZlwQy9sJV4jD4vtjoq5DsTHUe
	 YdjSlnnJGWIYCPlwHG+wVtN3r18Ym/tiuM/+V29rV9DgCA6paA4fPuzK3q/2ajifXPmQq
	 l8Cy+UlqT5PNfhG4sTb0vRTn01cPp6WIXjmErxj1TuBSJ+xow6GyM6xxZoh7meFSlFVBW
	 w5ff1BY7+7zbjPCcVKmb0Rhyi81QAfe6ZGtGMlN+X5O9ID9KgUlPYqMHA1Y177qpDGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235C7606A32E
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 08:42:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 235C7606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-85a6d046af0so555077a34.2
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2026 00:42:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793954560; x=1794559360;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=M8yDQ/yIYjf1yjkinMkq3f1GifKllueCDz6yFTcJFC8=;
        b=F4aiZ0s/BugLCuQR9FGhBazu3yyBfMQAGPPOtgNYGjzYyaWlyYkLYucjVMjVZli+9H
         sxnqKsw2zyujjQCr6r22ZapF06QvfwYaW2aQN3cHzzRQrBRc9ZpzFEVNHgllFPjgSqEf
         lPd9G0ZYZpimP5w/VBtcpFFfoTfFcb08Yf8d608m35aM1p/uK25I/k1qdwvLJLMFum/q
         60ue8cqgggkS8OpuK6YvFE18Mo/cfcyEGO415hygqOVncmKak3KV4ak+OrHXtJZ/hqpQ
         xhlH9DN0bUVs2kmRKhPhQr41Vp5D3TgsVuLdzsOaD2EU7jjYx97xbtibkwLZefZ59gel
         a7Cg==
X-Forwarded-Encrypted: i=1; AKwUvBw4Q8GpA4xwgdZZAD/mDldacl+5ubIyrX66WiGKp6CWNRKX6YuzOiY8ByV5b8pyseOm1ER+HqoCv46o@vger.kernel.org
X-Gm-Message-State: APuU4Z8dsazNcuNRQqcvBnL+nhqrc2Z+NMMiipoVSs7gzPa6RR4c135K
	JZtAfETAS1WNXAZ4d4kycWNcyZcMcd6ncmcvIimAgnWX2T9eXLgmGN2DEKdMnC4HbdDbBv+oMD3
	oGYYUIuzxjR6gvgrUzSa2DQrxrEDtp5qsFhS/GH0xHqj5oNe9WnugyBYupZo=
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3097:b0:4b3:7b31:8df7 with SMTP id
 5614622812f47-567e0faab32mr1577450b6e.14.1793954559883; Fri, 06 Nov 2026
 00:42:39 -0800 (PST)
Date: Fri, 06 Nov 2026 00:42:39 -0800
In-Reply-To: <6aec6433.0ce67c00.35143.0002.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aed92ff.a716b02e.a4a62.0000.GAE@google.com>
Subject: Re: [syzbot] [rdma?] [f2fs?] memory leak in radix_tree_insert (3)
From: syzbot <syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com>
To: chao@kernel.org, edwards@nvidia.com, hemanth.selam@gmail.com, 
	jaegeuk@kernel.org, jgg@ziepe.ca, kartikey406@gmail.com, leon@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, michael.j.ruhl@intel.com, mrgolin@amazon.com, 
	syzkaller-bugs@googlegroups.com, yishaih@nvidia.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    d68ce4e71248 Merge tag 'mm-core-7.4-rc2' of git://git.kern..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=1781772d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4361b1bb937ae1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=d60be66dd00b4490fa96
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=169572fd580000

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
unreferenced object 0xffff8881102cb918 (size 576):
  comm "syz.1.20", pid 6842, jiffies 4294945826
  hex dump (first 32 bytes):
    0c 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 ef c5 11 81 88 ff ff 30 b9 2c 10 81 88 ff ff  ........0.,.....
  backtrace (crc c4ea6eb8):
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
unreferenced object 0xffff88811021f488 (size 576):
  comm "syz.1.20", pid 6842, jiffies 4294945826
  hex dump (first 32 bytes):
    06 09 00 00 00 00 00 00 18 b9 2c 10 81 88 ff ff  ..........,.....
    00 ef c5 11 81 88 ff ff a0 f4 21 10 81 88 ff ff  ..........!.....
  backtrace (crc 8219f7d7):
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
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
