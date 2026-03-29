Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1B62475CB
	for <linux-rdma@vger.kernel.org>; Sun, 29 Mar 2026 02:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774752978; cv=none; b=U8uqU54j4mbD2VJfUC3pQUuN8DjfPpJ8BRhBN0JNvPmrDsW5QLe9VkdRkjb+WQqGnBWNpZZC7St9gAYo2eWzTrT0snpsZRGb6VLW6beShwpXEthw6dRtTNf4GVw9Iv363MrJDPnGNGlzyOqlH+FBbDYyE4WKoJ4S6WmW++UIPtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774752978; c=relaxed/simple;
	bh=gHt2uVrQZ+RXG5jw+4DTyKLAgX4ajBlZhvZ+0RsUVl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjlQtTWk6VZw26lCka+WfV/UycQNAW51zbeNZTm0yrucl0/LfzcV61wLj0IuzNuJCd6d8KSZgcJV1n96by/x4i9PPFXFTjA3w2Ghcn99EEWmzdDK/MXx8PcvICnu2Eck/G6WIL9UT1pAAuunR+tk4az1wor3m3CUbgmetUr/5lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BwO2wAgt; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BwO2wAgt"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774752975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U/JCIft0jRdQEOBhC6+IC+hol8iiOXSHXWP7V4qbfks=;
	b=BwO2wAgt0kfTxImf3MYvgHVwGff0XhbABy17PEVsCHq69LneEkrWFZNEADvXEfn7nxRfTo
	CZ1aBrDM7kTY600/XlrqyFOINiXyLt+XxHAeqJ3Tw6n1Fi0XQQzlC+Ucw121ZsVgf3vVtl
	yEfDjEgcrnrwsJrOPhxsLJ+tD0lgfxg=
From: zhenwei pi <zhenwei.pi@linux.dev>
To: linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	zhenwei pi <zhenwei.pi@linux.dev>
Subject: [PATCH v2 4/4] RDMA/rxe: use rxe_counter_get
Date: Sun, 29 Mar 2026 10:55:52 +0800
Message-ID: <20260329025552.122946-5-zhenwei.pi@linux.dev>
In-Reply-To: <20260329025552.122946-1-zhenwei.pi@linux.dev>
References: <20260329025552.122946-1-zhenwei.pi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There is *rxe_counter_get* helper in RXE, use it instead of raw
atomic64_read.

Signed-off-by: zhenwei pi <zhenwei.pi@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe_hw_counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_hw_counters.c b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
index 17edaa9a9b9b..a612e96f7a88 100644
--- a/drivers/infiniband/sw/rxe/rxe_hw_counters.c
+++ b/drivers/infiniband/sw/rxe/rxe_hw_counters.c
@@ -37,7 +37,7 @@ int rxe_ib_get_hw_stats(struct ib_device *ibdev,
 		return -EINVAL;
 
 	for (cnt = 0; cnt < ARRAY_SIZE(rxe_counter_descs); cnt++)
-		stats->value[cnt] = atomic64_read(&dev->stats_counters[cnt]);
+		stats->value[cnt] = rxe_counter_get(dev, cnt);
 
 	return ARRAY_SIZE(rxe_counter_descs);
 }
-- 
2.43.0

