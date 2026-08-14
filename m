Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E63370D63
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 09:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700288; cv=none; b=tsBaA9aGyslss5KdWB1ZHHk/3+/nOMlqg9/ibUyLvSsiMDtGxkVL/KyCdPyohyi2qqE1dOWMijtRfhnVtc+73rCq4xubL4QrtPfU7GWAPQqxG35Wcc+pDoogqKB5CFGnJ1XPeQNDW68YwS0grB9nfV/dpIxXrMvLojThqyPGZh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700288; c=relaxed/simple;
	bh=FVQfDUrbHjepdRtpMRhLJNPKhj6tVQsSgvGlErmtn/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fhN6xtKyBB3sMTCpXZox+f6u7CYirKzXMniGGsKxCnddQNTijgMo2/4lGDM3axiUXIP27SaKQaxdYF3PeMHplnO5F0GYO8GGryCuX42RiDHZ7hdbrgCwzLSYvGVdyMIEk2UQVqZAOwu2OJKdVYCYrMh4SAC/boQ1bz0fALvIwNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R3uyBxVO; arc=none smtp.client-ip=91.218.175.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R3uyBxVO"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FVQfDUrbHjepdRtpMRhLJNPKhj6tVQsSgvGlErmtn/Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786700283; v=1; x=1787305083;
 b=R3uyBxVOLncu2mzEvmoRY9tH2UGU1a/f/HUawNBCOCFf0Fv+PN44//29O+qazdLe4k2yg4kY
 XFxE8q7jMFkuO/J8Ik6HkgHlAdwuZl5n0hyUis0Lj9fpgAMwwCqQPL7Ga26JWTWTWS7nyDs0fol
 J6m90Pv/3GsnsM9qf2nhoTJU=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: from thinkbook16p.. (223.70.160.239)
	by smtp.migadu.com with ESMTPS id 5b9216f55cc885cc;
	Fri, 14 Aug 2026 09:37:53 +0000
X-Migadu-Flow: FLOW_OUT
From: Gang Yan <gang.yan@linux.dev>
To: yanjun.zhu@linux.dev,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Gang Yan <yangang@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH net v3] RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB access
Date: Fri, 14 Aug 2026 17:37:40 +0800
Message-ID: <20260814093740.292954-1-gang.yan@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Cc: stable@vger.kernel.org
Signed-off-by: Gang Yan <yangang@kylinos.cn>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
Changelog:
v3:
  - rebase on rdma/for-next
  - CC to stable maillist
v2:
  - Add Yanjun's reviewed-by tag as he suggested.
v1:
  - The reproducer is attached in v1 thread.
  Link: https://lore.kernel.org/all/20260728091128.9116-1-gang.yan@linux.dev/
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

