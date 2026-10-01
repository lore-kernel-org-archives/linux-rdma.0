Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323A74921A1;
	Thu,  1 Oct 2026 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855756; cv=none; b=P+QZgNyZ/Zqnv9XSYUcX0siEIoF4G9YVjXeEItbeSJmcSyzSeL+1ZZ2NA5euFlKXjUQ4SmuKWnQzzHGJQBKQJBvmX638qOQoEGkdvT1B48Iun+3qlUr7r+deZ6MV3SHRHuH4DApU8m71SvF9GYipfZatUMsaBNH8YGKVGG0/fs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855756; c=relaxed/simple;
	bh=r82jL5WVcsE7kmahJOP1AjghFLzIXt1P4Mp9z2NJ+Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iykdrv0EksfNeBIu5Pzs2MMhjsHy7oAjRjYFs7LSD5pwNhyt3NjCl1KPQUqZfFJULHN9ZfRTJmqak4/8YR7KGgheUGZI2crW9/bnlPKvxfwckCG7rC8Q5rksnO7lBON+UBqvFnSvheYKX/5xQoyFFaAYdV3Oumvv4Trcgn1ErUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5DBRc2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5DBRc2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D5A1F00899;
	Thu,  1 Oct 2026 11:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855745;
	bh=mB9EKqkzLzypkhdTWBPdUAfJNQuk4resftiaCbJ0Vhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5DBRc2d+I+rHfMXDN+NWlIt5rBO2OM8oIz3mzZMD/OUCJwY5jX9rpXCcjBhBpFUu
	 FzeIQxna1pRdyZ9lvs0twb10o/qjal9dDIMb1gYwQ6098xQ5C8UkWOrcD5CVL3qyqI
	 +Mkbk5Sj31wHlhyeaYGsIo40VCTrKxHzolFRMmoSC+oEJayC23vqN2vJ+wJliruazh
	 9SnBJIV4g81zoc+sr8oLQ1n5OCf1buRVU77sTrr5QCgw6VPaDcrYZeEHdpov41boUz
	 4OKl5r71fgip2isUGIU29QSarkVLfOt+SaPU3XfZLssz4Gi7NK2pCAwWc59vEzUoHj
	 IjAcF0Dp8e5rQ==
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
Subject: [PATCH v9 03/18] PCI: Reject unreadable ACS controls in isolation checks
Date: Thu,  1 Oct 2026 14:55:11 +0300
Message-ID: <20261001-fix-p2p-acs-v4-0-v9-3-1a8e0f50ddd9@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
References: <20261001-fix-p2p-acs-v4-0-v9-0-1a8e0f50ddd9@nvidia.com>
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

