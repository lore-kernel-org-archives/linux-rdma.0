Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9B93C0603
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 14:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791468748; cv=none; b=CIVP5m6Oed1qQtqPKDjtXoodHklotRq36NfAI+KTXaxwcZ+Uwc1jdKDELp38uAup9dK+OUy7u1Mj+Q2NtYbNtfv2H+XNz2JU4FkRGXQEfylTStJIT/9CwDicVc5R+aEfcOT9qf1ajPmMMc599D4z+kb9R5FdCBUOVA6zABXRvmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791468748; c=relaxed/simple;
	bh=7wkyy2yD82sNGCCk9GhwGN9YlxLXNUi2Q97VaIvfv0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iOZRjXKyEjusSd6U61HdWBQl41JrQcKfSfEclfIIHHQ8R0Spy5gfLgxPMaS9jN3LMQCxtzDpmDiP5N8Lf/FtZENc/JIOhn4e4HWyq6YzD5izwZmOMqyiUlzCVheJdokJn197632msvz+KUAliPJKl6oLEeq76UBACyT8EErTje4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k9JrYA/b; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k9JrYA/b"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48b02a2359aso831416f8f.0
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 07:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791468745; x=1792073545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pkucfHp2dQjWmjG5BzeIOm/V3naD65FK94W1wx43iBg=;
        b=k9JrYA/blZOIltF5SAL7ZhHTDsl+C5KHqAA/kOk2SBUcYBhLRp5aIh7Ptp6LbxZ3tc
         PcHTXNvsnj5nI0vHrHK287YiSeph7BTY0oSH5jWEKpov+Xe5E2126i6G8gvb3Z/PxF3n
         sM/z74nAtv9jQu237X7TmhkWMVMeTPCg+IkWTUOhbTM9G44v9Yt0snpdQ4yHF8Ok1//7
         4HPJ/iW5PkuquBdsr4jkMEa3MITPcSIfKMFeRIjnWNHjFhZVW9W1RweowzwL1ltMbw93
         HMf/zD9jOfkJgVtLjB+/I3lxIP5rRdHY2wIa+45fzwc2HZfbGI7KAy5bfqI6KoOuANw0
         82AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791468745; x=1792073545;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pkucfHp2dQjWmjG5BzeIOm/V3naD65FK94W1wx43iBg=;
        b=fGuH76n84guB7iTzqm7FNOrndghRma8OtVffgw/EZ9rgNR5KNtJt0PsrGh7mriFUiV
         A6BvwvvFdtFoVgbPhI8zkKEEg0lp2Sylpmn0i3p7+HaP7xyMp4dtGcopR4peTmco7pVy
         AwxtpEsVYldrb0AbyD7RDhCs8AeGtHWavU+dAU4SOtqsoWnJSkPpzbZiaLl29YeacdhB
         AEOzf5l8RcumWCAF2iAy/5+NDWjtWiXiO+DEY5/Rtd3ed08XzuvK+14TSodjpOP2pV4f
         3bntPOBotDJWkcF2FJDnyexpQOnqyC+NqdaA5yd1kBXr/jW/zyTV9PpxYCf4zS+QSfAC
         Hv0Q==
X-Forwarded-Encrypted: i=1; AKwUvByf3PyuejXzwKWKDMFJt5PkFGNI/HMkGXPN/oH4iStJxJKH+7HodtrXp5JsJ3Jg0na71ZGsPmnoo35G@vger.kernel.org
X-Gm-Message-State: AFq9FYK0m2VA9xnG3TlQkcPhQYVRREcrxNrCQaeSVykVrxqcqehhhITR
	Hb83e4lfRe6HsvLaEj/b9UuaE/FsyaUYMDPQBwaICaixRTM6l50mekKISzlWFWxb
X-Gm-Gg: AYBFou0t9XvZIYh5MDlQlRCAjqbIR2QdMxS//G3/aj9/en4RFLRrG4nuP5RC2RhbtXj
	hQWW5sO43O/eUICxvYc0BZjGiWQlKexgRtOQ8u6W/oicA6/SV5XChlpsYbbj1n9eFbTHkWsCsgW
	1Frxg9pht2zZSF6Ivl1zINXdg+9srax1cneGs9ulWuH4UVCi9IxbSH09xgbKjcw/NPhSBAeEiu6
	kS6uFD9/7XvExJe/rHdgROa+QRur1BKcONR2ijoQxRSdgl9vDSkQE2gltprIVD2YsbL1OgF26uY
	nq7MhgTO/oUj4efZWfwjqLniI6O1G1UL8mu3Ft4wKzfnVI6CC8pZTqkIaVcBvyUcgqWqhzhrGbV
	d2BTBoc/JD3wHzvgP9q14UX4oKYEeHOO2OFVHCkteVIznDK+Pf3kRso8kv1H4IRPk4nzMOpI1in
	RTZw+xTTf6GB1ABk0UAN1IJ5zIvi8jwkMn4dU5lZ17QDWBOHmcfxDI8bWE3ZDNVO8QNvgrOseVT
	q/xaj+ATJD7lW4xnBiv8XBU7ckqAdELteAxC1R+gQ5KTn+PClEcR/3fL5bs8B60fnbnNKXcDNmS
	KzBqwlO6UTf+ZE8=
X-Received: by 2002:a5d:64ee:0:b0:48c:47fc:df31 with SMTP id ffacd0b85a97d-48c7f0e9f94mr5528408f8f.7.1791468744882;
        Thu, 08 Oct 2026 07:12:24 -0700 (PDT)
Received: from SD.localdomain (heme-13-b2-v4wan-167795-cust403.vm32.cable.virginm.net. [81.108.45.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d04c0fsm11395902f8f.10.2026.10.08.07.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 07:12:23 -0700 (PDT)
From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
To: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Doug Ledford <dledford@redhat.com>,
	Haggai Eran <haggaie@mellanox.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma] RDMA/mlx5: Cancel software CQ notifications before teardown
Date: Thu,  8 Oct 2026 15:12:02 +0100
Message-ID: <20261008141209.6923-1-prathameshdeshpande7@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GSI completions queue notify_work to invoke the CQ completion handler.
CQ destruction drains hardware events and core polling, but does not
cancel this software notifier. Queued or running work can therefore
access a freed CQ, or restart polling after ib_free_cq() has drained it.

Cancel notify_work in the pre-destroy callback, before core polling is
stopped and CQ memory is released. Skip user CQs, which do not initialize
this work item.

Fixes: 25361e02c448 ("IB/mlx5: Generate completions in software")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
---
 drivers/infiniband/hw/mlx5/cq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 49b4bf148a4a..1653b2747f5f 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1117,6 +1117,9 @@ int mlx5_ib_pre_destroy_cq(struct ib_cq *cq)
 	struct mlx5_ib_dev *dev = to_mdev(cq->device);
 	struct mlx5_ib_cq *mcq = to_mcq(cq);
 
+	if (!cq->uobject)
+		cancel_work_sync(&mcq->notify_work);
+
 	return mlx5_core_destroy_cq(dev->mdev, &mcq->mcq);
 }
 
-- 
2.43.0

