Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2867200110
	for <linux-rdma@vger.kernel.org>; Fri, 28 Aug 2026 05:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787896354; cv=pass; b=lYhdH/kiAQQTiszw6lhBHLgw2uctS+Bn0jXlhLfFOGt1nwhorVqJFpuXLxNJmKmtYuC/O/Kn2Xw6oOO0xPpjYUKBFT04Dg57wmHdCR1XSfrubO02mpVQVTc0c2LEf9gvKKQdL7FQ4Ugm9z7p4R5BDaX+5brt3rYVTHKzz/3CNxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787896354; c=relaxed/simple;
	bh=usahOBnxvXC2AQ8/d4BKxTHAJUwY1FvkqTENx+qHQZY=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=HcX/6LXSuD/tBBX/RJOuap/k4sOg/wV16yG3t+Y9ie8kwP+4QkW3UW48l3sKxKWvtFRk4MSJprOSvvsUPDX1i8OT4j3K4wJLqj412Bb27UitbmogPe/JkuWvqjZIAuBWyDkABPIPcHZkUsO6/1dB2zZQjLkA24zmGEVvjRsMeAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=KN3eZu8Z; arc=pass smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="KN3eZu8Z"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38e347638adso589506a91.0
        for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 22:52:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787896352; cv=none;
        d=google.com; s=arc-20260327;
        b=r0pwRyXghj+4o3j5V5H5ZFYy9EB4uy8f9hEo99M1yrVLPmjz/bOQlPYIxdzP6WNMBb
         kQMKgNQkFMs7YoKffMJ4eHrPyaTC9aiDeQ4H1I3d1lJm6/rpEnihnAKbzokgL7YPlzXk
         hKPgVXZ9WtcbFMsjjOQeuf7ewx/U+7VqSHKv1X91xYSFM0q/lbqEtqTQofmDU9f2i7C6
         TAj7amF2vieKEDj8vga30qHFrlUQxW95QPQIICIscNQagDuOG145LBdo0nQszB9v9KX8
         gu6ADc13LQQV6Uv2pmeArl6MQ2++8tEX1XaA8O4VtNCSEqp3eT7qJVM+vzJQMt9daXwE
         artg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=jwFH7WepPcBgyi2vprtCONHJ2oI40q37ZuojfGEDWc8=;
        fh=OTj09qTjGBUOwalRa6RJoHk+4wuNX+hnmyKhF0avXrg=;
        b=Fgj5wQJ/8xhxE9s14tV/pIM1I/supPCl6butMd83LtXKgwx29AXwXDRMCQTFomdw6Q
         p31y6ccUCVlGEvlJCC7HZsdthkxbWISo+KVmTMs2paWiG7rGArCP9u2B/rcfzvgyP6To
         ju4PaFqHQlrezCfAh3bfUAo10ERDD1awchoyOyrHOUoE8yeOnkzpn6UR6++PZpxZm7tc
         wPiqKKTuwlUbSXRNEi+qFKAZIcTDs70fDMldMKewgMV2s89nIwyxvCKBnjagGhOWF5sp
         1w5xtdObOj5sKfHx0w+w6gVosLfSIF16D/w7K7ZtmoZ9u3w16E6nWovAGAlFBU5dROEw
         Zz4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787896352; x=1788501152; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jwFH7WepPcBgyi2vprtCONHJ2oI40q37ZuojfGEDWc8=;
        b=KN3eZu8ZNXhWloBFiHcPXn6ezeDEgMD9urDEslYjRAU5246rqzNMIchhWB5Feht2XB
         Q8NsukRRYGh+WaZwdO6RuP7OnzyejAZ++KQY2TaPlqXdHX2GWs0eDd61B78ceQedGsKV
         JQj7DptanX1TirHQrXlIPs0FPitZrot3h51EgQFKniCSV1jw9XGWOgrqDNXQmklAZFvz
         DW8wuN4OOYoF8mv2A4cnaTOLozBFam7ATLfUDsJSdQyg+aG4b5NvZgGTqrMALigCD7ne
         v36TN8EtlqsSgvUpNG+lWRbOy71SvNAgW1SeYaq40Ykkgs7tKZYySZoAVoNkaze1Ea6E
         6Qtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787896352; x=1788501152;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jwFH7WepPcBgyi2vprtCONHJ2oI40q37ZuojfGEDWc8=;
        b=ATJNXtFNzpt1Bi67Bk2b6PIKtWas6+4afTr/lYNztkkZbMPCRkoXE0N158KC1Df/qH
         iHNkktmLEX1ayj+q/vrWPrK+c4Daspci6qzmq/NBxgUJPI6WMAw1lutQJb81SQioZHfO
         skjTpN6EsZBxzZYHk9m2QiEfp3Z8CZqIUSTTutHC2N6Y03JI9tJYsJMHQt2kenh7aG3t
         NAmczBNRyOy8bIK9LgqqTNiluzYT1VkfyjwablEP87On04xulSYRyiPQIgnrTz2YZ83w
         0Fx3yOxAiuJBQWV9vUwchMhdJEHOVtiOddaR9GuCEbkdiDWeYzG4KenVHr/lM3NkvDge
         Qv+w==
X-Forwarded-Encrypted: i=1; AHgh+RradrOT51XlnobXe8PSQMgCsAFNiXpuSZILesjHioi6W63zV90oxt1MyaKwPHPAv+spdH3nuWZyHnNr@vger.kernel.org
X-Gm-Message-State: AFuF++mcXDUh1WB6fSmSSkCxwHtqA/ZVRTsM/BJEhvR9YV5/OeliulAe
	5V0/rDA7QOaUbvpZMHDzbCPAAVmlIEEVteYfokAp9bDvhILYbNNSgSsTe0WBIGowG16dmmrqQ9P
	fFvAcLMUZnQoQors/qW5KcVO4pKwYIf6rET1J7bUp
X-Gm-Gg: AR+sD10dAgoX3qSNdsBo4aT5TbPl53TATau3qfQFhGXBCtDwa+QkVa9f2idShrrdqSQ
	EOQdgXZmYrx26PUoo5cFMHkA/GsjMRCvvh0L0AP+z7MvoSZ5aF1IRYuoQ1YCvdqvAMRXVh4tLHC
	0f78Vvt/PmtvFkKSyc7MnfpTtoX8+IOdOB07sq4Urt4Y5S6esH+NTDIGnpgtx1CO5s6sCxxhK1Y
	puS+Y8pQXQdxbaPug5KhQH/GNZF0bmdx6T+mW3h8gNnSg5D+q3kNm/l42so58BA3o/vs0mJXCjM
	17v0fsxDvVC4858jwgVqdHzspXDOXScKX2UPeoGs+EyWsfGlcRe6Pjaij2nCapT402rmlmh0sWy
	tY6m1c9SftgKSkVPrUMTMlmSMm4qK/ToB
X-Received: by 2002:a17:90b:2552:b0:38e:9045:babe with SMTP id
 98e67ed59e1d1-396d0f02a58mr9085786a91.7.1787896351210; Thu, 27 Aug 2026
 22:52:31 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:52:30 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:52:30 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 22:52:30 -0700
X-Gm-Features: AcwNN1XVKD5-gBLP7U231hld4bet4lDjxXLHpGMVQ_reZr84s2L6KyyKDEvtY4Q
Message-ID: <CA+0ovCihE2_pxLimjmmR8NMz4g-ie8dvvq1jmAj-Om33y3Vzfg@mail.gmail.com>
Subject: [BUG] WARNING in ib_drain_rq
To: Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>, Jack Wang <jinpu.wang@ionos.com>, 
	"Md . Haris Iqbal" <haris.iqbal@ionos.com>
Cc: falemi@asu.edu, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

As part of the kernel research at ASU's SEFCOM
lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/198-warning-in-ib-drain-rq/

  failed to drain recv queue: -12
  WARNING: drivers/infiniband/core/verbs.c:2948 at __ib_drain_rq
drivers/infiniband/core/verbs.c:2948 [inline], CPU#1: kworker/1:3/5056
  WARNING: drivers/infiniband/core/verbs.c:2948 at
ib_drain_rq+0x30c/0x590 drivers/infiniband/core/verbs.c:3078, CPU#1:
kworker/1:3/5056
  RIP: 0010:ib_drain_rq+0x30f/0x590 drivers/infiniband/core/verbs.c:3078
  Call Trace:
   ib_drain_rq+0x30f/0x590 drivers/infiniband/core/verbs.c:3078
   ib_drain_qp+0x1bb/0x430 drivers/infiniband/core/verbs.c:3102
   stop_cm drivers/infiniband/ulp/rtrs/rtrs-clt.c:1763 [inline]
   rtrs_clt_stop_and_destroy_conns+0x216/0x1650
drivers/infiniband/ulp/rtrs/rtrs-clt.c:2210
   rtrs_clt_err_recovery_work+0x67/0xc0
drivers/infiniband/ulp/rtrs/rtrs-clt.c:1524
   process_scheduled_works+0x881/0x1170 kernel/workqueue.c:3397
   worker_thread+0x988/0xde0 kernel/workqueue.c:3478
   kthread+0x333/0x420 kernel/kthread.c:436
  Kernel panic - not syncing: kernel: panic_on_warn set ...

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
