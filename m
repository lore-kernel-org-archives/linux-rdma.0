Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BA1481675
	for <linux-rdma@vger.kernel.org>; Fri, 25 Sep 2026 09:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790328257; cv=none; b=SAhtjXgayDmF9h3/stYNN/7a28pQztQG07pOJsbRF473778kjo2S8oGbK/WJw0HqJT73DxoCAwGR7UkWAUufHi+dHnd/lr/T0tVj9wNMixZuL5eseXdVY8ABKpadnrGEeH2t6SiaJPwRT5coRH0fknzAPt1z3MC7eMc4QAO5TWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790328257; c=relaxed/simple;
	bh=Mun91e+a2sgF6TvIy/utfHU4x6hsKg0c3RJ65Bt4F9Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ophqanPXMF7+XH9si8VhCZj0EPatlRHpFbqBpBznVjaSD79qa24BtYnET2Ta2y0XMz0zTtcYRSYeRFqzzvPnnRn67gEdC4XpFSdwRZVHEKg9Jt3LVPwlMKeoiWw6JF/gN1lreIwFkBlpVnTc3EZZXK6pNS+UivhA1BXA1OdANpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ab8b4887d4so758366b6e.1
        for <linux-rdma@vger.kernel.org>; Fri, 25 Sep 2026 02:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790328251; x=1790933051;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SG9sz1wN9Eat286bNsFicmln6CdKM5JJEaOgRGJ1Aao=;
        b=NqcHvdA9MEbzZWU3wLJtLSl9he1hvQRtIKy2ZkyzriyNzxSFYtAy6FTl6kQP/QO/b7
         fH67CBHCi89gx+Tlq5rTXvMLd7IZF8YRyVT2o1GSSN0/3dBnUOzzfR9AiiTJh9iuUJl2
         89PJL/AjH8JS31DRnfHn+0XTGfi9vZOLiVjtmtVLdFOGw9kM2JVKFQvSwb7jvTpHppG4
         QgGzODdfXbt3+57pBjKvdMLIor4FcXBnC+xiR6cXai8ZD7tJV1vE9jdTNOAlgN2LxzGU
         exXI2xeWckAB2JsZW4oOD2nKsSLKKxCSr3vGBnpglCZjHqjOEyt3ttHLxGKqIjA5c4t4
         w77A==
X-Forwarded-Encrypted: i=1; AKwUvBxQYQmVFKB3a7qda5UulnAYLdlVy/WnUd5F5aI6/eF3fhkNEcS4+H7+Qu3mEYbUf+zgu8oOqFdS7KUh@vger.kernel.org
X-Gm-Message-State: AFuF++nqiHNi01KBDIMyPBNHd3NBhp8OZzYsqMtti2WKREXjn2YKheG4
	FOeAVvIhuIN1Mv7Qg1kewHiiy8hZnHrlxgnfWck4NBNUGECr687FEDVEvtQhOm/NbTl7zS4W+FS
	tCppULowAq+vixDiHKMkRkoUND3FtnPA1gkDO7+z1WiTuy7r9pog/NhqETKE=
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:11c9:b0:4b3:98f4:f057 with SMTP id
 5614622812f47-4dc57e294demr1386127b6e.3.1790328251491; Fri, 25 Sep 2026
 02:24:11 -0700 (PDT)
Date: Fri, 25 Sep 2026 02:24:11 -0700
In-Reply-To: <6b07af04b3ba66a09009e1a0a7b98ec5ec85d3a0.1790109248.git.sunnytiwari@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab63dbb.7eec07f4.c25c.0005.GAE@google.com>
Subject: [syzbot ci] Re: net/rds: replace tasklets with workqueue
From: syzbot ci <syzbot+cic449f4593b46dd93@syzkaller.appspotmail.com>
To: achender@kernel.org, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kuba@kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, rds-devel@oss.oracle.com, 
	santosh.shilimkar@oracle.com, sunnytiwari@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net/rds: replace tasklets with workqueue
https://lore.kernel.org/all/6b07af04b3ba66a09009e1a0a7b98ec5ec85d3a0.1790109248.git.sunnytiwari@google.com
* [PATCH net-next] net/rds: replace tasklets with workqueue

and found the following issue:
WARNING in __alloc_workqueue

Full report is available here:
https://ci.syzbot.org/series/e7102860-1b25-4e10-b653-afe8e9820ef8

***

WARNING in __alloc_workqueue

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      42a9fb3382fc2573e92f41d203b095d9a372cfc9
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/220e9c3a-eede-449e-8bb1-d34ad95dc867/config

gre: GRE over IPv4 demultiplexer driver
ip_gre: GRE over IPv4 tunneling driver
IPv4 over IPsec tunneling driver
Initializing XFRM netlink socket
IPsec XFRM device driver
xfrm_iptfs: IPsec IP-TFS tunnel mode module
NET: Registered PF_INET6 protocol family
Segment Routing with IPv6
RPL Segment Routing with IPv6
In-situ OAM (IOAM) with IPv6
mip6: Mobile IPv6
sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
ip6_gre: GRE over IPv6 tunneling driver
NET: Registered PF_PACKET protocol family
PFKEY is deprecated and scheduled to be removed in 2027, please contact the netdev mailing list
NET: Registered PF_KEY protocol family
Bridge firewalling registered
NET: Registered PF_X25 protocol family
X25: Linux Version 0.2
can: controller area network core
NET: Registered PF_CAN protocol family
can: raw protocol
can: broadcast manager protocol
can: netlink gateway - max_hops=1
can: SAE J1939
can: isotp protocol (max_pdu_size 8300)
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: HIDP socket layer initialized
NET: Registered PF_RXRPC protocol family
Key type rxrpc registered
Key type rxrpc_s registered
NET: Registered PF_KCM protocol family
l2tp_core: L2TP core driver, V2.0
l2tp_ppp: PPPoL2TP kernel driver, V2.0
l2tp_ip: L2TP IP encapsulation support (L2TPv3)
l2tp_netlink: L2TP netlink interface
l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
NET: Registered PF_PHONET protocol family
8021q: 802.1Q VLAN Support v1.8
sctp: Hash tables configured (bind 32/56)
NET: Registered PF_RDS protocol family
------------[ cut here ]------------
workqueue: rds_ib_wq is using neither WQ_PERCPU or WQ_UNBOUND. Setting WQ_PERCPU.
WARNING: kernel/workqueue.c:5939 at __alloc_workqueue+0x1cd2/0x1fe0, CPU#1: swapper/0/1
Modules linked in:
CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__alloc_workqueue+0x1cd5/0x1fe0
Code: 0b 90 e9 6d fc ff ff e8 89 02 39 00 e9 7f fb ff ff e8 7f 02 39 00 e9 85 fb ff ff e8 75 02 39 00 48 8d 3d ce 68 ee 0e 4c 89 f6 <67> 48 0f b9 3a 41 81 cf 00 01 00 00 e9 10 e6 ff ff e8 55 02 39 00
RSP: 0000:ffffc900000676a8 EFLAGS: 00010293
RAX: ffffffff818ed98b RBX: 0000000000000000 RCX: ffff888102adda00
RDX: 0000000000000000 RSI: ffff888173f5d170 RDI: ffffffff907d4260
RBP: ffffffff8d43a5a0 R08: ffff888102adda00 R09: 0000000000000002
R10: 0000000000000102 R11: 0000000000000000 R12: ffff888173f5d000
R13: ffff888173f5d000 R14: ffff888173f5d170 R15: 0000000000000018
FS:  0000000000000000(0000) GS:ffff8882a8cc6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000eb48000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 alloc_workqueue_noprof+0xe3/0x210
 rds_ib_init+0x54/0x190
 rds_rdma_init+0x74/0x170
 do_one_initcall+0x250/0x870
 do_initcall_level+0x10a/0x1a0
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x29d/0x3e0
 kernel_init+0x22/0x1d0
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
