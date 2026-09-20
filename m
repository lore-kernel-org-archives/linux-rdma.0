Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF61C42E401;
	Sun, 20 Sep 2026 11:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904577; cv=none; b=D25FMImkP2QeSMAMFIC2/RlO3LSXIKUrdydFQ/ULGc7hmy9gElzZ3TE5Pr56k8kVvcHipWBc2Hti70rhdHDbUbm+Z7xLjMowbhMKXAzYBU7VyLYr9qsnJ1cNVsGZ2fy4WUqaeMt1CmPn/UB0x7oZCWSzrtLa1MMDaf3Isbz1/Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904577; c=relaxed/simple;
	bh=riGlHG++DL8f0DnvaJ2KRuj/96+VOlrVeHQ7nm4g8CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lin2sbAfTYSzb8Y6/dtiEHE0RXTnvKNs7TtI2t4RpcWXaGADw9vQC/g2fCZF4K+OdwDlGjrMG21aAgyZPOSYN9g6g0qkEwJlsJlI7YyAgZv7yIdlmO3E++5MZ12CfmATEjYhNBj9Ac9tp4WQyiJ+nIslX9KZcxKmRNIrtJIyqEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PoGh9Arc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PoGh9Arc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CB01F00893;
	Sun, 20 Sep 2026 11:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904575;
	bh=s9hM+k8hMa1R4u6jdfPzKiE4L3rfw69xZAFpd6/U+Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PoGh9ArcYHh6zXNr/LygdppEE41Db17kxr5t8DdpKSiAmGcvrNfiIokCmXawiSfgM
	 Hku+cxQAisaRVymDGpXIo3meEk+bOR2g+Y8aLtNmYxus8IwnLKNDcdCfeOGfpUAhKb
	 qg3DXxavmZka1Wpk5hk3AzrKJd30UoX4QkJZaYjeiG7YyoC73R736Zf+VPco5sxyqZ
	 7yyzoTpNQaSFpcz9B8xtmt4zInIak96Jr+dPLsMf3PpVjYkdKBLbKPlS/ZSi2KdJmB
	 QwQiMhcXSYtwK3//ZBexba+fRUsUAsieD8tve6cl17Yql9bVvOorZZC4N0wazzUl1c
	 b1Nj4vFiXfdmQ==
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
Subject: [PATCH v7 18/19] RDMA/uverbs: Hand out the P2PDMA provider behind a dma-buf
Date: Sun, 20 Sep 2026 14:41:30 +0300
Message-ID: <20260920-fix-p2p-acs-v4-0-v7-18-ca0828ab697c@nvidia.com>
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

