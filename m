Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E75C314D1F
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 03:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789961654; cv=none; b=eZb9AvcGvRGBYwTYd5M/IiBSZh8lzwKamLNRrrMPTYZXW07zLINAsZ2lMzn7c2fmXalgtalSy9CXFoAJCYoSPlqQnE9Mz6r6S/LIYsMs/uEwhmBc6isUgztQnC0/yO0bf19I/M/AU/XIJBPL9zYxR9CknD7aNB7iCsv4QPhpxFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789961654; c=relaxed/simple;
	bh=WZqsK7BablMg3uJYAL8SiTAmrliVfgZmKZ5qsVpYP6o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X7qZgIB8iQzpjrojkP4B1iMOkjODDU/Y1xm07akX7EdGy25JHOiPiGC332hfkVm3e6cQzmhrlER8KOdaTVV00TayOh1w3QPIyGQqIJneJYjBl4pFcOUcB0LGOdm2FMoBEbhMokPNUVSqtYvHMA6W+sEqCRw83mGWuwRoPx9gMGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IrvVLd+w; arc=none smtp.client-ip=74.125.230.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IrvVLd+w"
Received: by mail-qk2-f41.google.com with SMTP id af79cd13be357-93bfd70b08cso111236685a.2
        for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 20:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789961652; x=1790566452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EzaPtthhhqRzlEoVTWSoFvonGQWTcr1AilXJoZMQT/A=;
        b=IrvVLd+wjYHYcyC0zRM1HV+gPEs35Chff2MnTrh+Tikt6cj1xS0OJg5sYow+aVKsfW
         wPliTM2yxKUBVrCEfiriGQMLtjRrjdwSCyovtMqbVkET3YLaiVGh06muYqaE17c/ROx6
         /bHAknD9+t72Cb+NO1K7CROiP3MMy1BtyaFf3I4Hw8WCib2yuy9/LRbepe1x/oMkWdRv
         7+rcRiQhQRlM2mivrKTGCOqHFy+jTbNggr17ThZTAwMCUz1l9mnTcyjHn3sWzFfBc7fH
         Fqy4nLKkFvSPlkHXo4/fE93mH33t0FbVXhQQ8Whhw24AO3pdVG/VHSyC2fiVFXB8bmt5
         OO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789961652; x=1790566452;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EzaPtthhhqRzlEoVTWSoFvonGQWTcr1AilXJoZMQT/A=;
        b=ONj6yRuImB3XJNlhXF5UHumpYQQQtOqmLwh9vFVvjpmgXkKsq90tjX5x2o3kQ+h/hA
         tq4ibxLjgcHpguRxmIWotKncVOKq85XKN3WFEcGYPu2NTRXnX0QYbcok/x+MJa3cXqQy
         yddilAUVozZh1FbIRQaIAfIkkuQvm16HWE/8V3xqZSvon/Cd7EoYHLahGBcP0srJ65ZF
         q2A5YkJZyriN68hei8uAXskMXAXpoB0wEzUM208Q8kuPuDFQ9YUSbLyfP0EKqBYz3a3v
         yXc8WLWOwOXvKD45IWeq+ec9d8nW+xzmkEqKmI+AYpNniyJViQmI31vIKkChQ6MdnZIj
         n7wQ==
X-Forwarded-Encrypted: i=1; AKwUvBwTuKex5qWjR4agN58ALXE3hzHYWSLwJ/BviF9oIIoD/+wjBMKAGzluRIyKRciA5SgtTF33SOTXcQjT@vger.kernel.org
X-Gm-Message-State: AFuF++nXyAq+2zB7s7na7K+oJpi7XQIHX8juoGnBrGlUHZzKz8Zvc2Lc
	5c3GbRqmUff56SZDksgYTjX3yAWMY5msJRX/e95RcunJNXIF67queKEa
X-Gm-Gg: AYBFou3ewWO7KTlS4L/Tm0Rk5IiMvqttK8MHERk82rDUe4yOjOa0xq7o5bPwZiRMsF2
	el0STDVwAIQ4MoYJUFL8fnxmncOjop0ALBvfhoE0uy6u/P+LedDapas6WJ95DqLlKtCukv3zi7i
	py9vn5vv/vyIyrv5BGJu/F+X2qwWAw67Rik8g3XhfBXQCuVXhcQtewk1Q36ws3Xceb/qIWJyYst
	e6ulUBLsNSIKdPUi7+TLQbhBTd5IZfDB+C7DgiJG4jNDG5nuMSA1h3lL9hf03MhmAWcUy2b49TE
	NmI5yYB3Olx/PdpmTf/g6se5z4pZiSayK4S7tYzX3Wj1F3iP/BSw7EgF4GodYvVIxkJH1yfkRCf
	/saYORJbk9lBY2dNkUAxEHSLY5iB5EWk4IZNzyyY2+b4iAiRqqzv8ofhr6+k662RuEM/XHAiMMu
	9CH4sRaK9ICSxK8EW2rqPR3omyeNp6bUqN6tF6KcLTJTw2+cuhYb2Yes0ANJq+3PslRo+8jLACL
	HW7eSzM6UNtLOqksgRB6qWCJ197
X-Received: by 2002:a05:620a:600c:b0:939:a834:98f2 with SMTP id af79cd13be357-93bf5524001mr917952985a.15.1789961651826;
        Sun, 20 Sep 2026 20:34:11 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93beda707c2sm549277685a.16.2026.09.20.20.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 20:34:11 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] RDMA/rtrs-clt: race between close_work submission and synchronous close
Date: Sun, 20 Sep 2026 23:33:36 -0400
Message-ID: <20260921033339.1320291-1-shuangpeng.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kernel Maintainers,

I hit the following report while testing current upstream kernel:

KASAN: slab-use-after-free in rtrs_clt_stop_and_destroy_conns

on commit: 93f51579e7df248780214094418f205253383cc5 (2026-09-20)

To help trigger the bug more reliably, we applied a minimal diagnostic patch
that only adds delays and print statements.

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/1b0782d283051b34df6548d387be90a6

I'm happy to test debug patches or provide additional information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[   86.996512] ==================================================================
[   86.996866] BUG: KASAN: slab-use-after-free in rtrs_clt_stop_and_destroy_conns (./include/linux/instrumented.h:82 ./include/linux/atomic/atomic-instrumented.h:32 drivers/infiniband/ulp/rtrs/rtrs-clt.c:2237)
[   86.996866] Read of size 4 at addr ffff8881038672fc by task kworker/0:0/9
[   86.996866]
[   86.999871] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   86.999871] Workqueue: rtrs_client_wq rtrs_clt_close_work
[   86.999871] Call Trace:
[   87.001599]  <TASK>
[   87.001599]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[   87.001599]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
[   87.001599]  kasan_report (mm/kasan/report.c:595)
[   87.001599]  kasan_check_range (mm/kasan/generic.c:? mm/kasan/generic.c:200)
[   87.001599]  rtrs_clt_stop_and_destroy_conns (./include/linux/instrumented.h:82 ./include/linux/atomic/atomic-instrumented.h:32 drivers/infiniband/ulp/rtrs/rtrs-clt.c:2237)
[   87.001599]  rtrs_clt_close_work (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2364)
[   87.001599]  process_scheduled_works (kernel/workqueue.c:3396 kernel/workqueue.c:3479)
[   87.001599]  worker_thread (kernel/workqueue.c:3560)
[   87.001599]  kthread (kernel/kthread.c:436)
[   87.001599]  ret_from_fork (arch/x86/kernel/process.c:158)
[   87.001599]  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
[   87.001599]  </TASK>
[   87.001599]
[   87.001599] Allocated by task 1 on cpu 1 at 34.840929s:
[   87.001599]  kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
[   87.001599]  __kasan_kmalloc (mm/kasan/common.c:398 mm/kasan/common.c:415)
[   87.001599]  alloc_path (./include/linux/slab.h:991 ./include/linux/slab.h:1312 drivers/infiniband/ulp/rtrs/rtrs-clt.c:1544)
[   87.001599]  rtrs_clt_open (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2870)
[   87.001599]  rnbd_clt_map_device (drivers/block/rnbd/rnbd-clt.c:1268 drivers/block/rnbd/rnbd-clt.c:1551)
[   87.001599]  rnbd_clt_map_device_store (drivers/block/rnbd/rnbd-clt-sysfs.c:612)
[   87.001599]  kernfs_fop_write_iter (fs/kernfs/file.c:345)
[   87.001599]  vfs_write (fs/read_write.c:595 fs/read_write.c:687)
[   87.001599]  ksys_write (fs/read_write.c:739)
[   87.001599]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[   87.001599]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   87.001599]
[   87.001599] Freed by task 1 on cpu 1 at 56.591404s:
[   87.001599]  kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
[   87.001599]  kasan_save_free_info (mm/kasan/generic.c:584)
[   87.001599]  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
[   87.001599]  kfree (./include/linux/kasan.h:235 mm/slub.c:2748 mm/slub.c:6508 mm/slub.c:6801)
[   87.001599]  kobject_put (lib/kobject.c:689 lib/kobject.c:720 ./include/linux/kref.h:65 lib/kobject.c:737)
[   87.001599]  rtrs_clt_close (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2933)
[   87.001599]  free_sess (drivers/block/rnbd/rnbd-clt.c:754 drivers/block/rnbd/rnbd-clt.c:766)
[   87.001599]  rnbd_clt_put_dev (drivers/block/rnbd/rnbd-clt.c:48 drivers/block/rnbd/rnbd-clt.c:61)
[   87.001599]  rnbd_clt_unmap_device (drivers/block/rnbd/rnbd-clt.c:1703)
[   87.001599]  rnbd_clt_unmap_dev_store (drivers/block/rnbd/rnbd-clt-sysfs.c:334)
[   87.001599]  kernfs_fop_write_iter (fs/kernfs/file.c:345)
[   87.001599]  vfs_write (fs/read_write.c:595 fs/read_write.c:687)
[   87.001599]  ksys_write (fs/read_write.c:739)
[   87.001599]
[   87.001599] Last potentially related work creation:
[   87.001599]  kasan_save_stack (mm/kasan/common.c:57)
[   87.001599]  kasan_record_aux_stack (mm/kasan/generic.c:556)
[   87.001599]  insert_work (kernel/workqueue.c:2272)
[   87.001599]  __queue_work (kernel/workqueue.c:2448)
[   87.001599]  queue_work_on (kernel/workqueue.c:2501)
[   87.001599]  rtrs_clt_close_conns (./include/linux/workqueue.h:700 drivers/infiniband/ulp/rtrs/rtrs-clt.c:1967)
[   87.001599]  rtrs_clt_rdma_cm_handler (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2063)
[   87.001599]  cma_cm_event_handler (drivers/infiniband/core/cma.c:2181)
[   87.001599]  cma_process_remove (drivers/infiniband/core/cma.c:5313 drivers/infiniband/core/cma.c:5346)
[   87.001599]  cma_remove_one (drivers/infiniband/core/cma.c:5453)
[   87.001599]  remove_client_context (drivers/infiniband/core/device.c:810)
[   87.001599]  disable_device (drivers/infiniband/core/device.c:1325)
[   87.001599]  __ib_unregister_device (drivers/infiniband/core/device.c:1571)
[   87.001599]  ib_unregister_device_and_put (drivers/infiniband/core/device.c:1636)
[   87.001599]  nldev_dellink (drivers/infiniband/core/nldev.c:1902)
[   87.001599]  rdma_nl_rcv (drivers/infiniband/core/netlink.c:? drivers/infiniband/core/netlink.c:239 drivers/infiniband/core/netlink.c:259)
[   87.001599]  netlink_unicast (net/netlink/af_netlink.c:1338 net/netlink/af_netlink.c:1364)
[   87.001599]  netlink_sendmsg (net/netlink/af_netlink.c:1919)
[   87.001599]  __sock_sendmsg (net/socket.c:800 net/socket.c:815)
[   87.001599]  __sys_sendto (net/socket.c:2281)
[   87.001599]  __x64_sys_sendto (net/socket.c:2288 net/socket.c:2284 net/socket.c:2284)
[   87.001599]  do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
[   87.001599]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   87.001599]
[   87.001599] The buggy address belongs to the object at ffff888103867000
[   87.001599]  which belongs to the cache kmalloc-2k of size 2048
[   87.001599] The buggy address is located 764 bytes inside of
[   87.001599]  freed 2048-byte region [ffff888103867000, ffff888103867800)
[   87.001599] ==================================================================


Best,
Shuangpeng
