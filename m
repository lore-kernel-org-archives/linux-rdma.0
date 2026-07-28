Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BC73264C7;
	Tue, 28 Jul 2026 03:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785209246; cv=none; b=bQ+P4GJX78cp9szKISSniC5wQPdNT5CCNd+4xumtTF5Z7lx307k8aYeQgi59Two1PjpB7ESYkMQDMNJcVf3QzCuhy3GpMhH4hCEKTL4zx7XghJdZvoQi5y1pXA3dxK12quvwU56s92kKMNcEHjJrTPMsu6GKKTZvc7MPWgnDf18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785209246; c=relaxed/simple;
	bh=KVdUGZ9pRFaOTwnF0igVWumQdfZwtvIjLj4Ratx0vnA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=PhjKkUFsxu9EJ+yKAZOEW9D1qmDUyOiQkfYwXXMb9bq/SWnXAzGg2GHsQN026RTBS0Bn5TUSJPBfomecBXEaBKd0nntI4olOfx5xJk16tqAmdeFCgu3z/fkCuKRRzR2Wc/0ri6TzSTVB7ClAgg6TCb0LG4DwVdDlU/nelXywn2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=NWX/Xp9Y; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="NWX/Xp9Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1785209216;
	bh=b5S0cpkt5ZScdUPlH7VbIoEynBrUTkPt5wwIerT4dMQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject;
	b=NWX/Xp9YFTlPBXM2Z2qxFqiTBEwFdZIURI8xAqGjUeOkIuCXjnMWvK/7Pjdk+WmTZ
	 Q8WbEVErn6aYYW1tzNaS/sKSziF1rDqam61w7yIY6vvz9zyhhTmKMLmqhekm4wBS62
	 BI+lrYQj9LWcHjKc8/SlHuop+8RKCIkUTOeq43YI=
X-QQ-mid: zesmtpgz4t1785209215tf601e1b7
X-QQ-Originating-IP: JChbxiwaKSvfaxEI6pfa32nGID+Ic04IaEyYeguiYm8=
Received: from [127.0.0.1] ( [36.152.24.148])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 28 Jul 2026 11:26:53 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 384521583918047642
Message-ID: <365C68B4923F8214+30195a67-0b90-4b92-ab96-2ce41517793c@smail.nju.edu.cn>
Date: Tue, 28 Jul 2026 11:26:53 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: zyjzyj2000@gmail.com
Cc: "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, leon@kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Peiyang He <peiyang_he@smail.nju.edu.cn>
Subject: [BUG] RDMA/rxe: OOB write in rxe_qp_from_attr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:smail.nju.edu.cn:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NLR4FNog5K1/aBu8mDASNOE5qLVT90dC47C4VVb5rBuWETYnku5HWBjU
	r58Z6ZKbKKwfsUeq2sbe6P0EA8Eqt/4bZvKAH+71gDnq8syUeguV0Bk5Z+OjP4vs0BEehAX
	Kgdoer8bt+1frqMh1jMnofUi/oS2AfMWlgqgUwRWZC6HWGCtept4yMqqq6EnHax7Si0Ur90
	2+kAJMsVv96ZPXxPJk3QPf0WYG8dRqN2YZaiPCr+MsGnMLFdVtp1tM4eK9YHs/R2hVSvLEn
	XtunkL/w8wDSzFjziJPes8+iEvv0hCD2LnMq/BJAJ2aUOeTU6Jh4kBEgGN1A9WecW1rep2V
	cJbLQlPOgduYYE+2uVFh6ukFxfJ2dFiwdhrgNLcAFm53ne3PGYthKCfLy3ldO7XXMNdL0II
	xjDP+JBX5Qg7T/NSCM2h4oanuZzPPz+cn6DPgOAZehKDaYMDyUF0vrMFPQksAdbCY0kRE2F
	uzSl68OWblFF5YtNEs0tca4WRAWjde8qGASWKE9EWNS6ygd7HlgCvX4WHpMY1bDMs3S+rRd
	kjxChX9fMqh7CsT8YJM4QJvsq+Xzq9bvqLDFY4iYEKPFucKsgi9+sc0FoyrCvlSHpKYWvOW
	gG2mQ4o2UH+nBUbALpNctxZ2u8hDvO/Yw1PbAbI0qFEthwc2eB6B40p2CF5ZDN5K29oP0tB
	mT5hmjBlQ1tXiAdU8bamGrsBCaa0/IZIiMgP+Jy+ejRRIiomq64aS1WRpLGFP+I/wv6fuWK
	q1y6v7Lxy8L02HO/0W5mVhOuzsCR2drWqiowJ0eEeV0utqDup1Z5PBax1Bov9RD8rxH9u8R
	/lE6pXAQXb7+JoRxkx1M5WYxUdj+U3px4Mf/aeDHyaWHc6/LuKJJV6WO+wcmlN/ygR2xO97
	jp39+Dnu3tXI+yxMFRU2L06CkDzsnownVjNYXWUtPs19+HYp70q1699W+8u91hn+TShRNnr
	SCqHklthAoA0B8Rb+HGdyZwPp5vTakU41I7rhaEtcya7NMDac8kdd42QqmDzKaABn6701D8
	lp/VlFji6Y7Sr4vLrfjHnJKsjV7JjmjyYM9jKP7fVoSS0Xa2mI2oVqIxK6UPqQd9QCZsUMJ
	w==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0

Hello Linux kernel developers and maintainers,

We hit a KASAN: slab-out-of-bounds Write in rxe_qp_from_attr when fuzzing RDMA/RXE
with Syzkaller.

The root cause is that RXE updates the max_dest_rd_atomic count before
it frees the old resp-resources array. The freeing code then uses the
NEW count to walk the OLD array and writes past the end of that old array
(when the new count exceeds the old count).

The version of the kernel under test is commit 8cd9520d35a6c38db6567e97dd93b1f11f185dc6 (tag v7.1).
We believe this OOB bug is still possible in the latest kernel.

The relevant kernel config is:

CONFIG_NET=y
CONFIG_INET=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_RDMA_RXE=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y

We have also prepared a C PoC that can stably trigger this OOB in https://drive.google.com/file/d/1GjnTgT8UKiMWmRXXNULZ7Gs1EiZUQiv6/view?usp=sharing.

=========================
Original Syzkaller report
=========================

BUG: KASAN: slab-out-of-bounds in free_rd_atomic_resource drivers/infiniband/sw/rxe/rxe_qp.c:180 [inline]
BUG: KASAN: slab-out-of-bounds in free_rd_atomic_resources drivers/infiniband/sw/rxe/rxe_qp.c:171 [inline]
BUG: KASAN: slab-out-of-bounds in free_rd_atomic_resources drivers/infiniband/sw/rxe/rxe_qp.c:163 [inline]
BUG: KASAN: slab-out-of-bounds in rxe_qp_from_attr+0x1e88/0x2150 drivers/infiniband/sw/rxe/rxe_qp.c:712
Write of size 4 at addr ffff88802b8dddb8 by task syz.3.451/11063

CPU: 0 UID: 0 PID: 11063 Comm: syz.3.451 Not tainted 7.1.0 #2 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x10e/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xf7/0x600 mm/kasan/report.c:482
 kasan_report+0xe4/0x120 mm/kasan/report.c:595
 free_rd_atomic_resource drivers/infiniband/sw/rxe/rxe_qp.c:180 [inline]
 free_rd_atomic_resources drivers/infiniband/sw/rxe/rxe_qp.c:171 [inline]
 free_rd_atomic_resources drivers/infiniband/sw/rxe/rxe_qp.c:163 [inline]
 rxe_qp_from_attr+0x1e88/0x2150 drivers/infiniband/sw/rxe/rxe_qp.c:712
 rxe_modify_qp+0x1e2/0x530 drivers/infiniband/sw/rxe/rxe_verbs.c:623
 ib_security_modify_qp+0x223/0xfa0 drivers/infiniband/core/security.c:625
 _ib_modify_qp+0x333/0xec0 drivers/infiniband/core/verbs.c:1915
 modify_qp+0x13ca/0x1940 drivers/infiniband/core/uverbs_cmd.c:1932
 ib_uverbs_modify_qp+0xcb/0x120 drivers/infiniband/core/uverbs_cmd.c:1958
 ib_uverbs_write+0xb86/0x1030 drivers/infiniband/core/uverbs_main.c:680
 vfs_write+0x2aa/0x1070 fs/read_write.c:686
 ksys_write+0x1f8/0x250 fs/read_write.c:740
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x116/0x800 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fefc75a70cd
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fefc8495018 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fefc7835fa0 RCX: 00007fefc75a70cd
RDX: 0000000000000078 RSI: 0000200000000240 RDI: 0000000000000007
RBP: 00007fefc764f10f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fefc7836038 R14: 00007fefc7835fa0 R15: 00007ffcf0586aa0
 </TASK>

Allocated by task 11063:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5296 [inline]
 __kmalloc_noprof+0x32a/0x850 mm/slub.c:5308
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 alloc_rd_atomic_resources drivers/infiniband/sw/rxe/rxe_qp.c:155 [inline]
 rxe_qp_from_attr+0x3f8/0x2150 drivers/infiniband/sw/rxe/rxe_qp.c:714
 rxe_modify_qp+0x1e2/0x530 drivers/infiniband/sw/rxe/rxe_verbs.c:623
 ib_security_modify_qp+0x223/0xfa0 drivers/infiniband/core/security.c:625
 _ib_modify_qp+0x333/0xec0 drivers/infiniband/core/verbs.c:1915
 modify_qp+0x13ca/0x1940 drivers/infiniband/core/uverbs_cmd.c:1932
 ib_uverbs_modify_qp+0xcb/0x120 drivers/infiniband/core/uverbs_cmd.c:1958
 ib_uverbs_write+0xb86/0x1030 drivers/infiniband/core/uverbs_main.c:680
 vfs_write+0x2aa/0x1070 fs/read_write.c:686
 ksys_write+0x1f8/0x250 fs/read_write.c:740
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x116/0x800 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88802b8ddd80
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes to the right of
 allocated 56-byte region [ffff88802b8ddd80, ffff88802b8dddb8)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2b8dd
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff888015c418c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4651, tgid 4651 ((udev-worker)), ts 123427165316, free_ts 123425874255
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
 __do_kmalloc_node mm/slub.c:5295 [inline]
 __kmalloc_noprof+0x68d/0x850 mm/slub.c:5308
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 tomoyo_encode2+0x100/0x3e0 security/tomoyo/realpath.c:45
 tomoyo_encode+0x29/0x50 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x18c/0x690 security/tomoyo/realpath.c:283
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x2ab/0x3c0 security/tomoyo/file.c:776
 tomoyo_file_open+0x6b/0x90 security/tomoyo/tomoyo.c:334
 security_file_open+0x7a/0x1b0 security/security.c:2739
 do_dentry_open+0x57e/0x1690 fs/open.c:924
 vfs_open+0x82/0x3f0 fs/open.c:1079
 do_open fs/namei.c:4699 [inline]
 path_openat+0x218a/0x3190 fs/namei.c:4858
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 __free_frozen_pages+0x763/0xfc0 mm/page_alloc.c:2938
 selinux_genfs_get_sid security/selinux/hooks.c:1364 [inline]
 inode_doinit_with_dentry+0x903/0x1320 security/selinux/hooks.c:1563
 selinux_d_instantiate+0x26/0x30 security/selinux/hooks.c:6658
 security_d_instantiate+0x123/0x190 security/security.c:3704
 d_splice_alias_ops+0x92/0x850 fs/dcache.c:3141
 kernfs_iop_lookup+0x23f/0x2d0 fs/kernfs/dir.c:1289
 lookup_open.isra.0+0x659/0x1080 fs/namei.c:4484
 open_last_lookups fs/namei.c:4611 [inline]
 path_openat+0x17dd/0x3190 fs/namei.c:4855
 do_file_open+0x20c/0x430 fs/namei.c:4887
 do_sys_openat2+0x101/0x1d0 fs/open.c:1364
 do_sys_open fs/open.c:1370 [inline]
 __do_sys_openat fs/open.c:1386 [inline]
 __se_sys_openat fs/open.c:1381 [inline]
 __x64_sys_openat+0x141/0x200 fs/open.c:1381
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x116/0x800 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88802b8ddc80: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff88802b8ddd00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff88802b8ddd80: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
                                        ^
 ffff88802b8dde00: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
 ffff88802b8dde80: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
==================================================================

==========
Root cause
==========

Core function sequence is:

userspace MODIFY_QP
-> ib_uverbs_modify_qp
-> modify_qp
-> ib_security_modify_qp
-> rxe_modify_qp
-> rxe_qp_from_attr

The failing case is a QP that already owns a resp.resources array from an
earlier MODIFY_QP, and then receives another MODIFY_QP with
IB_QP_MAX_DEST_RD_ATOMIC set to a LARGER value.

Inside rxe_qp_from_attr(), the state is updated in a buggy order:

	if (mask & IB_QP_MAX_DEST_RD_ATOMIC) {
		int max_dest_rd_atomic = attr->max_dest_rd_atomic ?
			roundup_pow_of_two(attr->max_dest_rd_atomic) : 0;

		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;

		free_rd_atomic_resources(qp);

		err = alloc_rd_atomic_resources(qp, max_dest_rd_atomic);
		if (err)
			return err;
	}

It first computes the new max_dest_rd_atomic value, then stores the value
in qp->attr.max_dest_rd_atomic, then frees the old qp->resp.resources
array, and only after that allocates a new qp->resp.resources array for the
new value.

The bug is that the free path uses qp->attr.max_dest_rd_atomic as the loop
bound while clearing the old array:

static void free_rd_atomic_resources(struct rxe_qp *qp)
{
	if (qp->resp.resources) {
		int i;

		for (i = 0; i < qp->attr.max_dest_rd_atomic; i++) {
			struct resp_res *res = &qp->resp.resources[i];

			free_rd_atomic_resource(res);
		}
		kfree(qp->resp.resources);
		qp->resp.resources = NULL;
	}
}

As a result, if the old array was allocated for a smaller max_dest_rd_atomic
and the new request increases it, the cleanup loop indexes beyond the end of
the old resp.resources array and writes out of bounds while clearing one of the
resource entries.

=============
Suggested fix
=============

We cannot calculate the correct length of qp->resp.resources in free_rd_atomic_resources().
To fix this OOB, one possbile solution is to pass the array length explicitly:

static void free_rd_atomic_resources(struct rxe_qp *qp, unsigned int nr)
{
    if (qp->resp.resources) {
        int i;

        for (i = 0; i < nr; i++) {
            struct resp_res *res = &qp->resp.resources[i];

            free_rd_atomic_resource(res);
        }

        kfree(qp->resp.resources);
        qp->resp.resources = NULL;
    }
}

But on a second thought, the only thing free_rd_atomic_resource(res) does
is setting res->type to 0, given that the whole qp->resp.resources will be freed in the end,
should we just delete the for-loop in free_rd_atomic_resources()?

Happy to hear any feedback!

Thanks,
Peiyang

