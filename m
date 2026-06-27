Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com [209.85.222.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642D31419A4
	for <linux-rdma@vger.kernel.org>; Sat, 27 Jun 2026 02:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782529025; cv=none; b=fEZbaySYB9lC+vIfWe3GpgDPPVrKuvGMvnJ0eOSFoDcUYhfIWMfYvtFofWux/+co1coiGYreHYkhJEm1A5DAve38WsXRhS/I05qY9akcbpVCwBhgNHsUkN1a6eyUO9bbSZ3lHvEHZ/ZcwhrQF9Dr2l0pwms46FZcwt47DTz5KGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782529025; c=relaxed/simple;
	bh=XB7GNetCX7vFibZAVlrXo49qnYwfQr1/fh2HDbqmF8I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fNAuvDeQnIJLCDRo13KErH/Ucm6eLgS9j8/M+2xAlgxRPeL3Af6Sx4PV77ojO6ekomNC+2ySfIrtstEyKCLwwsJ3hi79OYKo5ifPHiZnhnL9Yn/CFKkbW8PGVQpw50MyG+kJvXdh30ne7sfVb4S3hm2H7rZTFXsPBSfqgLVwEG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EYirj1eZ; arc=none smtp.client-ip=209.85.222.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EYirj1eZ"
Received: by mail-qk1-f201.google.com with SMTP id af79cd13be357-92ad11e2197so246202985a.1
        for <linux-rdma@vger.kernel.org>; Fri, 26 Jun 2026 19:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782529023; x=1783133823; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Am4I5QfrZhf6PpMmo5H6w2DfUTBQji/OnOmcVgK6WRs=;
        b=EYirj1eZwopZw/gXCtqKpalXfLXjcdJBGXS/jom/6VmrziYS4ssOIHSZLeWnyLvzTW
         K0ZsmOjMr+ZihsB4a89BuBZznwsZcA6linfzo1t/fgk/t69n6qmTswQ6Y11SXPyiPb+8
         vqTa6SiwF+cMWi4vv41o7jrzZmk1Y7udqTBtomO+j626s0utZ+qg4eS9C1vjEtPo9i9u
         8uPI/ZRgl1vwHsQ20DBaCkw0RwtPYHye2q2dkZLLbtoTqXDXekGG0x1hOqwq+Gkb305O
         o+H8BcR7Tzv1EHwlcNLnQu4RChb6JqHtV+jVaxjaVrsFNnADDsYBI8KO/2clCVJIK75k
         rJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782529023; x=1783133823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Am4I5QfrZhf6PpMmo5H6w2DfUTBQji/OnOmcVgK6WRs=;
        b=EHN8jpEQ7qbcGFmnQY/iZ3qExuQTVdKUGxyhpUhfYc2bQTau0CUMg3ubu4csgdFrW3
         XUiB2hWl46kiKDSa6JiIPMjuJPdHWOMto/uxWgQr9ROxsZETCcwc0wTzQU/QLWTz6aV4
         hpwBJBsQwEIHbgwhyeTrquZHw2AlF0zwgpxkmgHTJl53TO7YzDsisrNkKpNssgUv4xFY
         Y+CaVkqT8VdurRPuq7Z6RiIdQxJgYD4lfdV+FsFSUijStQkca3NQOw2ByclsGJpG5HjQ
         pk0uincbuEyhVAHCLQMQdjxCFSouBG8+ZfcPFInfRrGO/Bz9XJngtu9EerzjQODrGzlH
         3qWw==
X-Gm-Message-State: AOJu0YzruBaTaAIJHJKoQrjQ24PlUz+B49uTdndBCWBnEro6aJiTmLAP
	ZIpycv00b552Tq7/D51weoFNamhY475wh5d2IA7cVPoa1lkylPKnGPUTAUbM6r1u+VneHhsaQTf
	MWN0T0QntaA==
X-Received: from qknqm12-n2.prod.google.com ([2002:a05:620a:864c:20b0:920:9c9b:169b])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:f0c:b0:92b:6805:9178
 with SMTP id af79cd13be357-92b680593d3mr378515285a.64.1782529023177; Fri, 26
 Jun 2026 19:57:03 -0700 (PDT)
Date: Sat, 27 Jun 2026 02:56:42 +0000
In-Reply-To: <20260627025642.4064973-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260627025642.4064973-1-jmoroni@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260627025642.4064973-6-jmoroni@google.com>
Subject: [PATCH rdma-next 5/5] RDMA/irdma: Enable uverbs_robust_udata
 compliance flag
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

The irdma driver has been audited to confirm that:

1. Methods which do not accept udata input perform an explicit
   check for no (or zero value) input.
2. Methods which do accept input perform the correct validation
   to ensure that additional udata beyond the kernel's current
   ABI definition is zero, and to enforce the required minimum
   length.
3. Methods which do not return udata responses use the proper
   helper.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index f07c11a0569b..6d97c32d7015 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -5458,6 +5458,7 @@ static const struct ib_device_ops irdma_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_IRDMA,
 	.uverbs_abi_ver = IRDMA_ABI_VER,
+	.uverbs_robust_udata = 1,
 
 	.alloc_hw_port_stats = irdma_alloc_hw_port_stats,
 	.alloc_mr = irdma_alloc_mr,
-- 
2.55.0.rc0.799.gd6f94ed593-goog

