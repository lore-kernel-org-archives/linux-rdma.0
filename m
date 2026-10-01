Received: from mail-pj2-f37.google.com (mail-pj2-f37.google.com [74.125.227.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C376053160D
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 15:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868216; cv=none; b=hsi+34LnJ7bTe0yk3Wo59K+/7KsSqzO+62mqXWfeHwI8vWDiAWDWkstThJZoRDOyteEjSqjZIOXRfwhtEG9zuh8P57S8vNDzYWP8NHcXj22g300ioOltVYJmhfJdsh9OU2AMbVdnmEYc5WZI9vc7TS9mdy4RgqT+4lLKHT6TTC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868216; c=relaxed/simple;
	bh=Zvq2NfgqswGJXpD73eLNaboyrRxn1rag24jtHTev4Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSzmBkjJhLDmJqHQwPZCw3nxhrIK5+IDMjbL8BVztgUd2WiY6oDtPgRKgLoofz8vWGjbs8EwxlrM7OVNAJW29RkvwuB5P0sVhS4eEefkNd/gbNbMcoF1DY7vPVGDt0L5fuhbICL+tVxoEGTyPwf/y1xdvCXUXUHy8xtn9Uvg9rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J8iNnPfC; arc=none smtp.client-ip=74.125.227.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J8iNnPfC"
Received: by mail-pj2-f37.google.com with SMTP id d9443c01a7336-2e300fa474aso6206355ad.0
        for <linux-rdma@vger.kernel.org>; Thu, 01 Oct 2026 08:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790868214; x=1791473014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3+Yg2tTRm5a0YrOds2hAKtan8asnBjxDoQ9aQxRu5Ns=;
        b=J8iNnPfCYtxdinBHHviFQCaptXN4WsTNgDx8dIuh7H6G7jYNQNY5iXcoc7G/l0wixA
         KIcu8+kvcBZGNxg9eLXyLrPJGDjSWRVnzO7pCEltHykVKllKTZp2MEuZjbh9ZC71ZG62
         +X72Yygmzs/zdKKiR/3a5V9X61eBFxdc5iiSeNw+ffMEhaJCMWuObsUopfw5iS7eICYa
         sH6KfzYDfl3Bz8Fg/MvgW3CLz33HBl4MyRRC0u8SwNOkrpoq/v3n+f7PvW1yxqI0JXGS
         +WqYB1rtaKw1HNfBsk2FqT6ZYHDzeUt918qOp+LvFUyad0d5TSk1k4xoI4IdUuNxpBOi
         V7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790868214; x=1791473014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3+Yg2tTRm5a0YrOds2hAKtan8asnBjxDoQ9aQxRu5Ns=;
        b=xbiItDSC4onQt6+3yAXGxbm4hEhTQZfQczi7N9IEO3F3zKrxdZ+Kw+bfMY7p1/t9n7
         PEPBNokuO/Q2WqxXVU/k0E/UqoY0QBNbBlJOI1G593CzLYoG6ajQrdvj86oPElqueSe3
         I4xzJHxJy1Hu4Av3hFoPcGyYxpl+FR5ANxpqOWDc7nIlPheqOnNFtraEQPoCh1AcDuMg
         2Ce8GgBMPSpqVONNEmbuuoEkylW7M3FtvhfmE89rlV/xmaNVa9Tcc6QF2j79y0bjxWFA
         xsST9684VWlsfnBlUA7LBQmu+SuhVNcuuILxLRoUYhL4wUZ2tnJYsR3l1p/U7kAOy7SZ
         xkUw==
X-Gm-Message-State: AFq9FYKtkz8+AcFUBWgbWt4wiHTZeXRaUt+hgl1t6N4Ql8tIK27Jenj2
	TMP5vy/+9jTm55xpGPHwlCj4e+tGfA2/wPfhwdUNvSFhFD0S8YPqI+q7
X-Gm-Gg: AYBFou0L4ewZ3tbazB42foIqplaEsnPNCYtSMaz+ts4SwcdEbBAELskZWc+Yojvy3m1
	YraRyc7itdxaAhdqvNtayepay8ZPYQDivfjkHATQxOTsK912weefltDjuM+sOgWirrKSVU2JnWk
	eB/Nfj0R6jvmv74b6JYQVRzdJVEH4FnN5aCF2Phq8VGbifVO0SzdFxc8EwxUSi/B51uMfHlFYyy
	DDWXjy0J+ft4kzl6hrUgl/qk0mRw6O5LHQ2It575VeY1X0gU/2VuFCaDcugwXMHPvWe2EXCNoct
	C54bRZ8YdouK4J1pR7BF1oYeRlSfGzVMiz/5xbHzcHhxKt5N8dkNwPzg8HkrAlsogckkKrZYWwv
	WyY43CCjlrvtgMeG3XYTIgBYqNwbvCeUNWvhhxCSJR7bWLMZ9iesvSE/MxArz1VaNjTj9K4EwrI
	tFo58wSzuYH+Y2mnNGxVX+BNth2+AphBwabSr2XlA3RhYcqvW6UKadDFx+Mqbi2StbXDZeRF2BT
	0mVu6wMAA==
X-Received: by 2002:a17:903:4587:b0:2db:8019:847a with SMTP id d9443c01a7336-2e2e4a138demr41720775ad.9.1790868213833;
        Thu, 01 Oct 2026 08:23:33 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e30cc14cbbsm9078435ad.37.2026.10.01.08.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 08:23:33 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org,
	Youngsung Ahn <ays511.kr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] RDMA/rxe: bound the ODP page index against the umem in rxe_check_pagefault()
Date: Fri,  2 Oct 2026 00:23:25 +0900
Message-ID: <20261001152325.3258902-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260930175145.2491352-1-ays511.kr@gmail.com>
References: <20260930175145.2491352-1-ays511.kr@gmail.com>
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
Cc: stable@vger.kernel.org
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
Assisted-by: LLM
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

v2: no code change. Added Assisted-by: LLM and dropped the security@kernel.org
Cc, per review of v1.

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
