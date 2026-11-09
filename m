Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794255940;
	b=2/PrE9OLORcVqmPg79AbP+BYb9cBlqSIMDeHvBnyk5eYzjer0A71S0Tz5BlXXSU4V8xG
	 41z0OR/0HpW53ID/Zpbv79+bq3gSKuZAvUFUNilhk2+AwSa/hhn1s/uq9xJP71MvcVDzP
	 +3OYYAyWlE/ox/A1kvOFT6uUFIcrajzp3jnQ4ggqblKylAdFsCgesS5vZNwYl4uJXCWeb
	 ZnKnE0+UR+FStsvG7zwW9UI3wBEAAsN5rAMUhDA4YN3UafLrIiG5HN18bKAgOUr3HuCIs
	 zB714KXZEwPp8fXwQpm2+cdowBoH+yp8glIB1R7YzXBkhfVEuO/ifIMSNP9n4gjig6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794255940;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=pay2sYosAnhwn7fQyh9Ku6y8vgxixtQ82AP0dwKj8Bs=;
	b=FmBCvig8W7hLo3seR5sB9mPRGDi1O6YtcX2GG7lSKdnKKWwzxIZhaFgZK+ZGCJB+j2oA
	 XPAagJCkDnSae23N9Xh0He51k3ErClI6DA1K9V1qK63sZykt1JTQkW2j8N+i05+wJKaiZ
	 +NRRVWoSD8ldw4lKsHnRWqMsUdhYzwSXS5pFydiLVgCkUS1bHASylKi2KCxrmBiMQ9QvH
	 YLgqkwQ/WG9HsNuEYSvFfoixgsDQd+wyOuJXNDu1L1JDUk0Zr3AiVu2Ko/ZjNh5pED3vP
	 DXdXJRKGZ+o/3fwpAmlRkd5c6OJtJ8FkqeEuJ36UtApZxADkFiuPNl9pM50YNO45muw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Cjh15iRm;
	arc=none smtp.remote-ip=209.85.222.200
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85C1606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:25:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B85C1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Cjh15iRm
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93f559420f3so144129385a.0
        for <linux-rdma@vger.kernel.org>; Mon, 09 Nov 2026 12:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794255939; x=1794860739; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pay2sYosAnhwn7fQyh9Ku6y8vgxixtQ82AP0dwKj8Bs=;
        b=Cjh15iRmcXFnThThnNmiPS0zpp1Ca9YafhB3J/NWPOhoqDZLSJI3DiKP0xC+Rw/FXo
         WvPmSbK8zfOJK19ynLbviXxXqT4gpFPckTpo3t+NupBMFaeZzlH7+o1gq0teegyXqHZo
         M8xdQ6PQkZkrlyGYWIa4mMK0vuqkVI4SkcAe8Yj24GF5jdeeyK6yJm+Dkpqx5sySkI7Q
         ZbarhIthqnF7u6qHTiBFc5OtraniW1V9R8zLhVdxBH7t1kpKPfq6URxRx8wwhpZ38FDq
         sDEtqcBAGg/P9GPn72/8H+1yfnR58aSZRoFRWy28dIG+XHEZvBViEYKVb5fWDrA0flDX
         ++zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794255939; x=1794860739;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pay2sYosAnhwn7fQyh9Ku6y8vgxixtQ82AP0dwKj8Bs=;
        b=uHNz0lW/3muqwp+ftHpSRWXDX5HzgaeVfft2PqyYm5lm+qPpZaPi9WHBYxLLuOwmin
         rj9hUK91i0Ld+BGyW+yACpTi2c4BzYpTsdWgCAi4hQ9jvt5hGoRFE6ZP4uW8/2ecDU69
         31bkDAjuNn0gtaW6wBaOTFmyquU1BZDX+vSqq1rc4YdJsxZy+A4c3b1hYFaNWTUf2jRJ
         l1jjph61pRfr/C9OMlNHfxX6B5MbU/mBLuIFXOYzwYOa3ikszQlcHKA9DM25CCSqPSgL
         oqkD1++9A2UjgbZZOnnm1ThmfFHfDWAHxsa+guzUxyTQSMMSv22T06ni6pLUfDbeR7WM
         Z41g==
X-Gm-Message-State: APuU4Z/h8ZNs/BF0nWOAEnTaQoPIo0KbygtheVkFOn2TTsVVnSFXCXfh
	YkKuwtxQoomjZk2uCSDhjA+sqWC6M9yRFgEJZXMV/SnVK6p5WWtbx9vBc1mgUu1dTrfEjb2kWiG
	4/u/gRzZRxA==
X-Received: from qkbe6-n1.prod.google.com ([2002:a05:620a:a406:10b0:945:ccaa:ae3b])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:410c:b0:93c:62c4:e2e2
 with SMTP id af79cd13be357-9479f1d77a3mr102599685a.12.1794255938384; Mon, 09
 Nov 2026 12:25:38 -0800 (PST)
Date: Mon,  9 Nov 2026 20:25:25 +0000
In-Reply-To: <20261109202525.2937295-1-jmoroni@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261109202525.2937295-1-jmoroni@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109202525.2937295-2-jmoroni@google.com>
Subject: [PATCH rdma-next 2/2] RDMA/irdma: Drop unused SRQ table from resource memory
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

irdma_calc_mem_rsrc_size() reserves room for max_srq SRQ pointers at
the end of rf->mem_rsrc, but irdma_set_hw_rsrc() never sets up an SRQ
table there and nothing uses that memory. SRQs are looked up through
rf->srq_xa instead.

Remove the reservation so the allocation only covers what
irdma_set_hw_rsrc() actually carves out.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/hw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 3d755cca243f..db741afc80d5 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -2154,7 +2154,6 @@ static u32 irdma_calc_mem_rsrc_size(struct irdma_pci_f *rf)
 	rsrc_size += sizeof(unsigned long) * BITS_TO_LONGS(rf->max_mcg);
 	rsrc_size += sizeof(struct irdma_qp **) * rf->max_qp;
 	rsrc_size += sizeof(struct irdma_cq **) * rf->max_cq;
-	rsrc_size += sizeof(struct irdma_srq **) * rf->max_srq;
 
 	return rsrc_size;
 }
-- 
2.56.0.542.g3ef89b7020-goog

