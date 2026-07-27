Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E9B1624DF;
	Mon, 27 Jul 2026 05:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129046; cv=none; b=VipmE9DpaBpHrOiFQBuUTNQG2K9jJxlMxY1fKbx83wZMVRJ2rlkV8R4Dcj0aWmXFKb+Vokg5Wo3aV1MzDDNcziCf7cagmBdeGNaaSoDFK2KM1lEG8y9JAr5Au6z/ITqFVO9mfbiJ/WvNrRqzh2bAFRuBPYiKlXo5tPP/mHuYu20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129046; c=relaxed/simple;
	bh=xPkFzRX4FUrVPOYKRBHlPf2JUSKf9yhMlnhgl8r5Cn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0FoZbVhmSbIYTduJpLU7Tx8UUQt91qpdb1H1qsLQ46GC/OrxGlijWr5Z6tvfk5stsCbP4JuYLzd70q7n6L3rkT7ogrossDqUkUaYve7EkoVHJpZH3kp4GEeN54PR0gl4YBeIPFFhUKdBkb9ywVNHs2whrrxwWR67ukMWy/MTE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=wylne2B/; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="wylne2B/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1785129010;
	bh=Rw2Tm9XycmbPwWjMmPPZQ5pKlN7jakHeLnOyivB7F7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=wylne2B/7nv7dgruBSxJspzJm74qIXwXmiXalCuxrljHAj0xym2B+mos696teyBOF
	 pkQPBAMXQpiXfXTmxDALwi+T4gMYavcecSoNKbX2DCEUOEjcp3H85llNq4WifHKRJ8
	 sI5wZHMADziT+bT6BCcxwFNdGQF/4h/MW9MVgkZs=
X-QQ-mid: esmtpgz11t1785129004t7653a64c
X-QQ-Originating-IP: fJ4ZuRKSypDimO1E4LPfejxan+n2/17NHFATdGt5xPs=
Received: from [127.0.0.1] ( [36.152.24.148])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 27 Jul 2026 13:10:02 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5392829134361927056
Message-ID: <890DDFAF08006D5F+13003ec2-1ff2-48c5-835a-a09fafcdac2d@smail.nju.edu.cn>
Date: Mon, 27 Jul 2026 13:10:02 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: Fix UAF in ODP init error-handling path
To: zyjzyj2000@gmail.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-kernel@vger.kernel.org, matsuda-daisuke@fujitsu.com,
 stable@vger.kernel.org, linux-rdma@vger.kernel.org
References: <70CB6DBCB19624C7+20260727050659.1543627-1-peiyang_he@smail.nju.edu.cn>
Content-Language: en-US
From: Peiyang He <peiyang_he@smail.nju.edu.cn>
In-Reply-To: <70CB6DBCB19624C7+20260727050659.1543627-1-peiyang_he@smail.nju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:smail.nju.edu.cn:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MYU01JcVg+d1IrBWFRIG/WNUZxpYuviJfMz4Z8yyVHTtaIwyjQOOSGK1
	wN7FgvhinK27lNiwW6LshqYHU97NPivVa5C0MBh4mwFZfAT1YIGL1SUN7/hmSb37svo05t4
	og/JOL31JWdWv9GIwTCflNyNXf0PJj+YwifSn5H6dJh9zYR2CLuv/1ssRUuTwNyB+UrF0nM
	sfTQLjxyztp3dSI3SBrf3KXVI5GhdO8H/fo781U5Lz9tpzMsY4SP12c46canlieUW8R96ja
	B42vMCGzgw6r4BySiYJHclKVKdMh2HX5BeTqQRXhdrNOdH0yw1t4QdznX4wecewhZcryVOl
	L5yhiXyBdQv2vbOWKNM/Ik1Vr5rva0DT7tljcABHxqXL+HV/LImjgddDqhaK1IkF8CpTpxZ
	UrslD9ofeU19zeFgLQ03dBy1DsVcBwNFOrw8EgEhPEdsk9WvvOZ2yhSPGo/x/HzV64hwRhl
	vGUJ3QI8lTLPJBVvT0nBRAg5b7yPN4SNfxlmcEzuAa90IVohJBSKmWBjD/8y9vzWhrnEwCT
	r0LWK3lyAohmXj7DLe3RqnAuxZO56XGnIqyiWTqjphFbEXnYVsAEAS1mAzrleinwHrpRwwV
	oQilvEpNLUgkuCekI8eo3POaPiPPL0+mbIQ0W1O0eiEJfdaXWSd1pqb3wuiUfN9TmdmzUJl
	wZbEMQDT/dfOAyzwcKMHCH/OPO5xq3TqQkSOLURA5NL3QgvzTsdWV/UUMjeWmDxew6AOl4N
	07IEqR3ewjct9e9EP+5SdZcqs+M1yLvzQQdqtVSFPL69EXTC6W1a0dYIuhNbQYPJeEmkje6
	CORmh4XrHZOf7PtwUaexkm2JNhKutFy196rgHlTFyDqEp+8QY4f64SRo/ADzwMZ4Hj7pdYX
	BUJ2RDWpDJX9R3xUoezilDljvIXCwPmKyYCIcURPlpurwIG7Fj1N6qABS5JqeHKhaNI8lnu
	281WWEqMG9n40fCzr981CSv9t8Xh8OR4Ux0SgdseKkWnBb4abT7/74+36YOm3EIlZeFQN5G
	gRJz0Xi5dbOtp6YEs/DOh6frD+gAAnI6grUadsfA==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

On 2026/7/27 13:06, Peiyang He wrote:
> rxe_odp_mr_init_user() stores &umem_odp->umem in mr->umem before
> calling rxe_odp_init_pages(). If rxe_odp_init_pages() fails,
> rxe_odp_mr_init_user() releases umem_odp and returns an error.
> 
> rxe_reg_user_mr() then unwinds the error through rxe_cleanup(),
> rxe_mr_cleanup(), ib_umem_release(mr->umem). There is an
> IS_ERR_OR_NULL(umem) check at the start of ib_umem_release().
> But since mr->umem is NOT reset to NULL in the error handling
> path of rxe_odp_mr_init_user(), the check passes and it reads
> already-freed fields like umem->is_dmabuf, causing UAF.
> 
> Fix the UAF by clearing mr->umem after releasing the failed
> ODP umem so the MR cleanup path does not release it again.
This UAF is confirmed by a
  KASAN: slab-use-after-free Read in ib_umem_odp_release
report when fuzzing with Syzkaller:

==================================================================
BUG: KASAN: slab-use-after-free in ib_umem_release+0x205/0x260 drivers/infiniband/core/umem.c:288
Read of size 1 at addr ffff888052b29030 by task syz.0.515/11527

CPU: 0 UID: 0 PID: 11527 Comm: syz.0.515 Not tainted 7.1.0 #2 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x10e/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xf7/0x600 mm/kasan/report.c:482
 kasan_report+0xe4/0x120 mm/kasan/report.c:595
 ib_umem_release+0x205/0x260 drivers/infiniband/core/umem.c:288
 rxe_mr_cleanup+0x73/0x150 drivers/infiniband/sw/rxe/rxe_mr.c:812
 __rxe_cleanup+0x26a/0x3b0 drivers/infiniband/sw/rxe/rxe_pool.c:232
 rxe_reg_user_mr+0x258/0x660 drivers/infiniband/sw/rxe/rxe_verbs.c:1305
 ib_uverbs_reg_mr+0x4e1/0xa60 drivers/infiniband/core/uverbs_cmd.c:731
 ib_uverbs_write+0xb86/0x1030 drivers/infiniband/core/uverbs_main.c:680
 vfs_write+0x2aa/0x1070 fs/read_write.c:686
 ksys_write+0x1f8/0x250 fs/read_write.c:740
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x116/0x800 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f90fdba70cd
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f90fead3018 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f90fde35fa0 RCX: 00007f90fdba70cd
RDX: 0000000000000030 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007f90fdc4f10f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f90fde36038 R14: 00007f90fde35fa0 R15: 00007ffc6eef7d30
 </TASK>

Allocated by task 11527:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:415
 kmalloc_noprof include/linux/slab.h:950 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 ib_umem_odp_get+0x75/0x350 drivers/infiniband/core/umem_odp.c:244
 rxe_odp_mr_init_user+0x7e/0x480 drivers/infiniband/sw/rxe/rxe_odp.c:99
 rxe_reg_user_mr+0x221/0x660 drivers/infiniband/sw/rxe/rxe_verbs.c:1293
 ib_uverbs_reg_mr+0x4e1/0xa60 drivers/infiniband/core/uverbs_cmd.c:731
 ib_uverbs_write+0xb86/0x1030 drivers/infiniband/core/uverbs_main.c:680
 vfs_write+0x2aa/0x1070 fs/read_write.c:686
 ksys_write+0x1f8/0x250 fs/read_write.c:740
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x116/0x800 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 11527:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2689 [inline]
 slab_free mm/slub.c:6251 [inline]
 kfree+0x301/0x6e0 mm/slub.c:6566
 rxe_odp_mr_init_user+0x230/0x480 drivers/infiniband/sw/rxe/rxe_odp.c:116
 rxe_reg_user_mr+0x221/0x660 drivers/infiniband/sw/rxe/rxe_verbs.c:1293
 ib_uverbs_reg_mr+0x4e1/0xa60 drivers/infiniband/core/uverbs_cmd.c:731
 ib_uverbs_write+0xb86/0x1030 drivers/infiniband/core/uverbs_main.c:680
 vfs_write+0x2aa/0x1070 fs/read_write.c:686
 ksys_write+0x1f8/0x250 fs/read_write.c:740
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x116/0x800 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888052b29000
 which belongs to the cache kmalloc-512 of size 512
The buggy address is located 48 bytes inside of
 freed 512-byte region [ffff888052b29000, ffff888052b29200)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x52b28
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x4fff00000000040(head|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000040 ffff888015c41c80 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
head: 04fff00000000040 ffff888015c41c80 dead000000000100 dead000000000122
head: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
head: 04fff00000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 8180, tgid 8180 (syz-executor), ts 166688124697, free_ts 163595246868
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0xfc/0x120 mm/page_alloc.c:1853
 prep_new_page mm/page_alloc.c:1861 [inline]
 get_page_from_freelist+0x75b/0x3220 mm/page_alloc.c:3941
 __alloc_frozen_pages_noprof+0x27e/0x2b00 mm/page_alloc.c:5221
 alloc_slab_page mm/slub.c:3278 [inline]
 allocate_slab mm/slub.c:3467 [inline]
 new_slab+0xa6/0x670 mm/slub.c:3525
 refill_objects+0x278/0x420 mm/slub.c:7272
 refill_sheaf mm/slub.c:2816 [inline]
 __pcs_replace_empty_main+0x2ed/0x640 mm/slub.c:4652
 alloc_from_pcs mm/slub.c:4750 [inline]
 slab_alloc_node mm/slub.c:4884 [inline]
 __kmalloc_cache_noprof+0x5a5/0x710 mm/slub.c:5415
 kmalloc_noprof include/linux/slab.h:950 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 device_private_init drivers/base/core.c:3536 [inline]
 device_add+0xd13/0x18e0 drivers/base/core.c:3587
 netdev_register_kobject+0x1a9/0x3d0 net/core/net-sysfs.c:2343
 register_netdevice+0x1552/0x24c0 net/core/dev.c:11423
 veth_newlink+0x316/0xa00 drivers/net/veth.c:1861
 rtnl_newlink_create net/core/rtnetlink.c:3864 [inline]
 __rtnl_newlink net/core/rtnetlink.c:3995 [inline]
 rtnl_newlink+0xc45/0x2070 net/core/rtnetlink.c:4110
 rtnetlink_rcv_msg+0x95e/0xe90 net/core/rtnetlink.c:6997
 netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2555
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x584/0x850 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x8ba/0xd60 net/netlink/af_netlink.c:1899
page last free pid 8179 tgid 8179 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 __free_frozen_pages+0x763/0xfc0 mm/page_alloc.c:2938
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x47/0xf0 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x195/0x1e0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4570 [inline]
 slab_alloc_node mm/slub.c:4899 [inline]
 kmem_cache_alloc_noprof+0x2ff/0x6f0 mm/slub.c:4906
 __kernfs_new_node+0xd2/0xa40 fs/kernfs/dir.c:664
 kernfs_new_node+0x11b/0x1a0 fs/kernfs/dir.c:748
 __kernfs_create_file+0x53/0x350 fs/kernfs/file.c:1057
 sysfs_add_file_mode_ns+0x207/0x3c0 fs/sysfs/file.c:313
 create_files fs/sysfs/group.c:82 [inline]
 internal_create_group+0x5b0/0xfe0 fs/sysfs/group.c:189
 internal_create_groups+0x9d/0x150 fs/sysfs/group.c:229
 device_add_groups drivers/base/core.c:2837 [inline]
 device_add_attrs drivers/base/core.c:2901 [inline]
 device_add+0x718/0x18e0 drivers/base/core.c:3645
 netdev_register_kobject+0x1a9/0x3d0 net/core/net-sysfs.c:2343
 register_netdevice+0x1552/0x24c0 net/core/dev.c:11423
 __ip_tunnel_create+0x540/0x6b0 net/ipv4/ip_tunnel.c:268
 ip_tunnel_init_net+0x22f/0x7d0 net/ipv4/ip_tunnel.c:1147

Memory state around the buggy address:
 ffff888052b28f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888052b28f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888052b29000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff888052b29080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888052b29100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb

Best,
Peiyang

