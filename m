Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1073E7BC7
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 09:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785142997; cv=none; b=W1wmQoyplCrrYN6gAwVRG6X1hLkQzLeXGWtY3LkaWgWumTetlYgR0GZnqMMzT4gGZux17InjnApCeIJpWoPz1hnRrw510Erc667GBlR7gidscdWcUKJk2csOQ9SqNzZbegBbS/UDB6lgV2xKc2OvdD9HiNQFvUpa+n6WNOBOxYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785142997; c=relaxed/simple;
	bh=Yd+j2N6BDexmWZDkG1qyBAsz90dSAtXwey0Oz49olL4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B9wYD4yzyZc2/adb98q+wSNfYdIeg/L7cYdVR16wyxbxcMCcYGSRdQxjSYZ2I0jKPJnnuaB0r7+rhnu1WO/IlDsYkExvuTc/qACozjJu5HsrTrF+S+lqeeHUiQdj7iDcGVPbyMuqxVC4njhggVM/r9ZXvKa9TOtupchdO8VqMCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=ekajGGxU; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="ekajGGxU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1785142995; x=1816678995;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2QYECBe2vRMtGJtEBeD5xe02iCzIl+krRyvJAwjzHF8=;
  b=ekajGGxUESZjEGeiKC9oHqjUWACZplsEX3a/eJzuXxQ3ApXYfuGlzUMZ
   nSpjyjiuHrs7tMxsLw/j+eGk3Pwoh41C/McWqxcdMP0jdRVn8rMTVAFdj
   zMsCty/CRiEEIL6oLdqszL1sZNv0vo+n+e5uL8/GQObGQ/GNlygG6rrMr
   w2ZxMgfHU4o3/nVNDrSGGysL+6+R0udik+Tuvev4oegd4vVQA9bGakYJj
   AW/HIPPt0osCgM7UXBOKI98aHDuQyqjBn0xayIoieFir7mRzw+NQAoydi
   Qh2DdIK70Ak0NrEbhTn6G0Ldf+wPtsnrAMDV2ASX3C2X4ewGoQmOMNDJB
   w==;
X-CSE-ConnectionGUID: o2Oxt9cDQ12QqmdDO6gEEg==
X-CSE-MsgGUID: sKmAp0z/QvWns3LJUKkYVQ==
X-IronPort-AV: E=Sophos;i="6.25,188,1779148800"; 
   d="scan'208";a="24394956"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 09:03:13 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:12032]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.59:2525] with esmtp (Farcaster)
 id b4756087-b21b-4f2f-8465-c19413b7b50b; Mon, 27 Jul 2026 09:03:12 +0000 (UTC)
X-Farcaster-Flow-ID: b4756087-b21b-4f2f-8465-c19413b7b50b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Mon, 27 Jul 2026 09:03:11 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Mon, 27 Jul 2026
 09:03:10 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>, Firas Jahjah
	<firasj@amazon.com>
Subject: [PATCH for-rc] RDMA/efa: Fix PBL chunk length computation
Date: Mon, 27 Jul 2026 09:02:55 +0000
Message-ID: <20260727090255.1175120-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D033UWC001.ant.amazon.com (10.13.139.218) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On register MR, when creating the PBL, if it's an indirect PBL we create
a chunk list to hold the PBL pages pointers. Each chunk is 4KB in size
and can hold 510 addresses (EFA_PTRS_PER_CHUNK) and has a 12-byte
control buffer at the end of it holding the next chunk's pointer and its
length.

If the PBL number of pages is a multiple of EFA_PTRS_PER_CHUNK, the
calculated last chunk length is wrongly computed as 0, even though that
chunk is fully populated with 510 real page pointers. This wrong length
is used both to DMA map the chunk and is propagated to the device,
causing the device to see the chunk as empty and reject the memory
registration.

Fix the calculation so it will be performed only if the number of pages
isn't a multiple of EFA_PTRS_PER_CHUNK, if it is, its already handled in
the above loop correctly.
Also prevent out-of-bounds reach in the chunks array in such scenario.

Fixes: 40909f664d27 ("RDMA/efa: Add EFA verbs implementation")
Reviewed-by: Firas Jahjah <firasj@amazon.com>
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 6abb93b50731..2d28d68efe77 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1362,9 +1362,11 @@ static int pbl_chunk_list_create(struct efa_dev *dev, struct pbl_context *pbl)
 
 		chunk_list->chunks[i].length = EFA_CHUNK_USED_SIZE;
 	}
-	chunk_list->chunks[chunk_list_size - 1].length =
-		((page_cnt % EFA_PTRS_PER_CHUNK) * EFA_CHUNK_PAYLOAD_PTR_SIZE) +
-			EFA_CHUNK_PTR_SIZE;
+
+	if (page_cnt % EFA_PTRS_PER_CHUNK != 0)
+		chunk_list->chunks[chunk_list_size - 1].length =
+			((page_cnt % EFA_PTRS_PER_CHUNK) * EFA_CHUNK_PAYLOAD_PTR_SIZE) +
+				EFA_CHUNK_PTR_SIZE;
 
 	/* fill the dma addresses of sg list pages to chunks: */
 	chunk_idx = 0;
@@ -1376,9 +1378,12 @@ static int pbl_chunk_list_create(struct efa_dev *dev, struct pbl_context *pbl)
 			rdma_block_iter_dma_address(&biter);
 
 		if (payload_idx == EFA_PTRS_PER_CHUNK) {
+			payload_idx = 0;
 			chunk_idx++;
+			if (chunk_idx >= chunk_list_size)
+				break;
+
 			cur_chunk_buf = chunk_list->chunks[chunk_idx].buf;
-			payload_idx = 0;
 		}
 	}
 
-- 
2.50.1

