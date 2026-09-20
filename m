Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65D2429CE8;
	Sun, 20 Sep 2026 11:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789904564; cv=none; b=kSSTXJVa5fOmP2SxEvbra/6V8ahgBHlw0CNnxSf6TyT4I3MkJyv3S72zUdqU649qF8+Zs22xClzcoq+/JUF/aesApC1cKYE9UIl1ueyRFpvJSNkBdxYe8O7GH9gCa6efsgpz6D5DTYkIDBTT6W+bdmYhvOIEq7HNst7Oe8f/dgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789904564; c=relaxed/simple;
	bh=9nyRnvU6J7pEfh0z00W+k9FTcBVUtgjZMQHncga3XKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bf0Jrw4reMCEhfob/dQh9U0uV+rr4BJGxSCOpGkUS3Ps9VBKvsbcV973Nzc6js5haZQQn90xoPc8FpHiDIs/F+CjUbw7xv37GZupqA2wnGv1KRV/zEIZhvk5pluK+OweH9XAkr2ZOC2ZAUFuzlQYtfLJFmrpwTbwNdACxC/BJUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmECX4xV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmECX4xV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76BF1F00893;
	Sun, 20 Sep 2026 11:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789904563;
	bh=t1H31gQ69jwsTpe9r7dwRHyKnqahuj4ZFf+u0ryjpAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmECX4xVTgfhT7yMC/bO+XsW9AG8LPp/Zij4xq0iFO1Gb0jJCf/csNxVd/rOY1l5Z
	 LJVQUqS9Naolc/dmgm/F5IMMMWB8S8IaOz0REEocxdvsAVD4LGWtgg+z6+lQMPrDD7
	 WJFMQKJWLDBnRAJ11bmJ7h/nU5RaO08KV9QawRAdLGJO3t723JFNotl+RHYZrcUeEx
	 QZWUE2EjANGQorkQxUgi5bx8GzIRyJ5QlsnI/SZRcKjATpZ3psNxpHrAkN1AqETKC5
	 2++pVebYJuSklL0u6YuTlmvYfZ0/BEpoqMmmS1qVmpdI0FnJ5wxRAuKWB+ttIC94Ym
	 PEduFrM2Ja1EQ==
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
Subject: [PATCH v7 17/19] vfio/pci: Hand out the P2PDMA provider behind a dma-buf
Date: Sun, 20 Sep 2026 14:41:29 +0300
Message-ID: <20260920-fix-p2p-acs-v4-0-v7-17-ca0828ab697c@nvidia.com>
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

An importer attached to a VFIO dma-buf cannot tell whether its peer-to-peer
traffic would reach the exported BAR directly, because the
&struct p2pdma_provider describing it stays in vfio_pci_dma_buf.

Implement @p2pdma_provider so dma_buf_p2pdma_map_type() can reach it.
Refuse once the buffer is revoked: vfio_pci_dma_buf_cleanup() revokes
before it drops the device registration that keeps the provider allocated,
so a revoked buffer has nothing left to describe.

Tested-by: Tushar Dave <tdave@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index c16f460c01d6..fcf392cfc3c5 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -99,11 +99,23 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmabuf)
 	kfree(priv);
 }
 
+static struct p2pdma_provider *
+vfio_pci_dma_buf_provider(struct dma_buf *dmabuf)
+{
+	struct vfio_pci_dma_buf *priv = dmabuf->priv;
+
+	if (priv->revoked)
+		return NULL;
+
+	return priv->provider;
+}
+
 static const struct dma_buf_ops vfio_pci_dmabuf_ops = {
 	.attach = vfio_pci_dma_buf_attach,
 	.map_dma_buf = vfio_pci_dma_buf_map,
 	.unmap_dma_buf = vfio_pci_dma_buf_unmap,
 	.release = vfio_pci_dma_buf_release,
+	.p2pdma_provider = vfio_pci_dma_buf_provider,
 };
 
 /*

-- 
2.55.0

