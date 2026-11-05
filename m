Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793910592;
	b=rhbseAvXGMFAssgCP/dQrCQwzPGwGTM4kja09c6FMlqlOwHGvmPiniUXkk/VRQ6uz6nf
	 JDDqzBR1nWQUr0fHZxthI4/+OKGz7rKV985ka4boPdLae3AnuDyVrGyNxl6kbAcc/U9Ia
	 TreNZJvXsURSgHCBqlilpG9O3oeIKjYTt/KWx1FAAY6lyS7XESCFXW91V6fJt6yIz/WqL
	 0XTom1lSUoc98A1g8veyFKI/qmRxZI4JYEfB1saQON98Y8SOgYQr069wOP5RGCbkqfiX1
	 ay/mufIGm+RoHkZiqSbjiQfJOJUlktfz22ocP4RuylYYfeHxw5zGukoVTdMXjOYok2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793910592;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/nZzov8N+zyyuqAcE43h/bSIm3E1Cc1jzIpE1+g+dck=;
	b=n4kbvvj4hoi7xMXEWot1EoDYHl/xbkh6aWaHjfu64iOChHLPTA9hSmt9ZI8NH+sVN0J2
	 jFxqVJegZ5H8SfEhPpUXl3GnYnYEyeiFaAQiFk2dyfKnQQGEo+jBsUVgUWHFnt0lfgHb9
	 Z2wbrZTT6zXmCz00zExFtsJJeuGra7RHouRD5S1afu7igSdSYjdcp+R80BZpN7SPrskkJ
	 q3vgqeET79GmQyHiVek61aNWAj4IRmSey9BqQfYLTYnGiDP6mdec6jqBXKRM+Ohuki8kI
	 sCy9jM9qJi4NFt97Nc4mtURhmG9mBa2GcO78FZsHP1Vf8PMYl0l46Dtf0aVRm4VMkxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=F4nAnTX+;
	arc=none smtp.remote-ip=209.85.160.172
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F259F606A32C
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 20:29:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F259F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=F4nAnTX+
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-533861a59b8so23890531cf.1
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 12:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793910591; x=1794515391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/nZzov8N+zyyuqAcE43h/bSIm3E1Cc1jzIpE1+g+dck=;
        b=F4nAnTX+kii+PCwyyE0+1CUq6xJegQw9Tm8KNoyuKGVdIP/Ko9Ng/U+c58ziik5Se9
         UUtqGZLNGD8+LVfbRtp/Nn6er98UzOlv0qPoeWxv9Nh3I8THKjTFfKaGjrpsCtTh+Qjv
         CqXTFPgAldeBlYd5Mxeh18m2WjlHgzjpBApFxVcnIDFh8CYhePDyr6YHwW4IaDbezSpg
         t2oJyRQHZliPfEgufGXaXggD561cfP6iBPdqU1zssg+TF8PA8b7TjDHVEMUvYtao4waB
         GmvCcEivjyLLWU7WVoX2mNB6pbbzQG+NpdAhScovptkBDsEEZmt5ct4uu6kSHh5hYg2w
         a8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793910591; x=1794515391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/nZzov8N+zyyuqAcE43h/bSIm3E1Cc1jzIpE1+g+dck=;
        b=wwUD8VgzriEcfgnhSWz4X2Wp8284klqRa00xi5qdv2ADUEK7d5l4jMsbJJ6wvzB7Gt
         SgQuKq357NKI/Jb/elkNFWFIprioV0H3zlthw/hkQNToj8g6AHD8qoJaeKME+LCqinh4
         O7+eZiZqm5eTVndOfH8rZcMFjoUMu8FX9yBbTN2HCZLEZWsuKC39hYEJjpzeu4Imr/cN
         bDmXHYQe/gLCia0o/O3NNwfcEJAfFdm90DW7GkdgzUybBfipbk1ZIxpEgas5JQEESl53
         vz3hVQJS1UEX1NDA/IxeA/JvfT4K8k9SN0UQ7dhlZboqjmAYfTxH7jg0giut43C49YMk
         r1Jw==
X-Forwarded-Encrypted: i=1; AKwUvBzd5GoNMwlu+W+L5Php0G3sCO+x97z2kTuhBkduPqZGPf+MHZKw96BGljXQtzDOkvgIpjicU7GCLLVF@vger.kernel.org
X-Gm-Message-State: APuU4Z/4IRdJml7KqgKJ+fSChtJ0JInYng/28ICSIyqHfs/TFn1gbdJ0
	Kmk3dCSoe95zSQEppPMFkAX9pNRyksndg6P+3yzNEX7TkygHtu6WpUTk
X-Gm-Gg: AYBFou0hsI7MEqMIJDd0X7fTkZU2d8/10MWCX5dKbT6wDnr2gC9mg9Ib1TRsg4VAXAC
	XdKkX0Jm2MWY4kaCmYV1Ia8RaYe3Ikf/S4Va0CjfEdYpyWXrBVrsNNMySzh2UUvVBHJNpRD1A8T
	rTX/fYcCTCGYnFKVYKuCjuEFznw6TY7bnOYABE4nLWydIA0d0hZx0ziacJHrbJ2O/wS0YfVbcjn
	KWXUD8J89pCFdEsTAaH+xLvGbam9+5219oe5OudPHs50X1wkD1aX+3e44bw+fu9VCueHxILf8Qa
	fOky5I8iFWc4aa1cga+UmUjtV4woZ0I9mHyri22gm4tQQFXu7gxgqU7gjNBQBCIsGjcEsZMEWsc
	li9LmOMX0uJuwx2wNhgHZdK/ExKg2H84OPteAH26qKPyKTlxj3LNYMdA1eugt9NVemap0Tbj/un
	lc4LLfiGmmrbjR+mjtuCwT0S3Ktbiy15pfCN1QbwdldB/irJ3ussoIV1ExohYN6ofNqiBbhG8pr
	vqKQSfkwbu8bTmUmMimn5+rkXTMWqmLK5tPVZYnMwtADnc1K9INJKPwHAR4PMxCDv5bZkMFueeZ
	OU2RO2W/tB1yeyBkJJACz1072lOBq3vNbw/Icm022NEqX1ETwi4+nEyvM7A=
X-Received: by 2002:ac8:5ad6:0:b0:536:6488:e7e4 with SMTP id d75a77b69052e-54e12fa003emr7137181cf.13.1793910590737;
        Thu, 05 Nov 2026 12:29:50 -0800 (PST)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54e27502132sm1987361cf.28.2026.11.05.12.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 12:29:50 -0800 (PST)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Cc: Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [BUG] RDMA/rtrs-clt: KASAN use-after-free in rtrs_clt_query
Date: Thu,  5 Nov 2026 15:28:43 -0500
Message-ID: <20261105202939.3104321-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kernel Maintainers,

I hit the following report while testing current upstream kernel:

KASAN: slab-use-after-free in rtrs_clt_query

on commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d (2026-11-03)

The reproducer triggers this report. It uses the supported RTRS path disconnect
and RNBD force unmap_device sysfs interfaces.

To help trigger the bug more reliably, we applied a minimal diagnostic patch
that only adds delays and print statements.

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/5409f0d93ab7414fcb6d97ac799fe28f

For context, I previously reported a related but distinct RTRS client
use-after-free in the same subsystem:
Link: https://lore.kernel.org/linux-rdma/20260921033339.1320291-1-shuangpeng.kernel@gmail.com/

I'm happy to test debug patches or provide additional information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

==================================================================
BUG: KASAN: slab-use-after-free in rtrs_clt_query (drivers/infiniband/ulp/rtrs/rtrs-clt.c:59 drivers/infiniband/ulp/rtrs/rtrs-clt.c:3140)
Read of size 4 at addr ffff88810228d2f8 by task kworker/1:0/24

Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: rtrs_client_wq rtrs_clt_reconnect_work
Call Trace:
<TASK>
dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
kasan_report (mm/kasan/report.c:595)
rtrs_clt_query (drivers/infiniband/ulp/rtrs/rtrs-clt.c:59 drivers/infiniband/ulp/rtrs/rtrs-clt.c:3140)
rnbd_clt_link_ev (drivers/block/rnbd/rnbd-clt.c:691 drivers/block/rnbd/rnbd-clt.c:731)
init_path (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2161 drivers/infiniband/ulp/rtrs/rtrs-clt.c:2677)
rtrs_clt_reconnect_work (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2709)
process_scheduled_works (kernel/workqueue.c:3495 kernel/workqueue.c:3578)
worker_thread (kernel/workqueue.c:3659)
kthread (kernel/kthread.c:436)
ret_from_fork (arch/x86/kernel/process.c:158)
ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
</TASK>

Allocated by task 306 on cpu 1 at 11.590323s:
kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
__kasan_kmalloc (mm/kasan/common.c:409 mm/kasan/common.c:426)
alloc_path (include/linux/slab.h:991 include/linux/slab.h:1312 drivers/infiniband/ulp/rtrs/rtrs-clt.c:1540)
rtrs_clt_open (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2871)
rnbd_clt_map_device (drivers/block/rnbd/rnbd-clt.c:1288 drivers/block/rnbd/rnbd-clt.c:1571)
rnbd_clt_map_device_store (drivers/block/rnbd/rnbd-clt-sysfs.c:612)
kernfs_fop_write_iter (fs/kernfs/file.c:345)
vfs_write (fs/read_write.c:595 fs/read_write.c:687)
ksys_write (fs/read_write.c:739)
do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Freed by task 306 on cpu 1 at 47.089348s:
kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
kasan_save_free_info (mm/kasan/generic.c:584)
__kasan_slab_free (mm/kasan/common.c:264 mm/kasan/common.c:296)
kfree (include/linux/kasan.h:235 mm/slub.c:2780 mm/slub.c:6630 mm/slub.c:6923)
kobject_put (lib/kobject.c:689 lib/kobject.c:720 include/linux/kref.h:65 lib/kobject.c:737)
rtrs_clt_close (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2940)
free_sess (drivers/block/rnbd/rnbd-clt.c:770 drivers/block/rnbd/rnbd-clt.c:786)
rnbd_clt_put_dev (drivers/block/rnbd/rnbd-clt.c:49 drivers/block/rnbd/rnbd-clt.c:62)
rnbd_clt_unmap_device (drivers/block/rnbd/rnbd-clt.c:1723)
rnbd_clt_unmap_dev_store (drivers/block/rnbd/rnbd-clt-sysfs.c:334)
kernfs_fop_write_iter (fs/kernfs/file.c:345)
vfs_write (fs/read_write.c:595 fs/read_write.c:687)
ksys_write (fs/read_write.c:739)
do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Last potentially related work creation:
kasan_save_stack (mm/kasan/common.c:57)
kasan_record_aux_stack (mm/kasan/generic.c:556)
insert_work (kernel/workqueue.c:2356)
__queue_work (kernel/workqueue.c:2546)
queue_work_on (kernel/workqueue.c:2599)
rtrs_clt_close_conns (include/linux/workqueue.h:700 drivers/infiniband/ulp/rtrs/rtrs-clt.c:1963)
rtrs_clt_disconnect_store (drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c:259)
kernfs_fop_write_iter (fs/kernfs/file.c:345)
vfs_write (fs/read_write.c:595 fs/read_write.c:687)
ksys_write (fs/read_write.c:739)
do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

The buggy address belongs to the object at ffff88810228d000
which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 760 bytes inside of
freed 2048-byte region [ffff88810228d000, ffff88810228d800)

Best,
Shuangpeng
