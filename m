Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0436138C41B;
	Tue, 30 Jun 2026 10:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816764; cv=none; b=srhtAcshrOQUySXEN7C/YC2bXHenKwvvgHh/0DDtPolwSi14muF29fE4TOYzTyvp6RfCK+k1TxCcyUCO1fcKAXP7wFWOcGC6N5KBllx3mxwaYksNFmXfjGBqqdkXtNkYC46HIneIUrWtrvYQZV7svgjQ4G7E9RLtKUqID/KpY6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816764; c=relaxed/simple;
	bh=HMFf+FOxgexw9evQqbH3lMXr0udh1c1zHa40kS0eSO8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JDSNgnDDjvePQ82VTdkuZ9oOwtIVo4UND/uJOJdnDoCgwxnZQNRr16y3HLSI1NyT9GnDyuqSA0wBDFCgI1CoLvVd8nTEXAt+ZQqz5SF0ybE350cpG0zUtqG3E2Jf18FtuUeLX5R6rea6J6CPdnvXOCEkiTSiWtf8gn2FY+wml2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M3BTn0r4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M3BTn0r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1891F00A3A;
	Tue, 30 Jun 2026 10:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816756;
	bh=RgvAPeibeFQxp8pOU9O5j9nPVFhn3WJwFhauJ32wTvY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M3BTn0r4NqPQw3QUITJfljAld7kLxy1+/Qd1XPHB/Ud0Lg5c2vBkpXMAm8+VLxt6z
	 IOUy+k5i3XRwFPP0UVKOblQHyU41gg3SPV/7gGa+CUzcA8KBYg6jyfklZCy2Vh8U1/
	 wg0IRuZzXv+7muzS1ObXYiteA8vilrXM0lpE+Yqg9pZLGmvFO/p77tOu2U/hLmf1V9
	 DKYHK/QMrc/GSlBd6DfNpJit+3y125TPx0r/zLn5nKYlXpVrVWbUnIYYkEpmFaxZNR
	 bRv8DBb/NUhsPQDRZPbjRXLL9EdGIUjv/SJ8/VxcRsXq7DL2E3hoggvLeuS1YKUsEi
	 kQbDKNhNge/mQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:52:29 +0300
Subject: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
In-Reply-To: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2

ib_umem_get() allocates an array of pointers to struct page for
pin_user_pages_fast() calls during memory registration.

This array can be allocated with kmalloc() as there's nothing special
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
 drivers/infiniband/core/umem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 73498723a5d5..5c42497f32e2 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -209,7 +209,7 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 
 	mmgrab(mm);
 
-	page_list = (struct page **) __get_free_page(GFP_KERNEL);
+	page_list = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page_list) {
 		ret = -ENOMEM;
 		goto umem_kfree;
@@ -269,7 +269,7 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 	__ib_umem_release(device, umem, 0);
 	atomic64_sub(ib_umem_num_pages(umem), &mm->pinned_vm);
 out:
-	free_page((unsigned long) page_list);
+	kfree(page_list);
 umem_kfree:
 	if (ret) {
 		mmdrop(umem->owning_mm);

-- 
2.53.0

