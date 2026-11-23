Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444644;
	b=4tL2UvXCwdPMP40kUsg7msJAkrVfLSSm4gj6QGHv4PBO2tnZ0TFapFLJL2Mth6Kw5eoB
	 syld9QWrH5zL6ex1NMPF3RzagcG7OnxzoFxWXR7DvOTsooa+dCI27ej2onLUdl8U3uwje
	 oBZbCy6YN+qCPU8pxzU3FL5fZo05jIuD0RossbOBgGajF3b3cJ/C0M00eBfidTeB41Xnm
	 4dWybXZt5/e8QPjnZZUSjeQEOHBKtlydB/qP0dzo9y5z2sm45bl9xDo6LazKA27oKmTRt
	 oFVf4JDxJX0yj+ZMsZARMYEtiO/a5ZAeL9rrZ/nRg6nobxV4Vj8j6zJtVO6Tx8kcOsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444644;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oPe653FMhu8ma7cyhWF4HYoRPppUE+SO/5qs7yZB6R0=;
	b=euhnLZ5ce0H9buCRpKR1Rzdh2wqbVjSYfDRzuclL/o/+4KgBEFNxRCm5ERDwGe/SrxPW
	 u9B6VnOD8J8hvGVlMus/Ow2gGgbzFlXqV8GQF67aAMzR2Yx1fbjdv7hLiNMo1UyEKZnqM
	 DkCStOIewk2fOYy18id4AKUtGMi22GwPb8Xz6A0lXZGx2lFKbNHzCdv5OIcTpw3A3D3O5
	 xuH/YCJbH2d3PbGxjJQ0Xi+5JkYUGPT1PhFqn9SYvDNctT3SSwGL80xwL1VmWOU9vmffz
	 UCDIXkJ8uuhfhX7qpltAJAO6xClWEuPDD3e18VOtCF/lGsdbmjXSIJDISs2ue9iGxyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=ADiAKgrO;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659FC606A330
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:37:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 659FC606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=ADiAKgrO
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4b467581b98so31698985e9.0
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795444643; x=1796049443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oPe653FMhu8ma7cyhWF4HYoRPppUE+SO/5qs7yZB6R0=;
        b=ADiAKgrOD/8ATNo8qS9ewpyJeTjku66doueW6youTELYowrkLu9ySMDIVilfNMviLc
         z/76dO89BlZklwpxnr/JV2QKNyf8z664LBrzdHJteHJGrpnNap9+7p9PxbGitXw5xytJ
         6BgkGBR+oMh1jGL5ODs1qwC59SQkjl7nDjR2C9DqKVWSySkZg/9tiBjwFXSgkvR5wfb6
         3lyjBXV8NI2LXIQF9yjCoR15aG6rLPZlUGQQwum4GhvyNy1LH4dMKQDWHkScu1a/vSIb
         NJB78G5FxZB3bOH4seH+6RQ70bo+IDQJEvirhEiAyaS3EWvK0h+rV+/MRr6WI1jm55LI
         NL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444643; x=1796049443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oPe653FMhu8ma7cyhWF4HYoRPppUE+SO/5qs7yZB6R0=;
        b=2eTyvHCCiDXQaTj847xFqOb1Wj6oWBqusqKigH+jdUkb7JiROJDLApIvh3TLLsp2dz
         d4FZKRW1j7kIVYMJAJ+NommZajgdUQOnVKAjCVXNWYFehYsZVfb8c+XSbYpBvmiMf/sk
         oirXXM8gMR2qPv06J2Swu8A0MHmec2CDzu5UeilNHDrlKQT7BN7rYXTDpE37mQZGJVac
         K4CiBRO2PjFUQ7UFwb+NVhH2J29pzjXeDGJ+ckDf5YntnpGWKPzg4BFphj7/IpFRzBDT
         IjYmiW7N3aNIZCRDTNa9XR7O6Ufj0bL4+WJ5KUFUm12iwb10NMf0G73zHItRQaOfK4B1
         ALlg==
X-Gm-Message-State: APuU4Z/2NH+tQNS4i8mfCRziTuMcLIbFVKjEC2hWl1b5z/G4a2asNCS6
	P+KFxRik6P3SygvJVjIHXxVZz58B6Tw1VKz7aINx9QVhkzGjhxqizA5u7OS6it28CpKDDmxIANz
	/PCyWj5U=
X-Gm-Gg: AZFdTZfS4w2+Y4VMH0sQTwkRtf+NQODvbWXxxJtTzRSBCsLN0EySAvcAuOXQJ1YIZK5
	ciwSU9tTYttgtcCapkH7G8a5tL14tT0cKjeLirXWRkUiZ2pEY8rKiSbWmPAhhtbqta8+0Tyr8cu
	K7XhhMa1rUXjiZNRSVF4BuRqJgAyuBxzlAWNjcTdRpaSL19YYx79KqkZn7K6TPnqJyJAOB/K3s6
	Su4JLA7Lf7RW3l8GP37qF9x2XSF4g/zk7iBPqPWp4drUhbSfxRNpO1Vyccm/Wc8QZzuUfcv7W9c
	e/LCsk5NpELm73tBqopT6ckzJ8bhaXkAR9MWI2HDvoXcV90ZU9r+FN/OQp2VsAPmiCdg17HoS+e
	cma87eycv67nB+uN321jZuM5sjW0H90v6YyOTYZNotJqP7HSVTjjrQtOa9zAXdeBUwAzbheCbWO
	dE5SNk9XLg6fIV/AHozIJfnoQtbeRoRsPfwtRqgv3KnxMkCoqOKgUDGt34FpImM6nThyCechmHY
	06kkqGJUz3LjlKvRgFM4eUNAmIjzt+wGZLaiS/lwQ0m2c0II8Q8TYcsr3iY+CtC6vCLPEpDvR6m
	yR/TWaSb/FijRzxP+q1y/dnGu0k54Wqhj8FKpI+low77Q5XFyVrD8G6XiDZlKGhIWku/V9irKd/
	zIAgjk0zhCuRo4wOIqyHsjUcpC6KWDr2SwZSZHVw0ZMGZebLsSHLn7vBlCbCAgCPpLux4EZh1is
	CAQrQshOOI+Dk4q5cGJIWSVVIZBWRH51xR0Ns=
X-Received: by 2002:a05:600c:848d:b0:4bb:52d8:73ef with SMTP id 5b1f17b1804b1-4bb88940f1bmr240153855e9.34.1795444642779;
        Mon, 23 Nov 2026 06:37:22 -0800 (PST)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm172562325e9.3.2026.11.23.06.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:37:22 -0800 (PST)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Jack Wang <jinpu.wang@ionos.com>,
	Roman Penyaev <roman.penyaev@ionos.com>,
	Md Haris Iqbal <haris.iqbal@ionos.com>
Subject: [PATCH 2/9] RDMA/rtrs-clt: Fix refcount imbalance in rtrs_clt_write_req error path
Date: Mon, 23 Nov 2026 15:37:12 +0100
Message-ID: <20261123143719.938876-3-haris.iqbal@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123143719.938876-1-haris.iqbal@ionos.com>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@ionos.com>

When commit bab9f8db4295 ("RDMA/rtrs-clt: Do local invalidate after write
io completion") removed the chained LOCAL_INV WR for write requests, it
deleted the matching refcount_inc(&req->ref) under the
"req->mr->need_inval = true" assignment. The corresponding
refcount_dec(&req->ref) in the rtrs_post_rdma_write_sg() error path was
left behind, creating a refcount imbalance.

On synchronous post failure (e.g. -ENOMEM from ib_post_send()) the
refcount drops from 1 to 0 via refcount_dec(), which is annotated to
WARN ("decrement hit 0; leaking memory") because callers should use
refcount_dec_and_test() in that situation. The req is then reset to 1
on the next rtrs_clt_init_req(), but the WARN still fires and the
imbalance can race with an in-flight invalidate completion during
failover.

Drop the orphan refcount_dec(); clearing need_inval is sufficient.

Fixes: bab9f8db4295 ("RDMA/rtrs-clt: Do local invalidate after write io completion")
Reviewed-by: Roman Penyaev <roman.penyaev@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 573beb5ccdf0..de226e6ba124 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1163,10 +1163,8 @@ static int rtrs_clt_write_req(struct rtrs_clt_io_req *req)
 			    clt_path->hca_name, clt_path->hca_port);
 		if (req->mp_policy == MP_POLICY_MIN_INFLIGHT)
 			atomic_dec(&clt_path->stats->inflight);
-		if (req->mr->need_inval) {
+		if (req->mr->need_inval)
 			req->mr->need_inval = false;
-			refcount_dec(&req->ref);
-		}
 		if (req->sg_cnt)
 			ib_dma_unmap_sg(clt_path->s.dev->ib_dev, req->sglist,
 					req->sg_cnt, req->dir);
-- 
2.43.0

