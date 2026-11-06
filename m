Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793940136;
	b=tvNNMYCVOJR/18YOQ8htc+UaNunCtZ1KVizEZKIWepNHN/4i1Imgb5tLvKF0mivh+jzH
	 NgjkGgOIIs34K+bxkQoMPSHUigwyxYC1eWqxuSu+hf5ApCzI+Zy7RA1XnZEGY2hlfIfL0
	 QNoQDb0kYYtZhlOBWik5pAZLgaXibzrDn4zUxx71iM5QMLYHV0AEfcI/VqxfxCn+QWPaB
	 +RFLv10pHL6UhIVa3bLHxQb1JYNlbBnFQ/E2PHoJgS2Xs138Z0IgeLvCdCa/We21/Yuu7
	 9YR/ptEQxAdy8udYyePY3XkIoT6VDenq3GxeN8euZscPVGLN5wk+uAO+QSIKv7EBgJw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793940136;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=QTs4vTupvqWxMsqwlvyZzgzWqvxQfTxYSz2VzcLGV4I=;
	b=FAK2ydSbXN/Akzd3cIWh+tynbXUQyDWP+pxpc7krlRojdJJ4IOt6bsD12zZQTyDggPNv
	 E4CB2BD2stNJRRgo6ff8RQlJf9F+FeHILEOjAFMX+SsSuhynOIOBeeEdwkCIRmGflfMF2
	 QZHHBDUY+dJ+jCBLFCfAzg21hSPauKIZodjhEfIst3yMrg6g9oC8xy8yrX8nfrqGGdeHB
	 ZcZFAQUo1nAFSLyeCme5+bJi0U6bmWqgWcymsT1yI/+7NlxOWE3eJoIWHew7RKPJmm6OD
	 aXsuyeNGJ4okwtbwgpaL0GoFUV6YTOf52IUD9p8VUi/S5HcYNwq0D8nMqpQuQWK4RHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xSJbQW+y;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C773606A328
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 04:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C773606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xSJbQW+y
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3acb1224533so15592a91.2
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 20:42:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793940135; cv=none;
        d=google.com; s=arc-20260327;
        b=IoYduEHqb2ZJWGFJfP/Fp2qkVWyQh/z/mTUoIkTsfLF+O07afY/XXPgRFhJm2+f3P0
         AnMYL+hcOhuIz/Sc97Bu2pefZIyr7hZC67okbkOIrCgo5eDaIqRnfikfoPy5I+IWi8qP
         0T97pimkjJyc6GhNc9Vw1fOHavNBOePDy3NCumE5cbPeq/rRsnDte+6b5nFciLwCPXZe
         HVrSSzMWBbesBspZEkWcxB1jVH6iKVkmy4R+vuOYjDp4nHgs+46I+BoaLSPMmXGfbfif
         O2rIDW4Fq9eysu26tVuj+QPH5W5bPmsTy/u+3450WmfOPNxPTlfSfNKdTkJVZJllG2yI
         lG0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QTs4vTupvqWxMsqwlvyZzgzWqvxQfTxYSz2VzcLGV4I=;
        fh=gNYuQMkZNjKlkEBVAqRCn0SNZn8T0X87Y4ZxP/a8XSo=;
        b=LQNlC16Ncx//RcfudlY5hM22JByQxKGIVuMiNMr40JU42HQNcQI+BdlCOjoaDOVBrB
         YIyvn3UCfNC2tno+WS0IezF+bQKTJxQmQWXFIxhQBnIV9qwZLVGBkMpSn66MA8LYwPQN
         WqSELcsRXfONuPwERxqBpmQ/hNJhIdPVMcRHKbhfKRgzijB15nPomIQpENJvflrU9rNN
         tokTTvfV41q62TU0+KaNqMmdWUqbIck4hfxPUSk3yduUGH87MVK6VxQjsx0u4Y6GTo5/
         +UMPlLIJq8lct333nC0FrLRqXQ0y7UVocWSTV6Pg97KylZtOgi7oMIPORFlnXnMO1H2q
         KefQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793940135; x=1794544935; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QTs4vTupvqWxMsqwlvyZzgzWqvxQfTxYSz2VzcLGV4I=;
        b=xSJbQW+yMcQDaq4kikU8sScKlQBv/8ygZhix2c5CGD5CtMbfBcudbI9nrQe64cPc38
         842bYXTG+ZmLPgZJmYnrMd/z6S11rjd/PPT1N/QSOKsPySioIqGQlG530Yt/s77xw9Fo
         n+uB3sWRR/U/FY3E5xpCjtwg4TtGQGKDMpTd+EX/8S0MdodcKefqy9rgEp2RwXJ0s++Q
         Ytkhnyo5fvCw8nszS5ULJL8vFjP7qmVUqfG8i8i66KWuKHEjSiT9pv607lG5iF8Gps8v
         tmhNIfpWgSOenEwjnVSKgNy+ZsDvPDC6alyU1bJw2i79i7o39xZ6KndAkyNCgRFTZ+07
         RUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793940135; x=1794544935;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QTs4vTupvqWxMsqwlvyZzgzWqvxQfTxYSz2VzcLGV4I=;
        b=vA3U3TcWwJuQvTZNANYJSQdgHv3PPcotLTYJe+8SRIcWP7EvLk3Qs2y9qHiZTOcfSH
         /aAEfJzZ1Tto+zQQOzFXOxH1eBe3a0NTVq5pMmuda+/2jZ5tPibWbwp8661wld+Y/h7y
         HYzXdBwxcduJjKvCpMDqhl5V5lUnSH8QU6WNG3kGlp5hwvrFpBFuT/CsAbn8yciEa4gB
         2njNe2M7ggzWtj9K0E8pGEC3S67blM1Cs+UD+5sTQHdnhcvFmVgIO92ce8Fmrd4F+X4+
         UmPO9OO+r1kig187S5vL9JLRiEZaB62bvcU3BKmyeljugdXBLEcv4zg0Y2eVMrVSiMqG
         hidQ==
X-Forwarded-Encrypted: i=1; AL+hErHzknmGU9YmfLl7fL/7keC099X8aih9CRcA4dAVmciQR3q1f8L+fP173FrMSoRABudlhZBdRsYGumS2@vger.kernel.org
X-Gm-Message-State: APuU4Z+CC5q/k7Lydr8MY/Bq10Tx7WvZ1frvfwuXN2uycYqI4vmrCkeL
	t4nd/iEyMSnP5SBYSX8eeK8xzlu3SqBWKwCV4FzX6VVLdfNL+bwJiS1dYOgU45VNYbvjIbde29d
	5Aa372BIPqsS+2dB7Y1fOALahY/m8XR4AoLkPRAc=
X-Gm-Gg: AYBFou0x62wRVuvn/7Fr604wt//FN6+U3Dj2gy5FHSDhDsTO2XbeIOiyzwFqMv+KdoZ
	fQWOHGvQN3VzYIgXWK9dapk6A+U1U4BU1ts1e7OfFEunmtH++rz7BIn//ohXq8bptZ/0de+u1+O
	g3wYqlUR1UfFomQZIfGqjLp0VFCg7laPel64MLWe/HQVvETcqcp3THncEqLivxa7x34JI//oM08
	hzM9wyZVVyPY14osxdhB2SW5p5UQvkGRdDCnBGvkvLNxZhOUTQPrHqBi6z/oNUsyIuSAWgS5K+q
	onWsSSeHFMmMnm18NbWFYdNe+gtHsve+H9kkkYN4bInru3tytfIUTNOcD8SiVGbH+LC0zv6BZVq
	Qvq9pHfCe5AD8vJQXpwwFk7o2eXlAKvrpbuPD5Q==
X-Received: by 2002:a17:90b:2885:b0:3ab:a188:b898 with SMTP id
 98e67ed59e1d1-3b0db63ac4amr2074099a91.2.1793940135388; Thu, 05 Nov 2026
 20:42:15 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105042922.14733-1-lui2012qwq@gmail.com> <20261105193800.GJ8298@unreal>
In-Reply-To: <20261105193800.GJ8298@unreal>
From: Chengyu Liu <lui2012qwq@gmail.com>
Date: Fri, 6 Nov 2026 12:42:03 +0800
X-Gm-Features: AclHuK_ArmGVvjRBV7DbYWGe2-JE0WOUiMsUMiRl-IpTOTrxPIlTDbw0JxNPQY0
Message-ID: <CAE=Q7=7YhDjSS04b0FJh52H2i4zeiEyBHVSCvZzDYFvW==rH7w@mail.gmail.com>
Subject: Re: [PATCH v3] RDMA/ipoib: cancel the AH reaper synchronously on teardown
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 05, 2026, Leon Romanovsky wrote:
> Please add full dmesg kernel stack here.

Full dmesg of the crash below.
The reaper escaped the teardown, and its timer fires exactly one
second later:

How to reproduce : rxe devices presented as IB so stock ib_ipoib
attaches; churn ~500 AHs into dead_ahs via static neighbors; then
RDMA_NLDEV_CMD_DELLINK the rxe device timed against the reaper's
per-second run - when the running callback has passed the STOP_REAPER
check but not yet re-armed, the cancel misses it and the re-arm lands
on the dead workqueue.  The stock test->re-arm gap is a handful of
instructions, so the PoC kernel widens it with a module parameter
(200us in the run below) to make the hit deterministic.  The
measured stock timing (reaper walk 20-160us once a second, DELLINK
to ipoib_stop_ah_reaper ~3.9ms) is in the patch's reproducer
section.

    [  729.356910]
==================================================================
    [  729.356921] BUG: KASAN: use-after-free in
__run_timer_base.part.0+0x80c/0x900
    [  729.357095] Write of size 8 at addr ffff888021088628 by task swapper/0/0
    [  729.357097]
    [  729.357113] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
7.3.0-rc7-00032-g0fcb05b72344-dirty #9 PREEMPT(lazy)
    [  729.357116] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
    [  729.357133] Call Trace:
    [  729.357180]  <IRQ>
    [  729.357196]  dump_stack_lvl+0x55/0x70
    [  729.357375]  print_report+0x10d/0x5d0
    [  729.357426]  ? __run_timer_base.part.0+0x80c/0x900
    [  729.357428]  kasan_report+0x96/0xd0
    [  729.357430]  ? __run_timer_base.part.0+0x80c/0x900
    [  729.357433]  __run_timer_base.part.0+0x80c/0x900
    [  729.357436]  ? __pfx___run_timer_base.part.0+0x10/0x10
    [  729.357438]  ? tmigr_update_events+0x285/0x770
    [  729.357476]  ? _raw_spin_lock+0x51/0xe0
    [  729.357500]  ? _raw_spin_lock_irq+0x86/0xe0
    [  729.357501]  ? __pfx__raw_spin_lock_irq+0x10/0x10
    [  729.357504]  tmigr_handle_remote_up+0x38b/0x830
    [  729.357507]  ? __pfx_run_posix_cpu_timers+0x10/0x10
    [  729.357509]  ? sched_balance_trigger+0x803/0xd50
    [  729.357521]  ? __pfx_tmigr_handle_remote_up+0x10/0x10
    [  729.357524]  ? __pfx__raw_spin_lock+0x10/0x10
    [  729.357526]  ? call_timer_fn+0x27/0x210
    [  729.357528]  ? __run_timer_base.part.0+0xa7/0x900
    [  729.357530]  ? __pfx_tmigr_handle_remote_up+0x10/0x10
    [  729.357533]  __walk_groups_from+0x48/0x160
    [  729.357535]  tmigr_handle_remote+0x1fb/0x2f0
    [  729.357537]  ? __pfx_tmigr_handle_remote+0x10/0x10
    [  729.357539]  ? hrtimer_update_next_event+0x8a/0x100
    [  729.357542]  handle_softirqs+0x184/0x5c0
    [  729.357576]  ? __hrtimer_rearm_deferred+0x15d/0x460
    [  729.357578]  irq_exit_rcu+0x6e/0x150
    [  729.357580]  sysvec_apic_timer_interrupt+0x70/0x80
    [  729.357602]  </IRQ>
    [  729.357603]  <TASK>
    [  729.357603]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
    [  729.357623] RIP: 0010:pv_native_safe_halt+0xf/0x20
    [  729.357626] Code: fa e7 00 e9 d3 29 02 00 0f 1f 00 90 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 93 9a
19 00 fb f4 <c3> cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90
90 90 90
    [  729.357628] RSP: 0018:ffffffffb8a07d00 EFLAGS: 00000206
    [  729.357630] RAX: ffff8880e9ac8000 RBX: 0000000000000000 RCX:
ffffffffb7abb681
    [  729.357632] RDX: 0000000000000001 RSI: 0000000000000004 RDI:
0000000000071254
    [  729.357634] RBP: fffffbfff71428e8 R08: 000000aa3ae365f7 R09:
ffffed101480626b
    [  729.357638] R10: ffffed101480626a R11: ffff8880a4031353 R12:
ffffffffb8a14740
    [  729.357640] R13: dffffc0000000000 R14: ffffffffb8a14740 R15:
0000000000000000
    [  729.357641]  ? ct_kernel_exit.constprop.0+0xa1/0xc0
    [  729.357644]  default_idle+0x9/0x10
    [  729.357647]  default_idle_call+0x39/0x60
    [  729.357649]  do_idle+0x342/0x410
    [  729.357652]  ? __pfx_do_idle+0x10/0x10
    [  729.357654]  ? __pfx_do_set_mempolicy+0x10/0x10
    [  729.357656]  cpu_startup_entry+0x54/0x60
    [  729.357659]  rest_init+0x18e/0x1b0
    [  729.357661]  ? __pfx_acpi_read_bit_register+0x10/0x10
    [  729.357766]  ? __pfx_rest_init+0x10/0x10
    [  729.357769]  ? __pfx_acpi_ut_trace+0x10/0x10
    [  729.357834]  ? __pfx_kernel_init+0x10/0x10
    [  729.357837]  ? acpi_enable_subsystem+0x24d/0x480
    [  729.357949]  start_kernel+0x368/0x3c0
    [  729.357980]  x86_64_start_reservations+0x18/0x30
    [  729.357996]  x86_64_start_kernel+0xd9/0xe0
    [  729.357999]  common_startup_64+0x13e/0x158
    [  729.358015]  </TASK>
    [  729.358016]
    [  729.358017] The buggy address belongs to the physical page:
    [  729.358019] page: refcount:0 mapcount:0
mapping:0000000000000000 index:0xffff88802108b740 pfn:0x21088
    [  729.358021] flags: 0x100000000000000(node=0|zone=1)
    [  729.358025] raw: 0100000000000000 ffff8880a41bb1c0
ffff8880a41bb1c0 0000000000000000
    [  729.358026] raw: ffff88802108b740 0000000000000000
00000000ffffffff 0000000000000000
    [  729.358027] page dumped because: kasan: bad access detected
    [  729.358028]
    [  729.358028] Memory state around the buggy address:
    [  729.358030]  ffff888021088500: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
    [  729.358031]  ffff888021088580: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
    [  729.358032] >ffff888021088600: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
    [  729.358033]                                   ^
    [  729.358034]  ffff888021088680: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
    [  729.358035]  ffff888021088700: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
    [  729.358036]
==================================================================
    [  729.358039] Disabling lock debugging due to kernel taint
    [  729.358115] ------------[ cut here ]------------
    [  729.358116] workqueue: cannot queue ipoib_reap_ah on wq ipoib_wq
    [  729.358122] WARNING: kernel/workqueue.c:2352 at
__queue_work+0x72f/0xd70, CPU#0: swapper/0/0
    [  729.436887] Modules linked in:
    [  729.437563] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G
B               7.3.0-rc7-00032-g0fcb05b72344-dirty #9 PREEMPT(lazy)
    [  729.439787] Tainted: [B]=BAD_PAGE
    [  729.440426] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
    [  729.442037] RIP: 0010:__queue_work+0x733/0xd70
    [  729.442960] Code: b8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48
89 f9 48 c1 e9 03 80 3c 01 00 0f 85 0d 06 00 00 48 8d 3d 91 46 02 05
49 8b 77 18 <67> 48 0f b9 3a 48 b8 00 00 00 00 00 fc ff df 4c 89 fa 48
c1 ea 03
    [  729.446140] RSP: 0018:ffff8880a4008a68 EFLAGS: 00010082
    [  729.447180] RAX: 0000000000000000 RBX: 1ffff11014801158 RCX:
ffffffffb43d67fe
    [  729.448612] RDX: ffff88800fee30b8 RSI: ffffffffb6cbee40 RDI:
ffffffffb93fa880
    [  729.449832] RBP: ffffffffb43d6840 R08: 0000000000800345 R09:
ffff888021088628
    [  729.451014] R10: 0000000000000006 R11: ffffffffba5901c7 R12:
ffff88800fee3000
    [  729.452426] R13: ffff888021088620 R14: ffff8880a40a5c80 R15:
ffff888021088600
    [  729.453699] FS:  0000000000000000(0000)
GS:ffff8880e9ac8000(0000) knlGS:0000000000000000
    [  729.455129] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [  729.456079] CR2: 0000564a390a7d60 CR3: 0000000007589000 CR4:
0000000000350ef0
    [  729.457674] Call Trace:
    [  729.458198]  <IRQ>
    [  729.458571]  ? __run_timer_base.part.0+0x80c/0x900
    [  729.459855]  ? print_report+0x300/0x5d0
    [  729.460582]  ? __pfx___queue_work+0x10/0x10
    [  729.461637]  ? end_report+0x5e/0xe0
    [  729.462290]  ? __pfx_delayed_work_timer_fn+0x10/0x10
    [  729.463169]  ? __pfx_delayed_work_timer_fn+0x10/0x10
    [  729.464079]  call_timer_fn+0x27/0x210
    [  729.464833]  __run_timer_base.part.0+0x3cc/0x900
    [  729.465850]  ? __pfx_delayed_work_timer_fn+0x10/0x10
    [  729.466771]  ? __pfx___run_timer_base.part.0+0x10/0x10
    [  729.467843]  ? tmigr_update_events+0x285/0x770
    [  729.468627]  ? _raw_spin_lock+0x51/0xe0
    [  729.469248]  ? _raw_spin_lock_irq+0x86/0xe0
    [  729.469960]  ? __pfx__raw_spin_lock_irq+0x10/0x10
    [  729.470757]  tmigr_handle_remote_up+0x38b/0x830
    [  729.471618]  ? __pfx_run_posix_cpu_timers+0x10/0x10
    [  729.472491]  ? sched_balance_trigger+0x803/0xd50
    [  729.473436]  ? __pfx_tmigr_handle_remote_up+0x10/0x10
    [  729.474400]  ? __pfx__raw_spin_lock+0x10/0x10
    [  729.475211]  ? call_timer_fn+0x27/0x210
    [  729.476028]  ? __run_timer_base.part.0+0xa7/0x900
    [  729.476759]  ? __pfx_tmigr_handle_remote_up+0x10/0x10
    [  729.477575]  __walk_groups_from+0x48/0x160
    [  729.478361]  tmigr_handle_remote+0x1fb/0x2f0
    [  729.479169]  ? __pfx_tmigr_handle_remote+0x10/0x10
    [  729.480049]  ? hrtimer_update_next_event+0x8a/0x100
    [  729.480903]  handle_softirqs+0x184/0x5c0
    [  729.481641]  ? __hrtimer_rearm_deferred+0x15d/0x460
    [  729.482461]  irq_exit_rcu+0x6e/0x150
    [  729.483206]  sysvec_apic_timer_interrupt+0x70/0x80
    [  729.484058]  </IRQ>
    [  729.484560]  <TASK>
    [  729.484957]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
    [  729.485874] RIP: 0010:pv_native_safe_halt+0xf/0x20
    [  729.486678] Code: fa e7 00 e9 d3 29 02 00 0f 1f 00 90 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 93 9a
19 00 fb f4 <c3> cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90
90 90 90
    [  729.489844] RSP: 0018:ffffffffb8a07d00 EFLAGS: 00000206
    [  729.490707] RAX: ffff8880e9ac8000 RBX: 0000000000000000 RCX:
ffffffffb7abb681
    [  729.491941] RDX: 0000000000000001 RSI: 0000000000000004 RDI:
0000000000071254
    [  729.493334] RBP: fffffbfff71428e8 R08: 000000aa3ae365f7 R09:
ffffed101480626b
    [  729.494586] R10: ffffed101480626a R11: ffff8880a4031353 R12:
ffffffffb8a14740
    [  729.495895] R13: dffffc0000000000 R14: ffffffffb8a14740 R15:
0000000000000000
    [  729.497243]  ? ct_kernel_exit.constprop.0+0xa1/0xc0
    [  729.498020]  default_idle+0x9/0x10
    [  729.498610]  default_idle_call+0x39/0x60
    [  729.499281]  do_idle+0x342/0x410
    [  729.499884]  ? __pfx_do_idle+0x10/0x10
    [  729.500523]  ? __pfx_do_set_mempolicy+0x10/0x10
    [  729.501359]  cpu_startup_entry+0x54/0x60
    [  729.501999]  rest_init+0x18e/0x1b0
    [  729.502584]  ? __pfx_acpi_read_bit_register+0x10/0x10
    [  729.503511]  ? __pfx_rest_init+0x10/0x10
    [  729.504279]  ? __pfx_acpi_ut_trace+0x10/0x10
    [  729.504980]  ? __pfx_kernel_init+0x10/0x10
    [  729.505793]  ? acpi_enable_subsystem+0x24d/0x480
    [  729.506549]  start_kernel+0x368/0x3c0
    [  729.507208]  x86_64_start_reservations+0x18/0x30
    [  729.508001]  x86_64_start_kernel+0xd9/0xe0
    [  729.508710]  common_startup_64+0x13e/0x158
    [  729.509407]  </TASK>
    [  729.509877] ---[ end trace 0000000000000000 ]---
    [  730.435341] ACPI: PM: Preparing to enter system sleep state S5

The workqueue WARN right after the KASAN splat names the escapee:
"cannot queue ipoib_reap_ah on wq ipoib_wq" - the re-armed reaper
trying to queue onto the destroyed workqueue.

Chengyu
