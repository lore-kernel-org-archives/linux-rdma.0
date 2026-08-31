Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B7935C696
	for <linux-rdma@vger.kernel.org>; Mon, 31 Aug 2026 05:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788153682; cv=none; b=NloR7LCP1c/48tsAAki+LKycqnheXzUMqZ5OF/julER24kajnLDWXmbayMTjA1scrhWtRNaUrlHoSMNOEnpfqAZBbklYOJ0qFXwEcrkg7/hvJWouB401T0znloDZ9QsveoB15nYSdNO1qSYOIBSjmuC0yUTOJ9FbagLTBXqi7lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788153682; c=relaxed/simple;
	bh=D/OAPtmWMg/a24pmYC9Ob5VtMdBNPfjduUlqAtvXTS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b0a72facbik6nwChKXBqy1XDRBXPlnwK0Vj6jt+0ThwDiGr0yCUODj24BwLp29Dz0jVeteOIEB0DYjOBpYjkQ9vqygxtumGnkJAU21rrZNJG8muT6M7u5DX37OLQ5oox4i3AQRB+h7Ffe0uFLNrDixZ53Xw8GFeLGLfblKG3tHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U4a7MX6b; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U4a7MX6b"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c9aea40d799so1679984a12.0
        for <linux-rdma@vger.kernel.org>; Sun, 30 Aug 2026 22:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788153680; x=1788758480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a7w1HCUHNpjVoop/odhxR+2e8lKBAC9Tc7w090GqBj4=;
        b=U4a7MX6bEZTs/VvDrfZw6JnrwBpKfH3kA0gXnZA/uiHr9fC8zqNtw86OerV2R7MQib
         d8jNm8uEZRtk1wNaWJxf5pOIVR03mXgXgkz6Zy3CkQ+GghtBR2Z6+NsAh1+7Gvge15I2
         acdqvZo6eDSNcZ/2qw5M0sGuWM7U3lJ4QXEbD7OxQdoDUaGg4hlBQ3ajqa6X8lTxCm2l
         ycg6PxPYyKvRzUiFVbHYd+JDC0Sjgx1oshaBhTPM0mFHh9sdVMX7tmI0ec8MEjPW9+ku
         PgP078zxf8cjP+/FAtuJHZ7LKhfS6T7Kwm5k403509OF1YWf2BKDpCBwN0ntfbrV8CsH
         /5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788153680; x=1788758480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a7w1HCUHNpjVoop/odhxR+2e8lKBAC9Tc7w090GqBj4=;
        b=HpBSMuRYyPx1S5AMdbAekj7Gik1PWKBUvJBS8D+3gr9o/SxTEW79b+OpQqlLNB9Aia
         r1oZzNmJqob5bj7McYOCTTVc38sFW+Zv2qYeJiG6J+5cv3GtT1Mx4Qj8uGzphuOiq6yZ
         lWRG56/W6Gq+gsuW3IRAb1amlOjnXFFuo61UXbqC0m7E+cDFdVoTqbvFRnVVJJc6NIA1
         yHYycw0chjGOiec+vfcYD0Mlw306cikDlFi44rhA+mlHd2gnPMeOm/r3ihHPMTYujop8
         q48AHhJgXV7xXO5/VK9VS8E3p0PqJaB5UM6BPlrMqY8gjLLPDnrRR6d284w2Y/W9PZ+g
         z8bA==
X-Forwarded-Encrypted: i=1; AKwUvBwHCwttn/HHrYK5ecAsNG2RYLvk/H1Sht8QTHczLeTAxK7QAa6VqFSRlvJ/9Pkq3XEOGlmYW2GNYKYh@vger.kernel.org
X-Gm-Message-State: AFuF++k8YyewFchk3kURkYpnUbOcyDav49Nz5h6iI9OtwAjfBX8m6zpg
	Tnilr1/V6SUPLxepTvwdGOo7gVV/9r5Dyj/W8fCTO2l5VVTegxhcERiwHIG9fw==
X-Gm-Gg: AYBFou0dpjsUwYxyZWiDkbXjkA/yP3eO2+8lmk/wERYsbbg9hH2uMhYhi8yceGV1qP8
	NehB1KER1/pitZW+slJCNJ9O6ZiGDwrjJiibrVlz2csYPYxeIw2yh2Y8GOrxFourDaHNnJSJhJZ
	H6Viv30/fkPSdrsh5SCogHJxcD7cDuwXV3ogQu+Zl85BZj8mYGFG317mnfoCpihj64TEm4SF+QY
	nCyjlWm58RPm1oSuaHgdndYv03L7RDyh3su2iMf4hS7A5lpWFAP5kXG5cnqh5muJ8WpeEi8Bbmp
	prJx/aZ1GZq59B1/GrQM4WJq1oCEx6j27MwXqH+o77OOFd0itJQ+B5DDzyAHTQvMwbVqNlnWule
	FTyLCTd2m5RKpk6leEazMg3BWLALY7Ix+Siur/S87I1q5JXdrzkOzxybnkhrPauzcu61m/3bw5z
	Wlb+MZlmw0Vf8he1gJ80cVWnZgXtfDQ5ZgvbgnFeWUOxX/eFK3Zln+k34=
X-Received: by 2002:a17:90b:3c8c:b0:38f:efed:5448 with SMTP id 98e67ed59e1d1-396d0e7255bmr36972808a91.8.1788153680048;
        Sun, 30 Aug 2026 22:21:20 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0ea808csm19612656a91.2.2026.08.30.22.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 22:21:19 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Long Li <longli@microsoft.com>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mana_ib: Remove redundant NULL check before netdev_put()
Date: Mon, 31 Aug 2026 14:21:07 +0900
Message-ID: <20260831052108.903019-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

netdev_put() does nothing if dev is NULL, so the check before the call
is redundant.

So remove it. No functional change.

This is the result of running the Coccinelle script from
scripts/coccinelle/free/ifnulldev_put.cocci after commit f83b8a58695c
("coccinelle: ifnulldev_put: update outdated helper names").

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/infiniband/hw/mana/device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mana/device.c b/drivers/infiniband/hw/mana/device.c
index a8d19586a78a..62c7803ca6c6 100644
--- a/drivers/infiniband/hw/mana/device.c
+++ b/drivers/infiniband/hw/mana/device.c
@@ -103,8 +103,7 @@ static int mana_ib_netdev_event(struct notifier_block *this,
 				ib_device_set_netdev(&dev->ib_dev, ndev, i + 1);
 
 				/* mana_get_primary_netdev() returns ndev with refcount held */
-				if (ndev)
-					netdev_put(ndev, &dev->dev_tracker);
+				netdev_put(ndev, &dev->dev_tracker);
 
 				return NOTIFY_OK;
 			default:
-- 
2.43.0

