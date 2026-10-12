Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896A04AB3C3;
	Mon, 12 Oct 2026 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791821517; cv=none; b=j+rlYelvdLp8TZWJtEosM67tTR6DqPjXVn5MyFFDnIGUdmXh8hr/9uWSmpXNyt18mSvdooDOippBDFX/addIBmm5rBsrUYjU0//lwR+BZBkBQYL2Rts41L4l0T8EOR93kuHVGcVtxt1c6PE8npU5fAhQZRLh9A2gXfgzTkGO0wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791821517; c=relaxed/simple;
	bh=e/8swMYCLvyy1dlqt5ZkkmyUvBjW05+gIwT317lRJA8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gP5q73Dm5RT6zGeIYXxzu+y0kRk9TljhjU9IIMYZQp+i/mgpJxvG7NRRW8ywWyLH/X24Eqpu4TKAiq1x0v6Pcqouf2HLQyqhSVwgQs3bTrm431BA6fcYR+VdKWj3Sa2b8/PCr6kqq5/KLjyF0DQeUMhGfbT1P4e1+VhFhJVqct8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=IWQFas00; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IWQFas00"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ug2U4uOR87PKxNvkhazP9qraYMh5L+a55RRax+7Ny8I=; b=IWQFas007aLkz8phz/3c2rYKBK
	8PR3KDrSFgKHno6++93qRaDx4bKkbM2rX8bBRr8m691MSQFMXS5Ayz3drENTzLUNeRhOH/NeqKFWX
	jg6IZmOThwi9L6EZnSgPnp2mQejMUQrqg8V5F/pHbq8fN0qvfKUJCrh+J3cOkO0OqNLcIgm5V+tVV
	9xHx5HUlr0hRcjgzdX4Q/oKThaw37x7oO/Wl+OFNAv1xeVLYBc/rAyDpB0F6F7GJIlwLrIrFP6skC
	lTNWE0/5jausBcftnDUdzztHEGb4nJWftitGcipoiY0qtBEoz+GFWO9zOkSC2SlKeV8iBOcOk2PlC
	64FhOJ+oP5bwdGZh20W0Z36FXRprBM3eKJEGAysobouZorbwoHgi9ZKUY34zy2/5PixsuMBSFqsfL
	JZW9gi9eIPKx0QdvUDNUBSKoYciBjSXE5PDwfuCNFswlY1ORAt7jmrecak4ooUGFQZtw4btSnMTlz
	ocw9/+Z3S73CygctdKJGeGtd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xGIco-00000001Jte-3mB9;
	Mon, 12 Oct 2026 16:11:42 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-rdma@vger.kernel.org
Cc: metze@samba.org,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] RDMA/irdma: always route IB_WR_REG_MR through the allocated PBL
Date: Mon, 12 Oct 2026 18:11:35 +0200
Message-ID: <20261012161135.494544-1-metze@samba.org>
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

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Mustafa Ismail <mustafa.ismail@intel.com>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: linux-rdma@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Assisted-by: Claude:claude-sonnet-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>

--

change in v2:
- rebased on linux-rdma/for-next
---
 drivers/infiniband/hw/irdma/verbs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 71d7ae7baa47..e3cd38e0b3dd 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4286,11 +4286,14 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.wr_id = ib_wr->wr_id;
 			stag_info.va = iwmr->ibmr.iova;
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
 			err = irdma_sc_mr_fast_register(&iwqp->sc_qp,
 							&stag_info);
 			break;
-- 
2.43.0

