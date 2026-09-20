Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1921A33DEE6;
	Sun, 20 Sep 2026 11:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904506; cv=none; b=DrKOHi/82PnOqCAfUk57GRPdbQfJc84uCmugQab1YNWNaa6U457PV50bubKvASK5yvbv6ZDmaQN/oSiMKpFwL13LLGT3PPEuDnVfOf1OBpkrtrU787pJ9Jj8qmhp9dP3ebym30ZBKzZoZq/q4GXdb2pF/RcVeZTKQFcBIAAGZwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904506; c=relaxed/simple;
	bh=Yvdr+7gZn7fJruCtUeZMok6Sv0JTPuYuwqfbuzbDxM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PJzSqLZou5aHPWE2HbF/HpAT836OjPJ2B4H7UqQUqylpi9CuYd6mnWS6qydGcI1oCc8sMv8FtN3nGAOEzn1rwPop4EhT/5dTf98JSICByLswKbXs++v5N0Syz2tefGbDPeoO9k2tFuVqh/8SaU8YQtvSohUUjRkIP1x9ki6iQN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bm4/yRXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bm4/yRXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D8E1F000FF;
	Sun, 20 Sep 2026 11:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904504;
	bh=/TdmiqQ46y/8NRpgZ+g2iqUwv/O08JBQFMW3EdhAmmo=;
	h=From:To:Cc:Subject:Date;
	b=bm4/yRXMH4g6lpVOxlDOx0X2NSIMkVJ4fupGj8MIj8CpBqptmBCk4daJRozjM9HNU
	 1Bmeb5JIbThT7JXJx2O9R5BpraNIXLGs322zyokWAl5PSoqgLUH6enkyH4VA+8PZ/a
	 j6naba/2EWnfFqEy0mJU4S/2aG6DqjQg7VYPHUGLfwGdruyYplBGDIjAjwRfGw6an/
	 lfe37Cf57G0ngc4GGxsnuI3hkzrAE2sEi0/YmGSn7jxLHn9RzIXycHna8isAMeHQko
	 4tQPALi9EGWcouBuluZud1d21xqHtVTUwk8r/FcXNdIBXULBFB6ERCK61xv8489pnz
	 LR/XF8nShYGiQ==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v7 00/19] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Date: Sun, 20 Sep 2026 14:41:12 +0300
Message-ID: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260821-fix-p2p-acs-v4-0-e72455e3a261
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

PCI P2PDMA applies Request and Completion Redirect throughout both paths.
This misclassifies asymmetric and nested switches, and reports one answer
for every kind of TLP.

Three ACS controls act on TLP attributes the client chooses rather than
on the topology: Translation Blocking and Direct Translated P2P act on
a Request's Address Type, and Completion Redirect skips Completions carrying
Relaxed Ordering.

Evaluate each direction at the path divergence, decide every class from the
one walk, expose the provider to dma-buf importers, and let mlx5 ask rather
than assume.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Changes in v7:
- Removed "Document pdev->p2pdma lifetime rules" patch, it gives nothing
  after p2pmem fix.
- Split dmabuf patch.
- Tushar retested the series, so added his Tested-by.
- Added Logan's ROB tags and fixed minor documentation issues pointed
  by him.
- Link to v6: https://lore.kernel.org/all/20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com/

Changes in v6:
- Changed DMABUF to use callbacks and not directly stored pointer.
- Link to v5: https://patch.msgid.link/20260910-fix-p2p-acs-v4-0-v5-0-856087f63c0d@nvidia.com

Changes in v5:
- Rebase on the posted fixes.
- Dropped tags from changed patches.
- Remove Egress Control Vector interpretation and coverage.
- Keep enabled Egress Control conservative as a Request redirect.
- Use pci_dbg()/dev_dbg() for diagnostics and drop the "debug" prefix.
- Removed code comments from "Document the pdev->p2pdma lifetime and RCU
  rules" patch and reduced description to actual lifetime explanation.
- Added note that Linux assumes that TLPs are in strict-ordering and
  untranslated.
- Added code to calculate p2p paths per-TLP type.
- Converted mlx5 to use that new proposed API.
- Link to https://patch.msgid.link/20260821-fix-p2p-acs-v4-0-v4-0-94426b96de73@nvidia.com

Changes in v4:
- Reject ACS Violations and unreadable routing state instead of treating
  them as host-bridge redirects
- Added Tested-by tags from Tushar Dave
- Added support to asymmetric ACS routing
- Limited redirect checks to the two ports at the path divergence
- Added standalone ACS routing diagnostics for hardware retesting
- Dropped " PCI: Account for Direct Translated P2P in ACS isolation checks" patch
- Link to v3: https://patch.msgid.link/20260811-fix-p2p-acs-v3-0-efc488ee7c03@nvidia.com

Changes in v3:
- Fixed pci_p2pdma_add_resource() error unwinding
- Made pdev->p2pdma teardown wait unconditionally for RCU readers
- Restricted pci_p2pmem_find_many() to pool-backed providers
- Documented the pdev->p2pdma lifetime and RCU rules
- Fixed calc_map_type_and_dist() handling of the verbose argument
- Required the ACS port and target to share a bus before indexing the
  Egress Control Vector
- Gave pci_acs_enabled() and pci_acs_path_enabled() a scope, so the ACS
  Direct Translated P2P rule no longer stops pci_enable_pasid() from
  enabling PASID
- Dropped "Report ACS ports when the paths share no upstream bridge":
  the mapping type cannot change without a shared upstream bridge, so
  the pci=disable_acs_redir= hint was not actionable there and the ACS
  walk only cost config space reads
- Folded the Request Redirect rule into pci_acs_rr_ineffective(), so
  pci_acs_flags_enabled() and the Intel SPT PCH quirk share one copy
- Renamed pci_acs_egress_ctrl_set() to pci_acs_egress_ctrl_is_set(), it
  reads the bit rather than setting it
- Reworded the blocked-path warning: ACS may also leave the direct route
  indeterminate rather than blocked
- Added KUnit coverage for the shared-bus guard, a device with no ACS
  capability and an unreadable ACS Control register
- Added the missing Fixes: tags, a second one on the
  pci_p2pdma_add_resource() unwinding fix (the dangling devres action
  dates to f58ef9d1d135) and one on the Egress Control isolation change
- Link to v2: https://patch.msgid.link/20260806-fix-p2p-acs-v2-0-0cec14812965@nvidia.com

Changes in v2:
- Added Logan's ROB tags
- Added commas in Documentation patch
- Link to v1: https://patch.msgid.link/20260802-fix-p2p-acs-v1-0-a7c5eb64fff6@nvidia.com

---
Leon Romanovsky (19):
      PCI/P2PDMA: Document the TLP attribute assumptions
      PCI/P2PDMA: Derive routing from directional ACS controls
      PCI: Reject unreadable ACS controls in isolation checks
      PCI/P2PDMA: Evaluate ACS controls at the path divergence
      PCI/P2PDMA: Document directional ACS routing
      PCI/P2PDMA: Collect the path's ACS controls before deciding
      PCI/P2PDMA: Answer routing per TLP class
      PCI/P2PDMA: Route Relaxed Ordering Completions directly
      PCI/P2PDMA: Reject Translated Requests blocked by Translation Blocking
      PCI/P2PDMA: Route Translated Requests under Direct Translated P2P
      PCI/P2PDMA: Log detailed ACS routing diagnostics
      PCI/P2PDMA: Add KUnit tests for the ACS routing decisions
      PCI/P2PDMA: Test the ACS P2P routing walk
      PCI: Add KUnit coverage for ACS isolation checks
      PCI/P2PDMA: Document TLP-class routing
      dma-buf: Let importers ask how peer-to-peer traffic is routed
      vfio/pci: Hand out the P2PDMA provider behind a dma-buf
      RDMA/uverbs: Hand out the P2PDMA provider behind a dma-buf
      RDMA/mlx5: Ask P2PDMA whether ATS takes a direct peer-to-peer route

 Documentation/admin-guide/kernel-parameters.txt   |  15 +-
 Documentation/driver-api/pci/p2pdma.rst           |  71 +++
 drivers/dma-buf/dma-buf-mapping.c                 |  39 ++
 drivers/infiniband/core/uverbs_std_types_dmabuf.c |  12 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h              |  36 +-
 drivers/infiniband/hw/mlx5/mr.c                   |  47 ++
 drivers/pci/Kconfig                               |  15 +
 drivers/pci/Makefile                              |   1 +
 drivers/pci/p2pdma.c                              | 630 +++++++++++++++---
 drivers/pci/pci.c                                 |   7 +-
 drivers/pci/pci.h                                 |  26 +
 drivers/pci/pci_acs_test.c                        | 737 ++++++++++++++++++++++
 drivers/pci/quirks.c                              |   6 +-
 drivers/vfio/pci/vfio_pci_dmabuf.c                |  12 +
 include/linux/dma-buf-mapping.h                   |   3 +
 include/linux/dma-buf.h                           |  19 +
 include/linux/pci-p2pdma.h                        |  57 +-
 17 files changed, 1611 insertions(+), 122 deletions(-)
---
base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
change-id: 20260821-fix-p2p-acs-v4-0-e72455e3a261
prerequisite-message-id: <20260830-batch-p2p-fixes-v1-0-5044e8dfbe2e@nvidia.com>
prerequisite-patch-id: 6b25c7fcf164cdfc14e9fac5b908d97fcf6509d7
prerequisite-patch-id: 0d083c281001365aae4b35544cf28891a6ab9a96
prerequisite-patch-id: bfd9dabf271f3cc9a3a61f46387d20c20311363d
prerequisite-patch-id: fad0275efc722830fc591509506c0a5e4f581073
prerequisite-patch-id: 0c83bee688fec1f6d1564654df7c630fa6a4a978

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

