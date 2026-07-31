Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B521B35C684
	for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 19:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785527029; cv=none; b=X102vhATrVfxonz9zJ2QXwsh/Po//HyLBFm/wMVoOn/5msof4J5E15w177FfiEDQS1YPaAvs/dowObh89iXysS+sDyO6+OoGp44sJQLIldknh/WIG5y/FZ5Mae4pqXQEm4KRjP5q0efSeDUiJQr5fGyfq4jzYyTbLSrBDw17XaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785527029; c=relaxed/simple;
	bh=a4JoxwK8whd0hqjJLugLawL3etavM1SHtOZ/07odXjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DV4ux2vF5K3UZv5A8FPiLQeIi4wCR/7C/ZvFqAe/cY9AuRQxZOAHxUeHq0ZIdbuSNKngybpZHWgNAKAv1qM3FPlDE+oFbdoT5fgOkFp+IYEGedPdyKm1/0b/s/Jpi7JwScGr6Xax5rACkaSifN63fhMMMuQqnXS3ykBzfS1X7o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TtkScYgF; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TtkScYgF"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8efcef23d21so9425236d6.2
        for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 12:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785527026; x=1786131826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YGd998t4bIjPz8K4wuARBcoglgbiEtkoi+8NJ9UIttY=;
        b=TtkScYgFZA0XjvF9GaNlsVQp4lM0Y5rwS0btsGUyMte06ymSNo8tp3ELJn7q3MOSNV
         0Blmh9Ff8eWUKmKkIvULsqMXamYGSVU6zRT1WjuVW7MKXKHdy3JaMphMd6Qmn7XD1aFb
         lCzTtaSIRgjeuOt5gwpZiwIxFWJMtxQsRYnrG5h3Cik99lMIlC+qFdAhFdgDewn2mYa5
         r0Lrq0Uu5xqMkrkHOyO91ww47GUNjmMRMR4vXn2ZXA/54tSmA4vimOCR0/C2PwiBLIDg
         nmB1Xa7r7A8+LMfvJN2QDe4futzdZ48neW3jDtE0SC1QVvmBdn17g5CuCb0AHuj/lCO9
         VWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785527026; x=1786131826;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YGd998t4bIjPz8K4wuARBcoglgbiEtkoi+8NJ9UIttY=;
        b=gNAwpaRtXY9fVN/BLofHxLMU4/QJGPGXDeB2so7Qr7ukvcDc/gSBAD4UqvpiEuNwVl
         1CshczSKgHaW9GtMAGQut9GwH4jCoH9hqY8H4SbSul6CssRSOFMD0LXO3dd650GuMQaI
         TJl8LvDA29F/az9MRW9WsiNxnOwW6nAWzc6WrMC/iiH558M0X/p2ILukK3aa+kcygUmz
         qNSAzHPuZPAfav2BwpnEUIUPyAAWPiBpssxCV7cjBHcBYH2fk02geDek0bcTBHFphkRG
         8LlyxddWtjrbtimJRqKgcYBKHtdTbhrVqFpeDa1GWN41OzA101R3NPq2J6ndMstvqw9L
         /QRQ==
X-Forwarded-Encrypted: i=1; AHgh+RobcX4S02B1EUi01iim03Pq2m1QY0/Z3rsX5CFvBbqmYYssEThoiTBjrGOwX8qXPC0i87AGfZu4Fze+@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3La5OYffeP8f2mN0nCO6oJhqwRad9dtgrj22ntMeIqOOcyhqo
	HfeVp+3nLDK+O4HB0GlTHUiyP5SDV06QpvroF48/X/AghmppQLpWifPa
X-Gm-Gg: AR+sD105RGxOlF9j0yQ9HxpjhUZlrdD15eFWLJgCeCJcNeKBOfxuCMuxK3Cjxyf12bq
	Hg6PEWl1MU89jJGXmGhELe6sJU+ttWH3u58ku0P5HMEZDmdpYoZbtMZH0wOrYTuE6FRnfLkFVeb
	7K2sgftWAMaNb+4+8Tk6Df/TEv+CF8vtYGiN5v7QnHyzXIEFihSMnNo0zy3Li59GID5d1M8HaKx
	w4kW/qiYDrYhMJZqraiWRniaVA3pWFHmmVlPgrjpop1Ni0SZKdPmosNZbUqrkMGu0ldiAnwhZ80
	aT3/3LfPmCUftGfHU9Kqj1/PM6wMtUOSBVzJvp6cMr9TXIaTHIyy602FFKb6ZavfSIKjBuPgN5s
	GINDFBidZNUm2Fjb8hnXDGwMY2Cu8QPocmlsABrjMqjQn3v70zDULQdNeFbGHNGNZBpOyekxHG7
	5G6uDcwnzS0iyWapOPsAXB4y4tZH60J0GmnYszdpZRzb/hrrRcU+hyP5d15tHCqlw7T1o4Vjsg1
	GeNFCqwG+YjRfALiA==
X-Received: by 2002:ad4:5dcc:0:b0:907:5150:a2dd with SMTP id 6a1803df08f44-9084959f7ecmr23035636d6.14.1785527026491;
        Fri, 31 Jul 2026 12:43:46 -0700 (PDT)
Received: from i4-l-hqh5357-03.ad.psu.edu ([130.203.139.71])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435ed43esm17748166d6.40.2026.07.31.12.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 12:43:45 -0700 (PDT)
From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
To: "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] infiniband: rtrs: KASAN: slab-use-after-free in rtrs_clt_remove_path_from_arr
Date: Fri, 31 Jul 2026 15:43:22 -0400
Message-ID: <20260731194325.2322754-1-shuangpeng.kernel@gmail.com>
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

KASAN: slab-use-after-free in rtrs_clt_remove_path_from_arr

on commit: fce2dfa773ced15f27dd27cd0b482a7473cdcf2a (2026-07-16)

The reproducer and .config files are here.
https://gist.github.com/shuangpengbai/5f48e1bbb0576eecdf8ec7a5fb6b138b

I'm happy to test debug patches or provide additional information.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

[ 1396.946778][ T8599] BUG: KASAN: slab-use-after-free in rtrs_clt_remove_path_from_arr (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2236)
[ 1396.948953][ T8599] Read of size 8 at addr ffff88810fc7b2d8 by task bash/8599
[ 1396.953684][ T8599] Call Trace:
[ 1396.953694][ T8599]  <TASK>
[ 1396.953701][ T8599]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[ 1396.953716][ T8599]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
[ 1396.953748][ T8599]  kasan_report (mm/kasan/report.c:595)
[ 1396.953766][ T8599]  rtrs_clt_remove_path_from_arr (drivers/infiniband/ulp/rtrs/rtrs-clt.c:2236)
[ 1396.953786][ T8599]  rtrs_clt_create_path_from_sysfs (drivers/infiniband/ulp/rtrs/rtrs-clt.c:3158)
[ 1396.953792][ T8599]  add_path_store (drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c:187)
[ 1396.953852][ T8599]  kernfs_fop_write_iter (fs/kernfs/file.c:345)
[ 1396.953857][ T8599]  vfs_write (fs/read_write.c:595 fs/read_write.c:687)
[ 1396.953898][ T8599]  ksys_write (fs/read_write.c:739)
[ 1396.953921][ T8599]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[ 1396.953928][ T8599]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[ 1397.134599][ T8599] Freed by task 8599 on cpu 1 at 1396.942910s:
[ 1397.135348][ T8599]  kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
[ 1397.135942][ T8599]  kasan_save_free_info (mm/kasan/generic.c:584)
[ 1397.136539][ T8599]  __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
[ 1397.143207][ T8599]  kfree (include/linux/kasan.h:235 mm/slub.c:2705 mm/slub.c:6405 mm/slub.c:6720)
[ 1397.143701][ T8599]  kobject_put (lib/kobject.c:689 lib/kobject.c:720 include/linux/kref.h:65 lib/kobject.c:737)
[ 1397.144255][ T8599]  rtrs_clt_create_path_files (drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c:441)
[ 1397.144944][ T8599]  rtrs_clt_create_path_from_sysfs (drivers/infiniband/ulp/rtrs/rtrs-clt.c:3151)
[ 1397.145671][ T8599]  add_path_store (drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c:187)
[ 1397.159053][ T8599]  kernfs_fop_write_iter (fs/kernfs/file.c:345)
[ 1397.159699][ T8599]  vfs_write (fs/read_write.c:595 fs/read_write.c:687)
[ 1397.160233][ T8599]  ksys_write (fs/read_write.c:739)
[ 1397.160740][ T8599]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[ 1397.161333][ T8599]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[ 1397.174822][ T8599] The buggy address is located 728 bytes inside of
[ 1397.174822][ T8599]  freed 2048-byte region [ffff88810fc7b000, ffff88810fc7b800)


Best,
Shuangpeng
