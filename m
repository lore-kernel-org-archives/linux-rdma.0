Received: from mail-wr2-f9.google.com (mail-wr2-f9.google.com [74.125.225.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9233E44EC
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 09:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788428805; cv=none; b=VjITn/VbzsJ3O3dTkV5h1Mf7wfRj52uGrjZ7cLom8tan8sFHH73+j75Ju1hSZP1+sH1/zDenw9eezG1n7FKylaFd+nU1HBemskaIBzKC8uem6yX0IDooTgbg8DdeOvLvMjIUEEHINPSdjMVH8WatwyTcG9RI5/OCB7tZ2fXgtTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788428805; c=relaxed/simple;
	bh=Xje6CB80knQSh0BmuBoyirOUDBHjs4FDvxGmtjWfOsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azBC8jaD6WfkT10CIHo8uyZdv6UrIm4gVuDB44TtwXObtaXkpCP+pdoz5fjZ3ASfTZSmQRObatRYeglZbqgZYdKqHcil8F17Bv4wRJAZRaIq8Ky5ZVl36OR2Yo9BuB4IFvGMsnne0D2JabZU003Hx9DO92RC58bcWy9NlBnX4j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZU2khuc; arc=none smtp.client-ip=74.125.225.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZU2khuc"
Received: by mail-wr2-f9.google.com with SMTP id ffacd0b85a97d-485850cf4deso24419f8f.1
        for <linux-rdma@vger.kernel.org>; Thu, 03 Sep 2026 02:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788428802; x=1789033602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zTD3f7WSa83oQh+rRf1K+vKqXai+5amvlUjiaAlNShM=;
        b=mZU2khucLNqW/LZjOgOpYVjQzkZswF0vwbCpd1pVYFQoairGo0mecW/7akJQZpGQGA
         8Bog/cgwSlk/5u34dcgJXPDuI42I+FIergmT2BUsZYFviUzf+b5ZyfQFjHZyUghyD0UF
         SOr8NG3ZzgU/0trmo97HFpblB9FaaFKfBbvV2Q5IeYuP+B7DkeOtE4TdcEeQBRNdkJwP
         9fcOVLROUDZJw7XnJeyrzixmYNMYBlObEMy2zZgGWywTWSg7QMcGgVcw5vm8DLzPHbtf
         Ctp/Vmb1Be6AIVysA6uYwDAFCCzgglUhtjE7K3t3bxARZ8MpHtQ/8j/oBMyC5U/m3idt
         TMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788428802; x=1789033602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zTD3f7WSa83oQh+rRf1K+vKqXai+5amvlUjiaAlNShM=;
        b=aLPuipeMvM7KfjxSeSeev28kWolg7pZfrPovBLJvfzU3X28bW/OUUNO1HQTyM9iGUc
         XaUwOvv1pN2zKzN/GIJ/rUJVZVoTSg26PAIGo4JvbRLkjFU6cmpu9pl37XBxIEfn+Xfy
         e5V5lzqLMv80l6UfVqVPPCQhYGjgYxWIeLH9dLkq0YdciqT0FMGYwB3acRMPzOo8a46O
         gPp+Bocv0qiJUGcNVNKJVtKcDJsl9q4FaBHUoFhbVPs7t1FY4HDOqYOFUmAiAOdRZYdy
         8O7gGmsEkAMu2lARadoWF7f1faaeYYpyswZ0uS93LX3+XlMrrZ1BCEqSNFkPprTGZSzl
         j0Zw==
X-Forwarded-Encrypted: i=1; AKwUvByIvMooG7ycj1ya+LKBgmEF2f/EoGNgAgJFkD5cU9EGvK3hkMBY2sM7jcYLiYSWuljBVxzPawHD0FyM@vger.kernel.org
X-Gm-Message-State: AFuF++kq8PAJWiHvxmLw1xHDYldNpz7B9cJKmgQE7xFDQ0tDp13pIrAg
	qX0jFbkQRk6DZJwp8q4q+PCyQXWG8JfpkPsM1P4AbTey2NLmCS5eMLJ6
X-Gm-Gg: AYBFou3PoFCRM+5QDmDg2gbPU3hJoQyKW16Tbs5tfLSt2GKoWKu5qLVf7Y6B/o42MM/
	wxJJsaLKNzdmxXDl1Bto561fRXmrBiaAf+PWr03OjjHXIdE+Ziw8Frr3LnX2g0QInbvqlCgtVWf
	88Gs2PTqJsO1rEpwvFqjqDfNDGwfqUSblBfHj4preC3LnXdlVPpelAjzFCcqWscuvqlJienndcH
	n+fHI8ZzVNZqKytGbusMbSmDgH/4/U2UGV9rDYje+HgbDq17bAEd0ZVK5TOdy1QW3PHlpMaYkPn
	sH9AYlWtJhm1O+qkrt6gtdB9rCA5pf5so7j2O+e2nEYV8/ebqZg894H3EkgXlFc1Aq/GvgYpaP8
	wXIWCm8bMioUiEShkUE/qbf2x5JL0YiunCa0q48IrDhL3l3JJqgaE7hXqFZcaUhZgGfcYR1hOAH
	w9FUX9m+UTYOuyFq/u0I6A1zf9C0IBlP+k0+mYi34YRt0tT4aF1ow54iWnK8YJWN7N29Ywl8Zm8
	FZI
X-Received: by 2002:adf:ed0f:0:b0:482:e12b:b3be with SMTP id ffacd0b85a97d-48488f07d79mr16491507f8f.12.1788428801401;
        Thu, 03 Sep 2026 02:46:41 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.216.238])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448ed3840sm13330407f8f.17.2026.09.03.02.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 02:46:40 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: leon@kernel.org
Cc: jgg@ziepe.ca,
	parav@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/core: Fix use-after-free when netns exit races compat dev removal
Date: Thu,  3 Sep 2026 12:46:25 +0300
Message-ID: <20260903094625.18465-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902075653.GS24140@unreal>
References: <20260902075653.GS24140@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Please don't trim kernel panic logs. Please post the full output,
> including the steps required to reproduce the issue.

sure,

-----------------------------------------------------------------------------
  i=1
  while [ "$i" -le 200 ]; do
  	dev="rxed$i"

  	unshare -n /bin/sh -c "
  		ip link add ${dev} type dummy || exit 1
  		ip link set ${dev} up || exit 1
  		ip addr add 198.51.100.1/24 dev ${dev} || exit 1
  		rdma link add rxe${i} type rxe netdev ${dev} || exit 1
  		sleep 0.2
  		ip link set ${dev} netns 1 || exit 1
  	" || echo "iteration $i failed"

  	sleep 0.05
  	ip link del "$dev" 2>/dev/null
  	i=$((i + 1))
  done
-----------------------------------------------------------------------------
Run in a qemu guest with -enable-kvm.

-----------------------------------------------------------------------------

[   50.325096] ==================================================================
[   50.325099] BUG: KASAN: slab-use-after-free in kobject_uevent_env+0xb6f/0xc80
[   50.325118] Read of size 8 at addr ffff8881084d0250 by task kworker/u32:1/62
[   50.325120] 
[   50.325123] CPU: 3 UID: 0 PID: 62 Comm: kworker/u32:1 Not tainted 7.3.0-rc1 #1 PREEMPT(lazy) 
[   50.325126] Hardware name: QEMU Ubuntu 26.04 PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
[   50.325128] Workqueue: ib-unreg-wq ib_unregister_work
[   50.325133] Call Trace:
[   50.325134]  <TASK>
[   50.325135]  dump_stack_lvl+0x5d/0x80
[   50.325140]  print_report+0x153/0x4b1
[   50.325143]  ? kobject_uevent_env+0xb6f/0xc80
[   50.325145]  ? __virt_addr_valid+0x221/0x4c0
[   50.325148]  ? kobject_uevent_env+0xb6f/0xc80
[   50.325150]  kasan_report+0xe4/0x1a0
[   50.325153]  ? kobject_uevent_env+0xb6f/0xc80
[   50.325155]  ? __pfx_device_namespace+0x10/0x10
[   50.325159]  kobject_uevent_env+0xb6f/0xc80
[   50.325161]  device_del+0x737/0xc10
[   50.325164]  ? __pfx_device_del+0x10/0x10
[   50.325166]  ? __kobject_del+0xcb/0x310
[   50.325168]  disable_device+0x1ad/0x230
[   50.325169]  ? __pfx_disable_device+0x10/0x10
[   50.325172]  __ib_unregister_device+0x229/0x3f0
[   50.325174]  ? process_one_work+0x790/0x1630
[   50.325177]  ib_unregister_work+0x14/0x30
[   50.325178]  process_one_work+0x8e1/0x1630
[   50.325181]  ? __pfx_process_one_work+0x10/0x10
[   50.325183]  ? lock_acquire+0x18c/0x300
[   50.325186]  ? lock_is_held_type+0x87/0xf0
[   50.325189]  worker_thread+0x4af/0xd20
[   50.325192]  ? __pfx_worker_thread+0x10/0x10
[   50.325193]  kthread+0x2ce/0x3a0
[   50.325195]  ? _raw_spin_unlock_irq+0x23/0x40
[   50.325199]  ? __pfx_kthread+0x10/0x10
[   50.325200]  ret_from_fork+0x520/0x770
[   50.325203]  ? __pfx_ret_from_fork+0x10/0x10
[   50.325205]  ? __switch_to+0x58a/0xf60
[   50.325207]  ? __pfx_kthread+0x10/0x10
[   50.325209]  ret_from_fork_asm+0x1a/0x30
[   50.325212]  </TASK>
[   50.325213] 
[   50.325213] Allocated by task 1409:
[   50.325215]  kasan_save_stack+0x30/0x50
[   50.325217]  kasan_save_track+0x14/0x30
[   50.325218]  __kasan_kmalloc+0x7f/0x90
[   50.325221]  __kmalloc_cache_noprof+0x223/0x510
[   50.325224]  uevent_net_init+0xcf/0x2f0
[   50.325225]  ops_init+0x185/0x560
[   50.325228]  setup_net+0xf7/0x320
[   50.325229]  copy_net_ns+0x225/0x400
[   50.325231]  create_new_namespaces+0x358/0x9e0
[   50.325234]  unshare_nsproxy_namespaces+0x9c/0x140
[   50.325239]  ksys_unshare+0x4dd/0x770
[   50.325241]  __x64_sys_unshare+0x2f/0x50
[   50.325243]  do_syscall_64+0x106/0x5f0
[   50.325245]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   50.325248] 
[   50.325249] Freed by task 12:
[   50.325250]  kasan_save_stack+0x30/0x50
[   50.325251]  kasan_save_track+0x14/0x30
[   50.325252]  kasan_save_free_info+0x3b/0x70
[   50.325254]  __kasan_slab_free+0x47/0x70
[   50.325256]  kfree+0x1b3/0x550
[   50.325257]  ops_undo_list+0x273/0x8c0
[   50.325259]  cleanup_net+0x3b3/0x720
[   50.325261]  process_one_work+0x8e1/0x1630
[   50.325262]  worker_thread+0x4af/0xd20
[   50.325264]  kthread+0x2ce/0x3a0
[   50.325265]  ret_from_fork+0x520/0x770
[   50.325267]  ret_from_fork_asm+0x1a/0x30
[   50.325269] 
[   50.325269] The buggy address belongs to the object at ffff8881084d0240
[   50.325269]  which belongs to the cache kmalloc-32 of size 32
[   50.325271] The buggy address is located 16 bytes inside of
[   50.325271]  freed 32-byte region [ffff8881084d0240, ffff8881084d0260)
[   50.325273] 
[   50.325273] The buggy address belongs to the physical page:
[   50.325275] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881084d0c80 pfn:0x1084d0
[   50.325277] flags: 0x200000000000200(workingset|node=0|zone=2)
[   50.325279] page_type: f5(slab)
[   50.325282] raw: 0200000000000200 ffff888100042780 ffffea000427e690 ffffea0004039fd0
[   50.325284] raw: ffff8881084d0c80 000000000040002a 00000000f5000000 0000000000000000
[   50.325285] page dumped because: kasan: bad access detected
[   50.325286] 
[   50.325286] Memory state around the buggy address:
[   50.325287]  ffff8881084d0100: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
[   50.325288]  ffff8881084d0180: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
[   50.325289] >ffff8881084d0200: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
[   50.325290]                                                  ^
[   50.325291]  ffff8881084d0280: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
[   50.325292]  ffff8881084d0300: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
[   50.325293] ==================================================================
