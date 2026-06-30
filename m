Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B786403AF8;
	Tue, 30 Jun 2026 10:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816772; cv=none; b=lsV5+aMxFOUToS0FBfhfAUx87QwBOLqdnHftZuV4y3w4ya4tln7FGezVPfgRP3ybWFqxlYCQGlTvruguLtrQm1o4RBoey4NVvniRiyGrhKzYzTHnpsgAPdgX4lI86Ni9xEbe9WH1clF+iDfulqDg3oxSqp5UjsCAzjkfHHTlFiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816772; c=relaxed/simple;
	bh=ZnUyjYJQ9FcxnRevoO+HwNPLSapZWFHPNg2h7hIMPmE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rv76er3XnWC1QEBeElzkzy3GVcNfU8qyK3OAtLyUwFbowtSYyqZ4WpiyFIBlstseSL3iHUUe05XUQ87bepadEry541XqkQTRb3vPACx/8Q3drUjrQu3KcYLBRKQEIajHmZzia6RP3TFjDnkq6/gmfjwzuIbipwAWUupg5Kx8RZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oP5VcZqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oP5VcZqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0681B1F00AC4;
	Tue, 30 Jun 2026 10:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816762;
	bh=KFYeKargova8Ud8wjAeX+s1i+b6lKR01HyMHcvbV2VQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oP5VcZqfFAMLfd35gIGVu/nMyRSUEy2FwfsDttuu3hvj8BtJuooi/CAVb5JzT3eF7
	 CJ35cEKFH20+mfCwfndnINoNtkhHJOhoxPHwlzcYnpq50uN3pcoD8G1G8IQApZ16pv
	 2N+A/rV0PnhQPxlqI/7lM1HoSvoh5KXDyNSHwZDiMxOQykRhPaYnXQ10Yur0Mf62gg
	 goOiumuV0aAbJaQFfgU/x92qk1P6GXmNdRxwrHMeGJMBwJGcgDKtuv4nnmacq5KMuH
	 44RYqS6ok3IMYI9R5Ec5ZP+itiQEs+Fg+Q+T4kWQFcDrUs9e3dWfM4y7HU4xs/Zh5U
	 o35V6keGB7gMQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:52:32 +0300
Subject: [PATCH 4/5] IB/mthca: allocate mthca_array memory with kzalloc()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-rdma-v1-4-ab42bcf0de92@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
In-Reply-To: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2

mthca_array is essentially a sparse array of pointers and there is no
need to allocate its memory using page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/infiniband/hw/mthca/mthca_allocator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_allocator.c b/drivers/infiniband/hw/mthca/mthca_allocator.c
index dedc301235a0..117a070e784e 100644
--- a/drivers/infiniband/hw/mthca/mthca_allocator.c
+++ b/drivers/infiniband/hw/mthca/mthca_allocator.c
@@ -126,7 +126,7 @@ int mthca_array_set(struct mthca_array *array, int index, void *value)
 
 	/* Allocate with GFP_ATOMIC because we'll be called with locks held. */
 	if (!array->page_list[p].page)
-		array->page_list[p].page = (void **) get_zeroed_page(GFP_ATOMIC);
+		array->page_list[p].page = kzalloc(PAGE_SIZE, GFP_ATOMIC);
 
 	if (!array->page_list[p].page)
 		return -ENOMEM;
@@ -142,7 +142,7 @@ void mthca_array_clear(struct mthca_array *array, int index)
 	int p = (index * sizeof (void *)) >> PAGE_SHIFT;
 
 	if (--array->page_list[p].used == 0) {
-		free_page((unsigned long) array->page_list[p].page);
+		kfree(array->page_list[p].page);
 		array->page_list[p].page = NULL;
 	} else
 		array->page_list[p].page[index & MTHCA_ARRAY_MASK] = NULL;
@@ -174,7 +174,7 @@ void mthca_array_cleanup(struct mthca_array *array, int nent)
 	int i;
 
 	for (i = 0; i < (nent * sizeof (void *) + PAGE_SIZE - 1) / PAGE_SIZE; ++i)
-		free_page((unsigned long) array->page_list[i].page);
+		kfree(array->page_list[i].page);
 
 	kfree(array->page_list);
 }

-- 
2.53.0

