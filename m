Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF7D51AFD5
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 17:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790715; cv=none; b=HMEribafIrERH/bJFBTClwUlP7vYwXADM2QxnyalDdSJJzsvvS0F+2WlXafZVTQDtwZBr5ntbXf/SExY5MOymlVMewZLCvDrbdPuqD/ZIWmJmGq+Wc+/vINUn0MnP/s6jng/BJI0AH3fMUBwtId9rU31I/MP+w9qN5PVvXi3dcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790715; c=relaxed/simple;
	bh=JGDhwkIFa26RsuIaslb3CISGzpyd83oB4r6FRh1y5Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eMhDEpFMbBPQGe3gMJTz/UcAh5uYx2HNLd+gTwntF9ExPHO5mwU/1HYTJNbEOUXtHvbKbaR2awWSOVqmf9uLi46dF7hiM67bLqjNYrQA+6NCOlOfjC8KkWlEHGDjirzLbtwPwNzzlmnCLieAWBIjWNKp6aISflKCzWVn2hSu4ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rH/7oeyP; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rH/7oeyP"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-3a49573b8bdso1843236a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 10:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790790713; x=1791395513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hAjrwuMZvVWdLFmuu4tuGVZ0yE1Xsl0ZDSEcE8jKHXQ=;
        b=rH/7oeyPhzHQa2miXDLkdvvZ8Pa7t0OURPNyxGiyXvRvvbkJnbGXFeSAP5QijlLU5j
         UyBLAvOONh6ACIK8ZRofHFAWWp3yyhk2NjQRZsMA8Fk+YGP0UU58lXBVBlEHKSGnkiAt
         WVVL6zb79zoFjxaQcJzW7zsTLgz/xBU02usXmMlsLF26TzinghhO6rRbI4N3dtfWhSu5
         4ekZzlQC0BWKrVXz9qp3SqpoD+gugz/yIePwaGWXFG2Rok6BTYJVSrxdzRhfWj5O7OY1
         1ATpVM2EGJiYZKipPLE/fxAKKxobQrKZXBIDGgSjqB9Q11RpTPmyqGYdsnoVsYD8dz4m
         dacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790790713; x=1791395513;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hAjrwuMZvVWdLFmuu4tuGVZ0yE1Xsl0ZDSEcE8jKHXQ=;
        b=oQ6QmQ3vz5XeiFMvrrAULBTAC/xNlMLA/jpJPnumVAi15dmaCNFGC3+nGB8EngFkZc
         zV7pFfDYf9q8mAgyy+1Jpjf8IFzlnZJythdTfzJVbk1aGHy2tqssPMvX2KlSXMUHtHq7
         0iwAjP+c0wiB6iJtjp3WecYd20/bOQgbEw4jeYpwwRBn7E9lQBNnBvXZ9MY3NM2bxm6v
         NNJubmL2kppG9/j/Iy1+zDAb1YXF2Juz47psjkGYySapw1jLbdUmtvpiz5QyIrX9Qxi3
         f9ZvSiZSQ3n39Lze1IXIgZyxPZoDcQEQjkDIZbSLLeB5bMbtvM4RfI6IVggBYJ+7R073
         QmZw==
X-Gm-Message-State: AFq9FYIbk69MYNx+cdj2UVHijI2F+meqZu2vS4GLdC940L/H+0G4lDLi
	i+ubVrTOWQCsgPyItiv5xn11k992FG5Kh5djujQ2TywyTkjjRC9Ov1XL
X-Gm-Gg: AYBFou0qQvDEfeQ+jEq/XRIanTWkPBK/IoC+HEe/y6slWbiqhh87MiVaJK9p4lXP8TB
	xKdlYrnWXFvJI5wuH8fLdJGXysHrGlO0iBD2nWi9MCRxE2Vql3Q0NrUsl4KGZQ8aoluUyDRLvN5
	Fl+MgU9D1P84MXZ+DEH3H7cB/Xz/3deGvxEekSqIS00HfA9LlSpzbv6M7N6exuq5KMXWjsBflpZ
	1aTE+DofI3pZBS5Q/LKskCrS+XU95kycrmOhs6dZ+TMAhUQIFsaNothvJKf6540Ejyi76xPSGJN
	ZpKVIWHEQ2AOYfk0F+gCvil6ZUO+80XUP/p8epG1qgh/7krFrvAzEZOHHn9F1YLhyW3w3DL3q5e
	lFt0Q3Po2H0sktLDkK8i+m+Ik+1v9UA/XC7sPHIudHb3R3e2sG/Hm1pzGZFjK41MTtQhTMP7nka
	YJ+UTFi2XsZIvyGY4WSsYIVLtEDmYyOsJ2lCLK/FQttnyef+lI4q+qXeEXpN4rURTjMwItvtuHs
	Lot/xHRYZ3+Fykm4AZ3
X-Received: by 2002:a17:90b:5146:b0:3a4:bd4e:6d15 with SMTP id 98e67ed59e1d1-3a4d18a299cmr1800274a91.34.1790790712941;
        Wed, 30 Sep 2026 10:51:52 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f471b16asm337936a91.9.2026.09.30.10.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 10:51:52 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>,
	zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org,
	security@kernel.org,
	Youngsung Ahn <ays511.kr@gmail.com>
Subject: [PATCH] RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
Date: Thu,  1 Oct 2026 02:51:45 +0900
Message-ID: <20260930175145.2491352-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An ODP MR's page array map.pfn_list[] is sized from the umem's
start, but rxe_check_pagefault() indexes it with an iova taken
relative to that start, while the access was range-checked against
the MR's iova (ibmr.iova). reg_mr only requires start and hca_va to
share a page offset, so a user can register with hca_va =
start + N*PAGE, and the index skew (hca_va - start) >> PAGE_SHIFT
then lands out of bounds of pfn_list[], which is read with no bound
check. An unprivileged local user reaches this with a single RDMA
operation on a self-connected rxe QP: observed as a KASAN
slab-out-of-bounds read and, when the out-of-bounds qword looks like
a writable HMM pfn, a write into an attacker-influenced page.

Reject an index that leaves the umem and force the fault path, which
fails the out-of-range access via the umem range check in
ib_umem_odp_map_dma_and_lock(). The downstream pfn_list[] users
(__rxe_odp_mr_copy() and the atomic helpers) run only after a
successful map, so this check protects them as well.

Fixes: 2fae67ab63db ("RDMA/rxe: Add support for Send/Recv/Write/Read with ODP")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
---
Notes (not part of the commit):
Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000; the data-only write
primitive was used to reach uid 0 on a fully hardened build.
drivers/infiniband/sw/rxe/ is unchanged between 7.3-rc4 (93f51579e7df) and
mainline 551c722f4080 (2026-09-29) and rdma for-next, so both are affected.
Compile-tested (KASAN+RDMA_RXE), not runtime-tested. Found through AI-assisted
review; per Documentation/process/security-bugs.rst this is public and a
reproducer can be shared on request. A maintainer may prefer to also index
relative to ibmr.iova (as the non-ODP rxe_mr_iova_to_index() does) so
legitimately skewed MRs keep working; this patch takes the minimal, safe route.

 drivers/infiniband/sw/rxe/rxe_odp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index ab21b620e94c..07a30c60fc62 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -136,6 +136,11 @@ static inline bool rxe_check_pagefault(struct ib_umem_odp *umem_odp, u64 iova,
 	while (addr < iova + length) {
 		idx = (addr - ib_umem_start(umem_odp)) >> umem_odp->page_shift;

+		if (idx >= ib_umem_odp_num_pages(umem_odp)) {
+			need_fault = true;
+			break;
+		}
+
 		if ((umem_odp->map.pfn_list[idx] & access) != access) {
 			need_fault = true;
 			break;
--
2.43.0
