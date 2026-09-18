Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1455C427FBE
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 11:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789729491; cv=none; b=U4rP9RsgdIH1dhLru337eJmqQCN8cIaEm9wWyjqjj3AnawRhE2BB7d7cHbzxosCvcMBvDh1zUrdtny23sK87D7WDf4KLQPWCXDgILcx4Tr+lgSEF3ikyTtfuD/S0fTWVyNWwAOq1Y35+Lu9HtWeNt/HNi7uPIRpa4xpv7EA9fXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789729491; c=relaxed/simple;
	bh=q14v7R3EK3i7SDZaNs52rxEa4lQHtackk/2drf66XPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kiDRX2s1izbgw6H3YSA7SP8sAadwCoCUOyM0c9MvM3qJbQrryZDVkwX/fzR0usK5yNnbKPy0jukdMEPOq8vdCSzUlFFOn19oUJY6/jkH6ya97hV5dRnseAa+37MP43vTwZK7T9ay0fmnTL04xcC/86cd8Ba8U9qwgeMb0TIuaZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pn4y+s4t; arc=none smtp.client-ip=74.125.225.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pn4y+s4t"
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-49b92ccb8e0so1370405e9.1
        for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 04:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789729488; x=1790334288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dsUUrhZxDXVLnpzzLxhn6wboqqmfaSeS/zWhQNNaxZY=;
        b=pn4y+s4t76zBfhjulOlDsawk1N9xo8OoiwzEFAoWLCg2G1qXgrwoKe5bwHPLpEZVXi
         pwYy+IMNjeb/wzAhVZfS2rmiD0kNHDEj0YX85B5nYwJZavSOakxp+xLkSRfJD+tK03RF
         1Hufs6a5aLjGqYoNv21c+WTet8Tn69ZFgU1CVloWlBE/az6XOvnJy+x9ovloQpRT1sd+
         pKemMwH2GE+i9zrXGpkva89Q5+UTK3DpOcQe6FLLWEjbsuQ8Cm9ZF8q8qbhxs5J4vym9
         AXL7mp8uf8IwsivzxiRed5mp5g4JjdPlPhkjlGt5efslIFt4SXDEBsSVcCNgVCu73f55
         q4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789729488; x=1790334288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dsUUrhZxDXVLnpzzLxhn6wboqqmfaSeS/zWhQNNaxZY=;
        b=w2kwagmhuGf8oh1aXuOkjHXnOvrwkynVylbLehhryZht1oPAUMnxK3MDW227DN+E95
         afJYPruICZSvHIE23iUPP0wcnKTwV19Nr63P8rUFfMTuDL1klZQozgnxHelT4brAhukX
         lGfRysff2zDxJSZGIxw6dLap+bVuETtg3LPLV8DVVgINRcxlppElMZq/fkau49CSfatN
         FWjY6Z87m7gKJJvd4Wy6MoU1MRvPQQmyCbSfceZZsGUZAp6MgsVR+wAChlZp5odXOJGS
         xtXS0bJlElebLyyddetGcVjTxAHsIv4h0MM1IFxGrMbjfj6nzabNMp/hfuCq189Lm6Ai
         B9ww==
X-Forwarded-Encrypted: i=1; AKwUvBysRhVOniVIpd7CCqrRAKRB8Q0N8GpLaIBUdJ2wDtTKQe0yFu8mRjSPOYpkb6OW/5wLnqEu+dd3UZZb@vger.kernel.org
X-Gm-Message-State: AFuF++n36EAUcluq2cE/mL4yPC1LysjcTgowSwneAvKT0PZFImdU1JDl
	L9khx9A+qghPPsLaoTNn/4hm8hzJqiaZSUA3ERjgUK90xhi5osd2OdVK
X-Gm-Gg: AYBFou0efHSvqr/tJKioAmbxJ8CRPn5RODlt88OKocDxRcsp6yBDUNWB2PK1o3JprI1
	9B96UuOO6qqEoyJUNXtXIMqCuDPXUsCv3x2b8yj+Z5WKgLj7zPXpdNlBc/jROKiY1NyHZ4qNPpE
	8WeCZg3xjEY+mzu4E3MGbnJpAIsRdGMlbAjlvkJhyEgaXPiMp7rQJUBlpv9E8vdiasxcx7cT3Xs
	9T1uF0Rnsy16D63gFMydEgucwkclOFvGHzdmSSf06PMAuoF9QVGZCLCQ8VckF2bQkVNp6S7TpY6
	ksAHfUACrVH74HY19BO31mKXqkz3Np+5lgae06kkpKNux2aF5WpS1KF5d+mpxk9PqH/3OEJFTVs
	neIOJIjtMIGweDvhVDtqK93JmVBMBvW1Oaw5tJDtBix1jkuLQgLw1ltOJPOFM2f2dnceWOtxsNm
	xIULfSr3wB+Vg+4ZHv/two4pdI+Hchk0vechaT2oqZ7UiFAK88cWalV9vX5Cx758MI1/vMWWtxP
	2RSGeKQ0IwrexY=
X-Received: by 2002:a05:600c:a0a:b0:49e:84bf:6110 with SMTP id 5b1f17b1804b1-49fc56dbb49mr28248695e9.6.1789729488054;
        Fri, 18 Sep 2026 04:04:48 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.192.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc53b1b78sm34115545e9.3.2026.09.18.04.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 04:04:47 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: tatyana.e.nikolova@intel.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: shiraz.saleem@intel.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/irdma: Free IRQ when CEQ vector mapping fails
Date: Fri, 18 Sep 2026 14:04:28 +0300
Message-ID: <20260918110428.36586-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

irdma_cfg_ceq_vector() registers an IRQ handler before requesting the
CEQ-to-vector mapping through the virtual channel. If the mapping
fails, the function returns without releasing the IRQ resources.
The caller destroys the CEQ, leaving the IRQ handler registered
and potentially referencing freed memory.

Call irdma_destroy_irq() on mapping failure to release
the IRQ resources and drain the associated tasklet
before the caller destroys the CEQ. Use the same dev_id
passed to request_irq(), accounting for CEQ0 sharing
its interrupt vector with the AEQ.

Fixes: b800e82feba7 ("RDMA/irdma: Add GEN3 support for AEQ and CEQ")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Assisted-by: Claude:claude-opus-5
---
Found by smatch:
.../drivers/infiniband/hw/irdma/hw.c:1261 irdma_cfg_ceq_vector() warn: 'msix_vec->irq' from request_irq() not released on lines: 1261.

I performed only compilation test, it hasn't been tested on hardware. 

 drivers/infiniband/hw/irdma/hw.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index cae4f316def4..522a1685d400 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -1252,12 +1252,20 @@ static int irdma_cfg_ceq_vector(struct irdma_pci_f *rf, struct irdma_ceq *iwceq,
 	}
 
 	msix_vec->ceq_id = ceq_id;
-	if (rf->sc_dev.privileged)
+	if (rf->sc_dev.privileged) {
 		rf->sc_dev.irq_ops->irdma_cfg_ceq(&rf->sc_dev, ceq_id,
 						  msix_vec->idx, true);
-	else
+	} else {
 		status = irdma_vchnl_req_ceq_vec_map(&rf->sc_dev, ceq_id,
 						     msix_vec->idx);
+		if (status) {
+			void *dev_id = (rf->msix_shared && !ceq_id) ?
+				(void *)rf : (void *)iwceq;
+
+			irdma_destroy_irq(rf, msix_vec, dev_id);
+		}
+	}
+
 	return status;
 }
 
-- 
2.53.0

