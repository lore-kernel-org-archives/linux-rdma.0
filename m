Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB4948032F;
	Tue, 13 Oct 2026 14:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901550; cv=none; b=bP/I0VgzbqgUUIYf+K+CJ8CNN4YMMQ9LVR9TpP8N3fenEKEA9Jdce1JwD02bnQQAKAdniWa4Q8wIQGFhHWrotyXBkhGaEeEEk/Vp639w7Z91mEPbFCIn08n0qzV99pmb+ZN8i2mHEBgAseBRTceJhhhNFgmy7lepxYExWkYENs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901550; c=relaxed/simple;
	bh=pt0ruMHb22TjwcSE1bQoaUqJkhEB+8+JFPJkNCp3IEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPyzKbkmhIVat7n1eX06U0qcPEuT3dMFDy9iGDoxpYOZNTd0I3kUX+WIZG+9ZAm6bx/39xKB35sAA+GjexiI/I+UZAB+Wf7Onk+GaQQxRFhATEHhl54zR9Krzv4N95gO9ptO4PZs3mnfECaoheDY0dCBBmEDD65vFuEd54LH+pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I5QpFT5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I5QpFT5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCB01F000FF;
	Tue, 13 Oct 2026 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901549;
	bh=Bj6ifN0X7QiFcwgmv/4msNlxFsw0k7Toslkew1uDKhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5QpFT5XyRYgGMSuSZn2Ks0RvZ8Xn+pTDX7Ag8Y7XJ/UJXOkjbOB/gmgL3vt/Bi//
	 uVtJNLpdZA+zFOmjMukFEqQw5K9VG7lGmRmDYsN61ld4GHOirQKrdR71NXHmUv7vJr
	 FImoz0Hj87624ndsTqNNTe2dvLKlm+DkhSBzeSRkWOORL/WA1AyDubzjXwCwxRBYa9
	 gZh4a+BeUI4UM2BhJ13NzOWm3esKM1ykZHIJcY15OwYMLaf6EMBh1wMO222Kido/Uu
	 FpEp7sFQXR6J/WlgqC5hGtC3m2Z8W22lnMNCCZfypPB5APq7PS+UMI5WAkrg2gtF1m
	 DguVjO8oArEmA==
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
Subject: [PATCH v11 04/19] PCI: Reject unreadable ACS controls in isolation checks
Date: Tue, 13 Oct 2026 17:25:12 +0300
Message-ID: <20261013-fix-p2p-acs-v4-0-v11-4-72cf8c96e617@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
References: <20261013-fix-p2p-acs-v4-0-v11-0-72cf8c96e617@nvidia.com>
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
controls. So can a read that returns all ones with a successful status,
which is what a device that does not answer usually produces.

Return false when either ACS capability or control state cannot be read
or reads as all ones, which neither register can legitimately hold. An
unknown state cannot prove isolation.

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/pci.c    | 4 +++-
 drivers/pci/quirks.c | 8 ++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b2879a6be5f8..5f6db2416cee 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3594,7 +3594,9 @@ static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
 	 */
 	acs_flags &= (pdev->acs_capabilities | PCI_ACS_EC);
 
-	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+	if (pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl) ||
+	    PCI_POSSIBLE_ERROR(ctrl))
+		return false;
 	return (ctrl & acs_flags) == acs_flags;
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index de9bbccda21f..849619e270fd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4992,10 +4992,14 @@ static int pci_quirk_intel_spt_pch_acs(struct pci_dev *dev, u16 acs_flags)
 		return -ENOTTY;
 
 	/* see pci_acs_flags_enabled() */
-	pci_read_config_dword(dev, pos + PCI_ACS_CAP, &cap);
+	if (pci_read_config_dword(dev, pos + PCI_ACS_CAP, &cap) ||
+	    PCI_POSSIBLE_ERROR(cap))
+		return 0;
 	acs_flags &= (cap | PCI_ACS_EC);
 
-	pci_read_config_dword(dev, pos + INTEL_SPT_ACS_CTRL, &ctrl);
+	if (pci_read_config_dword(dev, pos + INTEL_SPT_ACS_CTRL, &ctrl) ||
+	    PCI_POSSIBLE_ERROR(ctrl))
+		return 0;
 
 	return pci_acs_ctrl_enabled(acs_flags, ctrl);
 }

-- 
2.55.0

