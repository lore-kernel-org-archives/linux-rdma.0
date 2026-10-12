Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4582E375F81;
	Mon, 12 Oct 2026 13:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810500; cv=none; b=JCQWBAqFqhE7LjvEJNByaDqXIKWbnHj0vXg8DInRKLT9CZw97m/9594pO7vTryTt+rx/W5A35ZR6SZ2Rt/p/vIVSl+ZOg8/2rfKthgm3DWq43LG0pfgppAPWQ5TBG8aLzIvbQ/Iy+37v3gme7TOqmi4JOJcyN1bjs80VTiKJGlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810500; c=relaxed/simple;
	bh=5OoO4u4wT2EspBgtGfHo4fnutiaRSS4knSYoOyJYjR4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mkvihMeWph3PFjLOtxOHDt5ZPCU5cLKao7/YrRoRuXbKdkUhru2fRNIkHdt4eHLQ2NS57rogGVo8i7vZ9CQ0lPrbMrOksJofVCpgM5oCet6/7BVLGQc8hM6HqHrZ3z/rnbCpnSSH97qDMGvVXyzQqciY4TwlJkdykNNaxNuTGjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjXaAxUY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjXaAxUY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D6E1F0089B;
	Mon, 12 Oct 2026 13:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810498;
	bh=hPD4B6sRGtyUbN0DgtR7qqzDwJtgKxfCYn3LCYYPWBo=;
	h=From:To:Cc:Subject:Date;
	b=VjXaAxUYRaAMJ9UDZRIhSGKch2D3eK+W/4GnK3Abi9fGOVhoo5Vc7NrHGnBNKIx5I
	 0ZaSDpw3JUhjSLhn4MGtuZLNlRUwRp9VGS9R/hHUJd3ALB9s9c4CDVK3mFXzfeBWBC
	 JlbthD/kyLCYW8wTQKVUVTtj+Wxl9zsDFLMdX96jrP4wIspfP+XjizcsQ3gVMa+i8s
	 U9MwWZx+/luOySXU6esCZWxXgr7fHC17Ct/RyMphKL8UZTV+zR67VCnj7ZJ+HFSOcr
	 qWEt4kgz30LmeOO+9DXRaV4sT8NnyKPzGBxusQq1ffqym+Ve/J5A0GyUZx2W51q/0C
	 OxOAQajio+HmQ==
From: Leon Romanovsky <leon@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v10 00/18] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Date: Mon, 12 Oct 2026 16:07:37 +0300
Message-ID: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
X-Mailer: git-send-email 2.56.0
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

Three ACS controls act on TLP attributes the Requester chooses rather
than on the topology: Translation Blocking and Direct Translated P2P act on
a Request's Address Type, and Completion Redirect skips Completions carrying
Relaxed Ordering.

Evaluate each direction at the path divergence, decide every class from the
one walk, and treat a client with ATS enabled as translating unless its
driver declares per-mapping ATS.

This completes the P2PDMA side; dma-buf and mlx5 follow separately.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Changes in v10:
- Fixed the Relaxed Ordering description: a Completion carries the
  attribute of its Request (PCIe r7.0 sec 2.2.9.1).
- Used the PCIe terms Requester and Completer for TLPs, ACS and ports;
  client and provider remain for P2PDMA objects.
- Rebased on pci/p2pdma, which includes the prerequisite P2PDMA fixes.
- Added a topology example to the path divergence patch.
- Removed a repeated sentence from the disable_acs_redir documentation.
- Explained the path divergence in the documentation.
- Link to v9: https://patch.msgid.link/20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com

Changes in v9:
- Removed dmabuf patches for now.
- Removed mlx5 per-mapping ATS declaration for now; it comes back with
  the dmabuf patches.
- Link to v8: https://patch.msgid.link/20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com

Changes in v8:
- Added extra Reviewed-by from Logan.
- Added patches to take care of ATS per-device vs. per-mapping option
- Link to v7: https://patch.msgid.link/20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com

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
Leon Romanovsky (18):
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
      PCI/P2PDMA: Let a client declare that it selects ATS per mapping
      PCI/P2PDMA: Evaluate the ATS path for clients with ATS enabled
      PCI/P2PDMA: Test the routing of clients with ATS enabled

 Documentation/admin-guide/kernel-parameters.txt |  11 +-
 Documentation/driver-api/pci/p2pdma.rst         |  81 +++
 drivers/pci/Kconfig                             |  15 +
 drivers/pci/Makefile                            |   1 +
 drivers/pci/p2pdma.c                            | 719 ++++++++++++++++++--
 drivers/pci/pci.c                               |   7 +-
 drivers/pci/pci.h                               |  56 ++
 drivers/pci/pci_acs_test.c                      | 860 ++++++++++++++++++++++++
 drivers/pci/quirks.c                            |   6 +-
 include/linux/pci-p2pdma.h                      |  12 +-
 10 files changed, 1683 insertions(+), 85 deletions(-)
---
base-commit: 36038f0e8377ef316b723d0d85b1510bc64069ab
change-id: 20260821-fix-p2p-acs-v4-0-e72455e3a261

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

