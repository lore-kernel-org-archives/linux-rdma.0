Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328344B0E48;
	Mon, 28 Sep 2026 11:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790594454; cv=none; b=ti2T1fQeLuqTCePHi2QLjGrcElhh0AuMnNGf1DAOcK8bDjG2pdrumn+OaBCmX6BYxgyZjLwK+Sjb9VEOR6R7g1iacfYgcXOpeinO2q7tTlF10iRWpICRNobFg5N2dj4hByfThQdRkdOtDvjG6ThFm1AH57wnkKzOib4YlJGcA4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790594454; c=relaxed/simple;
	bh=9nyRnvU6J7pEfh0z00W+k9FTcBVUtgjZMQHncga3XKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZBifgfSoO1D2QEn9nmulGg1WtyJmUZyv3M8cygf5pMSw/m2AR/hdUUfsxrjjF12jcfY3zp5vNdq/pt807awrSK0V6ldxwhRi/BZdlaGuCKab/jD4nOvDGUycbvHkx8mc0LbYuz9WbAbQBlqJ8MvX6NOGuwrEGTHwmn3N9CqWG8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7lxGuC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7lxGuC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B931F00898;
	Mon, 28 Sep 2026 11:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790594453;
	bh=t1H31gQ69jwsTpe9r7dwRHyKnqahuj4ZFf+u0ryjpAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7lxGuC+YqGN6KtwPZTY/sQaX7LKhD93hWAwf0s8AGgN7q0xRXVIM7HuJWCiIcuqM
	 9YkDBG4qUZEjW0VZLLerb6R4HfN3MjQYdrbyZX2BdwugLub8PV7rJMQwtW4Sij+EuV
	 6olEKKL8WCKtQBWWp7zaY+WE3HvZ9lIt2jisHI4w9c7G9rMWDRFJi/jLcdAFxr2nbx
	 ejNGDVnQNrH0ddHt4Ve6+Bx8xXRhQZ4Th77Rpqmb47igDjtv8Xq2Q14EFik0EfK3uB
	 LT/P19JdoiP7+ic92LdMcCLHtMaPFd9wzDz74bz4hSY9PtZKE3OtQ3byTVJVhpZgDE
	 pAKypZNxBClUw==
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
Subject: [PATCH v8 17/23] vfio/pci: Hand out the P2PDMA provider behind a dma-buf
Date: Mon, 28 Sep 2026 14:19:21 +0300
Message-ID: <20260928-fix-p2p-acs-v4-0-v8-17-404453b9c435@nvidia.com>
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

