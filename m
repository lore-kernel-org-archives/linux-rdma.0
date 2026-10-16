Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5A442AD83
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 18:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792174165; cv=none; b=CN1EKenxx7j9Utu4hFCob0bQ7/s9Xlod7ijxp4UZzghI1CvSNjM4yHqQPagjnpJP/0H7RKVlqf7sXcNN8McN7X3OmLrqEqjrzMh+z5IMmnFkbXzWWtcaVswybGYuyOVUJ4Dehu1Pw+VB/ykawruhoW6VaT8q0SgCDiwkgpHV5nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792174165; c=relaxed/simple;
	bh=CT+aP+Huhs19lopW7GVrHaBvhhJka4Am8V+Pr/EFfhA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=M9vF5eU8C0KA7bx0WGg6GVTtOl31w+gX7yNiVHSGA39HwRCWpoySu/+HB5xDVzi/aR1DiPVIuL1W0ExAxUI5Fa0rdk9Ie4NU/ae4DbAjoeLUPFpbAsMyiRDDYsKQGCW4Ikt0T4efpSB2R+B1eo+afmziqUYW1YI95fiPylb/g5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AZ6Ay8Io; arc=none smtp.client-ip=209.85.222.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AZ6Ay8Io"
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93c5ab5c136so36173585a.3
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 11:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792174159; x=1792778959; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BnJ8yk4bRz6nTLNfVcOjbffzZYxPGW60EpbrIIckClI=;
        b=AZ6Ay8IoFvcgoM+PBsR8cFSquJlPz3nZdT+BUVnNbQ4GF2YhzEiGvdE/KPyilk6fyX
         22m8cnTLLrGLkhLFbk8ouPjozS6yCU0xbZU/jOS0al13Tuls0GWdVQDLszvi4rz/077F
         sdfGqcZeY0h/yafoKbKahUWYuLFYf0OXrqIsNBebizGcEct9sg69wdEppxcB1lPlo5L7
         vmvl47SGxDId3xjkCqxq0Bi50ExHBfxzyZu2euLmS8qx2Vk1il7tM8fHYBdfmwwZHAen
         YBRBpLoFHxuKBsnywayxFfzLYzAZVe4++TwHQsx9IO6lauxnVzXMSCy2JIDFspmB15zW
         TOkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792174159; x=1792778959;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BnJ8yk4bRz6nTLNfVcOjbffzZYxPGW60EpbrIIckClI=;
        b=rIwDLomT1hkltLefHt4toFsZm3NKNrhGUHeWw6P8CgJp2hBtD7XWk+ImFFn3fN8C84
         /hribasNggR3eML16+08uRcTv6eEn3CE5ZQYE+0lRj6mYgSn1D5yWPHqUEeaEFDhatow
         ZmHWhesTasY51dgAK6UFeKgn5VfUvG3mk2MA4qYxGfp+hJt0BJtsisWHaQYrBHDiNriS
         xelXSGhURmFWupVBywPTuEXGZotphqmRs5jOR68kKYjPO8HpFG+leD9iwotEOjBn/Du4
         79+5Iig0WhW2eFKrAy2vpavl5o+x7QuHZXSdUDPfjBBGJGaD43oTgGXytg1zjaX5VMTY
         n/Gg==
X-Gm-Message-State: AFq9FYJLaYyRyIJfNeWNzcsNE1z5aQjgou1dIoJbfP4XJ02ufGQNQCG9
	i7Dt6I6YNFX1HSoIvgECAAHti9PlFmLs9L4vjM6dHoAIu4n8w0wgFEJVltkhoZgiNtDbbnUFwk0
	rH158dXBUfg==
X-Received: from qkfw12.prod.google.com ([2002:ae9:e50c:0:b0:93f:130b:e0b])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:1a08:b0:93e:5fff:db07
 with SMTP id af79cd13be357-93f29d56d38mr103254085a.40.1792174158802; Fri, 16
 Oct 2026 11:09:18 -0700 (PDT)
Date: Fri, 16 Oct 2026 18:09:01 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261016180901.3292775-1-jmoroni@google.com>
Subject: [PATCH] RDMA/irdma: Fix PBLE_LEVEL_2 FRWR generation
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, metze@samba.org, 
	Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

When an FRWR is posted with only 1 page mapped, it uses a
direct mapping, with the page-aligned DMA address provided
in the WQE (reg_addr_pa). This address is obtained by reading
it from the PBLE that was previously populated during ib_map_mr_sg(),
but it did not account for whether the original allocation was
PBLE_LEVEL_1 or PBLE_LEVEL_2 and just assumed it was always level 1.

As a result, it would program incorrect addresses if the MR was
originally allocated as PBLE_LEVEL_2.

Additionally, multi-page PBLE_LEVEL_2 FRWRs were also broken
because it was using the wrong chunk_size.

Fix these issues by correctly populating the stag_info fields
depending on whether it's a PBLE_LEVEL_1 or PBLE_LEVEL_2 MR and
whether more than 1 page has been mapped or not.

Tested with NFS over RDMA running various fio scenarios, with
and without a modified kernel to force it to take the PBLE_LEVEL_2
path.

Fixes: 137d264c6f63 ("RDMA/irdma: Add 2 level PBLE support for FMR")
Suggested-by: Stefan Metzmacher <metze@samba.org>
Link: https://lore.kernel.org/linux-rdma/20261012161135.494544-1-metze@samba.org/
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 71d7ae7baa47..2178fb344e4d 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4286,11 +4286,23 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.wr_id = ib_wr->wr_id;
 			stag_info.va = iwmr->ibmr.iova;
 			stag_info.total_len = iwmr->ibmr.length;
-			stag_info.reg_addr_pa = *palloc->level1.addr;
-			stag_info.first_pm_pbl_index = palloc->level1.idx;
 			stag_info.local_fence = true;
-			if (iwmr->npages > IRDMA_MIN_PAGES_PER_FMR)
-				stag_info.chunk_size = 1;
+			if (iwmr->npages > IRDMA_MIN_PAGES_PER_FMR) {
+				if (palloc->level == PBLE_LEVEL_1) {
+					stag_info.first_pm_pbl_index =
+						palloc->level1.idx;
+					stag_info.chunk_size = 1;
+				} else {
+					stag_info.first_pm_pbl_index =
+						palloc->level2.root.idx;
+					stag_info.chunk_size = 3;
+				}
+			} else {
+				stag_info.reg_addr_pa =
+					(palloc->level == PBLE_LEVEL_1) ?
+					*palloc->level1.addr :
+					*palloc->level2.leaf->addr;
+			}
 			err = irdma_sc_mr_fast_register(&iwqp->sc_qp,
 							&stag_info);
 			break;
-- 
2.56.0.176.g3575e65682-goog

