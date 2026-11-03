Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694610;
	b=LJHDTTZIBRtAeijtTQGTPBAK+LAaj3ucMSZccB4EibcPdstBUwlYvFJfL7PfO11KJFy1
	 nlc2tODwXO8j9vKMeHd4Qk3XbHuqUMK+gXijc1URMF7Mb3uhUv3lF7jsuxyKY8w2MBmn3
	 YPcGGQhVE2SUEUWmst98I0aSH22KRmFv6izFjgacykJCj++EJxWlw5/rzzDUmKOR6yXXA
	 m0/detDchCxQfYYPi6isSbYNWFuEiBilg6kX/6NyW0odkHiwMIJZkt7k8OwXNL0TtDSmY
	 ga3E36/HNL2F5xWlFQYEG8FFSHMjRPvsqtguSHimo0rNr1QXw6qtI0ahQtw1/92CV2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:X-Change-ID:X-Mailer:
	 Content-Transfer-Encoding;
	bh=upNUkJyXoLVAUbVayP9rfwiDE1A46jbcDOisdU9woW4=;
	b=pJ/VbPxYJUbndKG/XYMkzVFjY+qSkSQjf/rW8YqSEg/yTTWtW57KVMowI39Xr7c3iEDs
	 l2utCFKsjRQagayHkbQqIsbCgAAK61hWA2MfKVE7EX/jLg2CTOMzpHnpMGzEal9oN+hkA
	 m9eTspaFRYNbor9lE1aM1mBZxfRAQdCsshzSYSG2Uv0G8c9u3R4oYi0S3GwRVAPPl+1bd
	 GZHeTcZHoEY11K/GoyvSysbfwVScRnAtYqwAZ4+E8kILliIYcAryilhDepnjT+MNROgwR
	 T7Tt4HNYQQe8JjGrOC+Yob7Mjt/nljUbAtf44TzU0U47ANpnc//qORvJ3LEjKr0RqrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=obBzRYe6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD61606A339;
	Tue,  3 Nov 2026 08:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=obBzRYe6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D921F00A15;
	Tue,  3 Nov 2026 08:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694609;
	bh=upNUkJyXoLVAUbVayP9rfwiDE1A46jbcDOisdU9woW4=;
	h=From:To:Cc:Subject:Date;
	b=obBzRYe6fJ+bAS01CeQuLw1S7ubUvpxw3IkivGbYaX0e6gG0KpaG149RzyU1X0D4n
	 4A6Uu6p4Hm1k33qHUk8n+XNy2Z0F1DFTICWeISCsMqe6E55U5bYxWbFJym3aiSp9gE
	 mNOB2nZVoOdDOuxl217WMRhKKQyETsIGQTkCIJ5KcoLmNblqArGtP+B5DvTCFgx7pR
	 E8YwO5tjTR+RXyU4aif8YrtMcovkOKsS5urFn99V+Eloemv/Bg0gbYC/Z5WOtZP790
	 ZYrqD26iXuKRjApWD3eZDHOwqmNlJRFks/URSe01BPwX1IRHHcXcDj5ry5V+W47t2o
	 jWpOjEQkf/yjw==
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
Subject: [PATCH v12 00/19] PCI/P2PDMA: Route peer-to-peer DMA by TLP class
Date: Tue,  3 Nov 2026 10:29:39 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
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
Changes in v12:
- Rebaed to v7.4-rc1
- Link to v11: https://patch.msgid.link/20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com

Changes in v11:
- Applied the client ATS policy in pci_p2pdma_distance_many() too, as
  local Sashiko pointed out.
- Read the ATS Enable bit once per query, so the class and the ATS policy
  always agree.
- Documented that pcim_p2pdma_set_ats_per_mapping() needs a successful
  pcim_p2pdma_init().
- The path diagnostics no longer read ACS Control or the bridge bus range,
  and they report a failed cache store.
- Added a KUnit case for Direct Translated P2P without a redirect.
- Clarified the Relaxed Ordering and diagnostics commit messages.
- Honored device-specific ACS redirection, such as Zhaoxin Downstream
  Ports, in a new first patch with a KUnit case, as local Sashiko
  pointed out. Relaxed Ordering Completions are redirected at such a
  port too.
- Clarified in the documentation that a quirk also redirects Relaxed
  Ordering Completions and that Translation Blocking applies only to
  upstream Requests, and labelled the ACS routing debug line with its
  class, as local Sashiko pointed out.
- Treated ACS registers that read as all ones as unreadable, and named
  ports that a quirk redirects instead of suggesting
  pci=disable_acs_redir= for them, as local Sashiko pointed out.
- Ignored ACS quirks of endpoints, which only describe traffic between
  their own functions.
- Link to v10: https://patch.msgid.link/20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com

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
Leon Romanovsky (19):
      PCI/P2PDMA: Honor device-specific ACS redirection
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

 Documentation/admin-guide/kernel-parameters.txt |   11 +-
 Documentation/driver-api/pci/p2pdma.rst         |  105 ++
 drivers/pci/Kconfig                             |   15 +
 drivers/pci/Makefile                            |    1 +
 drivers/pci/p2pdma.c                            |  942 +++++++++++++++--
 drivers/pci/pci.c                               |    8 +-
 drivers/pci/pci.h                               |   57 ++
 drivers/pci/pci_acs_test.c                      | 1225 +++++++++++++++++++++++
 drivers/pci/quirks.c                            |    8 +-
 include/linux/pci-p2pdma.h                      |   12 +-
 10 files changed, 2292 insertions(+), 92 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20260821-fix-p2p-acs-v4-0-e72455e3a261

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

