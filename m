Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873206;
	b=Vyd5YzPwUTL/z+TOEb8WguhHuxr3+TzxTQvvt9g+4WUDDDAstcj5ONx1KCSZ1fwSO/wI
	 kk30xlkzAqeeOw7FtpPGlw71LGTd/2F5VW29E1XReJuvXb73NLX94Zd19DPBBePuiCbtP
	 emCOxX2ZEhAT21P03Tgn8eiQVXuJkI06x3KQAXo+SkyiffaxC4Dy0lVGL2WeA6HETOFIc
	 qCLcxYFdKvRyr9LApADmNd6CvfM/dSvFxZ86g0FFb62vVfhsUSoWMIN220h5LFONBbjFV
	 VI+ikVtn4IRIqITJE62Yd9aShhvKAcQSGBIakWVtq+DXKwYe0e1CQbUVtDMk61uLzlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=pFoJauY+ge8oZt6IncAYryNUK0J2lM4fu9aSr026sNo=;
	b=bOSApXZRehNq3maqb/p9FI0vqCumQFr9P81MQeE04HQWKxT+l1g2aATbA9SaLYIzhj09
	 rVl0blLYTnEgHVZiPplT2wf7mQmXXmgJhSuULpMf67VFtLM7GyxPJsKB/xllH1ggKkL2N
	 GoqjQGvT7rWIwz2RL9JMS4HY+SyjsaOPiubMQmoCcfb+j7YV2AHbj2hEEA9Hjm0tjZYOA
	 ZXHUQAyBSav/CqdKh8N0fyXUy/PpD2zZwzb9RYxQYmjiIF8w8/27qECFXmHIwbFSqr9RX
	 Att+ZV9YSPdDGOTouFAn7y8cXmhoWJ3a4ve5OQaPFyWzmvjZDFkSZ5sRp8SGnUPZUgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZjZn38Vw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1774606AA58;
	Thu,  5 Nov 2026 10:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZjZn38Vw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57EE1F000C1;
	Thu,  5 Nov 2026 10:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873206;
	bh=pFoJauY+ge8oZt6IncAYryNUK0J2lM4fu9aSr026sNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjZn38VwsrwMZXJLV5x34Lok+FZ+yf4xp9O8BDRyvQLc0yF7Dx2hLMrrUFBmi8OGu
	 bdKwA6sHymWKFFrb58oZ/9pR8zW6+O1V59ZLUGiOzg6uwKgirzFZLhImDV0vEIKxuW
	 JiXeyQ83LdmTcpE+R9mRW6z0ci0n4Jz4qBF/PLZb/LAa9kUQU7vnsVDfbqsHT2z4VE
	 bhBgSPKg8t56tejL4KDbjWWqrp8yK3qbHjf7vg2le90AcA5gh2d6W+tTC9qr6nIQtv
	 BxxnseASJx7NULJXqyBicgkFsRNlH7M32fit4MsFrUwwuoTNLbAw5U1q75BpH2n6KN
	 W8J6OQuDtNqQA==
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
Subject: [PATCH v13 17/19] PCI/P2PDMA: Let a client declare that it selects ATS per mapping
Date: Thu,  5 Nov 2026 12:04:48 +0200
Message-ID: <20261105-fix-p2p-acs-v4-0-v13-17-3dd065907c3b@nvidia.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
References: <20261105-fix-p2p-acs-v4-0-v13-0-3dd065907c3b@nvidia.com>
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
index 9b35aabbfa157..df66aa056dec8 100644
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
@@ -1769,6 +1770,35 @@ void pci_p2pmem_publish(struct pci_dev *pdev, bool publish)
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
index dd17501ba1b6e..ce389e18d0239 100644
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
2.56.0

