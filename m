Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6386B3B27F4;
	Wed,  7 Oct 2026 09:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791366819; cv=none; b=eWXuL3dexeG18NnLv7WjAjKgr+cQXXTT7GBMB2LFLTz4KQeLXhHbvLdnX8i4psMJ4hwJB3zKKJrubzBe5miAc1ofLI9FcKU1ITTCzkUtITwCYayikb/Nky0zMwbMIQaM1foKdgl/gDE/staHpxiFnlJoEad4dTqLEpfIFcToQxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791366819; c=relaxed/simple;
	bh=A+S6Ysi0jCzHYjeRuLPpvBaziaKV+t4UxfMXIesua7g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l7phsjU+KKAkTtdrXvdFtPxRzuiyBssgpoE4SBU1ryQn7ZVFwq/ww9GqZF2JlAkBXjDNomPpQ/SQCXm4rZLoy7+Tuzk6YSmMk8pMax1vz5WQFCe10+7trNoChW/fjSAjb7KxS4B0lFHKk+0g6CafqhcdjBoJN+M3GNok4Q/EkXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=L9snuXOT; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="L9snuXOT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=TbcYnc/5VwXt4ETJ4OwijyHd6fxKlIM9wHIIQ1Ku5eU=; b=L9snuXOTEbcTtELQmGSCtXnK1Z
	e/SPnXSLjLRTWLkgp0d0BiR7cTOE2srPP7AHnAAzsDDxFFCH6XdljXMbSziOrZvBGzhDMBDMwSF50
	M/cxuvjkxY0oZkagXMh9f03/0BKCy5J8jqoz1Je6v/2dU6ibBSObYwKNwE9NFCIgHUel0WJXSaKNw
	18pJovjnrpYUeEuISyPvt5uhBeKYC9XZPhjeJUpqPBytJLv3xmgMUyvT3GBJh7rY7l/FQFDowBhTW
	UcOMjsZzFNDV7MAr+QnRjba1wKO6+Q9nTZUBLQIjoFzDcqoh9lUSR7AbqSXbK85RXhRpxfcE/UYyt
	qemaya/DOaxcykHs9m5iZeK4p6VOfuBscq1UoOpQRFIhdvEHcstl9LnAl0FTkOJBh0zLJhRjGqg0a
	67E+UbHpiiKq+2PAHXWJyH3Z9sZJzs96HVUOuipUntUNAfvqgZIRKHg5hM8MTeIoTNiOt+tIBCNYL
	1Ip09K63xwzRnPG6AomK+9l+;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xEOKy-000000069bF-0tyY;
	Wed, 07 Oct 2026 09:53:24 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-rdma@vger.kernel.org
Cc: metze@samba.org,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/irdma: always route IB_WR_REG_MR through the allocated PBL
Date: Wed,  7 Oct 2026 11:53:12 +0200
Message-ID: <20261007095312.1523211-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

irdma_alloc_mr() always allocates a PBL via irdma_get_pble(), but
irdma_post_send()'s IB_WR_REG_MR handling only pointed the FAST_REGISTER
WQE at that PBL (chunk_size != 0, first_pm_pbl_index) when
iwmr->npages exceeded IRDMA_MIN_PAGES_PER_FMR (1) - leaving chunk_size
at 0 for a single-page (npages == 1) registration, telling hardware to
use direct/PBL-less addressing for a registration that was never
allocated that way.

This reproduces as data corruption / an IOMMU IO_PAGE_FAULT when a
peer later performs an RDMA WRITE/READ against such a single-page
FRWR-registered MR, even though ib_map_mr_sg() itself reports success.
100% reproducible on iWARP, intermittent on RoCEv2, with fs/smb/smbdirect's
own single-page memory registrations on an Intel E810-CQDA2 (irdma).

Intel's current out-of-tree irdma driver (2.6.96) never gates this on
npages - it always sets chunk_size/first_pm_pbl_index based on the
actual PBL level (PBLE_LEVEL_1 vs PBLE_LEVEL_2), matching what
irdma_alloc_mr() actually allocated. Mirror that here instead of the
npages-based heuristic.

Also drop the reg_addr_pa assignment. irdma_sc_mr_fast_register()
packs reg_addr_pa into the FAST_REGISTER WQE's PBLADDR field, which
hardware only consults when chunk_size == 0 (direct/PBL-less
addressing); with chunk_size now always nonzero for this opcode, that
field is never read for IB_WR_REG_MR and the assignment is dead code -
Intel's driver never sets it for this path either (only the separate,
non-FRWR irdma_sc_mr_reg_non_shared() path actually branches on
chunk_size between reg_addr_pa and first_pm_pbl_index). Removing it is
not required for correctness: *palloc->level1.addr is always a
page-aligned address (low 12 bits zero), so it could never have
collided with the first_pm_pbl_index bits sharing those same bit
positions in the WQE word even if some path still read it.

This leaves one deliberate difference from irdma-2.6.96: that driver also
ties local_fence to the WR's IB_SEND_FENCE flag
(stag_info.local_fence = ib_wr->send_flags & IB_SEND_FENCE) rather than
hardcoding it true for IB_WR_REG_MR. That is a separate, non-corruption
behavioural change, so local_fence is left at true here.

I've tested the change with an Intel-E810-CQDA2 card, lspci show is as:
Intel Corporation Ethernet Controller E810-C for QSFP (rev 02)

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Mustafa Ismail <mustafa.ismail@intel.com>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Assisted-by: Claude:claude-sonnet-5-5
Tested-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 5d71300da0ff..a524e8fc7738 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4279,11 +4279,14 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.addr_type = IRDMA_ADDR_TYPE_VA_BASED;
 			stag_info.va = (void *)(uintptr_t)iwmr->ibmr.iova;
 			stag_info.total_len = iwmr->ibmr.length;
-			stag_info.reg_addr_pa = *palloc->level1.addr;
-			stag_info.first_pm_pbl_index = palloc->level1.idx;
-			stag_info.local_fence = true;
-			if (iwmr->npages > IRDMA_MIN_PAGES_PER_FMR)
+			if (palloc->level == PBLE_LEVEL_2) {
+				stag_info.chunk_size = 3;
+				stag_info.first_pm_pbl_index = palloc->level2.root.idx;
+			} else {
 				stag_info.chunk_size = 1;
+				stag_info.first_pm_pbl_index = palloc->level1.idx;
+			}
+			stag_info.local_fence = true;
 			err = irdma_sc_mr_fast_register(&iwqp->sc_qp, &stag_info,
 							true);
 			break;
-- 
2.43.0

