Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694619;
	b=Hr8JLcp9FPVPwPbOgbNM336oMQqq6ypjR9L8OLDhPn0SlJvnOHl2tk3FWmHoDAdQMa/P
	 T/bQeW5spg9yNr/i7UDgX0j8wdhvv8kj0wOGO8Q+L0ocg544GhrRhE7+qLYlwdub5pNiG
	 7Ro07f9l23Fr+GAoQtyh9Hi1hB295o86qS20JaRiLO+xDvmwtX5DMQ91sEch7oALdtGf2
	 YnWF04nu8PJ9YrC9CNAFSUMZME2lE7YSQ6wBR1Z1rjP214hF8IyEdCgyDXfHXwM0Opq20
	 t95Ax53mtLgTW2Xzx2JPWRwoaxvzrZYHEXsxsTZLXB/fMiSCbXTv4lf6CQwkZfw0/ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=YD0JyfMGqA98tDkqSb0eSRlEdJc2ifVG/QLKbZ5F19M=;
	b=XWbv55nNqO11iMjIYNSB+ZvrUY324/NBu4aDJggwc11lKVn1H2CsHvTRfSZQt9ihdJk+
	 Zpl0LzkkFMVaeKNysOydi6qUQxiCkc7PpYIbZagRoxROKcuoqT3WRJXqOqnwBfHTezTA/
	 OpKTW+PEp6gijoj1uQfzwQLBPT28Ah69E2XLxyRp8t1wuDve0rfRAwgCdfocpz6nfjXKi
	 I0XTkG9hqkhawDmt3UfAm58SDe6DNLJvVRJ9DXEa0FROwyl2j0nYOsYffu39rPx4rWR7P
	 1k91KUqsTZnLxrqrrWd8uWe6fLLY663+zNxYVfIZbWeAEcjnz8QR1/r599lsgbKs3Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=giyn1c7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716CB606A32C;
	Tue,  3 Nov 2026 08:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=giyn1c7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750CD1F00A26;
	Tue,  3 Nov 2026 08:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694619;
	bh=YD0JyfMGqA98tDkqSb0eSRlEdJc2ifVG/QLKbZ5F19M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giyn1c7cs//4KOb8XR0QI8MxZLfh9r2Tk7zoc21CsaGzI/1aoQ8lv81zR0s4H15qc
	 N6vOTuU9XFYoUMUuYv3l0rc1VZGrvBEbnLIuV1yowOf5k7Tj6qYztNLt4eFE3JuEnY
	 ipuHkwOuUbUOcDY9Z5QepLPuA8FObTSfOLQqFhtyzxOJGbbIfMb5lF1/0yLJuqVeCB
	 yXuEZ/1UqQnqHO44PeFWAOzB12AuBuSDUoeVaLOXDJ5qJiTUkvhM4kBP5EOU5/joni
	 iOVhs+P/aiGIUbcKAfaF2ZgXj2YT57n5/1alvnrGYZlxwDhk9QvI4BrtAylvo9U0LL
	 MMO5bzzJoKJsg==
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
Subject: [PATCH v12 04/19] PCI: Reject unreadable ACS controls in isolation checks
Date: Tue,  3 Nov 2026 10:29:43 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-4-912101f93517@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
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
index 7c6f2aba8144..6d677695c0f5 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3627,7 +3627,9 @@ static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
 	 */
 	acs_flags &= (pdev->acs_capabilities | PCI_ACS_EC);
 
-	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+	if (pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl) ||
+	    PCI_POSSIBLE_ERROR(ctrl))
+		return false;
 	return (ctrl & acs_flags) == acs_flags;
 }
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7f1f47ea2ee4..05605c3afe08 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5145,10 +5145,14 @@ static int pci_quirk_intel_spt_pch_acs(struct pci_dev *dev, u16 acs_flags)
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
2.56.0

