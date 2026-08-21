Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6D330EF80
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 07:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787295917; cv=none; b=sZPiJp5p96Rs19FWItfPox+vl1Xr1w/SnJXpwvhJN91oHaZWxEN36WNcRQWRL4gNzr4JsQIFdq88sHn/LZd39a0EqzXWib9Ei7HIyrTfqyNeWdnjwyMJ87BuYGvjqBucbrlc2jqW2AwaKAZ00LeoTXIZco+24QBRoc54PU9PvLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787295917; c=relaxed/simple;
	bh=DmJp/vi+6ILWonYXZkj5nFKHTNQ+VfTuwhZy3v5z5S0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=RqiYt2ULR7jmLA0GiNYnMVcqimQEvUw5LRR9KY56nWL7xqPhuqM5Gf0/ak+wH8Esy4Qrktg5o5rOTvuz73uy4xfdUNXV3Xz4EjgXXejwxgiNYIQfNSGESgTE+B6J2BVY24hldy9mADmDe/PvL5mvJ7EH2zYL8KIbTf3IN4seKU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kLEiSjEf; arc=none smtp.client-ip=209.85.222.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kLEiSjEf"
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e53b8a302so69599985a.1
        for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 00:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787295914; x=1787900714; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0zmDvT9S0k3bq8hYlKyXaWcrzslmEN/ZbGYA0GARxd0=;
        b=kLEiSjEffvueavyr8Tf7Y7HkuLmr3M386MARIl4iK8JNYeOdj676PWXNKUYQsOgKBs
         YeW+cDtxVEUSJIFtPmA4xQmr8i/2eo1IPSJ6yl4Ec9aVKOn28zWN7WqzYjGCof/3EDM6
         8UJLI2XmriGWVElj750lTCBgGVbyGKI85jr5YUYOBenR1A0P4r8KVjilEtsmPogQTQyo
         X0TZ4x+1mLe3Xaciw5UK/McWLQqc33zUZ8rIA9dAwuwvkKGL+cU25BXB5Z3wimwodMHR
         rV3BRNxOLVhCZ8Au5q1LPTUtqmBSTk5INB1FpCcb4kLOfN2NP0xA8KrknkJ/wH2lCyFU
         EOng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787295914; x=1787900714;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0zmDvT9S0k3bq8hYlKyXaWcrzslmEN/ZbGYA0GARxd0=;
        b=luUgpqFgnvNmZxnBOU+ciOooJWL/q7c8MT45rCu8XTKl/WtGuscu5Me2IDZaDoQLcL
         66p1ZVRAEXtVeEgCyDOnK7Xe0ZPHNM8gfYMZX+VG40KmXPqwVr23W/kq60Jz+8wwj90m
         5BYosY58s8h/NI7uLEPq1yJV9uBsUMFDf0c47CvBZlis34UWFCWZQq70RrtPYBnPMH9S
         joA1lpYoWc0XHBd8pmbQp4Mt/v/uYekBh0HUBoGzfkxR3NNtqRdU1SIj0qPcX3o7hKst
         YTmld1HUJlUdEuUCUT2xTiXHPM7bWzlLCdJeHPlIOlfPpbICJrpd8wYP6o5suiT2mUKY
         nKhA==
X-Gm-Message-State: AOJu0YxQ2WwEur2D7sK80Yy5uMn9FgvzMpefrPqRt+UVp+/BSw6GZLK0
	bsnN87Hl5DmtqGmPqF/ii2fZheukOsaGh2JDscdSMdA8A0pGXtF7WX4hL0DIjPX0uLR/HnRFWFO
	ZzqTq4gw4sMfZQg==
X-Received: from qkjx14.prod.google.com ([2002:a05:620a:14ae:b0:915:7c23:5aa])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:225a:20b0:936:ad4e:9243 with SMTP id af79cd13be357-937395b1c2cmr243532685a.40.1787295914062;
 Fri, 21 Aug 2026 00:05:14 -0700 (PDT)
Date: Fri, 21 Aug 2026 07:05:12 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260821070512.3122442-1-edumazet@google.com>
Subject: [PATCH] RDMA/core: Fix use-after-free in ib_get_eth_speed()
From: Eric Dumazet <edumazet@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

In ib_get_eth_speed(), dev_put(netdev) is called before inspecting
rc and dereferencing netdev->name in pr_warn(). If dev_put() drops
the final reference to netdev, netdev->name accesses freed memory.

Move dev_put(netdev) after the warning block so netdev is kept
alive while its name is read.

Fixes: d41861942fc5 ("IB/core: Add generic function to extract IB speed from netdev")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/infiniband/core/verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 86811d31092ce03c8156b444fece47b824231219..57f109c8085dadf90bcc498a9ee64eea3c5f5271 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2052,8 +2052,6 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 	rc = __ethtool_get_link_ksettings(netdev, &lksettings);
 	rtnl_unlock();
 
-	dev_put(netdev);
-
 	if (!rc && lksettings.base.speed != (u32)SPEED_UNKNOWN) {
 		netdev_speed = lksettings.base.speed;
 	} else {
@@ -2063,6 +2061,8 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 				netdev->name, netdev_speed);
 	}
 
+	dev_put(netdev);
+
 	ib_get_width_and_speed(netdev_speed, lksettings.lanes,
 			       speed, width);
 
-- 
2.55.0.766.g2966f0265a-goog

