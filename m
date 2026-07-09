Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106BF403B16
	for <linux-rdma@vger.kernel.org>; Thu,  9 Jul 2026 09:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783590978; cv=none; b=ZrVs8MQgVxlWs+zPPMEkDPVN/63Pnazv+tQhlWvkanH+A63cuFGLm5r38Ql4hPPLAIfZE2jLTpFIx2rLAJKax5APQI+QxFzq07STSvoXHI1JMkPG+cb/zuMawyhQeJ2JHWlXGYmWSgb07Lhfid46GjuMegnxISPKQd43w6LsTN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783590978; c=relaxed/simple;
	bh=AlWKq+WCpJ6jqrd7bHxM+xUmQDKopJjD0aSNOnzQ77Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giHDDSZPX2xhK45tw51xW07GcdYO0VE4DogwJ/HqzbqBW4hlaSSXMMPZCpZedqzODjJb+JhxkUkw2ZDmBgtS4rY+p2j2woOZcPBeFbk8TN+K/pAAC7q8Qp3CCr+FIu5uGji9Z3O1K1bYcuZkVJDgSJXA6zIT+fU1NgOdbVIWF9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=EK2qKbHj; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="EK2qKbHj"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so9673425e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 09 Jul 2026 02:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1783590975; x=1784195775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1DAcALuj6CLiGGxg2YU+zPjUKqyxKHB8HUr7MGOtyF0=;
        b=EK2qKbHjF/3hyZLJq5H3dLsl0XlAQpmpHO1Y1rUF/egg5KypMZaczFPeaQRkZVsBB6
         cSlc++ZZt6IckP+7sdSpgTQhf1V453QWIahFOXEcJeIPJi3/gLJrIsJ5RxOxKEg8MzcG
         MykQH4rHxRigN65mZPXdJG6s4duuT7FTamRX9keequsaiFTxSOea0I3PTFHEaYU6/oIU
         xjkRpoKGRa1IosbPqNIlOVlzaVUcL0XJMDKgiVVHcj5yf45h8TdA+qloac8TWbnYob7h
         IC4x2FE4ceW2wfL/UfycuSnSBYT9pc4ubMvTlJw3poeC8udAHJPmMP1Wi4qb9t101Mcq
         5iaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783590975; x=1784195775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1DAcALuj6CLiGGxg2YU+zPjUKqyxKHB8HUr7MGOtyF0=;
        b=nGkjDGevGKHXtXyOkbpktjKYfoCG9HhrnvuFG8+00BYJcEPLx98mmAFzZ4C1bEsVyD
         z2+v6cXoUwDwJR+k8iIEXAnRe8+ABUbO62/k874FbRHVT/+Im8LyvpXLpf5mgp2sm70B
         lAayQ7UXttcVESIozqR8My2+bZh0EFfq973nnjQQ941Bz1lw+pElrEzEvDmEO7QoiCwI
         oZZBylBS9J6nWEKBm0CiOLW3UZo8d/YvTtugwuuKkv8+/aOTRZcTdI75A49bLHLXPUi1
         AVl1/3foGNai7bXeNMiv03TuLkQOwK28cN6Xc2ZDa0Y4rTnAQLLgR/u8fUp7Qp8RKZBz
         lCUw==
X-Gm-Message-State: AOJu0YxZKFdXdDyI3qWBMmVM6+JigTG55mF0x6vrPAFLDVMif7V5ekvx
	60jaRjLW0VmNOpcvztV9Ba6n/Tzw53XGa9fxoI/YoIIImbp2U3nEO2iEOUUm6pCjHjr52TLbGF1
	rm0sl
X-Gm-Gg: AfdE7cnzMUjj3M356q+177+AKgkfbUIY1SZlZEY4yZ/14cMker7zr5YpuE2Xw+zeZk3
	oMlpFQBdSLqsMSPoah16BBAzfdFy4noTJmFWnnPer1MvGeVIZsGtDUaFRHzSGRa3MGxjcsj5s5u
	yWiwWFcPsk+kEJp/0BsBf+mLOqn5488InNUKzCJbz2TW8zihmrBRlAJmTWC91gh/CAO/etmaQKR
	pQeebvVI4VU+/jqdt3lzPvcb4JiQDEZmc2Mdji9Thv4fRvJY37KxA5dqO6LrOdjBQzkkFjgbySL
	b5SjjGWHdWkqpQYRhUu1mS/uh+37xk0Zsc8bk2yJbEXezUokQtLVOEegIzHOOWtVzBU8l6AzC+4
	KGzZlxfJhgZ4BkSfdjDZu1gnM8IuL1uHP1jE0emInkYD5GTzlnM7evvsEGxa5taf48rGGtHrBbw
	7Zahwr40N4ZHMMKv7BPeclVw==
X-Received: by 2002:a05:600c:628d:b0:493:bcef:5646 with SMTP id 5b1f17b1804b1-493e6862b68mr59669985e9.12.1783590975296;
        Thu, 09 Jul 2026 02:56:15 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742a49sm47241745e9.12.2026.07.09.02.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 02:56:14 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: cgroups@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	parav@nvidia.com,
	mbloch@nvidia.com,
	cmeiohas@nvidia.com,
	roman.gushchin@linux.dev,
	bvanassche@acm.org,
	zyjzyj2000@gmail.com,
	shuah@kernel.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com
Subject: [PATCH rdma-next 12/13] RDMA/rxe: Implement disassociate_ucontext callback
Date: Thu,  9 Jul 2026 11:55:31 +0200
Message-ID: <20260709095532.855647-13-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709095532.855647-1-jiri@resnulli.us>
References: <20260709095532.855647-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Implement an empty disassociate_ucontext() callback so the RDMA core
can move rxe devices between net namespaces. The core requires this
callback to reset user contexts without waiting for userspace.

rxe needs no teardown here: its user-mapped queues live in
reference-counted vmalloc memory (see rxe_mmap.c) that stays valid
while userspace holds the mappings.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 1ec130fee8ea..6eb10d2f0653 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -240,6 +240,10 @@ static void rxe_dealloc_ucontext(struct ib_ucontext *ibuc)
 		rxe_err_uc(uc, "cleanup failed, err = %d\n", err);
 }
 
+static void rxe_disassociate_ucontext(struct ib_ucontext *ibuc)
+{
+}
+
 /* pd */
 static int rxe_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 {
@@ -1478,6 +1482,7 @@ static const struct ib_device_ops rxe_dev_ops = {
 	.destroy_srq = rxe_destroy_srq,
 	.detach_mcast = rxe_detach_mcast,
 	.device_group = &rxe_attr_group,
+	.disassociate_ucontext = rxe_disassociate_ucontext,
 	.enable_driver = rxe_enable_driver,
 	.get_dma_mr = rxe_get_dma_mr,
 	.get_hw_stats = rxe_ib_get_hw_stats,
-- 
2.54.0

