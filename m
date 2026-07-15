Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F712931D7;
	Wed, 15 Jul 2026 11:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784113414; cv=none; b=NyW9PlSvMwjrtnxWIASWp10jy7r66KCbxHagRzUbptUq06K8Fmlk1LCIHKVHa74IrvEUyJMQLMTc9EhpaRkqBiYM5LdFAjEje8ShgHyKWSWdmA/s3ziiGpLkygVJ+QuakvLaW1JvyYwn8a1b+cmShVmwdWaH6LIc0gbyUDTnpk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784113414; c=relaxed/simple;
	bh=YVfNgKLJqLMc3cgYjhzOYCdFXrpn8ajwevb61bQVXV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OlbcZwYlAjbqzPrB7lHbWzUWPsCu55MotXXQjud82a7bgLc1CJ4JY63Gwbhrj2EHeuH8sNIizcxzyS5wQQofGR0VdRs08P/jk9SB2xq9240Yh+oY76dhzq9wzGfCyYgL2Q3M4eKmQZk4DOTDOjZrP/JODNgCsvfxnuCQTqGhp0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqO6427z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqO6427z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A87E1F000E9;
	Wed, 15 Jul 2026 11:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784113413;
	bh=oQkZyUXmELQN2zMIAqet4gZF6hrG+qrP9SS1Y/vJinM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqO6427zEcFyWwsUFlMdV3S0o5lVjm9vAF3xG7TLvhLLWDFNUNSq6w2EBONEpXOLf
	 cVGlXcbkwQRcqv+zduLbKKWuNayczM0a3JWCydjyAKsEU9ZKq4ZACGXLKr86BTLbyZ
	 tRWVDWbDfGIBoHQ85Mt48InzRsPJ/W7+jJGx7QSr3KMicxWg15fLsSbF+ITleEwmk4
	 9bfdDewy9LzQ1pRD47f3/iwy29ygICVDosMmGAKlvFgwOeEtU8+75tAfa1UiFEp0yj
	 GDPOyrwgJ0NGUnPPhFe3T+nQewzgmBqAlGxKmgoSwmq880hPbjQ1HQY56ykFeVbrPs
	 8yjRjn8MEdHWQ==
From: Leon Romanovsky <leon@kernel.org>
To: Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH rdma-next 2/4] RDMA/mlx4: use kzalloc() for the fast registration page list
Date: Wed, 15 Jul 2026 14:03:10 +0300
Message-ID: <20260715-get_pages-to-kmalloc-v1-2-b0b7fce288be@nvidia.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260715-get_pages-to-kmalloc-v1-0-b0b7fce288be@nvidia.com>
References: <20260715-get_pages-to-kmalloc-v1-0-b0b7fce288be@nvidia.com>
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

mlx4_alloc_priv_pages() allocates a zeroed, page-sized buffer for a
DMA-to-device page list. kmalloc() provides the required physical
contiguity, and a PAGE_SIZE allocation retains the alignment needed to
keep the list within one page.

Use kzalloc() for the buffer and kfree() on the error and teardown paths.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx4/mr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 761e2c05dd0f..a6b4abce1bfe 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -313,7 +313,7 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 				    MLX4_MR_PAGES_ALIGN);
 
 	/* Prevent cross page boundary allocation. */
-	mr->pages = (__be64 *)get_zeroed_page(GFP_KERNEL);
+	mr->pages = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!mr->pages)
 		return -ENOMEM;
 
@@ -328,7 +328,7 @@ mlx4_alloc_priv_pages(struct ib_device *device,
 	return 0;
 
 err:
-	free_page((unsigned long)mr->pages);
+	kfree(mr->pages);
 	return ret;
 }
 
@@ -340,7 +340,7 @@ mlx4_free_priv_pages(struct mlx4_ib_mr *mr)
 
 		dma_unmap_single(device->dev.parent, mr->page_map,
 				 mr->page_map_size, DMA_TO_DEVICE);
-		free_page((unsigned long)mr->pages);
+		kfree(mr->pages);
 		mr->pages = NULL;
 	}
 }

-- 
2.55.0

