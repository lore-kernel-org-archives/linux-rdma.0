Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com [209.85.219.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3463E3CDBDD
	for <linux-rdma@vger.kernel.org>; Mon, 29 Jun 2026 23:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782775554; cv=none; b=UiwKOAH7hnQP/kaSrETXbLvO79JFJCPMG83PPPGmyIsi9BspmRBwpMF0NKgq2Ls0S/zVuBKpqpcHdnDBA0RLUPwZ3+JeVD96JHjv1udwluytEaHksQsuiydgxN9B+fXHMCprgi6yURJilNa4i1u3c++8goaJJtuguqM9mljTvMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782775554; c=relaxed/simple;
	bh=LBP4PuyYJ/fuh48gDjT+shvsTxNkGXhDWHjrnWcJK9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=klEN+Bo1S1fu6jAxU31c5BJK13oHyFGWedqxeor61emdjGTQJKcSso9IvusYrcvGTci071RNELqTJ3rtV+hVSwR+N0iyN+Evpk/W4R9xo/1puKseWaSC1qc5ogB1CrA3oW1c8w7yVj5n8o10DYvdrPqIi2alyQPsTSPtTM2XHs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aH5U7vvA; arc=none smtp.client-ip=209.85.219.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aH5U7vvA"
Received: by mail-qv1-f74.google.com with SMTP id 6a1803df08f44-8f1e4e0eac1so3906806d6.1
        for <linux-rdma@vger.kernel.org>; Mon, 29 Jun 2026 16:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782775552; x=1783380352; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XFV9yMvU7ZCpcablHvugmiD0e5kB5Sex1+yg/nlJ+/Q=;
        b=aH5U7vvAy/d3J4nPNk9evkB5HXQxGBIoZGPzKpMbV8ynpJ7P88krI8sDfsRacQkE89
         2CY+PUiuvO/3gFjavtzaGmkw6yHlI6MnguaZz6tuyPltXd5rU4TEpcBJgUawXFW/5ulh
         6PJMT1mUXa6SHA4vV75Jc4s5KfVauMA6dnHUlS7uOXiecKazwzzo/U6o92gdErl0FoFe
         W+H9TXqnn3oY7EUKQuz3ifL6vrZoLbZ/347Ej4I0j3YZZbntJIq6l4QcsKoAk7dD4PwG
         kiU72SzOPPEyDXQD9vuGD7nsd9yLsNU9CczMSwXjfF9fehNe3wF7ezP3OVlk0Cl7mxqX
         AWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782775552; x=1783380352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XFV9yMvU7ZCpcablHvugmiD0e5kB5Sex1+yg/nlJ+/Q=;
        b=GkQG3jhSOdlNLvlKGz4YLaD6Vy2fYzTpQ50gbBuotHjehxmrkhhuTFC4suoems/RpB
         xPcyVroFCjtWeozmZeVVVtpBBJef4OJLYZN0RSiVz7hZ6jaP6b871zqYb3JaIsJ7Kf4G
         /ScLU1xH8CQ9YUYMS6Ap3dTbvt6I8o785dm/dZYLELTjbfHQzEOBiz/XBx1eBMGQn/Rz
         qNjnxJEgqOIqLpwf7HKKydDTgYqqxM8aHBTvwBY7/kG/EZlVUBxMcRqTllgyqP06f38G
         xOzR+LjXsTD0guVI4z8oPmPL0izdIiKElkRPkNoDsi0RptOZ8779uZZ58AyE86wjB2PY
         WRaQ==
X-Gm-Message-State: AOJu0YwHQkXEBHDsKO5Gl+9qQtFStSjOCXCxmj4qEZ3t1j6NrZxpmqFm
	ehWZ9HN4a0LfBnvqUvUqAARPFIPT5zpH+1vmxgPGhPZhRugsyHP+NsoXGiqOdARDCfhb/+l4xLt
	JMeXZig/a7A==
X-Received: from qvt9.prod.google.com ([2002:a05:6214:dc9:b0:8e4:2cc1:23b3])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:622a:2599:b0:51b:60f1:6895
 with SMTP id d75a77b69052e-51c1073fe7emr19977431cf.2.1782775552225; Mon, 29
 Jun 2026 16:25:52 -0700 (PDT)
Date: Mon, 29 Jun 2026 23:25:32 +0000
In-Reply-To: <20260629232532.2057423-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260629232532.2057423-1-jmoroni@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629232532.2057423-6-jmoroni@google.com>
Subject: [PATCH rdma-next v2 5/5] RDMA/irdma: Enable uverbs_robust_udata
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
index 30f2483bdc33..1170c688937f 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -5500,6 +5500,7 @@ static const struct ib_device_ops irdma_dev_ops = {
 	.owner = THIS_MODULE,
 	.driver_id = RDMA_DRIVER_IRDMA,
 	.uverbs_abi_ver = IRDMA_ABI_VER,
+	.uverbs_robust_udata = 1,
 
 	.alloc_hw_port_stats = irdma_alloc_hw_port_stats,
 	.alloc_mr = irdma_alloc_mr,
-- 
2.55.0.rc0.799.gd6f94ed593-goog

