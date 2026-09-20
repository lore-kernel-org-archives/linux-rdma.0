Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D0A3515F8;
	Sun, 20 Sep 2026 11:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904513; cv=none; b=Hbg6xPOIRkVoax6/BgYdcBBzu1eKPVkcgVvlgM7lGwGaKI9xyH3/ishkmVCBPxjddA1cIa+FwPS7K7+VWZC3l6xrD0rjGtNsZ4Mqq2QV12aFOSWGwmyV98hPk/5h5h62ZOkrDFIQNQLio+/kjwey0ToUiH3+3CuE2DpvYGYdBrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904513; c=relaxed/simple;
	bh=r82jL5WVcsE7kmahJOP1AjghFLzIXt1P4Mp9z2NJ+Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A+qgeZeJKy7Yfago80e14rA7nWo954mzeELethrIOWfwTpsVAAcQ/87Q2sp1iMeR0ypbjvtrkl9UW9Y4F4NQ8Ba9osAXUNq7+Z0wsve/Se/jgau2wxSkr/pZ1PXLxAdR77NmvZ7z/NUzxQXgeJj+B82y5qdZ4yGiVhxQ/zDpROo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQqBUWJF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQqBUWJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E26E1F000FF;
	Sun, 20 Sep 2026 11:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904511;
	bh=mB9EKqkzLzypkhdTWBPdUAfJNQuk4resftiaCbJ0Vhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQqBUWJF5+nKXmOJtT2JE4EiQKGekYJkgGty3zB523vGr8s8VfiEDwatYoLvMBKZf
	 ZSnheTyWquCZ2QjOQ+f8svrrUYdcgMgM6F5+NKzJxrfFLGKcuvkWwISS9bDgk7PPNC
	 NRHwchF1HjcPHs34r1OxuC1Jq9FQKjJqMFvVCv0cvzpeHgQAVvf2ckMFR90O/3uPEm
	 xk0DHSGLTFjjuUk2oO62We9xkLNoj/BsE0eeqXxdbfGvkKJ01dtPOF9YzzaaDsDJsw
	 ATFGcvPCDSVhnDzW3mFd4Ior9lZXbKvnGDt/KOaSy3xpOfdcN5sjOWvIjza2H3j2YM
	 8GYhwArtYJK7A==
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
Subject: [PATCH v7 03/19] PCI: Reject unreadable ACS controls in isolation checks
Date: Sun, 20 Sep 2026 14:41:15 +0300
Message-ID: <20260920-fix-p2p-acs-v4-0-v7-3-ca0828ab697c@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
References: <20260920-fix-p2p-acs-v4-0-v7-0-ca0828ab697c@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

pci_acs_flags_enabled() and the Intel SPT PCH quirk use ACS registers
without checking config-space read errors. A failed read may leave control
state indeterminate yet allow the device to satisfy requested isolation
controls.

Return false when either ACS capability or control state cannot be read.
An unknown state cannot prove isolation.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/pci.c    | 3 ++-
 drivers/pci/quirks.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b2879a6be5f8..f7d94ecf9157 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3594,7 +3594,8 @@ static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
 	 */
 	acs_flags &= (pdev->acs_capabilities | PCI_ACS_EC);
 
-	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+	if (pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl))
+		return false;
 	return (ctrl & acs_flags) == acs_flags;
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index de9bbccda21f..d5c3e6802840 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4992,10 +4992,12 @@ static int pci_quirk_intel_spt_pch_acs(struct pci_dev *dev, u16 acs_flags)
 		return -ENOTTY;
 
 	/* see pci_acs_flags_enabled() */
-	pci_read_config_dword(dev, pos + PCI_ACS_CAP, &cap);
+	if (pci_read_config_dword(dev, pos + PCI_ACS_CAP, &cap))
+		return 0;
 	acs_flags &= (cap | PCI_ACS_EC);
 
-	pci_read_config_dword(dev, pos + INTEL_SPT_ACS_CTRL, &ctrl);
+	if (pci_read_config_dword(dev, pos + INTEL_SPT_ACS_CTRL, &ctrl))
+		return 0;
 
 	return pci_acs_ctrl_enabled(acs_flags, ctrl);
 }

-- 
2.55.0

