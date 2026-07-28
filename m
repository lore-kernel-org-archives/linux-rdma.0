Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C92241A791
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 09:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229963; cv=none; b=g40kzbBhCwG5VCzGaA0pxXyADdKaU2lzoSQRJDCRSm1UoRY1SzIK/cv2WGVP1M7u5WpTM+g4WULV9aiD2tc0Nav5MqRxa9skZbB5UKE6xyZJhuuvsBebQp0GZJhzsLaLRTLuxPLNDHp4kVGdYpaVzJl0a7lbkgzThVrDcAlrGZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229963; c=relaxed/simple;
	bh=GaB32Z91poxTreALSf65DcvJoA4OnkGSSZI3v0VtLKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvWuyZOyOJcgLIr4l2Kv7mfOfHZqHbB1NIODVIflaVAMr79fvU2BNOuB3Cwo9SvKEaT0kpA00UF1PvbfbBqVrnMddl+Otbogd9oXR3mo89zxCToUxfRDeUXu1bP+bA0IOodW2SNBWzui2Vdbll033tYbv1Iqr4VzX1uIhi1vbnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OPexIgPg; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OPexIgPg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785229959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MyvrdLu1L1PDpqCpsREEVInmS5IUWwvyyezhFqKjokk=;
	b=OPexIgPgKmjpBseE8gZjdvVHeevT7Ziaiokp0fLt8k+uF3PODxAqnI+x3QThofgbNTa8lX
	5+R/c+ZfvTdDIv/jmJ1l8dHN6XPJBaoseC9n3jdJ21O/nCNYq5fqWxktfwBKOIVg2L26g6
	q+gyMJZdxorr2eSYaf1X5uqNHZkHIQY=
From: Gang Yan <gang.yan@linux.dev>
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org,
	Gang Yan <yangang@kylinos.cn>
Subject: [PATCH net 1/2] RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB access
Date: Tue, 28 Jul 2026 17:11:27 +0800
Message-ID: <20260728091128.9116-2-gang.yan@linux.dev>
In-Reply-To: <20260728091128.9116-1-gang.yan@linux.dev>
References: <20260728091128.9116-1-gang.yan@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Gang Yan <yangang@kylinos.cn>

mr_check_range() validates that [iova, iova+length) falls within the
registered MR range using wraparound-prone arithmetic:

    if (iova < mr->ibmr.iova ||
        iova + length > mr->ibmr.iova + mr->ibmr.length)

A remote peer can craft an RDMA-Write/Read RETH so that iova + length
wraps to 0 (e.g. iova=0xfffffffffffffff8, length=8), bypassing the
check. rxe_mr_iova_to_index() then computes a huge index (int idx, only
guarded by WARN_ON) and rxe_mr_copy_xarray() dereferences
mr->page_info[huge], causing an out-of-bounds read/write and a kernel
oops that is triggerable by an unauthenticated remote peer.

Rewrite the check in overflow-safe form; the first two clauses guarantee
that the subsequent subtractions do not underflow:

    if (iova < mr->ibmr.iova ||
        length > mr->ibmr.length ||
        iova - mr->ibmr.iova > mr->ibmr.length - length)

With the fix, mr_check_range() returns -EINVAL for the crafted iova and
the responder reports REMOTE_ACCESS_ERROR instead of triggering the OOB.

Assisted-by: Codex: GLM-5.2
Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Gang Yan <yangang@kylinos.cn>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 875eceb55fdf..71d9ea477289 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -33,7 +33,8 @@ int mr_check_range(struct rxe_mr *mr, u64 iova, size_t length)
 	case IB_MR_TYPE_USER:
 	case IB_MR_TYPE_MEM_REG:
 		if (iova < mr->ibmr.iova ||
-		    iova + length > mr->ibmr.iova + mr->ibmr.length) {
+		    length > mr->ibmr.length ||
+		    iova - mr->ibmr.iova > mr->ibmr.length - length) {
 			rxe_dbg_mr(mr, "iova/length out of range\n");
 			return -EINVAL;
 		}
-- 
2.43.0

