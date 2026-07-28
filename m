Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5C5231C91
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 14:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785248108; cv=none; b=In+XjMergHN6VqngMFdOBpoaGde+Bo96p2Z3K4+EAbJxc68guSN2rBYlDjn4SFKOoUVamrNTBPmxvgKIzLkg3y5NwSnMEy94JYcVS6P/t3Uqr9M5sqpCA1EmgXyaRcBeIZrzhTMkCDazOWz1DuQmyajg6l1e8mI/zH8M9tO4BU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785248108; c=relaxed/simple;
	bh=O33GgqQbEe6vBUDa7jjPblodP4s07yjAi+uP550FKxg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HN9JygKlEk5xsxD9k2zWurkywm7LVRsHlnIRGAKTDPnYux7tFHCwMcLoEwzv6KCg/Gc/mEwJbgEro7lWB+czoYHedmv5Mb+hEHAm1ecp2nZ+rsDMfOM4S27TC2VdXlxNXJKPN7aTQfEHShXnXEYW57oj+IhC5MRYvZPlGt1adAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hFzrPETX; arc=none smtp.client-ip=209.85.128.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hFzrPETX"
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-81ebbbd60cbso61426547b3.1
        for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 07:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785248106; x=1785852906; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lnbX5Qd9afL5SIDZ428l6VmD4eEN+HRsYONZ0njP2hU=;
        b=hFzrPETXECUwnBorhlcEz5wd/yzS8asJ8QOZjeRX8NAAUMKizpbQlhxiXpGiFQvtYT
         wudcsxARvSEeTQ2o+3KIA5XVcnBS4eim+tY1UvzxgZd2lJKFzZppUulUD9NBmgZOsEvk
         A/4umJAOO9fz8ZQap299N024/4K6LVlSwLtilSMdvsftIYcsccVHXOlkAAcO+WYLMjJ1
         V0gmW8h+6Z7RYyhYt2aySxLxsp7TQK0gNpgMfsfPlYJFXH2wyotK+jXtI1X4ZkIVkEK/
         gto56BS2/mNePA89nVvdrGCML/ukyz/sDLLPFD7XItHp9F5UKk/vCJUvjSoWRhQG9kqe
         1gzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785248106; x=1785852906;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lnbX5Qd9afL5SIDZ428l6VmD4eEN+HRsYONZ0njP2hU=;
        b=ooR5/O0KKZBBC74I/uyNA0kI/L8RRKLQJPjOoyHBNqrqtjWiHYrWQLUHXyz67Xi3NG
         icu/QOpYjQUBZNDDbOFOTeORXQ35YIYKl1nv57BYElcqVySflv5HDckJcHA7Agc/IQE1
         KKNhYqbUaSf2/xSsPyuNWAstjVA9kZaQwUS6cfXqjVFRzME7Runbfvelw2arbw4F4f3J
         EOJnGwO99eylgmcbfc0bO+hNhLKXrTlnjDCJfhd5qwkXNv1U0XLQJ3FDRCuvDUFP6yFj
         C/lGk+P2RuH/gw1fhEOPQ3SLJnZozoyIZ9LRAKrF6/J+KSma9AbR/WNYA3ghKz/K6bB3
         gPUg==
X-Gm-Message-State: AOJu0YxoKa4N/+rQ1kFRpO+pn/g8luv3zZzVJOfVTkCm4nEroOJhTHUV
	dC+Xtsuw4lBhtqDAG0/xMJdSQfyLeGMYJuOejERkoEB7HlusXsHbweup4wa6gXXhf1pNj8gbljT
	r1uKU1+25rA==
X-Received: from ywbnv7.prod.google.com ([2002:a05:690c:9307:b0:809:9422:8c32])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690c:d1e:b0:80d:21d3:a399
 with SMTP id 00721157ae682-81f99219afemr11925137b3.48.1785248106049; Tue, 28
 Jul 2026 07:15:06 -0700 (PDT)
Date: Tue, 28 Jul 2026 14:15:01 +0000
In-Reply-To: <20260728141501.1425737-1-jmoroni@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260728141501.1425737-1-jmoroni@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728141501.1425737-2-jmoroni@google.com>
Subject: [PATCH rdma-next 2/2] RDMA/irdma: Remove dmabuf checks in rereg_mr
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that ib_umem_check_rereg entirely blocks rereg for dmabuf
umems, the extra logic can be removed from irdma.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 31 +----------------------------
 1 file changed, 1 insertion(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 16c80367270f..5e03cf39fa6e 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3885,8 +3885,6 @@ static struct ib_mr *irdma_rereg_user_mr(struct ib_mr *ib_mr, int flags,
 	struct irdma_device *iwdev = to_iwdev(ib_mr->device);
 	struct irdma_mr *iwmr = to_iwmr(ib_mr);
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
-	bool dmabuf_revocable = iwmr->region && iwmr->region->is_dmabuf;
-	struct ib_umem_dmabuf *umem_dmabuf;
 	int ret;
 
 	ret = ib_no_udata_io(udata);
@@ -3903,26 +3901,9 @@ static struct ib_mr *irdma_rereg_user_mr(struct ib_mr *ib_mr, int flags,
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (dmabuf_revocable) {
-		umem_dmabuf = to_ib_umem_dmabuf(iwmr->region);
-
-		ib_umem_dmabuf_revoke_lock(umem_dmabuf);
-
-		/* If the dmabuf has been revoked, it means that the region has
-		 * been invalidated in HW. We must not allow it to become valid
-		 * again unless the user is requesting a change in translation
-		 * which will end up dropping the umem dmabuf and allocating an
-		 * entirely new umem anyway.
-		 */
-		if (umem_dmabuf->revoked && !(flags & IB_MR_REREG_TRANS)) {
-			ret = -EINVAL;
-			goto err_unlock;
-		}
-	}
-
 	ret = irdma_hwdereg_mr(ib_mr);
 	if (ret)
-		goto err_unlock;
+		return ERR_PTR(ret);
 
 	if (flags & IB_MR_REREG_ACCESS)
 		iwmr->access = new_access;
@@ -3939,12 +3920,6 @@ static struct ib_mr *irdma_rereg_user_mr(struct ib_mr *ib_mr, int flags,
 			iwpbl->pbl_allocated = false;
 		}
 
-		if (dmabuf_revocable) {
-			/* Must unlock before release to prevent deadlock */
-			ib_umem_dmabuf_revoke_unlock(umem_dmabuf);
-			dmabuf_revocable = false;
-		}
-
 		if (iwmr->region) {
 			ib_umem_release(iwmr->region);
 			iwmr->region = NULL;
@@ -3955,10 +3930,6 @@ static struct ib_mr *irdma_rereg_user_mr(struct ib_mr *ib_mr, int flags,
 		ret = irdma_hwreg_mr(iwdev, iwmr, iwmr->access);
 	}
 
-err_unlock:
-	if (dmabuf_revocable)
-		ib_umem_dmabuf_revoke_unlock(umem_dmabuf);
-
 	return ret ? ERR_PTR(ret) : NULL;
 }
 
-- 
2.55.0.229.g6434b31f56-goog

