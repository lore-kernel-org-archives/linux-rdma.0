Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694674;
	b=Hmw/Sk4hMD4AO6vikc7wz3kw6SzYnVsAn5k/EgEO0Z6HHEpoHQvhYBlcbZvDE3jn22Ey
	 Bss4uo4G7wt6ZV5uL0et4WG6gwiFx9sO/PXDmaeZPp/pNvsAG7tm3fBTo5U9/zmvpGXMa
	 9tchDDLJewxTEOv5E1Exy0a/pMEOwgabJ8iZRMQOjaZwopTnUflmHHg91JjDmyo3uRQSO
	 9qrxRrUAmMBPySEs9FedEf4dgCK+GPhzgFw7Av/EbqOqB2i7NB+CC0g3CPcdzsreMfoSd
	 i92MWbZKs+tojbGFa0fnU9UuCSjQKM06cw1RS9i+OG3xWiSpw1pfbfQtJdK9wiWwqhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-Mailer:
	 Content-Transfer-Encoding;
	bh=n410ETS7lVaZbhJ2PCDjAMJ1Xx97zul32vr6dhkh048=;
	b=4DlIYjrs9L4IptCmdxMh5r5ESqviNuZb5o2Y6+dNgyUXslRcTw+gN3haCgdVSwLntn35
	 1a9HhwFYt+Rr2Hhh7x1BsOWPU3CG1mjQuGAuzvxjhRgfWdKX4l/BXHHwRl5vTFFKSNp1v
	 gr0A3/aBrdyRlWkssoczBXg8XcyEnGju9o66w7Hqto9jixS9ToVxarVaJE0wBuG/F+7+O
	 BNbjtqhYVllW7IIsduW5l4k2VzlQIZ4PE9grBw+EBV1rDSZIHmK4d1e3ZZPY170GdKeiq
	 zQGRmtLxoT9c69sYQ1pIfBXPNeINTBgSuTx6N1qdWrZBI/dke3icXj5N0Kezc7B9N2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eLQ83BXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BFE606B6DE;
	Tue,  3 Nov 2026 08:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eLQ83BXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEFE1F000C1;
	Tue,  3 Nov 2026 08:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694674;
	bh=n410ETS7lVaZbhJ2PCDjAMJ1Xx97zul32vr6dhkh048=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLQ83BXMyfHTouTsfSD+kL5HE/Vtis8OXIxwfKk90CLPlhSJGyNgl80UJZkQA/wgC
	 L8KPro6pNM0C8WhbsGr6YRPd4DBhmPiilSjKPufnSBtvXiKnSZyUP5yKvn5QPgidOm
	 7eJDwOP9Yt+2hD9gtN7KCMlWVSgJ3WTDOvDLw2kc+lJIbq+ORmjY36secFYx8ApXes
	 76T6/d5AFpSaJcvs6CWiWoLnSgn+Wl3PHiyzMdj9BOUzDdQq37p7j7RAACBs6hQpGG
	 DHm40Ee716coVPkhiizq7lTmDLnH3y2ilG9Xl5H7CrqAk4mHwCELOF2HApJTLzZpKQ
	 4Ah6vQGTbooYw==
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
Subject: [PATCH v12 17/19] PCI/P2PDMA: Let a client declare that it selects ATS per mapping
Date: Tue,  3 Nov 2026 10:29:56 +0200
Message-ID: <20261103-fix-p2p-acs-v4-0-v12-17-912101f93517@nvidia.com>
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
2.56.0

