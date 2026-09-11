Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1A73D8903
	for <linux-rdma@vger.kernel.org>; Fri, 11 Sep 2026 23:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789168599; cv=pass; b=m8Bb7649HUeDYyDiMGzQE3228unKGzfgXoer2j5Dcf+WpuZfr2ch1Dw7pzFiN+AXkmM+/veez9FI5cLwvbyV3hv53wVOUR+FXcoOxBUITzal5NWVc25MJy9w5GDI1ZgJkR5lUS4XN4vz6JgzAFtXEo6bj0TpOU2j6bnfwfOtwSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789168599; c=relaxed/simple;
	bh=6BwWUhopNJCVWbvq3kqeWRjr+6+86X4MBPRZIneWh1U=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=LkSYvD0tcOFsAdC/Ag5BK7+eJUEYbSHKGITIOdihcCgkawK6T1T7yHUFOe2FxPWl4bPJFmRYJgu7erOr5VpUJD/e7nYFXkWyLoRAAfQc0Jr7DMPqYIayo4RaHNKpnWyFHZlLbL7X05kxxNRM2BXSbLetOSyqYqiZbIHCdsN6DbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=XPKTPyZj; arc=pass smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="XPKTPyZj"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-8692a8568e9so73217b3a.3
        for <linux-rdma@vger.kernel.org>; Fri, 11 Sep 2026 16:16:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789168597; cv=none;
        d=google.com; s=arc-20260327;
        b=dqBBmVsQXzMZDaINoJEQv93iniUTSnKHjTp9FvLHzqWhntYXZ/1XXApSWtTg8B6+Bc
         IccyKWzBQfWyteRE54lv1P1Rj1bwcLLYntB3AHA82Tszdkn7jT3MtS6WAZ/pxooVWIyA
         7PqvV/f1ZsQ9Ru5fTovD0EjV1FJW0+iXia8pNcHf5Jviq/gsC12sMHSGXubJ30mE/XRV
         KgRZ/YZwI9B7XMQAUCp+uYXjDBYFsZ5Z5dKzwndXD6D3yeUNhLLgfhzbliLgcUVUdWw4
         Lik5XU3VIJqodR82DXP7PkgHVsMI/hAYnVDFGQx5KRdvQTGyZlbIyNK1+W3mzDkFuU4v
         IM0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=RHAsiPxFFkFEmDS8WIqOdADs8MzEVGvc9nFNOzWCuzw=;
        fh=a/wiuUUq9eSRA2EpylXiolqwl3UHrID0zQSmFei3xdc=;
        b=ovI60Vqp2ys5AJjeWjHpLlXcrQlJ1r4APcKPWd/alVyuN6uozHCVJgWYTNlG8FTajr
         QYxnS6u3q51G0/sn2yZLWa/QX9M2MLSEc5y3PDaCHjIXQwDMbTcNlCYK7uLYAlGQzVe+
         KPb3gOvBh/6tNUAHJ23oX8Iap5l6Kmo1u1lK1MrPsX08HjRMQVUGZryw4BjzrAgdWWpL
         5XvpVXfo/OwM6H0whYs6VVHeJTgoOQXhE790+q9HvTuelA4SeP/0m9fkEit4est0P/tJ
         2pRcKg2skYEPv3Kcp53luJOhtd0ByUtRhVGnBfYCt0CU9H00oELeGpe5V6qbmGw/QsCf
         nZ1A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1789168597; x=1789773397; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RHAsiPxFFkFEmDS8WIqOdADs8MzEVGvc9nFNOzWCuzw=;
        b=XPKTPyZjz1XPAHz8+bmo3vkHqkEmN0iSseifgf+77y+4r5fXe/aS4j1cXoezK+zOm2
         io1lb9Bn+wSqpHVJm1VluFIAfr0W986OopZJFfXce7qTHSGgC8hGUWWzUlGb9/cObSpM
         yQ/IIEBAXMIT6sfOBK8OO8AdHJxD322gDImFFM5nL07+W+031gu38GaR/TgdEPiV9dTa
         n5gNF8HrNwv5+SpTk2yW3DH+J1E/G6TXq9naYNXmtmBVaE6tXvqxar9ZPFmT9AzDEa3o
         o6Mq07Q6Twd0XxUPfJNO2UU8FkAqUV/aawrJVwzJCDyZLIXAlRjQRMttlO6E0TjTltzY
         WYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789168597; x=1789773397;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RHAsiPxFFkFEmDS8WIqOdADs8MzEVGvc9nFNOzWCuzw=;
        b=AJXxFBQel3pyaLUxIBs/YYCvvvVknLYB5/mjRaaUYvek84/v/NTHpTG2KC3HRnzzPQ
         92lo1EqKksIfI87BeLy5Hke3G1QYy3tQ5lQOTndkrG/l/PbQSTY4ALeT1njnG3/9QyVH
         9mI6edhjuKXn1QTrt6bxB5OUFb9q0OotIjwuKAXRenpkl9N+/w7EBivOE7Ytek1AITeF
         xKgF0jMcsk8hFS7pcHMFyQKMidOvgnq9Es90E3os95b+9MaEhSvsUcX3Bw6Vh6ODO3V4
         PEScL7y7b36WCw7tDCJUo5bH1gDZ6e5LBnMAHyUO3A92awv8QJOUMecCG5FwJmQzULXh
         dTDQ==
X-Gm-Message-State: AFuF++mMrvrXy7vmuB2z1UtgtxAG+TkFe4BzHBuHhtMu5xtubj1V6sk1
	iR0pFGOjOrLp8X8bpCy40K81NvzYj2kprgZrEKkXRgWNOA7fhZJGqJ9rWhGSJ+hfk3+yuUyysmU
	XuroMYEX0lCIT4PerotXSaAbvRGOT0JDl4Yvzb1uc
X-Gm-Gg: AYBFou0pQI0kEXHZ56slBfTEEZe8PQhky3/AQCP31GzrJDb+8uiXFIvpBAT2RnfhGhp
	YjWjXkBHJp1WwPubIqHA5+Vo0u1uitIMPSpmJLaZjSQLpW/Rp8jBv0B+J+7/759az8cnBB283dZ
	ObKzMomqLwfezOsG/xiUcgaedWLd1ne0NI+rG5Ydd2jjaAGzSxiu8WFOU2UUxMdnQm172y2SsEz
	I83+sIpTW9s77XxA7ovNU6DpCoh7I6ZV85sMwzoGUIG0yyVD4TJ4CoGbUqfVRvZS24O1Gi3X55U
	x+iPs7mqkx5o/mlutJ52dTS8w9xZYB7jhM5pECMqdtFh9pyQqebZL9iEF4tj/HHNj3y++Hbfqcz
	IW5e7njTtJ8Ktes6xsPybVNSUBnACMdydAbbXk1rH
X-Received: by 2002:a05:6a00:2d95:b0:857:72f8:dc91 with SMTP id
 d2e1a72fcca58-86ccb04f878mr386562b3a.18.1789168595667; Fri, 11 Sep 2026
 16:16:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Fri, 11 Sep 2026 16:16:24 -0700
X-Gm-Features: AcwNN1U1BqfZ3_4q72T11xZonFSZXmbZoa8g1klYWNvVGnLSvXjL4uelQBAZjCs
Message-ID: <CA+0ovCg_sG8gaZXXj9zmOrpxRt=8+-x9wvycVNUKwWmMbr6-Yg@mail.gmail.com>
Subject: [BUG] WARNING in rtrs_clt_rdma_cm_handler
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000097b04f065b3d4600"

--00000000000097b04f065b3d4600
Content-Type: text/plain; charset="UTF-8"

Hello,

We are reporting the following crash (reproducer attached):
Linux version 7.3.0-rc2 50d05c7c76c96b90462f24debacca971d2e86713
Build Config: UpstreamAppArmorKASAN (KASAN + UBSAN, panic_on_warn=1)

[   45.983990][   T35] WARNING:
drivers/infiniband/ulp/rtrs/rtrs-clt.c:1688 at
rtrs_clt_rdma_cm_handler+0x19c1/0x2070, CPU#1: kworker/u10:1/35
[   45.991111][   T35] Modules linked in:
[   45.991718][   T35] CPU: 1 UID: 0 PID: 35 Comm: kworker/u10:1 Not
tainted 7.3.0-rc2-00099-g50d05c7c76c9 #1 PREEMPT(full)
[   45.993294][   T35] Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
[   45.994913][   T35] Workqueue: ib_addr process_one_req
[   45.995699][   T35] RIP: 0010:rtrs_clt_rdma_cm_handler+0x19c1/0x2070
[   45.996650][   T35] Code: f8 4c 8b 74 24 10 e9 e3 e9 ff ff e8 99 8c
ea f8 90 0f 0b 90 e9 96 ee ff ff e8 8b 8c ea f8 90 0f 0b 90 eb 14 e8
80 8c ea f8 90 <0f> 0b 90 eb 09 e8 75 8c ea f8 90 0f 0b 90 41 bf ea ff
ff ff e9 c4
[   45.999431][   T35] RSP: 0018:ffffc9000069f6a0 EFLAGS: 00010293
[   46.000310][   T35] RAX: ffffffff88dd1000 RBX: dffffc0000000000
RCX: ffff8881000fcc80
[   46.001070][   T35] RDX: 0000000000000000 RSI: 0000000000000000
RDI: 0000000000000000
[   46.001832][   T35] RBP: ffffc9000069f858 R08: ffffffff90563d7f
R09: 1ffffffff20ac7af
[   46.002598][   T35] R10: dffffc0000000000 R11: fffffbfff20ac7b0
R12: ffff888105cb3280
[   46.003372][   T35] R13: ffff8881006cfa40 R14: ffff88810e55f570
R15: 0000000000000000
[   46.004128][   T35] FS:  0000000000000000(0000)
GS:ffff8881da588000(0000) knlGS:0000000000000000
[   46.005008][   T35] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.005629][   T35] CR2: 0000556db97f6da0 CR3: 0000000105e29000
CR4: 0000000000752ef0
[   46.006369][   T35] PKRU: 55555554
[   46.006712][   T35] Call Trace:
[   46.007032][   T35]  <TASK>
[   46.007319][   T35]  ? __pfx_rtrs_clt_rdma_cm_handler+0x10/0x10
[   46.007890][   T35]  ? __lock_acquire+0x74c/0x2db0
[   46.008353][   T35]  ? do_raw_spin_lock+0x12b/0x2f0
[   46.008824][   T35]  ? rcu_is_watching+0x16/0xb0
[   46.009302][   T35]  ? trace_cm_event_handler+0x81/0x1f0
[   46.009838][   T35]  cma_cm_event_handler+0xac/0x2c0
[   46.010342][   T35]  addr_handler+0x343/0x5b0
[   46.010795][   T35]  ? register_lock_class+0x31/0x2e0
[   46.011294][   T35]  ? __pfx_addr_handler+0x10/0x10
[   46.011802][   T35]  ? lock_acquire+0x115/0x350
[   46.012263][   T35]  process_one_req+0x302/0x550
[   46.012734][   T35]  ? __pfx_addr_handler+0x10/0x10
[   46.013215][   T35]  ? process_scheduled_works+0x94e/0x1900
[   46.013791][   T35]  process_scheduled_works+0xc99/0x1900
[   46.014338][   T35]  ? __pfx_process_scheduled_works+0x10/0x10
[   46.014992][   T35]  ? assign_work+0x3d5/0x5e0
[   46.015448][   T35]  worker_thread+0xa53/0xfc0
[   46.015911][   T35]  kthread+0x38b/0x480
[   46.016313][   T35]  ? __pfx_worker_thread+0x10/0x10
[   46.016811][   T35]  ? __pfx_kthread+0x10/0x10
[   46.017260][   T35]  ret_from_fork+0x514/0xb70
[   46.017741][   T35]  ? __pfx_ret_from_fork+0x10/0x10
[   46.018234][   T35]  ? __switch_to+0xc79/0x1410
[   46.018695][   T35]  ? __pfx_kthread+0x10/0x10
[   46.019145][   T35]  ret_from_fork_asm+0x1a/0x30
[   46.019656][   T35]  </TASK>
[   46.019964][   T35] Kernel panic - not syncing: kernel: panic_on_warn set ...
[   46.020659][   T35] CPU: 1 UID: 0 PID: 35 Comm: kworker/u10:1 Not
tainted 7.3.0-rc2-00099-g50d05c7c76c9 #1 PREEMPT(full)
[   46.021684][   T35] Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
[   46.022641][   T35] Workqueue: ib_addr process_one_req
[   46.023126][   T35] Call Trace:
[   46.023435][   T35]  <TASK>
[   46.023712][   T35]  vpanic+0x56d/0xa60
[   46.024100][   T35]  ? __pfx__printk+0x10/0x10
[   46.024527][   T35]  ? __pfx_vpanic+0x10/0x10
[   46.025023][   T35]  ? is_bpf_text_address+0x292/0x2b0
[   46.025512][   T35]  ? is_bpf_text_address+0x26/0x2b0
[   46.026037][   T35]  panic+0xc5/0xd0
[   46.026386][   T35]  ? __pfx_panic+0x10/0x10
[   46.026804][   T35]  ? ret_from_fork_asm+0x1a/0x30
[   46.027261][   T35]  __warn+0x315/0x4c0
[   46.027633][   T35]  ? rtrs_clt_rdma_cm_handler+0x19c1/0x2070
[   46.028173][   T35]  ? rtrs_clt_rdma_cm_handler+0x19c1/0x2070
[   46.028720][   T35]  __report_bug+0x273/0x580
[   46.029144][   T35]  ? rtrs_clt_rdma_cm_handler+0x19c1/0x2070
[   46.029735][   T35]  ? __pfx___report_bug+0x10/0x10
[   46.030216][   T35]  ? rcu_is_watching+0x16/0xb0
[   46.030665][   T35]  ? trace_contention_end+0x3d/0x140
[   46.031149][   T35]  ? __mutex_lock+0x310/0x1580
[   46.031590][   T35]  ? __lock_acquire+0x74c/0x2db0
[   46.032047][   T35]  ? rtrs_clt_rdma_cm_handler+0x19c1/0x2070
[   46.032587][   T35]  report_bug+0x16b/0x220
[   46.032988][   T35]  ? rtrs_clt_rdma_cm_handler+0x19c1/0x2070
[   46.033541][   T35]  ? rtrs_clt_rdma_cm_handler+0x19c3/0x2070
[   46.034083][   T35]  handle_bug+0x9c/0x200
[   46.034477][   T35]  exc_invalid_op+0x1a/0x50
[   46.034967][   T35]  asm_exc_invalid_op+0x1a/0x20
[   46.035415][   T35] RIP: 0010:rtrs_clt_rdma_cm_handler+0x19c1/0x2070
[   46.036007][   T35] Code: f8 4c 8b 74 24 10 e9 e3 e9 ff ff e8 99 8c
ea f8 90 0f 0b 90 e9 96 ee ff ff e8 8b 8c ea f8 90 0f 0b 90 eb 14 e8
80 8c ea f8 90 <0f> 0b 90 eb 09 e8 75 8c ea f8 90 0f 0b 90 41 bf ea ff
ff ff e9 c4
[   46.037731][   T35] RSP: 0018:ffffc9000069f6a0 EFLAGS: 00010293
[   46.038285][   T35] RAX: ffffffff88dd1000 RBX: dffffc0000000000
RCX: ffff8881000fcc80
[   46.039002][   T35] RDX: 0000000000000000 RSI: 0000000000000000
RDI: 0000000000000000
[   46.039720][   T35] RBP: ffffc9000069f858 R08: ffffffff90563d7f
R09: 1ffffffff20ac7af
[   46.040434][   T35] R10: dffffc0000000000 R11: fffffbfff20ac7b0
R12: ffff888105cb3280
[   46.041149][   T35] R13: ffff8881006cfa40 R14: ffff88810e55f570
R15: 0000000000000000
[   46.041874][   T35]  ? rtrs_clt_rdma_cm_handler+0x19c0/0x2070
[   46.042419][   T35]  ? __pfx_rtrs_clt_rdma_cm_handler+0x10/0x10
[   46.042975][   T35]  ? __lock_acquire+0x74c/0x2db0
[   46.043449][   T35]  ? do_raw_spin_lock+0x12b/0x2f0
[   46.043917][   T35]  ? rcu_is_watching+0x16/0xb0
[   46.044363][   T35]  ? trace_cm_event_handler+0x81/0x1f0
[   46.044927][   T35]  cma_cm_event_handler+0xac/0x2c0
[   46.045397][   T35]  addr_handler+0x343/0x5b0
[   46.045821][   T35]  ? register_lock_class+0x31/0x2e0
[   46.046299][   T35]  ? __pfx_addr_handler+0x10/0x10
[   46.046773][   T35]  ? lock_acquire+0x115/0x350
[   46.047209][   T35]  process_one_req+0x302/0x550
[   46.047649][   T35]  ? __pfx_addr_handler+0x10/0x10
[   46.048113][   T35]  ? process_scheduled_works+0x94e/0x1900
[   46.048638][   T35]  process_scheduled_works+0xc99/0x1900
[   46.049155][   T35]  ? __pfx_process_scheduled_works+0x10/0x10
[   46.049708][   T35]  ? assign_work+0x3d5/0x5e0
[   46.050136][   T35]  worker_thread+0xa53/0xfc0
[   46.050571][   T35]  kthread+0x38b/0x480
[   46.050949][   T35]  ? __pfx_worker_thread+0x10/0x10
[   46.051414][   T35]  ? __pfx_kthread+0x10/0x10
[   46.051844][   T35]  ret_from_fork+0x514/0xb70
[   46.052270][   T35]  ? __pfx_ret_from_fork+0x10/0x10
[   46.052740][   T35]  ? __switch_to+0xc79/0x1410
[   46.053174][   T35]  ? __pfx_kthread+0x10/0x10
[   46.053619][   T35]  ret_from_fork_asm+0x1a/0x30
[   46.054065][   T35]  </TASK>
[   46.054995][   T35] Kernel Offset: disabled
[   46.055551][   T35] Rebooting in 86400 seconds..

Regards,

--00000000000097b04f065b3d4600
Content-Type: application/octet-stream; name="reproducer.c"
Content-Disposition: attachment; filename="reproducer.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mtxkrff40>
X-Attachment-Id: f_mtxkrff40

LyoKICogMjg2LXdhcm5pbmctaW4tcnRycy1jbHQtcmRtYS1jbS1oYW5kbGVyCiAqLwojZGVmaW5l
IF9HTlVfU09VUkNFCiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNs
dWRlIDxzdGRpbnQuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2lu
Y2x1ZGUgPGVycm5vLmg+CiNpbmNsdWRlIDxwdGhyZWFkLmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMu
aD4KI2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4KI2luY2x1ZGUgPHN5cy9pb2N0bC5oPgojaW5jbHVk
ZSA8bmV0aW5ldC9pbi5oPgojaW5jbHVkZSA8YXJwYS9pbmV0Lmg+CiNpbmNsdWRlIDxsaW51eC9u
ZXRsaW5rLmg+CiNpbmNsdWRlIDxuZXQvaWYuaD4KCiNpZm5kZWYgTkVUTElOS19SRE1BCiNkZWZp
bmUgTkVUTElOS19SRE1BIDIwCiNlbmRpZgojZGVmaW5lIFJETUFfTkxfTkxERVYgICAgICAgICAg
ICAgNQojZGVmaW5lIFJETUFfTkxERVZfQ01EX05FV0xJTksgICAgMwojZGVmaW5lIFJETUFfTkxE
RVZfQVRUUl9ERVZfTkFNRSAgMgojZGVmaW5lIFJETUFfTkxERVZfQVRUUl9OREVWX05BTUUgNTEK
I2RlZmluZSBSRE1BX05MREVWX0FUVFJfTElOS19UWVBFIDY1CgpzdGF0aWMgdm9pZCBhcHBlbmRf
bmV0bGlua19zdHJpbmdfYXR0cmlidXRlKGNoYXIgKmJ1ZiwgaW50ICpvZmZzZXQsCgkJCQkJICAg
IHVpbnQxNl90IHR5cGUsIGNvbnN0IGNoYXIgKnZhbHVlKQp7CglpbnQgdmFsdWVfbGVuID0gc3Ry
bGVuKHZhbHVlKSArIDE7CglzdHJ1Y3QgbmxhdHRyICphdHRyID0gKHN0cnVjdCBubGF0dHIgKiko
YnVmICsgKm9mZnNldCk7CgoJYXR0ci0+bmxhX3R5cGUgPSB0eXBlOwoJYXR0ci0+bmxhX2xlbiA9
IE5MQV9IRFJMRU4gKyB2YWx1ZV9sZW47CgltZW1jcHkoYnVmICsgKm9mZnNldCArIE5MQV9IRFJM
RU4sIHZhbHVlLCB2YWx1ZV9sZW4pOwoJKm9mZnNldCArPSBOTEFfQUxJR04oYXR0ci0+bmxhX2xl
bik7Cn0KCnN0YXRpYyB2b2lkIGFkZF9zb2Z0X3JvY2VfZGV2aWNlX292ZXJfbmV0ZGV2KGNvbnN0
IGNoYXIgKmliZGV2X25hbWUsCgkJCQkJICAgICBjb25zdCBjaGFyICpuZXRkZXZfbmFtZSkKewoJ
Y2hhciBidWZbNTEyXTsKCXN0cnVjdCBzb2NrYWRkcl9ubCBiaW5kX2FkZHI7CglzdHJ1Y3Qgbmxt
c2doZHIgKm5saDsKCWludCBuZXRsaW5rX2ZkLCBvZmZzZXQ7CgoJbmV0bGlua19mZCA9IHNvY2tl
dChBRl9ORVRMSU5LLCBTT0NLX1JBVywgTkVUTElOS19SRE1BKTsKCWlmIChuZXRsaW5rX2ZkIDwg
MCkKCQlyZXR1cm47CgltZW1zZXQoJmJpbmRfYWRkciwgMCwgc2l6ZW9mKGJpbmRfYWRkcikpOwoJ
YmluZF9hZGRyLm5sX2ZhbWlseSA9IEFGX05FVExJTks7CgliaW5kKG5ldGxpbmtfZmQsIChzdHJ1
Y3Qgc29ja2FkZHIgKikmYmluZF9hZGRyLCBzaXplb2YoYmluZF9hZGRyKSk7CgoJbWVtc2V0KGJ1
ZiwgMCwgc2l6ZW9mKGJ1ZikpOwoJbmxoID0gKHN0cnVjdCBubG1zZ2hkciAqKWJ1ZjsKCW9mZnNl
dCA9IE5MTVNHX0hEUkxFTjsKCWFwcGVuZF9uZXRsaW5rX3N0cmluZ19hdHRyaWJ1dGUoYnVmLCAm
b2Zmc2V0LAoJCQkJCVJETUFfTkxERVZfQVRUUl9ERVZfTkFNRSwgaWJkZXZfbmFtZSk7CglhcHBl
bmRfbmV0bGlua19zdHJpbmdfYXR0cmlidXRlKGJ1ZiwgJm9mZnNldCwKCQkJCQlSRE1BX05MREVW
X0FUVFJfTElOS19UWVBFLCAicnhlIik7CglhcHBlbmRfbmV0bGlua19zdHJpbmdfYXR0cmlidXRl
KGJ1ZiwgJm9mZnNldCwKCQkJCQlSRE1BX05MREVWX0FUVFJfTkRFVl9OQU1FLCBuZXRkZXZfbmFt
ZSk7CglubGgtPm5sbXNnX2xlbiA9IG9mZnNldDsKCW5saC0+bmxtc2dfdHlwZSA9IChSRE1BX05M
X05MREVWIDw8IDEwKSB8IFJETUFfTkxERVZfQ01EX05FV0xJTks7CglubGgtPm5sbXNnX2ZsYWdz
ID0gTkxNX0ZfUkVRVUVTVCB8IE5MTV9GX0FDSzsKCW5saC0+bmxtc2dfc2VxID0gMTsKCglzZW5k
KG5ldGxpbmtfZmQsIGJ1Ziwgb2Zmc2V0LCAwKTsKCXJlY3YobmV0bGlua19mZCwgYnVmLCBzaXpl
b2YoYnVmKSwgMCk7CgljbG9zZShuZXRsaW5rX2ZkKTsKfQoKI2RlZmluZSBSRE1BX1VTRVJfQ01f
Q01EX0NSRUFURV9JRCAwCiNkZWZpbmUgUkRNQV9VU0VSX0NNX0NNRF9MSVNURU4gICAgNwojZGVm
aW5lIFJETUFfVVNFUl9DTV9DTURfQUNDRVBUICAgIDgKI2RlZmluZSBSRE1BX1VTRVJfQ01fQ01E
X0dFVF9FVkVOVCAxMgojZGVmaW5lIFJETUFfVVNFUl9DTV9DTURfQklORCAgICAgIDIwCiNkZWZp
bmUgUkRNQV9QU19UQ1AgMHgwMTA2CiNkZWZpbmUgUkRNQV9DTV9FVkVOVF9DT05ORUNUX1JFUVVF
U1QgNAoKc3RydWN0IHVjbWFfY29tbWFuZF9oZWFkZXIgeyB1aW50MzJfdCBjbWQ7IHVpbnQxNl90
IGluOyB1aW50MTZfdCBvdXQ7IH07CnN0cnVjdCB1Y21hX2NyZWF0ZV9pZF9yZXF1ZXN0IHsKCXVp
bnQ2NF90IHVpZDsgdWludDY0X3QgcmVzcG9uc2U7IHVpbnQxNl90IHBzOyB1aW50OF90IHFwX3R5
cGU7Cgl1aW50OF90IHJlc2VydmVkWzVdOwp9OwpzdHJ1Y3QgdWNtYV9jcmVhdGVfaWRfcmVzcG9u
c2UgeyB1aW50MzJfdCBpZDsgfTsKc3RydWN0IHVjbWFfYmluZF9yZXF1ZXN0IHsKCXVpbnQzMl90
IGlkOyB1aW50MTZfdCBhZGRyX3NpemU7IHVpbnQxNl90IHJlc2VydmVkOwoJc3RydWN0IHNvY2th
ZGRyX3N0b3JhZ2UgYWRkcjsKfTsKc3RydWN0IHVjbWFfbGlzdGVuX3JlcXVlc3QgeyB1aW50MzJf
dCBpZDsgdWludDMyX3QgYmFja2xvZzsgfTsKc3RydWN0IHVjbWFfY29ubl9wYXJhbSB7Cgl1aW50
MzJfdCBxcF9udW07IHVpbnQzMl90IHFrZXk7IHVpbnQ4X3QgcHJpdmF0ZV9kYXRhWzI1Nl07Cgl1
aW50OF90IHByaXZhdGVfZGF0YV9sZW47IHVpbnQ4X3Qgc3JxOyB1aW50OF90IHJlc3BvbmRlcl9y
ZXNvdXJjZXM7Cgl1aW50OF90IGluaXRpYXRvcl9kZXB0aDsgdWludDhfdCBmbG93X2NvbnRyb2w7
IHVpbnQ4X3QgcmV0cnlfY291bnQ7Cgl1aW50OF90IHJucl9yZXRyeV9jb3VudDsgdWludDhfdCB2
YWxpZDsKfTsKc3RydWN0IHVjbWFfZWNlIHsgdWludDMyX3QgdmVuZG9yX2lkOyB1aW50MzJfdCBh
dHRyX21vZDsgfTsKc3RydWN0IHVjbWFfYWNjZXB0X3JlcXVlc3QgewoJdWludDY0X3QgdWlkOyBz
dHJ1Y3QgdWNtYV9jb25uX3BhcmFtIGNvbm5fcGFyYW07IHVpbnQzMl90IGlkOwoJdWludDMyX3Qg
cmVzZXJ2ZWQ7IHN0cnVjdCB1Y21hX2VjZSBlY2U7Cn07CnN0cnVjdCB1Y21hX2dldF9ldmVudF9y
ZXF1ZXN0IHsgdWludDY0X3QgcmVzcG9uc2U7IH07CnN0cnVjdCB1Y21hX2V2ZW50X3Jlc3BvbnNl
IHsKCXVpbnQ2NF90IHVpZDsgdWludDMyX3QgaWQ7IHVpbnQzMl90IGV2ZW50OyB1aW50MzJfdCBz
dGF0dXM7Cgl1aW50OF90IHBhcmFtWzMwNF07IHVpbnQzMl90IHJlc2VydmVkOyBzdHJ1Y3QgdWNt
YV9lY2UgZWNlOwp9OwoKc3RydWN0IHJ0cnNfbXNnX2Nvbm5fcnNwIHsKCXVpbnQxNl90IG1hZ2lj
OyB1aW50MTZfdCB2ZXJzaW9uOyB1aW50MTZfdCBlcnJub187IHVpbnQxNl90IHF1ZXVlX2RlcHRo
OwoJdWludDMyX3QgbWF4X2lvX3NpemU7IHVpbnQzMl90IG1heF9oZHJfc2l6ZTsgdWludDMyX3Qg
ZmxhZ3M7Cgl1aW50OF90IHJlc2VydmVkWzM2XTsKfTsKI2RlZmluZSBSVFJTX01BR0lDIDB4MUJC
RAojZGVmaW5lIFJUUlNfUFJPVE9fVkVSICgoMiA8PCA4KSB8IDApCgpzdGF0aWMgaW50IHVjbWFf
ZmQgPSAtMTsKCnN0YXRpYyBpbnQgdWNtYV93cml0ZV9jb21tYW5kKHVpbnQzMl90IGNtZCwgdm9p
ZCAqaW4sIHNpemVfdCBpbl9sZW4sCgkJCSAgICAgIHNpemVfdCBvdXRfbGVuKQp7CgljaGFyIGJ1
ZlsxMDI0XTsKCXN0cnVjdCB1Y21hX2NvbW1hbmRfaGVhZGVyICpoZHIgPSAoc3RydWN0IHVjbWFf
Y29tbWFuZF9oZWFkZXIgKilidWY7CgoJaGRyLT5jbWQgPSBjbWQ7CgloZHItPmluID0gaW5fbGVu
OwoJaGRyLT5vdXQgPSBvdXRfbGVuOwoJbWVtY3B5KGJ1ZiArIHNpemVvZigqaGRyKSwgaW4sIGlu
X2xlbik7CglpZiAod3JpdGUodWNtYV9mZCwgYnVmLCBzaXplb2YoKmhkcikgKyBpbl9sZW4pIDwg
MCkKCQlyZXR1cm4gLWVycm5vOwoJcmV0dXJuIDA7Cn0KCnN0YXRpYyB2b2lkICpmYWtlX3J0cnNf
c2VydmVyX2FjY2VwdGluZ196ZXJvX3F1ZXVlX2RlcHRoKHZvaWQgKnVudXNlZCkKewoJc3RydWN0
IHVjbWFfY3JlYXRlX2lkX3JlcXVlc3QgY3JlYXRlX3JlcXVlc3Q7CglzdHJ1Y3QgdWNtYV9jcmVh
dGVfaWRfcmVzcG9uc2UgY3JlYXRlX3Jlc3BvbnNlOwoJc3RydWN0IHVjbWFfYmluZF9yZXF1ZXN0
IGJpbmRfcmVxdWVzdDsKCXN0cnVjdCB1Y21hX2xpc3Rlbl9yZXF1ZXN0IGxpc3Rlbl9yZXF1ZXN0
OwoJc3RydWN0IHNvY2thZGRyX2luICpsaXN0ZW5fYWRkcjsKCgltZW1zZXQoJmNyZWF0ZV9yZXF1
ZXN0LCAwLCBzaXplb2YoY3JlYXRlX3JlcXVlc3QpKTsKCW1lbXNldCgmY3JlYXRlX3Jlc3BvbnNl
LCAwLCBzaXplb2YoY3JlYXRlX3Jlc3BvbnNlKSk7CgljcmVhdGVfcmVxdWVzdC5yZXNwb25zZSA9
ICh1aW50NjRfdCkodWludHB0cl90KSZjcmVhdGVfcmVzcG9uc2U7CgljcmVhdGVfcmVxdWVzdC5w
cyA9IFJETUFfUFNfVENQOwoJaWYgKHVjbWFfd3JpdGVfY29tbWFuZChSRE1BX1VTRVJfQ01fQ01E
X0NSRUFURV9JRCwgJmNyZWF0ZV9yZXF1ZXN0LAoJCQkgICAgICAgc2l6ZW9mKGNyZWF0ZV9yZXF1
ZXN0KSwgc2l6ZW9mKGNyZWF0ZV9yZXNwb25zZSkpKQoJCXJldHVybiBOVUxMOwoKCW1lbXNldCgm
YmluZF9yZXF1ZXN0LCAwLCBzaXplb2YoYmluZF9yZXF1ZXN0KSk7CgliaW5kX3JlcXVlc3QuaWQg
PSBjcmVhdGVfcmVzcG9uc2UuaWQ7CgliaW5kX3JlcXVlc3QuYWRkcl9zaXplID0gc2l6ZW9mKHN0
cnVjdCBzb2NrYWRkcl9pbik7CglsaXN0ZW5fYWRkciA9IChzdHJ1Y3Qgc29ja2FkZHJfaW4gKikm
YmluZF9yZXF1ZXN0LmFkZHI7CglsaXN0ZW5fYWRkci0+c2luX2ZhbWlseSA9IEFGX0lORVQ7Cgls
aXN0ZW5fYWRkci0+c2luX3BvcnQgPSBodG9ucygxMjM0KTsKCWxpc3Rlbl9hZGRyLT5zaW5fYWRk
ci5zX2FkZHIgPSBodG9ubChJTkFERFJfQU5ZKTsKCWlmICh1Y21hX3dyaXRlX2NvbW1hbmQoUkRN
QV9VU0VSX0NNX0NNRF9CSU5ELCAmYmluZF9yZXF1ZXN0LAoJCQkgICAgICAgc2l6ZW9mKGJpbmRf
cmVxdWVzdCksIDApKQoJCXJldHVybiBOVUxMOwoKCW1lbXNldCgmbGlzdGVuX3JlcXVlc3QsIDAs
IHNpemVvZihsaXN0ZW5fcmVxdWVzdCkpOwoJbGlzdGVuX3JlcXVlc3QuaWQgPSBjcmVhdGVfcmVz
cG9uc2UuaWQ7CglsaXN0ZW5fcmVxdWVzdC5iYWNrbG9nID0gMTY7CglpZiAodWNtYV93cml0ZV9j
b21tYW5kKFJETUFfVVNFUl9DTV9DTURfTElTVEVOLCAmbGlzdGVuX3JlcXVlc3QsCgkJCSAgICAg
ICBzaXplb2YobGlzdGVuX3JlcXVlc3QpLCAwKSkKCQlyZXR1cm4gTlVMTDsKCglmb3IgKDs7KSB7
CgkJc3RydWN0IHVjbWFfZ2V0X2V2ZW50X3JlcXVlc3QgZ2V0X2V2ZW50X3JlcXVlc3Q7CgkJc3Ry
dWN0IHVjbWFfZXZlbnRfcmVzcG9uc2UgZXZlbnRfcmVzcG9uc2U7CgkJc3RydWN0IHVjbWFfYWNj
ZXB0X3JlcXVlc3QgYWNjZXB0X3JlcXVlc3Q7CgkJc3RydWN0IHJ0cnNfbXNnX2Nvbm5fcnNwICpj
b25uX3JzcDsKCgkJbWVtc2V0KCZldmVudF9yZXNwb25zZSwgMCwgc2l6ZW9mKGV2ZW50X3Jlc3Bv
bnNlKSk7CgkJZ2V0X2V2ZW50X3JlcXVlc3QucmVzcG9uc2UgPQoJCQkodWludDY0X3QpKHVpbnRw
dHJfdCkmZXZlbnRfcmVzcG9uc2U7CgkJaWYgKHVjbWFfd3JpdGVfY29tbWFuZChSRE1BX1VTRVJf
Q01fQ01EX0dFVF9FVkVOVCwKCQkJCSAgICAgICAmZ2V0X2V2ZW50X3JlcXVlc3QsCgkJCQkgICAg
ICAgc2l6ZW9mKGdldF9ldmVudF9yZXF1ZXN0KSwKCQkJCSAgICAgICBzaXplb2YoZXZlbnRfcmVz
cG9uc2UpKSkKCQkJcmV0dXJuIE5VTEw7CgkJaWYgKGV2ZW50X3Jlc3BvbnNlLmV2ZW50ICE9IFJE
TUFfQ01fRVZFTlRfQ09OTkVDVF9SRVFVRVNUKQoJCQljb250aW51ZTsKCgkJbWVtc2V0KCZhY2Nl
cHRfcmVxdWVzdCwgMCwgc2l6ZW9mKGFjY2VwdF9yZXF1ZXN0KSk7CgkJYWNjZXB0X3JlcXVlc3Qu
aWQgPSBldmVudF9yZXNwb25zZS5pZDsKCQlhY2NlcHRfcmVxdWVzdC5jb25uX3BhcmFtLnZhbGlk
ID0gMTsKCQlhY2NlcHRfcmVxdWVzdC5jb25uX3BhcmFtLnByaXZhdGVfZGF0YV9sZW4gPQoJCQlz
aXplb2Yoc3RydWN0IHJ0cnNfbXNnX2Nvbm5fcnNwKTsKCQljb25uX3JzcCA9IChzdHJ1Y3QgcnRy
c19tc2dfY29ubl9yc3AgKikKCQkJICAgYWNjZXB0X3JlcXVlc3QuY29ubl9wYXJhbS5wcml2YXRl
X2RhdGE7CgkJY29ubl9yc3AtPm1hZ2ljID0gUlRSU19NQUdJQzsKCQljb25uX3JzcC0+dmVyc2lv
biA9IFJUUlNfUFJPVE9fVkVSOwoJCWNvbm5fcnNwLT5xdWV1ZV9kZXB0aCA9IDA7CgkJdWNtYV93
cml0ZV9jb21tYW5kKFJETUFfVVNFUl9DTV9DTURfQUNDRVBULCAmYWNjZXB0X3JlcXVlc3QsCgkJ
CQkgICBzaXplb2YoYWNjZXB0X3JlcXVlc3QpLCAwKTsKCX0KCXJldHVybiBOVUxMOwp9CgpzdGF0
aWMgaW50IGdldF9pcHY0X2FkZHJlc3Nfb2ZfbmV0ZGV2KGNvbnN0IGNoYXIgKm5ldGRldl9uYW1l
LCBjaGFyICpvdXQsCgkJCQkgICAgICBzaXplX3Qgb3V0bGVuKQp7CglzdHJ1Y3QgaWZyZXEgaWZy
OwoJc3RydWN0IHNvY2thZGRyX2luICphZGRyOwoJaW50IHNvY2ssIHJldCA9IC0xOwoKCXNvY2sg
PSBzb2NrZXQoQUZfSU5FVCwgU09DS19ER1JBTSwgMCk7CglpZiAoc29jayA8IDApCgkJcmV0dXJu
IC0xOwoJbWVtc2V0KCZpZnIsIDAsIHNpemVvZihpZnIpKTsKCXN0cm5jcHkoaWZyLmlmcl9uYW1l
LCBuZXRkZXZfbmFtZSwgSUZOQU1TSVogLSAxKTsKCWlmIChpb2N0bChzb2NrLCBTSU9DR0lGQURE
UiwgJmlmcikgPT0gMCkgewoJCWFkZHIgPSAoc3RydWN0IHNvY2thZGRyX2luICopJmlmci5pZnJf
YWRkcjsKCQlpZiAoaW5ldF9udG9wKEFGX0lORVQsICZhZGRyLT5zaW5fYWRkciwgb3V0LCBvdXRs
ZW4pKQoJCQlyZXQgPSAwOwoJfQoJY2xvc2Uoc29jayk7CglyZXR1cm4gcmV0Owp9CgppbnQgbWFp
bih2b2lkKQp7CglwdGhyZWFkX3Qgc2VydmVyX3RocmVhZDsKCWNoYXIgbWFwX2RldmljZV9jb21t
YW5kWzUxMl07CgljaGFyIGRlc3RpbmF0aW9uX2lwWzY0XTsKCWludCBtYXBfZmQ7CgoJYWRkX3Nv
ZnRfcm9jZV9kZXZpY2Vfb3Zlcl9uZXRkZXYoInJ4ZTAiLCAiZXRoMCIpOwoKCXVjbWFfZmQgPSBv
cGVuKCIvZGV2L2luZmluaWJhbmQvcmRtYV9jbSIsIE9fUkRXUik7CglpZiAodWNtYV9mZCA8IDAp
CgkJcmV0dXJuIDE7CgoJcHRocmVhZF9jcmVhdGUoJnNlcnZlcl90aHJlYWQsIE5VTEwsCgkJICAg
ICAgIGZha2VfcnRyc19zZXJ2ZXJfYWNjZXB0aW5nX3plcm9fcXVldWVfZGVwdGgsIE5VTEwpOwoJ
c2xlZXAoMik7CgoJaWYgKGdldF9pcHY0X2FkZHJlc3Nfb2ZfbmV0ZGV2KCJldGgwIiwgZGVzdGlu
YXRpb25faXAsCgkJCQkgICAgICAgc2l6ZW9mKGRlc3RpbmF0aW9uX2lwKSkgIT0gMCkKCQlzdHJj
cHkoZGVzdGluYXRpb25faXAsICIxMC4wLjIuMTUiKTsKCglzbnByaW50ZihtYXBfZGV2aWNlX2Nv
bW1hbmQsIHNpemVvZihtYXBfZGV2aWNlX2NvbW1hbmQpLAoJCSAic2Vzc25hbWU9czAgcGF0aD1p
cDolcyBkZXZpY2VfcGF0aD0vZGV2L251bGwgIgoJCSAiYWNjZXNzX21vZGU9cncgbnJfcG9sbF9x
dWV1ZXM9MCIsIGRlc3RpbmF0aW9uX2lwKTsKCW1hcF9mZCA9IG9wZW4oIi9zeXMvY2xhc3Mvcm5i
ZC1jbGllbnQvY3RsL21hcF9kZXZpY2UiLCBPX1dST05MWSk7CglpZiAobWFwX2ZkIDwgMCkKCQly
ZXR1cm4gMTsKCXdyaXRlKG1hcF9mZCwgbWFwX2RldmljZV9jb21tYW5kLCBzdHJsZW4obWFwX2Rl
dmljZV9jb21tYW5kKSk7CglyZXR1cm4gMDsKfQo=
--00000000000097b04f065b3d4600--
