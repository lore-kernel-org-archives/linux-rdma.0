Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865B14B7A46;
	Thu,  1 Oct 2026 11:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790855815; cv=none; b=PaZnqpmDo/vVeIctFi3d/hoMfbbEd6vruMNPG5dWH7BDXhkSgAZKn9NELX4pKERb70kI3EPjxFrPYLUrLQtm2KVmikXfGHOrRCtcNjpipdrYVxpSweGjznIjf1/fgkcBZ6k5e2jRngiv+HSpccUDNNXukxC48Q5mFM5uyd+TnM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790855815; c=relaxed/simple;
	bh=mXkfwVMSTG/O8xES3e+cilNTPUL6vj5Tm7w9qm/T15c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/dLpVUmtMSneE7UITrwH5EyS8PvIPwYLO0dh8Ww6a0VmvafE0bsa4P3ZxQsUbu3htM9JDj7ymRB7HTn+LhXZT8vbac7KLjJIQfIhyjT73E34PqagSiXSoOetFJdsd8mHfOEG7+bBm7XomhNxoeH+DJsW0kLT9/5iRM9F2Jaorc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFsK0+VK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFsK0+VK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A961F0089A;
	Thu,  1 Oct 2026 11:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855808;
	bh=1ffECzzDMF9N/V+IW068tuIKbzvCCrI+xf0c3ifH81I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFsK0+VKEXganTCL4uFtKxjL0tKHK9HQELCBPFQW+B64RunZ5cwIcdl5VSbLjyyk9
	 hp7q/QePiL603BPldDm1amKxlv0cnggedDe4/APPdWo1clWkf4+KkjqU4UH4zqie9v
	 +0Njoz3shhOG6aN3TofI90r0T827NXVZM6m1MbX5nV9TshyQp8t7qUJRjR5LifiM8a
	 I1aZSzw+Xk6nn3sR7gVgYFgtuop4hUYkuwJ1kxb6PN1DDiyu7mjD8FiS7IxapSQn0e
	 JMYDzd7ZCBO5wwZdcLxDLK687Uu6Ifrc4wgdFotJA1T3R3EH64D8Ky/Pu1FcE+9cZB
	 li2w1ubTvh3bg==
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
Subject: [PATCH v9 16/18] PCI/P2PDMA: Let a client declare that it selects ATS per mapping
Date: Thu,  1 Oct 2026 14:55:24 +0300
Message-ID: <20261001-fix-p2p-acs-v4-0-v9-16-1a8e0f50ddd9@nvidia.com>
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

The PCIe ATS Enable bit covers the whole device, so P2PDMA cannot tell
from it whether a client will translate a given address. Most devices
translate any address once ATS is enabled, but some choose ATS per DMA
mapping and can still use bus addresses for the rest.

Add pcim_p2pdma_set_ats_per_mapping() so the driver of such a device can
declare that before P2PDMA starts treating clients with ATS enabled as
translating everything. Keep it in the device's P2PDMA state, which
already ends with the driver binding.

Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/pci/p2pdma.c       | 27 +++++++++++++++++++++++++++
 include/linux/pci-p2pdma.h |  4 ++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index c1e9d43bded2..126e28d2a5dd 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -26,6 +26,7 @@
 struct pci_p2pdma {
 	struct gen_pool *pool;
 	bool p2pmem_published;
+	bool ats_per_mapping;
 	struct xarray map_types;
 	struct p2pdma_provider mem[PCI_STD_NUM_BARS];
 };
@@ -1568,6 +1569,32 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 }
 EXPORT_SYMBOL_GPL(pci_p2pmem_publish);
 
+/**
+ * pcim_p2pdma_set_ats_per_mapping - Declare per-mapping ATS for a client
+ * @pdev: PCI device that initiates peer-to-peer DMA
+ *
+ * Declare that @pdev issues Translated Requests only for the DMA mappings its
+ * driver sets up to use ATS, rather than for any address once ATS is enabled.
+ * P2PDMA then routes this client's Requests with the Address Type each query
+ * asks about, rather than the one its ATS Enable bit implies.
+ */
+void pcim_p2pdma_set_ats_per_mapping(struct pci_dev *pdev)
+{
+	struct pci_p2pdma *p2p;
+
+	p2p = rcu_dereference_protected(pdev->p2pdma, 1);
+	if (!p2p)
+		/*
+		 * ats_per_mapping is a performance optimization,
+		 * if pcim_p2pdma_init() didn't set pdev->p2pdma pointer
+		 * for some reason, let's simply use ATS global settings.
+		 */
+		return;
+
+	p2p->ats_per_mapping = true;
+}
+EXPORT_SYMBOL_GPL(pcim_p2pdma_set_ats_per_mapping);
+
 /**
  * pci_p2pdma_map_type_tlp - Determine the mapping type for P2PDMA transfers
  * @provider: P2PDMA provider structure
diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
index dd17501ba1b6..ce389e18d023 100644
--- a/include/linux/pci-p2pdma.h
+++ b/include/linux/pci-p2pdma.h
@@ -82,6 +82,7 @@ struct scatterlist *pci_p2pmem_alloc_sgl(struct pci_dev *pdev,
 					 unsigned int *nents, u32 length);
 void pci_p2pmem_free_sgl(struct pci_dev *pdev, struct scatterlist *sgl);
 void pci_p2pmem_publish(struct pci_dev *pdev, bool publish);
+void pcim_p2pdma_set_ats_per_mapping(struct pci_dev *pdev);
 int pci_p2pdma_enable_store(const char *page, struct pci_dev **p2p_dev,
 			    bool *use_p2pdma);
 ssize_t pci_p2pdma_enable_show(char *page, struct pci_dev *p2p_dev,
@@ -138,6 +139,9 @@ static inline void pci_p2pmem_free_sgl(struct pci_dev *pdev,
 static inline void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
 {
 }
+static inline void pcim_p2pdma_set_ats_per_mapping(struct pci_dev *pdev)
+{
+}
 static inline int pci_p2pdma_enable_store(const char *page,
 		struct pci_dev **p2p_dev, bool *use_p2pdma)
 {

-- 
2.55.0

