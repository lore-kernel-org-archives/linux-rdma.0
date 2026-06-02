Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02743AA1B8
	for <linux-rdma@vger.kernel.org>; Tue,  2 Jun 2026 21:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780436719; cv=none; b=R4FeQTF/nww0q9C7E7bUjw5En//8hQ8tMQ+FHNq0QDjfL1tMFvWhQcXKwTmsc8RYKMp0jX6M2jOuUaonPv8mi5xpRH8NubAxuE+pg0ybkKINjdg/RvYL+3gHZv6sjSBuezNd/W6AEXR9yYJsuJ6/zJMAGDMn14LC1a4ILwM4Hyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780436719; c=relaxed/simple;
	bh=CHDCMffsguUENrDXKkXKIZ7/ZjvN8+mrkp2Rbuqb0PQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KUxHSCP1jvfgd/uh/1dNZP5+wL6R4em0QwbkTtB/BtWgvZGY68Lnefj2SY4e51kvce7hhFGZ+aqr0pgx9sV7jgaR1bNO330zlZn+Pd8CL3A/ckTr6fPTD/cx7vyV96sQkKccOY+Fa0u9OWv5+xNs/z81lQaaybieNh4iqjeuyg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NFwHNAEy; arc=none smtp.client-ip=209.85.222.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NFwHNAEy"
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-9157f453a27so192794385a.1
        for <linux-rdma@vger.kernel.org>; Tue, 02 Jun 2026 14:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780436717; x=1781041517; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hqcs/O7zspAFRNMX5NHRdQd+ViJqqE//kVJ3KWT/ht4=;
        b=NFwHNAEy5MlHoxi+/YrtEz/IoNHUhkYnptPFoaPJLfw6gHFHcQKfQZjK/2GXreNejF
         ZiunG613BVkW2ryJxjmQyRlk5W33JuvsKWFovcnwvYjyO8RHmOmwKNBvsA0uJIfKdaWp
         mOEq+jwmEHko1NHq/+GRJYm6v+3PTghFk8pg2Z4tYLYOW5sQ7p+osdGrU3ii3YGUmKIC
         R8ZeBMBZqriCYO4r2/ib+QSWze4LAl4IeuskfcQErvoWsKnVkFbtUbXYPuOmLDHakpOT
         aLZaPBMgjXZJNGtyD+NBjVXENzXgOsL61QHQ8n785zeRfaQW7WtRJx5ovRARwlNoOuIu
         +qfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780436717; x=1781041517;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hqcs/O7zspAFRNMX5NHRdQd+ViJqqE//kVJ3KWT/ht4=;
        b=RASHAA0lfuGGovvrPC4uFiiUVvoPpbE+YLchdONTrYhrXI+rl7uIZBV9vMq61emv3e
         KBErQ7Iz9d3BALcpMOTuYI5WwhVdhiY/kHrrhuMt7RisDVpshEkM6we8/RpTpX0JoN8E
         CQJQAE17WqogUcqbdx4DWS0v/UTbmtuXHrFRdH9gX13WcfWRjY3rhuewFFW+DDwx3FGI
         4JMb2vimOh2Pl1BHdp4SLZ4PY9wxaGgescBSglrP8LpPdPM9tiXKWKBVSotPwf2r4rY0
         V5B8ZVxym8D0FRa/hz3RdAj9wYXbjBYcyJ+tjrkk/5PLvb5P6rGvJXSTQy1VjY16Tryu
         hKmg==
X-Gm-Message-State: AOJu0YxbLw0v1QRFFh6KmtHl424GPF9G3uRiicAUiikyTFOmALUhFYZc
	IoJ7g/z3pA57hs0qjIsIW1kLm1o1YHyr+g0/lhRPs4ntHgEFsne2x6zZU9mbSBB8DvFLH9OfRIN
	4oCgY0zwCHQ==
X-Received: from qkbde6.prod.google.com ([2002:a05:620a:3706:b0:912:add7:777d])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:258f:b0:914:babf:9f53
 with SMTP id af79cd13be357-9158a6f9e27mr152180085a.26.1780436716691; Tue, 02
 Jun 2026 14:45:16 -0700 (PDT)
Date: Tue,  2 Jun 2026 21:44:23 +0000
In-Reply-To: <20260602214423.1315105-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260602214423.1315105-1-jmoroni@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <20260602214423.1315105-2-jmoroni@google.com>
Subject: [PATCH rdma-next 2/2] RDMA/irdma: Fix OOB read during CQ MR registration
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Sashiko pointed out an unrelated bug during a previous patch:
https://sashiko.dev/#/patchset/20260512183852.614045-1-jmoroni%40google.com

This change fixes the bug by eliminating the cqmr->split field which
was not being set properly and instead just checks the CQ resize
feature flag directly.

The cqmr->split field essentially tracks whether IRDMA_FEATURE_CQ_RESIZE
is set, but it was not being set until CQ creation time, which is _after_
CQ memory registration (the only other place where it is referenced).

As a result, it would always be false during MR registration and would
therefore cause irdma_handle_q_mem to populate cqmr->shadow even for GEN_2
HW and beyond:

    cqmr->shadow = (dma_addr_t)arr[req->cq_pages];

The issue is that for GEN_2 and beyond, req->cq_pages may be exactly equal
to iwmr->page_cnt and therefore equal to the size of arr, which would cause
an OOB read by one.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 4 ++--
 drivers/infiniband/hw/irdma/verbs.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 670b0e0f9200..4a96e14d1418 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2567,7 +2567,6 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 			}
 			cqmr_shadow = &iwpbl_shadow->cq_mr;
 			info.shadow_area_pa = cqmr_shadow->cq_pbl.addr;
-			cqmr->split = true;
 		} else {
 			info.shadow_area_pa = cqmr->shadow;
 		}
@@ -2975,7 +2974,8 @@ static int irdma_handle_q_mem(struct irdma_device *iwdev,
 	case IRDMA_MEMREG_TYPE_CQ:
 		hmc_p = &cqmr->cq_pbl;
 
-		if (!cqmr->split)
+		if (!(iwdev->rf->sc_dev.hw_attrs.uk_attrs.feature_flags &
+		      IRDMA_FEATURE_CQ_RESIZE))
 			cqmr->shadow = (dma_addr_t)arr[req->cq_pages];
 
 		if (lvl)
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index aabbb3442098..289ebc9b23ca 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -65,7 +65,6 @@ struct irdma_hmc_pble {
 struct irdma_cq_mr {
 	struct irdma_hmc_pble cq_pbl;
 	dma_addr_t shadow;
-	bool split;
 };
 
 struct irdma_srq_mr {
-- 
2.54.0.1032.g2f8565e1d1-goog

