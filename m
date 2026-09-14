Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003AD466B63;
	Mon, 14 Sep 2026 11:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789385031; cv=none; b=DkBeFfp6MWUBMdlfikybyZGVrOJreZ37FRGi+k6oQFjmiiakq6wzuZ+blaNgySJAXbkcYoHHs5a5da9Q4XmVKO6aw/n7Z4vcpnK5TsjhHsYaslGev+pkJ0vYA/4bVsqsmkiGOM6MrK5NA1wuGmfJyOMRvf1IHTQrLpd7FY7GiV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789385031; c=relaxed/simple;
	bh=hvVwt6ohh/ZS5jfoRHiM6qKZdBfoz9Vd2295Ug5sbr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KciR0r9UOTm3rgR8m4UfNJ6Ww3p7+OhMDEYA/Qkefqd+TWWLU/jInhU302jbhCaoFiONHcZ0+VfjMjoGKlhLEZTr7cAu15idlfCwzyTzHWEyt0cdaEwfTpm8dlnAMFYfJfGqTJxPC97xVsYkBV7El9OpXHjSAVgBphjOqzGUvaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JYI+FvP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JYI+FvP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E031F00893;
	Mon, 14 Sep 2026 11:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789385029;
	bh=YtIACyToojkPPw7wMDUQ/Ckhd+O2kfDRIKTR1tO2oXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYI+FvP30YddKzsKXFEkFHc1ePvUyq/iYxSOGKSdqlJVyiDez1W95ECZQI+G6pIiv
	 vEVwty9vH1OjAPUN0xmkrgTI3i8JAz4aI5rM+A/TtRFyE7bSozbDcUtmwjnTzEP6Mq
	 K5KLqgOnCq4SRb2DxtXoVKY/F0U/KT0RK3KgQSEAT3n4SXk0Pr/8MdG1nFZvxw09AI
	 VEaTdsOOMcy5nUT13udy3uO3TxYuznibdwkPN/dNS1AC/Cvubp4jqublt/5js9Fbsk
	 cRkcdptXJ0bUrsmdQAy7k9Q5x1gWXqp2hyDt6dZeqLZbxpZ/yLN4fOp8OrZj0uAKBZ
	 6SG2Gf0ZBfQVg==
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
Subject: [PATCH v6 18/18] RDMA/mlx5: Ask P2PDMA whether ATS takes a direct peer-to-peer route
Date: Mon, 14 Sep 2026 14:22:51 +0300
Message-ID: <20260914-fix-p2p-acs-v4-0-v6-18-5ef07ec9ef06@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
References: <20260914-fix-p2p-acs-v4-0-v6-0-5ef07ec9ef06@nvidia.com>
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

mlx5_umem_needs_ats() enables ATS for any dma-buf whose caller asked for
Relaxed Ordering, on the assumption that a switch in the path has CR, RR
and DT all set. It also enables it for a buffer already mapped with the
peer's bus addresses, which are not translatable at all.

P2PDMA has read the ACS controls, so ask it through
dma_buf_p2pdma_map_type(): enable ATS only where the path is not routed
directly as it stands, but would be for a Translated Request whose
Completions carry Relaxed Ordering. Exporters that name no provider keep
the old assumption, since their ACS settings remain hidden.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 36 ++------------------------------
 drivers/infiniband/hw/mlx5/mr.c      | 40 ++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e9ddf2e97a76..ab32742b2180 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1646,40 +1646,8 @@ static inline bool rt_supported(int ts_cap)
 	       ts_cap == MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
 }
 
-/*
- * PCI Peer to Peer is a trainwreck. If no switch is present then things
- * sometimes work, depending on the pci_distance_p2p logic for excluding broken
- * root complexes. However if a switch is present in the path, then things get
- * really ugly depending on how the switch is setup. This table assumes that the
- * root complex is strict and is validating that all req/reps are matches
- * perfectly - so any scenario where it sees only half the transaction is a
- * failure.
- *
- * CR/RR/DT  ATS RO P2P
- * 00X       X   X  OK
- * 010       X   X  fails (request is routed to root but root never sees comp)
- * 011       0   X  fails (request is routed to root but root never sees comp)
- * 011       1   X  OK
- * 10X       X   1  OK
- * 101       X   0  fails (completion is routed to root but root didn't see req)
- * 110       X   0  SLOW
- * 111       0   0  SLOW
- * 111       1   0  fails (completion is routed to root but root didn't see req)
- * 111       1   1  OK
- *
- * Unfortunately we cannot reliably know if a switch is present or what the
- * CR/RR/DT ACS settings are, as in a VM that is all hidden. Assume that
- * CR/RR/DT is 111 if the ATS cap is enabled and follow the last three rows.
- *
- * For now assume if the umem is a dma_buf then it is P2P.
- */
-static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
-				       struct ib_umem *umem, int access_flags)
-{
-	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
-		return false;
-	return access_flags & IB_ACCESS_RELAXED_ORDERING;
-}
+bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev, struct ib_umem *umem,
+			 int access_flags);
 
 int set_roce_addr(struct mlx5_ib_dev *dev, u32 port_num,
 		  unsigned int index, const union ib_gid *gid,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 00e13028762a..286f372e5b0c 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -38,6 +38,7 @@
 #include <linux/export.h>
 #include <linux/delay.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-resv.h>
 #include <rdma/frmr_pools.h>
 #include <rdma/ib_umem_odp.h>
@@ -47,6 +48,45 @@
 #include "data_direct.h"
 #include "dmah.h"
 
+MODULE_IMPORT_NS("DMA_BUF");
+
+bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev, struct ib_umem *umem,
+			 int access_flags)
+{
+	struct dma_buf_attachment *attach;
+
+	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
+		return false;
+
+	/*
+	 * The Completer decides whether its Completions carry Relaxed
+	 * Ordering, and only a Request that asked for it can expect them to.
+	 */
+	if (!(access_flags & IB_ACCESS_RELAXED_ORDERING))
+		return false;
+
+	attach = to_ib_umem_dmabuf(umem)->attach;
+	switch (dma_buf_p2pdma_map_type(attach, 0)) {
+	case PCI_P2PDMA_MAP_NONE:
+		/* Nothing is known about the route, so fall back to the bet. */
+		return true;
+	case PCI_P2PDMA_MAP_BUS_ADDR:
+		/*
+		 * The path is routed directly already and is programmed with
+		 * the peer's bus addresses. Those are not translatable, so
+		 * ATS would be wrong as well as pointless.
+		 */
+		return false;
+	default:
+		break;
+	}
+
+	return dma_buf_p2pdma_map_type(attach,
+				       PCI_P2PDMA_TLP_TRANSLATED |
+					       PCI_P2PDMA_TLP_RELAXED_CPL) ==
+	       PCI_P2PDMA_MAP_BUS_ADDR;
+}
+
 static int mkey_max_umr_order(struct mlx5_ib_dev *dev)
 {
 	if (MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))

-- 
2.55.0

