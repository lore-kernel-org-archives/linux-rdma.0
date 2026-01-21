Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BE848C8D3;
	Wed, 21 Jan 2026 12:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769000399; cv=none; b=ikOiTfi3flte0xWazekIBcCeBjZuz1jYAooB0GQTa27DQWdCSlpFHyRGkOaydnJP/XWN8Zax8oWMeushVuniLaxfxBWE7xDm5PLBwRyK2VWpprAPwvGO0ITl52MdZW5UvOVggtykbhYxb5+xxpK4XhWRTpllD+KGmwzq/X1yeH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769000399; c=relaxed/simple;
	bh=vLjazFYFrcdZwtehxf7gnTv1xyibOoNdpX1K34q0p3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MiYWRTximsmzpQ+86lGtKnmuepote0W+QgiLul6g6+i6EWSSz3RYdioKrUVFCiNNqvueBpQuF/OBDSEWbVy+oBHBn3r8WMr8OsjreIW4py0I3JehbPzX9vk6hrKc6In65ITJ9BmgVXqcZWmWS9C0B0ndsPpzrd657fkGStsAcOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NA7uryHE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NA7uryHE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB17C19424;
	Wed, 21 Jan 2026 12:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769000398;
	bh=vLjazFYFrcdZwtehxf7gnTv1xyibOoNdpX1K34q0p3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NA7uryHE9iDwVHrzumlE7t+lD0n+J50JcM2WsmP8rdBM5V740UnFfQSpZd3zEgQlO
	 3KuJZ6ov0sgy0kSEri4J3GcU92CTaacv1iawToZP3zTfDkLPoCbRlTEsUsBEe52rEc
	 H47Ac15N2NaKplHUwls8z7+InCqBENsxsXQF8/RCGnFXRTDFrKhCbgA2GMXnHQyxSU
	 LyMRfAJwBN8olNZH3eI4jquRR8lckL3LXaGHHC4SUsFUZT5VjOEGNCySBpArnoBXn3
	 rVWTFBcdxQK1AlCtQ3m2cgXv4OCxHy8eDXYIXsRQUkN7bFS8HznJU9Rs3eJu7usZDz
	 eXLD+zUaulSww==
From: Leon Romanovsky <leon@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v4 8/8] vfio: Validate dma-buf revocation semantics
Date: Wed, 21 Jan 2026 14:59:16 +0200
Message-ID: <20260121-dmabuf-revoke-v4-8-d311cbc8633d@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121-dmabuf-revoke-v4-0-d311cbc8633d@nvidia.com>
References: <20260121-dmabuf-revoke-v4-0-d311cbc8633d@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

Use the new dma_buf_attach_revocable() helper to restrict attachments to
importers that support mapping invalidation.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index 5fceefc40e27..85056a5a3faf 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -31,6 +31,9 @@ static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
 	if (priv->revoked)
 		return -ENODEV;
 
+	if (!dma_buf_attach_revocable(attachment))
+		return -EOPNOTSUPP;
+
 	return 0;
 }
 

-- 
2.52.0

