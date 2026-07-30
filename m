Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7C936B06A;
	Thu, 30 Jul 2026 02:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785378590; cv=none; b=EdBNO6BuSF2KYY8Ro1f2qckxNU9JAzKj+5r0JU1LWU6EF8pk2+iqzYK4nzKo0lnS6FrZ7KGjPkvLtUms+jlQ9oLRnAkNyfHE7zGUZXliOh06WdaCscyq4XK8MG0rFlBqV7S3O5RAzrU+gjsdPCNwfVJqDTNYrH4b1oN5rZXGSJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785378590; c=relaxed/simple;
	bh=oWYv/l/jADFNsV3DyI+vI9UDuAH7WcUSLssyH6qyNBM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CnJkdmAc14Fe8iKOn7O9waj4pgbg1t2p2pWaAN/TTcUFNfcQoR0WaRTIF2OtUJHkQo07lH9WcsZmwKCOPlbeEkuw1MQ0FzWC4nmLXrePR5i9Pd3OhlrAyJqMHplpe1gvE6YNt7pFfK4RinaspviqgW0AdYBdpbO5TE3lsTodcis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=NiujLHuu; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="NiujLHuu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1785378531;
	bh=aFzfm8RDBrLbSQU7PFOincYS+bfXtNxK4eO9vwSVPOw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=NiujLHuubDZ3bYJDJfe9SYsTJOweBFL+mWg7KQlyF+PmHLCg0g1g5Q0cCnOPL2Eli
	 i9/ULJKIj8pHeG9lBnu3jYOk/sG5eFiQiW12LZHUmNxHTDvBqW9BnFE3quc8ZokWWu
	 DNQQCuCeNS6D1ihJeVqcUNTzse0eoEAHBppp83CY=
X-QQ-mid: zesmtpgz7t1785378515td5540d6d
X-QQ-Originating-IP: BdiIn405ZoFs6U1MLhN6TqQL7YsVE1LugAKpQoh/40A=
Received: from hepeiyang-vm.wu.lxd ( [218.94.142.72])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 30 Jul 2026 10:28:34 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16790207941067441370
EX-QQ-RecipientCnt: 9
From: Peiyang He <peiyang_he@smail.nju.edu.cn>
To: yanjun.zhu@linux.dev,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	pandit.parav@gmail.com,
	dledford@redhat.com,
	Peiyang He <peiyang_he@smail.nju.edu.cn>
Subject: [PATCH v2] RDMA/rxe: Fix OOB in free_rd_atomic_resources()
Date: Thu, 30 Jul 2026 10:28:27 +0800
Message-ID: <A8FFB80EB4DA06C9+20260730022827.2906506-1-peiyang_he@smail.nju.edu.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:smail.nju.edu.cn:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MAL61fhe2h5SatH047gqauxEx3te8HtRmj7myrjK1voauSHlztbpu47i
	haUUW+wGNyIesx5/wP9yfnHobJpmgSJGn9Zrd6V9PqxgTv41S393fDROg/Wmy3nM6kvmfHo
	iX56m1FRoHrtx3+rN6Ytd234u4XFWw6aWI7Ggkxh+U2p/idcgcVHYJduHJ2ilt/j1XeFb0y
	KaltMIAOdhWgnkd7hfVCvUiWKaZ37GCfu7T3WlQnlwc7gzOmU0nssHkSgXLPFHK/K/gc4ei
	uqJK7n1YsELs6kfiqd9SPugyMLf51gqsoOHaXc3zxjBH9v8ReXuObqf8SRTAePd0Tnm9jH6
	wR4G618QD5REykm9GfRFybLrcrScocDxmvM/LpaNvhhfg//N9nu2aYbiz1f29l+RQUuU1tQ
	/cCUpAZ3fQclZtJI0wEk7RX2bQFd8P2bRdxCJk4QW6FbiT4WdDnyNtChuTauBP7PgVgVW9/
	Bk+5DflIgEvonzWPDUxtUBPT1kd4aNMojreKoRpQZ3JqrmiPpGl/9H6XfFceHFrgWEjx0yf
	8y66yEnRlSfQunYIHPRwqFuodlhXpHbmOZwdRCpGQl6uTcGAagqPMxEJT954rfrW8jMphb7
	jkhF/+XfXCF5J85wSEz+ihof0wOsD3eDvrVilkeFaxLHzSBf8hYimDcjMEj0eHJDtDrqQI0
	rDSmrc6ADpgB9f1RtfQNwy2x91l+atj/5CjXjuOd3kwqqOHV80PkeZGLb6Nne9IFS5S5C6o
	nZnVijLqy7hzx78Ex7Qoa+9HceKRq3J8vTF09wnvlC6lYoRvBwD97Mh2ReJtoOuuJj/dJeH
	tZXGIbN4hVNoP1bX5YWbLc9mTBpx6qt+d34Tf9KUVMWvukMHyISWs+/9Hveoe3ouDy7VIWE
	XnRltb3iPu30Ma1B7ouhQshKJ6YU5yFuYgaWrv+iJBwc9eIL5Em4DzYd/FgowgXB36YyBEY
	anr8FS00BC8hqCAPH2aeVQaYGM8HwOlTrIs6Uld7XnduquXdDVhdsDUupZgKfbakLok+zQM
	go99Fk/XdSwAnGJPvx8XW9bLOv3xE2m0NEkBjM9sfO92RLhGXr
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

free_rd_atomic_resources() iterates using qp->attr.max_dest_rd_atomic.
Updating max_dest_rd_atomic before freeing the old array can make the
free path walk past the old allocation and trigger a slab out-of-bounds
write catched by KASAN:
==================================================================
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

Fix the OOB by moving the assignment after free_rd_atomic_resources()
so the old array is freed using the old bound. This matches the original
ordering in commit 8700e3e7c485 ("Soft RoCE driver").

Closes: https://lore.kernel.org/all/365C68B4923F8214+30195a67-0b90-4b92-ab96-2ce41517793c@smail.nju.edu.cn/
Fixes: b6bbee0d2438 ("IB/rxe: Properly honor max IRD value for rd/atomic.")
Cc: stable@vger.kernel.org
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
Changes in v2:
  - add KASAN OOB log (suggested by Zhu Yanjun)
  - collect Reviewed-by

 drivers/infiniband/sw/rxe/rxe_qp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c b/drivers/infiniband/sw/rxe/rxe_qp.c
index f3dff1aea96a..1fffe3c6685d 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -707,10 +707,10 @@ int rxe_qp_from_attr(struct rxe_qp *qp, struct ib_qp_attr *attr, int mask,
 		int max_dest_rd_atomic = attr->max_dest_rd_atomic ?
 			roundup_pow_of_two(attr->max_dest_rd_atomic) : 0;
 
-		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
-
 		free_rd_atomic_resources(qp);
 
+		qp->attr.max_dest_rd_atomic = max_dest_rd_atomic;
+
 		err = alloc_rd_atomic_resources(qp, max_dest_rd_atomic);
 		if (err)
 			return err;
-- 
2.43.0

