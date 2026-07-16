Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F596429CD2
	for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208255; cv=none; b=GuJiEofcA0/sBr3WTCpFDDlTqgH3mvbY0Ct57hyimfsvQB0DMDp7TCQaKPAgQ6lRXYCQQq2JVoVVF6Ao83R4HYFAgC23nhlJ5RBstprl+ebfmZuXcwfuHGV234I70CKNOiPdw/i8v6ZPoCA9dipABD+xx95nX9Fx+XtxpE6a888=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208255; c=relaxed/simple;
	bh=AlWKq+WCpJ6jqrd7bHxM+xUmQDKopJjD0aSNOnzQ77Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWyoxt1QnMYOXNlhqTm7H7V8px87KJwzVqz8tTpCeSp2x5bmJ0pnQC4kH5YLaN1slJBKuy5Wvr/BZOZ39dtQk1caC4sBOU53+ryYCkccvulVSXWcm/y8e/F/52tidsDMx4dedflpnkHeBvotwgOQ4QYSJ+8PrZp1t9j7RimWlVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=VlQlSpmE; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="VlQlSpmE"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493f4638f4aso28059865e9.3
        for <linux-rdma@vger.kernel.org>; Thu, 16 Jul 2026 06:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208253; x=1784813053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1DAcALuj6CLiGGxg2YU+zPjUKqyxKHB8HUr7MGOtyF0=;
        b=VlQlSpmE1Z3leOD1COLVeZhT+Hg9Mz8WNBDSoQQ9udLnHRDIamdI+5I90i9lFdObiC
         KygFfig72N2Y6nJTFQdaubmKvaPpg72DMiik8GnUK00qWd7/nxGEkGZrsaGCQen2AFxZ
         qJlmmWfTUm4lwQv1hkXl8VFpKe2PaMaEgC4IXfDWscZ3qExx4a8tTQBnCxrH4+jc18YU
         Cd01/dtXB1C5pfyjxjDRATPNp2hFbMTzA4Sn4rkyVx8cyN1vC1JPzcxKakzkoyhhjbc4
         CuwhiIINuyl+d1BTW71znX+olnpY7MyDZdcB83qDWVTp7aXbNzqHPCqj2dPZg+Yl2qSR
         tzwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208253; x=1784813053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1DAcALuj6CLiGGxg2YU+zPjUKqyxKHB8HUr7MGOtyF0=;
        b=sDzZ+KtclINfkSHWUNckb9m6whxPdLk/1YIrS2Z4AB8v3vPVbL2gnDzyu6BpngbQ6W
         WXmdfTnugaGG1RoRfzTb84/f0iLIiGJ45WIFz7fSVK9V7aNnyfbK3ijxvoigOfNKKAnc
         l+6uPah8NSLnvHcxx7ENcwJo6QL0SS5KC2YQpPtRu4QxnaHhMwW35VQHfVq/lmF3S8+c
         V+VKwAoyO3xrsL4BFJ2Ema0xGjFKBr+9AZJhc4PBrV8IHkIkEYJIW8XWwYRI6cwkFG3Y
         cne94HasKtcYpsT8WiVaTH4WYAWvexNTGqdN667ZOEPS1GVybtp8WayrX4CpfobP4seF
         14rA==
X-Gm-Message-State: AOJu0YyhSqMsXjxpmJNUd/lH1wgth9OXyl1XpkG8m6MvzVdOmur2ZZcK
	L6/ADmBdqDfNFH8HTGRXYWaRoYkOSXnUUFJ6zB2ZykVFmMRpiPwRfzdCeO44+X8bIqiq80jVlXx
	k1kat
X-Gm-Gg: AfdE7cnhk4QhRuQglhGIA0x/XQn5ZJ+eero1I/OdCoaS55BklUnlkm3AMF87rzToMUE
	+4/rePpjDX16QZzBFojvNx5bN7kk9q5MAdS7u3xFERJgPsQwW4vahyS2bl6UpzbYhaImAbNL7x+
	4mfjhjNqOmQSn2aIC9/XTRWDpmpSWuxoBx6zAHaB5E25/Zky9mQqXvqiy5+BGrKTNPMQdJM6YLC
	JWU4qTn/aGjxXPR8XxZfdLnXEe89HQfg6DE72OeQg5GyUh+4mlKXzjCoIKI04b6PKvE+L8adVD7
	7227H3V57IgJYkjLNanFaBNLz7/UmLjYVhvzA970lmCZ5ZdbCTxvY//RvyQ6VuiSgSBIBHIVpxz
	NEA1z8kdKEUgT9VlfHzYxZvqU/VV4OzJCgmAkDgZge6kW9Ox6HYUbGuuU1eeVQwIDH+UmV94URI
	eV6SXZkNlXe1/BRh0iA/MSUg==
X-Received: by 2002:a05:600c:6287:b0:495:4749:16a7 with SMTP id 5b1f17b1804b1-495474916eemr1028195e9.14.1784208252423;
        Thu, 16 Jul 2026 06:24:12 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a5d7sm23813896f8f.10.2026.07.16.06.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:24:11 -0700 (PDT)
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
	wenjia@linux.ibm.com,
	yanjun.zhu@linux.dev,
	cui.tao@linux.dev
Subject: [PATCH rdma-next v3 13/14] RDMA/rxe: Implement disassociate_ucontext callback
Date: Thu, 16 Jul 2026 15:23:14 +0200
Message-ID: <20260716132316.1495242-14-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716132316.1495242-1-jiri@resnulli.us>
References: <20260716132316.1495242-1-jiri@resnulli.us>
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

