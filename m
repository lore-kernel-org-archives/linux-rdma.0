Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098E65187F2;
	Tue, 13 Oct 2026 14:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901611; cv=none; b=ZfGNX9RxW5dtxh40W1Lsd+ALeA/AVWnEx4p1+SRmxSZ4FOoJibFczGFNmYs9XD6IA7oNkayY1/GpqItBtC9cej55ggM3aXAXS2b4Tg9owi1mZ1Dlhs36oh5yTCvDOrjlBEhr0OkAbhXRgdi82hWqav2TOq1zwhKoxHQQR2t24FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901611; c=relaxed/simple;
	bh=Zm7YvLjSd928d55gJQhk1qII9rpJSTPjLjNHslHAa1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LLts/z5ZPXHPfrUbWZ0XktrzqA9oKSFf3ZEoRKlaqND7UX/mHiOakVQ57PsEGG5AsAkUnXedBJMxSEi+ecATYh4uJfy0ReFpoXk/ae5oUat/2AoHSYYcA8iN5LWYVmHrru2jnJMuRqkxJ26QGvo2W5Q1xFcwQbudh13auGcrAqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBufTWZr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBufTWZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13521F0089C;
	Tue, 13 Oct 2026 14:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901609;
	bh=G6+HXzTIsdMXUDkB87K1SqwkQ8xKxvMiZmAMjtsCQwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBufTWZrlibOe040ffQmM69yRylTDpkUoxGTJVtEhDmWx+4LCP+4Yg5ltBb7UcZTS
	 Jy08ZMZVYk/HkcG8EwYDtLR96JATNGtZZpfGT8k/eq/g6Jss6LO6fS0jkunGihzrFl
	 HyVvHTxNS+GNu7/xgJt58UjBFAexZ5+vzHL0VT+16bPvrkZnwFqyC46DfT5TIpoj8Q
	 /0T6YW2Z6b64iz/te9Uq+7qi8DZpE+EfQpxLeUl9WG2iLlAGl331JithROmKCSanW6
	 7bCXOPX7Ig1o/+DkQ8EEp0WYsH26NWoaU41xYFX4ASoL9HwVHZKuC7Tl/1kunRVSKl
	 qk+I1qbzogTPg==
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
Subject: [PATCH v11 17/19] PCI/P2PDMA: Let a client declare that it selects ATS per mapping
Date: Tue, 13 Oct 2026 17:25:25 +0300
Message-ID: <20261013-fix-p2p-acs-v4-0-v11-17-72cf8c96e617@nvidia.com>
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
 drivers/pci/p2pdma.c       | 30 ++++++++++++++++++++++++++++++
 include/linux/pci-p2pdma.h |  4 ++++
 2 files changed, 34 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 6a05a5019daf..144314ab5fae 100644
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
@@ -1750,6 +1751,35 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
+ *
+ * Call it once pcim_p2pdma_init() has succeeded. Without P2PDMA state the
+ * declaration is dropped and the ATS Enable bit keeps deciding.
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

