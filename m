Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C76B3BBFD0
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789491812; cv=none; b=nubuh0gAZXAZLnIlJPgWaLuoD0VdnIO86cvuL2ib3Xct3r9ZOp9ocpI2CfQCnPHTH53OlOIX2ExvbEdQodQKOSQvlE6lbVkYjBahgSTK8Pow1BZv/YfjdZeL8qo2g19iUJLJPgFtPnteu1RnrWsaep+IyJNXWY9MuU7mEU8FxaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789491812; c=relaxed/simple;
	bh=lT9BmO2d+vI1OFhdQ+5mESiV4B52msQbiI/Vh0cJM/I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=rO1AWxD+Lreu2CxVqzBHJktstXA+/KIaxhIHVqJDCLb8+5aqhVMpQUIJxtCOR4UdbSAtYMrQMGLUEgVw8OHA5y/nQVJ25l4o+kOvYAI3tcgvbVY62UL6+lebNcFpbCTvIQv6PqI4nQcGpUS6QkGjAp2vsK00PjnZzz84r0/+jEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sAzEXezT; arc=none smtp.client-ip=209.85.219.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sAzEXezT"
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-912054a1c29so60633056d6.2
        for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 10:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789491809; x=1790096609; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8DFX1oywQUyUdmV95w+YYHEPTmBRwoRKA+Q+FI49FE4=;
        b=sAzEXezTqyZG0sqgN+xKyvmvICEnJ/ocHoXv8P0d3E4Vf7ZJ7bWh/Z/063oN1yZ3i2
         TF6P2GHd0vMywLwcy7G3ukNy4ln/rJv3naKo2tPpJpTUXcBsGMF8+pdFJxQWNnuxzd2P
         kSmHf3MZIMiO4myzQ/RBtJK77mmA2BAZMKZT8JdslOWyhGQz69+/A2Ag90KknYqeeUND
         I/wNSAYDJ0ooP/zz3T7sb5y+3+/eKNRL4U13y7OxjBGopIDbIWhO0Fc0YFq94dxLdMPm
         bHY8nO8fTa62TMWG2GBZQ75hGzzt/1HPH3WCV4vaGU5t1rUXMDigiV7v52bUI0sFq1zO
         CiPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789491809; x=1790096609;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8DFX1oywQUyUdmV95w+YYHEPTmBRwoRKA+Q+FI49FE4=;
        b=vQf9Zdx5efbzDsSqQyykG+mMnxm+UPe9nx9fu8FeVjju2LDqRRXFpf0ATmyQ5rRUZ3
         CdD1zEe1U8JuTnrNl96ytS1cVBeq/dQO59fHzA8wC30txC3t+fgE+Sdt0z+pZLbY2qLI
         bjg9EzM84YaI5k/eR41P/vPrUBzY1S5c+dtXtBIG4Ra1xLHU6m0zEhFR7aFUeuGMP224
         OjOnEyc3EfWvCHtKC+VtHD1Goj+8muyBNAC59zXijZwmrgiv0UTdzq/HmVCsdNmD3tk4
         hybAPpwVzDhISlfe3FRN9VzH03acIOnlQuBStTBnd/m6w464Fan1AMav/7lG3ThvtqhI
         4t/g==
X-Gm-Message-State: AFuF++lac76/S2WOfkCQDA0ZlybhpCkZ7zyYdI2S22/1mmCC3eZQpB0l
	fHyCrQVrNUJEIMQmdWhxiqxWEru+Nn85Jocc6i7RIReSnUVkTxcBsiVzwGp8xqXGw5SFUAPiXgn
	yxJ8U+zaH3Q==
X-Received: from qkss4.prod.google.com ([2002:a05:620a:804:b0:93b:2254:23b])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:a0cd:10b0:93a:855b:b95
 with SMTP id af79cd13be357-93a855b2dc5mr147384985a.52.1789491809016; Tue, 15
 Sep 2026 10:03:29 -0700 (PDT)
Date: Tue, 15 Sep 2026 17:03:17 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260915170317.2901672-1-jmoroni@google.com>
Subject: [PATCH] RDMA/irdma: Fix erroneous -ENOMEM for large MR registration
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Commit cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
replaced the explicit level1_only boolean with a bit mask
but did not properly convert the "if (level1_only)" check
in irdma_get_pble() to be "lvl == PBLE_LEVEL_1" and instead
left it as "if (lvl)".

User MR registration passes "lvl = PBLE_LEVEL_1 | PBLE_LEVEL_2"
so this check always evaluates to true and causes the
loop to bail after grabbing a single SD even if the region
actually requires more than one SD (as is the case for
regions larger than 1 GiB with 4k pages). As a result, these
registrations can fail with -ENOMEM even if there are
sufficient PBLE resources.

Fixes: cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/pble.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index 28dfad7f940c..14318af97d58 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -482,7 +482,7 @@ int irdma_get_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 
 		status = get_lvl1_lvl2_pble(pble_rsrc, palloc, lvl);
 		/* if level1_only, only go through it once */
-		if (!status || lvl)
+		if (!status || lvl == PBLE_LEVEL_1)
 			break;
 	}
 
-- 
2.55.0.1032.g73a4cd73de-goog

