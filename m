Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794995638;
	b=GD5BxemrRonKqKO1qggB2DZP3F445B48BO7hQ5YajMMjvklE/y6l089pWadgbsUnxIzy
	 2x53UZaa5JsfsTP0xQgGkQAijv83FtAGaStaoYsUWHblq5TYSbJGImKfEhvIUbrWUSBjH
	 HVHvajhM2WpJ08uDuugxk5WBQKyi1u6TAC+KKPmdFiRV210PRl4nX17Evco1EvJJqSiE8
	 OHiNYsB9VPAC8ahpjCeFUBQ0f2f/ENQW5HzJ1ownW1oOV26knZf9d2bUoLdD4yGkrQrS7
	 YN9siksdaAQJa9mN7zmI0hO1sW8Ajdq6CW/hntQbZ3NbdFTGZR3hFePu+V4seHZMYUQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794995638;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=jOQdwFFmcdU2t3MoRBuiPs+2TwOTpuyDjeUAWF0EYFA=;
	b=pqPfF3Z8O4Yv4MCE1WlQBI1LUGRA8WCj1ktrMLxSqIRpSFv7yzQwea+qx+0YDSBQi3ao
	 XJhRUyixaFBSgdmOEB+GKqTcw325K/v/DM7Jl3tFnZJNi38RHFRveeI1QdR/guc2J0DM0
	 Tqdi4eTdb4lvjKlKVpyYJX61j7fOuPrzX9MshM4UZ9XFpBHyaz9xGVKJr4wXANvsAznZR
	 /AzzqS9EKDEIwznGFWD/W9l86BB6d9jHADFBrBKkJgtxv1Vsi+ZQMcXq8c6qmURXwcoaq
	 OorBbsxHo88XL2IJ5xmedGVMzbpR2y3TUA1PwMgFaDLflxKMSPEGtSiyv5euRJDoE7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=H2pOIoxq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44194606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:53:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44194606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=H2pOIoxq
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b887ca9f5cso997284a12.0
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 01:53:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794995636; cv=none;
        d=google.com; s=arc-20260327;
        b=NOLCrSckKMa3GHfIrJ4p5F1kTyyS7sV9MKUiEao9454WTKpDbCLxuTpMfN8iZ92uTX
         QdpNIDdEXGv3mEIZW2Fuoqc9t99Sl4MEAc6ubDI0GMG2kd8Hc/tCT2xCoFOm+Qt68I5x
         IwWSQIdLWrEg9ICIDzlIUgC7rJ2KM6I02ci7LzsEocbFB+EiaTAQ7w5DlQ94xOFGIqFr
         BlvzcXH/SFH/7mD+YlbrFne7VujH/8KE839Iju3+9rb7eo+od9vn6W3bHt1kcFb7GzLR
         RabmmJ+Y/BmgBt/UU5EvYSFAoS+dBLE46u6Kwu3h0hzxUUvk9Hbo6veCfTKpzCg9GlI/
         k3rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jOQdwFFmcdU2t3MoRBuiPs+2TwOTpuyDjeUAWF0EYFA=;
        fh=rk8EePpPHwMdpQMRodPdOHm8iAuvuNdwAbAzU6YKzHc=;
        b=jqnMqlLOZuVI71wGqLJSKRdcpKz6ZGM1qkSjVY+V551QVaB5UE1o6armvLW61JJUsm
         xMLXJjFEbycDrZS9wPjh3KpSgKvicRglx6RkDpsXprnugqcNgoxrAu3K4z3AFn+MkoXn
         J3XZUgFyH+FuFwxfys5sDA60/yIYX+TyW8IzivLGLQ7+vDkG/DXlIGm2W1c7V/pw9GdG
         Q42MAhqG694Xfhm8W+OEB+A405dlngw/CguckLId+gYnyPz6g4u+PqQF4/mHLli2+6MA
         2JtqsO7Hx/+WNcMul1pFpJ3zW6tKSt+y4GOqXb8WUeB7c3ChyFwfJ0r+Wsm6yLArNANH
         wxFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1794995636; x=1795600436; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jOQdwFFmcdU2t3MoRBuiPs+2TwOTpuyDjeUAWF0EYFA=;
        b=H2pOIoxqPswoPleCarndVFfGIljsWoTlHBNxVXGE2SKZb2xTWx5+3G/ykUEtwpCO3O
         vqMSD2+Y87PGrZNyJRwoI2EtTmSLLvr5NCNyTOXSOJVTawUSQktUvuBGWAPv6tizhSKp
         loWE4oL59PDgutci1nGhbQTZ20P8Zkq3mpbQ4j2qbvHl/FNlBSr6XX/y61qPy/nyjas9
         IpdQDTaEu1g9jQjCtS6x3VreD9dK8wTfCuxmu31oaiMgq4RGtSwdR5DwECv+ufntCqp9
         Shuc+sKhiuNYREtqQWILWjKJ4KxyJM00VjpR7ECtlrzfWR2cUldtBbosuKwbsVCRJwMH
         yzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794995636; x=1795600436;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jOQdwFFmcdU2t3MoRBuiPs+2TwOTpuyDjeUAWF0EYFA=;
        b=jXDk4dojmPJZidV2JKKR41gBLESunN4KeJ23U4h4nAtUAPIocBrb+tlUG6yutPk4jp
         I1dmjSe49TIrzYHdb0dNG9LpBxT+exhcnvcEErKK9vHe3hy5V9vm+mEgxoubId2X7k09
         CsfYppqCw7UwAA3WfP/nLu/l/pN7iE2kuYWHl5zN3277y6VGUMjxm7gZZg8TSXJJPhnC
         WwGFibrvclXMdd1emeQjW+xotkd91Bj5DcnAxb6MzK/nyqO/KMCMbbvphTbwOKMhtpnV
         eJ+pH5l4aQzLQN6Z4QxUwnfg8b+3wlSRHHYJSbnDWhUVn+RoeKe/H7tQziGs1+/B0vnX
         g79g==
X-Forwarded-Encrypted: i=1; AL+hErHi2WiImMl/SlnRwvyIAH+5KkSQ8uwScr5CFBpyTo2wemoJOu4AK9PBT25bxNd6Ya7jse7kjRLBrvAe@vger.kernel.org
X-Gm-Message-State: APuU4Z8kkQ3P76e4O0t6Ilf47OPFoATViD/CQhCTCpqohipStYh6RkvS
	DWPsGG59dWLaiGuTSRUFvoozAyIpx2Lx32Fn1/H/+htJM/T/6m1bhQft6xL8uBGngFyoNsI81Eg
	oSBohLJ3BKuBvsH/FMoVE0Cxm0e0IP1OA5ifFcly2NQ==
X-Gm-Gg: AYBFou1QTBtlDvBZvBZbr8jaIZFTtqS3ARcdEcDyZcOKHI5MKWer9M4qy+YtHtfYozm
	8SRoct1sf0jccPByREEfAmc4C5LK34OEevhMJ17OJ/+g9dDKbadPbrJ7Z8mpLtWjawFo1k7Wioj
	Ga2XuzPHzLDam4ZozZzwBci5Glgu/xomL7mlDnPPpnR2SMAfhLdhA431faQuNcEvuIe2P9ViV/E
	gNQ44CmhHgzzNby/T2rnzYM6dAd/qHI75Xd3k95J8FZ4S/3gktg25Dl1y8SnwlNymJU0Us9Z8d/
	gqlmVq752YVSrquiCWioR6N4g8cHg5C4M6YQfDPX5uT8uEONTQKNVKDM5baIsa3gGvAd80xvydw
	wI6j8wCCBQOJwd461JeOSL3OCM5VpTNAPw2i7d9QHYAkRjFC9hM/GWd/KXRon7UwtbUXkgm4chF
	0giTBSPyVXt30mwyp1LTA0hm8dLfsRnNlQ5oiK9CWxUaMaAFm0clqG2OPWN0c2g47yw83nicjkM
	AfFynMSMO/TMr1J18hBNo+a
X-Received: by 2002:a05:6402:210d:b0:6b8:6d8e:bf1 with SMTP id
 4fb4d7f45d1cf-6b887f208bbmr1500440a12.25.1794995635626; Wed, 18 Nov 2026
 01:53:55 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105202939.3104321-1-shuangpeng.kernel@gmail.com>
In-Reply-To: <20261105202939.3104321-1-shuangpeng.kernel@gmail.com>
From: Haris Iqbal <haris.iqbal@cloud.ionos.com>
Date: Wed, 18 Nov 2026 10:53:44 +0100
X-Gm-Features: AclHuK8hhZDh4YS1kG5ohrpKCRFfNpHez4ilI0r2l5cGXVd9OXlKYmFjusqU4og
Message-ID: <CAJpMwyhqnaqHjeF0_3MsEZj1-TG0dG-ksuJrbrOgbSLMPAOo+A@mail.gmail.com>
Subject: Re: [BUG] RDMA/rtrs-clt: KASAN use-after-free in rtrs_clt_query
To: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Cc: Jack Wang <jinpu.wang@ionos.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 9:29=E2=80=AFPM Shuangpeng Bai
<shuangpeng.kernel@gmail.com> wrote:
>
> Hi Kernel Maintainers,
>
> I hit the following report while testing current upstream kernel:

Thanks Shuangpeng.
I am looking into this, and will send a patch soon.

>
> KASAN: slab-use-after-free in rtrs_clt_query
>
> on commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d (2026-11-03)
>
> The reproducer triggers this report. It uses the supported RTRS path disc=
onnect
> and RNBD force unmap_device sysfs interfaces.
>
> To help trigger the bug more reliably, we applied a minimal diagnostic pa=
tch
> that only adds delays and print statements.
>
> The reproducer and .config files are here.
> https://gist.github.com/shuangpengbai/5409f0d93ab7414fcb6d97ac799fe28f
>
> For context, I previously reported a related but distinct RTRS client
> use-after-free in the same subsystem:
> Link: https://lore.kernel.org/linux-rdma/20260921033339.1320291-1-shuangp=
eng.kernel@gmail.com/
>
> I'm happy to test debug patches or provide additional information.
>
> Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in rtrs_clt_query (drivers/infiniband/ulp=
/rtrs/rtrs-clt.c:59 drivers/infiniband/ulp/rtrs/rtrs-clt.c:3140)
> Read of size 4 at addr ffff88810228d2f8 by task kworker/1:0/24
>
> Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 199=
6), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: rtrs_client_wq rtrs_clt_reconnect_work
> Call Trace:
> <TASK>
> dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
> print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
> kasan_report (mm/kasan/report.c:595)
> rtrs_clt_query (drivers/infiniband/ulp/rtrs/rtrs-clt.c:59 drivers/infinib=
and/ulp/rtrs/rtrs-clt.c:3140)
> rnbd_clt_link_ev (drivers/block/rnbd/rnbd-clt.c:691 drivers/block/rnbd/rn=
bd-clt.c:731)
> init_path (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2161 drivers/infiniband=
/ulp/rtrs/rtrs-clt.c:2677)
> rtrs_clt_reconnect_work (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2709)
> process_scheduled_works (kernel/workqueue.c:3495 kernel/workqueue.c:3578)
> worker_thread (kernel/workqueue.c:3659)
> kthread (kernel/kthread.c:436)
> ret_from_fork (arch/x86/kernel/process.c:158)
> ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
> </TASK>
>
> Allocated by task 306 on cpu 1 at 11.590323s:
> kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
> __kasan_kmalloc (mm/kasan/common.c:409 mm/kasan/common.c:426)
> alloc_path (include/linux/slab.h:991 include/linux/slab.h:1312 drivers/in=
finiband/ulp/rtrs/rtrs-clt.c:1540)
> rtrs_clt_open (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2871)
> rnbd_clt_map_device (drivers/block/rnbd/rnbd-clt.c:1288 drivers/block/rnb=
d/rnbd-clt.c:1571)
> rnbd_clt_map_device_store (drivers/block/rnbd/rnbd-clt-sysfs.c:612)
> kernfs_fop_write_iter (fs/kernfs/file.c:345)
> vfs_write (fs/read_write.c:595 fs/read_write.c:687)
> ksys_write (fs/read_write.c:739)
> do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c=
:84)
> entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>
> Freed by task 306 on cpu 1 at 47.089348s:
> kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
> kasan_save_free_info (mm/kasan/generic.c:584)
> __kasan_slab_free (mm/kasan/common.c:264 mm/kasan/common.c:296)
> kfree (include/linux/kasan.h:235 mm/slub.c:2780 mm/slub.c:6630 mm/slub.c:=
6923)
> kobject_put (lib/kobject.c:689 lib/kobject.c:720 include/linux/kref.h:65 =
lib/kobject.c:737)
> rtrs_clt_close (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2940)
> free_sess (drivers/block/rnbd/rnbd-clt.c:770 drivers/block/rnbd/rnbd-clt.=
c:786)
> rnbd_clt_put_dev (drivers/block/rnbd/rnbd-clt.c:49 drivers/block/rnbd/rnb=
d-clt.c:62)
> rnbd_clt_unmap_device (drivers/block/rnbd/rnbd-clt.c:1723)
> rnbd_clt_unmap_dev_store (drivers/block/rnbd/rnbd-clt-sysfs.c:334)
> kernfs_fop_write_iter (fs/kernfs/file.c:345)
> vfs_write (fs/read_write.c:595 fs/read_write.c:687)
> ksys_write (fs/read_write.c:739)
> do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c=
:84)
> entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>
> Last potentially related work creation:
> kasan_save_stack (mm/kasan/common.c:57)
> kasan_record_aux_stack (mm/kasan/generic.c:556)
> insert_work (kernel/workqueue.c:2356)
> __queue_work (kernel/workqueue.c:2546)
> queue_work_on (kernel/workqueue.c:2599)
> rtrs_clt_close_conns (include/linux/workqueue.h:700 drivers/infiniband/ul=
p/rtrs/rtrs-clt.c:1963)
> rtrs_clt_disconnect_store (drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c:2=
59)
> kernfs_fop_write_iter (fs/kernfs/file.c:345)
> vfs_write (fs/read_write.c:595 fs/read_write.c:687)
> ksys_write (fs/read_write.c:739)
> do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c=
:84)
> entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>
> The buggy address belongs to the object at ffff88810228d000
> which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 760 bytes inside of
> freed 2048-byte region [ffff88810228d000, ffff88810228d800)
>
> Best,
> Shuangpeng



--=20

Regards
-Haris
