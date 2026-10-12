Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99E44921B3;
	Mon, 12 Oct 2026 13:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810520; cv=none; b=KEOu3iDP/9tGFdbGYvCvqpd3WpU90SCCMnAI4FifjfkKqRCstU1MXJH4ydwt/w/JXB9AaDYA2KIrLBz5nOVEAyb/n5/PMD47PJ+5JA+sIzFm4IMUhDATgsBvdIAGGsQOUvS/y/tJBKfPwBTb3vTdHjfw4Cs3rdC6Kj8i5bOjFks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810520; c=relaxed/simple;
	bh=r82jL5WVcsE7kmahJOP1AjghFLzIXt1P4Mp9z2NJ+Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DlPQbxf22Mckqiwx9EyEJrdNc6InrVhT/Mk8O8lRCuIvsN2HQ0JF8dojcusDxWez9lHFzbSWOvZKjMJow/ZL6uS5mtZ82yKYMyhrKRk7co93nmY3zX+vqypDM1cgI6hq+k+OUoriwj8fgJR/7Yzn0XLk4t3POBn/QMW24QaNrtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BT8Nwe7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BT8Nwe7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2EF1F0089B;
	Mon, 12 Oct 2026 13:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810519;
	bh=mB9EKqkzLzypkhdTWBPdUAfJNQuk4resftiaCbJ0Vhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BT8Nwe7FYI1Pg5G6Sp4nxNqTdOtphgHNU7voQ6jYKoLv7f14uppoRZdgL4nVUpkgk
	 gQOnmoi6LeZg7RX0eO1y1+B8v4oxvceK7nA/onT0v5dJbvqIyAA59qiC/x+qnHvIfG
	 7zwmU3Tc2etDdFlhcnN2t6F8tOz0dMru04LmZtwub3UyUivQBd+XA09qQgARsKy11K
	 9mYwIpg4ihfM9htzHpyladH/GveMaaCQPck7TEuOJ4iXlupBLGAxmZl0O8CzP9lz/b
	 INi+N4FQCX7+/il+Z+ZQQM5axAa8uVOMLTvXyk1WpgefZjj2d3fl7nmsboEEl4gUsS
	 tm1GNxidgPknQ==
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
Subject: [PATCH v10 03/18] PCI: Reject unreadable ACS controls in isolation checks
Date: Mon, 12 Oct 2026 16:07:40 +0300
Message-ID: <20261012-fix-p2p-acs-v4-0-v10-3-6ffe7b7a4517@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
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

