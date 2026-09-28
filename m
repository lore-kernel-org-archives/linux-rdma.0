Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDAC4AEBED;
	Mon, 28 Sep 2026 11:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790594445; cv=none; b=ZnCiEKMf7pMRiiwQKmrk/9jIHAiHlA/woQOgvweOQpmotDofhQXFvxjnbiDaqHn2WBOpXvvcicJEtplj0rNGGqUVzRZz6nrUjCTWStphS4G2PJsYScVUPyd2rcpuQpXZdm9CwyJ7s1ikcmROTHDHLZKuUQOva4gRDEDpYjSK2wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790594445; c=relaxed/simple;
	bh=riGlHG++DL8f0DnvaJ2KRuj/96+VOlrVeHQ7nm4g8CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N2Smcq9dZHPEQYAB1fueoGTv4CWVUODEFqUVvjEn09N0ACjFidwydm2phtWz/NuCzT8/kSyAT8EF47GmZam2/NSfwjgnI8zvbT1kzuCfzk82C6OmGCRl1wwWCaN0FDI/DHdT332EXxGF+Vbjwt3d/pVt782/uia8dI4PJhfMcuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jb1HoBXF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jb1HoBXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD391F00893;
	Mon, 28 Sep 2026 11:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790594443;
	bh=s9hM+k8hMa1R4u6jdfPzKiE4L3rfw69xZAFpd6/U+Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jb1HoBXFJMB3IDbe4GhY8nB1F9W1moE7kNm4uW2GfyIqc1wE/ZP9i06nmcYMHHGI4
	 u/5vcWWU1fNfGjj28ZdnylJu+sW01UJPi8sVxdSMUPTzbFAX/UkhnGvSBytmAd42eR
	 ZDXiZHSY9B4LtILRVn6DGYrjOU/4IbMCxv+ML7cqwG7Fc4gPGUnAsXBWfIpLkdbTa8
	 dgb6s50YZCpxnma5IgrgdxuITz8c8ecCzZbGbsODwqR+gMb99ykg8COeeZU+Z9lJco
	 JTC2RXnikcG9TqNjxyvFaWFwyaaf3K6i22rwwZrmUoMNI1Bg82EWUk9FYpqJD8R2y6
	 ZEkg3PQmxaiqA==
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
Subject: [PATCH v8 18/23] RDMA/uverbs: Hand out the P2PDMA provider behind a dma-buf
Date: Mon, 28 Sep 2026 14:19:22 +0300
Message-ID: <20260928-fix-p2p-acs-v4-0-v8-18-404453b9c435@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
References: <20260928-fix-p2p-acs-v4-0-v8-0-404453b9c435@nvidia.com>
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

An importer attached to a uverbs dma-buf cannot tell whether its
peer-to-peer traffic would reach the exported memory directly, because the
&struct p2pdma_provider describing it stays in ib_uverbs_dmabuf_file.

Implement @p2pdma_provider so dma_buf_p2pdma_map_type() can reach it, and
refuse once the buffer is revoked and the memory it described is gone.

Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/uverbs_std_types_dmabuf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_std_types_dmabuf.c b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
index 2411ebee69e2..5a6a1ee430a7 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmabuf.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmabuf.c
@@ -76,6 +76,17 @@ static void uverbs_dmabuf_release(struct dma_buf *dmabuf)
 	uverbs_uobject_release(&priv->uobj);
 }
 
+static struct p2pdma_provider *
+uverbs_dmabuf_provider(struct dma_buf *dmabuf)
+{
+	struct ib_uverbs_dmabuf_file *priv = dmabuf->priv;
+
+	if (priv->revoked)
+		return NULL;
+
+	return priv->provider;
+}
+
 static const struct dma_buf_ops uverbs_dmabuf_ops = {
 	.attach = uverbs_dmabuf_attach,
 	.map_dma_buf = uverbs_dmabuf_map,
@@ -83,6 +94,7 @@ static const struct dma_buf_ops uverbs_dmabuf_ops = {
 	.pin = uverbs_dmabuf_pin,
 	.unpin = uverbs_dmabuf_unpin,
 	.release = uverbs_dmabuf_release,
+	.p2pdma_provider = uverbs_dmabuf_provider,
 };
 
 static int UVERBS_HANDLER(UVERBS_METHOD_DMABUF_ALLOC)(

-- 
2.55.0

