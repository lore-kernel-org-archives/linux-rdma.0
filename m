Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66270400E07;
	Tue, 30 Jun 2026 10:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816769; cv=none; b=ETEY9RKR0eDkVckGAcZsgAH+gMR/eVyMuwC3P6Vazsg77KuIv+ZPUiqkYA+0YwIW+Ks3wXMJrif+VQoY8Cxg21vOEj1lNaGkKvVkbpsoQ+bzUybe9cXqp8kvmpNeJ8189DAxcC0wPadN4ka0lR1NSfWe8osqk4PYq69R70xx7sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816769; c=relaxed/simple;
	bh=shpt6/cTKj/99YTx53y+Mhu8rD/9AbzfOYXD+kl8e14=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V5R6kiCXCR8NlwjGz3QsyRLD0hbbqhVgvt8xsOfFJBTnH4VvrfG2DmWte3hgFi0TRjVOONtgXroaGrSn2WfKtfio7RK/qA4xVW3CgoJMDA9BIcCLEsVX2QGWwOwAc8pkbUp6k5sX3jgH1l/AQD7IBvRwTHleKQ9K/QBo1UMSS+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxSlKD39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxSlKD39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE1A1F00A3F;
	Tue, 30 Jun 2026 10:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816760;
	bh=4RsrgcGBsOocoT8tD9/brmr55eMYBlG6KCg/uQd4DZI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AxSlKD39eppqJHEQZDH8Ay4tZe39eWqVTaZVmQ7D+WJw8hWauXvb7MjGsNr/KN/CV
	 LJJ2WxIOPcUsmXkCT0m/WadzImliOlZhpjPxCN5qzecdmHhkqirMmYnuNR2zZ6xdN4
	 r7thb9ICG70yh+wYCfxOA2BoNeGGbWuIgZ4EGEIjQlZ4nFULkJGetaz4EDZhdfN9zA
	 h6016i9DNBmU0yzHzlEXLOTsTGr6ELbQAvIXy0IwX/aInTafCpQiQ7g20FuNYlQP4O
	 bLeR00u2nZdqj083gUvTunhc6zwvQ1D/C0a/mzugRm4r/PEqyBaQApbqK+L6ksTX4Y
	 O3vAn/gpXMezQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:52:31 +0300
Subject: [PATCH 3/5] IB/mthca: mthca_reg_user_mr(): use kmalloc() to
 allocate addresses array
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-rdma-v1-3-ab42bcf0de92@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
In-Reply-To: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2

mthca_reg_user_mr() allocates an array of DMA addresses during memory
registration.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/infiniband/hw/mthca/mthca_provider.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index f90f67afc8fa..c9ec9ca0aaa6 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -895,7 +895,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err_umem;
 	}
 
-	pages = (u64 *) __get_free_page(GFP_KERNEL);
+	pages = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!pages) {
 		err = -ENOMEM;
 		goto err_mtt;
@@ -924,7 +924,7 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	if (i)
 		err = mthca_write_mtt(dev, mr->mtt, n, pages, i);
 mtt_done:
-	free_page((unsigned long) pages);
+	kfree(pages);
 	if (err)
 		goto err_mtt;
 

-- 
2.53.0

