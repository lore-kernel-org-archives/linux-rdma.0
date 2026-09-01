Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EF1351C35
	for <linux-rdma@vger.kernel.org>; Tue,  1 Sep 2026 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788278421; cv=none; b=gGlt8Lm6rbJD0AsV22E9XRZYV9d6X4eoueE7j7WJO2hkYb3FJAj30G6II3/4j0AYaIQAkssW6tsvG86ghaXpZMu88dqBntYK4VNjtaROvTw0j35C5racAcGVZqzJxOER4IbnGn7SYo8cYQ/YA18HY2tlDCPsoQuo7r7z5R7pXlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788278421; c=relaxed/simple;
	bh=DN03RjNL9ivOID2LaSBxKtvb0PgEE/sYWmZ8mgOP3Q4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DVz7OUYVib0qJ4QzhyC0GmL6JHMkC7tJPshDBSumWy0ZKaB1rxW8leXCPpmqXYAtYopehYwA1pXDUS977D3AcSs2FLHMGpZX/C19Ztmh1UI22nYw3zAFyfn42J7Krj8CnZ4H7KVnsAY96RkJyDCHxVFDfxnT4dGzFUvTax5hfQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hw7BE7C/; arc=none smtp.client-ip=209.85.222.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hw7BE7C/"
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93494cce712so12494785a.3
        for <linux-rdma@vger.kernel.org>; Tue, 01 Sep 2026 09:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788278418; x=1788883218; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XTZ7dOgoTZyn3RbrZcyajB0oUOd2KuS1fxmQryZrAi8=;
        b=hw7BE7C/dpedI3qHnM1wAIYCTExYpAIGKC2zUmAFnbUn99zzR+eMVIVZFynEyKYR26
         NgjiRwXwT+EtFHL7qj99d9J5DnlVUse6m9GptHGoUZm8ycck2gU18vwPwRamOwsdksCh
         xNb7B3ci6a4/SBhEwjoBXzxTYDyQpbYTJF8VnUM/0qOh7cVHa4A4+ymM1TKZLFjxGQaJ
         vH3KguVUnbP4Du2LrviQimLaYoq5TAmym9TQLHNVNQwI0l8+kqSqZXNMhyEopZdacxoc
         oKU7S9iPTBRlqiOZDtK4EO2/Lk8UDUNlhsxZB8zjydzEg7LRbM9SLZdbUYsFM1IvcdNV
         tQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788278418; x=1788883218;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XTZ7dOgoTZyn3RbrZcyajB0oUOd2KuS1fxmQryZrAi8=;
        b=MDmzHyGTdQIDZ1qnpGY1JMl+600C0uUHwDWPXyayeBbiXHcT1B42wRNMWc9KVs+Uoe
         TM/32iNblX9rAmqjVjQoG6TRGXYFhsEiyw7x/K/i3jljEp91FHlcFvbkL8C1rmjGo7t2
         eIbA5bkqt9qHf3qg9kNMp1Fk5avZEIQ15dMHS/I2vJfpOj0E7Z0/KlpbPhC3rP5jlsK4
         kQy4RzjXbZiR55xB+2hHUzAel3/nvOTzym36jdZDymnhIBQEADjYqfJ2GWToPv50tgof
         3w9ub+oc9uOZN1Xa+63Cl3XKf+yyVP4fvrbw4L5Zrdzp3m7zlPwPR3p8m29VwZszfsg6
         gBlA==
X-Gm-Message-State: AFuF++mNGuBQgstjWzIiZVnhVQCw5h6MtJ6LrwLuZkbs4DOUnS/ADvlt
	zKGu6LmIupz7HIUEpx0UR+saRz2YZdkRfHlRU/KD3FG0t0/HdiNUoHcR3Ik1eqquaNf4/sICkd5
	3yFPjSST8tA==
X-Received: from qkntz19.prod.google.com ([2002:a05:620a:6913:b0:934:9b09:29b1])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:a185:20b0:92e:6c15:24cd
 with SMTP id af79cd13be357-93947fccb8fmr1007083385a.15.1788278416207; Tue, 01
 Sep 2026 09:00:16 -0700 (PDT)
Date: Tue,  1 Sep 2026 16:00:14 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901160014.2026285-1-jmoroni@google.com>
Subject: [PATCH] RDMA/irdma: Enforce local fence for IB_WR_REG_MR
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Enforce local fence for IB_WR_REG_MR to avoid spurious
FASTREG_VALID_MKEY async events during heavy invalidation
and registration activity.

Commit 69e8e429bca2 ("RDMA/irdma: Enforce local fence for LOCAL_INV WRs")
was very similar, but was not sufficient to prevent all occurrences
of these async events.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 9cfd84dd6869..5d71300da0ff 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4281,7 +4281,7 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.total_len = iwmr->ibmr.length;
 			stag_info.reg_addr_pa = *palloc->level1.addr;
 			stag_info.first_pm_pbl_index = palloc->level1.idx;
-			stag_info.local_fence = ib_wr->send_flags & IB_SEND_FENCE;
+			stag_info.local_fence = true;
 			if (iwmr->npages > IRDMA_MIN_PAGES_PER_FMR)
 				stag_info.chunk_size = 1;
 			err = irdma_sc_mr_fast_register(&iwqp->sc_qp, &stag_info,
-- 
2.55.0.897.gb25b4bd76c-goog

