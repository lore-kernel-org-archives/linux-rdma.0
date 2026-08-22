Received: from mail-oi2-f1.google.com (mail-oi2-f1.google.com [74.125.231.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB0531F9B9
	for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 22:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787439394; cv=none; b=ocFwL+nQrMsDCI09E6l/Mt7zrHLdnfUL3tVgrkKvKwmI/G7B0A9OxQupQ8PGKk5BV9qY9IPTAArrxENGX9y9xgysrr5pR6c//M0l5OgS4ZOuZVqvZTGbjjOthT8BjjnIfb7qKMqrnBP+IoBTJ2kRInhSF4OWa/HknnKCuYtlaVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787439394; c=relaxed/simple;
	bh=TQcHSOe/R3yrN48PDXxH7O4Wi0nUygbPOQMVsYjLRoM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QoIEHe/ClL3diESaFK8xGqTCNWlu9djZIEC1mdVWU/hpAFaTKWKhDV6FuDJzoMKtXZ7pP/1SniSR/xbHwMlTCUz3WdhONzSNS7K4HNQuMC4Y5W/2LgAhw/q7rhbib0J5luf/KG+SxA5Yz2m93lNvjYt81EIpHSQh6XlslAqr0ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f1.google.com with SMTP id 5614622812f47-4960b753d6fso841025b6e.0
        for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 15:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787439392; x=1788044192;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6UAAy5zuHWHazDW8LHIKW/+RB4gab80h9C4J32f7yDY=;
        b=GpAqUIgNRlfpsrJpYWDdN2uVB5sqgfpxxHibc8xOixOhbFFY33bt0AWHVYd/wb5pXm
         /oTT7RfuNnhUGkRPQsdgjiMNuywBJn4KHY5pBcDw1TxI3d1y+yQegxQQcQoLppxYyfT9
         yLD/QVM9O3IW8x6EtZI/g/Y4pYSZChoqEiVDn7WjwsKFf1CRGz3/75rI+lYc0FOsVNGZ
         ++E/8WycqmranERijQgk1DExqJAZJi+dIizYf+KwW80hFF+WMR86yWpfBvSzwag3pgUb
         /CweTFOi24ctDBj7G8pe+7ofhoEywTwyaMfUmHz4Ab55asoV/qIzk9itNno36xF/sAuk
         3aSg==
X-Forwarded-Encrypted: i=1; AHgh+RpEpyreHAFgXO9GIQNrQFlGYBsOY2MOzmtD5WpdWsJ2vzIWAumb2bCZx18uG6Y+p6/tcfcmRRCfvwn4@vger.kernel.org
X-Gm-Message-State: AFuF++l6a7/ml6Ob+rG+qwftivocb92sSQoP4/CsZxQQW2pAGdXYPdfN
	XRh6qQXcwsWCHmPISQlLoLH4JSMaYY7PlhPAUzjJi4XT09rxUWl9vq/toFzes0Gt/zwZ/qIBdgV
	WzSq8N6nYV3rUO/aApfmufI+2wKbxglrlK6XWx81iL5gLIX8xtZ50YzHXiIQ=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:10d6:b0:487:530f:5754 with SMTP id
 5614622812f47-4b2ef571690mr16781390b6e.20.1787439391964; Sat, 22 Aug 2026
 15:56:31 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:56:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8a291f.dbb3a75c.13dd47.0037.GAE@google.com>
Subject: [syzbot] [rdma?] KASAN: null-ptr-deref Read in trace_event_raw_event_rtrs_clt_conn_class
From: syzbot <syzbot+1695193198994f4e7fed@syzkaller.appspotmail.com>
To: haris.iqbal@ionos.com, jgg@ziepe.ca, jinpu.wang@ionos.com, leon@kernel.org, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    21d6ac051080 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=13e45549580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d1128bc53f2ef7f3
dashboard link: https://syzkaller.appspot.com/bug?extid=1695193198994f4e7fed
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=146f8625580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f7c415580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/88380e2ddcb9/disk-21d6ac05.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5dba5c2896b7/vmlinux-21d6ac05.xz
kernel image: https://storage.googleapis.com/syzbot-assets/52ac739e37e0/Image-21d6ac05.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1695193198994f4e7fed@syzkaller.appspotmail.com

rtrs_client L2098: <s1>: Failed to resolve address, err: -ENODEV
rtrs_client L2641: <s1>: init_conns() failed: err=-ENODEV path=<invalid address family>@ip:127.0.0.1 [:0]
==================================================================
BUG: KASAN: null-ptr-deref in do_trace_event_raw_event_rtrs_clt_conn_class drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h:58 [inline]
BUG: KASAN: null-ptr-deref in trace_event_raw_event_rtrs_clt_conn_class+0x220/0x480 drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h:36
Read of size 255 at addr 0000000000000000 by task syz.0.17/4921

CPU: 0 UID: 0 PID: 4921 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/07/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_report+0x58/0x84 mm/kasan/report.c:485
 kasan_report+0x8c/0xc4 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x17c/0x1ac mm/kasan/generic.c:200
 __asan_memcpy+0x3c/0x84 mm/kasan/shadow.c:105
 do_trace_event_raw_event_rtrs_clt_conn_class drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h:58 [inline]
 trace_event_raw_event_rtrs_clt_conn_class+0x220/0x480 drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h:36
 __traceiter_rtrs_clt_close_conns+0x74/0xc8 drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h:77
 __do_trace_rtrs_clt_close_conns drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h:77 [inline]
 trace_rtrs_clt_close_conns drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h:77 [inline]
 rtrs_clt_close_conns+0x2f0/0x40c drivers/infiniband/ulp/rtrs/rtrs-clt.c:1949
 rtrs_clt_open+0xa6c/0xd54 drivers/infiniband/ulp/rtrs/rtrs-clt.c:2858
 find_and_get_or_create_sess drivers/block/rnbd/rnbd-clt.c:1268 [inline]
 rnbd_clt_map_device+0xcb8/0x1f64 drivers/block/rnbd/rnbd-clt.c:1551
 rnbd_clt_map_device_store+0x900/0xad8 drivers/block/rnbd/rnbd-clt-sysfs.c:612
 dev_attr_store+0x6c/0x90 drivers/base/core.c:2505
 sysfs_kf_write+0xe0/0x108 fs/sysfs/file.c:145
 kernfs_fop_write_iter+0x260/0x3b8 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x51c/0xa0c fs/read_write.c:687
 ksys_write+0x12c/0x228 fs/read_write.c:739
 __do_sys_write fs/read_write.c:750 [inline]
 __se_sys_write fs/read_write.c:747 [inline]
 __arm64_sys_write+0x84/0x98 fs/read_write.c:747
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x19c/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:758
 el0t_64_sync_handler+0x44/0x104 arch/arm64/kernel/entry-common.c:777
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590
==================================================================


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
