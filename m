Received: from out-186.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EA23EDE52
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 09:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786009495; cv=none; b=ZAILiFW0sScI3joKChYvfqg3QTm5FukYBRu+YxXpqknYllsX0vyoykXEA4wPaxUPBSyETs5IF6FyMqlfJNfD7zknZn13QhoN17nH9hE7kov84PTQXbLuuc8rG7dhyb7Di4nwW+tRySSYlgJiVQg06Nl4ERoObMO5B3SljrJHPH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786009495; c=relaxed/simple;
	bh=gCq6IKrdE1UNefJ7GZqmguayMX1GiCjIyWvAzUdB0Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ck/VK4XQ36Ja4lUcOKT//hzyFhIexMf5JLFxKc6OYooXrxY0wrFJy108Q0v5DkdP5hjpUxDJXf6egSyg57t425OB0XYsPctnhsytNiG3aFDq6eqYt2OhRCNJHRhgQuIlNVi82GR2zqEaBbxdketdaBTgESB2ROJIShm45+S1H8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P4HBdyaZ; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P4HBdyaZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786009489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Da2BnG3mu72mWCV1WYMQrrWBW4TWucBPCmyLBbgi2L4=;
	b=P4HBdyaZq3BQKEZgSWhDSzcsBwLGWaHwNJGpcR3/Swr28e0G/8QN01RAnN/HowQtO7/NOF
	qc5tnDUJ6oa2sGIgfXz6sAA482XuOjMyOk1J4w+8na2hoKo74Og2XFDi+/7rYYFBleIkZt
	CNfdz9bNW/xwrqeEeJoK9QMTyt/FezU=
From: Gang Yan <gang.yan@linux.dev>
To: linux-rdma@vger.kernel.org
Cc: Gang Yan <yangang@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH net v2] RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB access
Date: Thu,  6 Aug 2026 17:44:27 +0800
Message-ID: <20260806094427.106307-1-gang.yan@linux.dev>
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
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
Changelog:

v2:
  - Add Yanjun's reviewed-by tag as he suggested.
v1:
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

