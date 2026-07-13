Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E707381AE2;
	Mon, 13 Jul 2026 07:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783927056; cv=none; b=ifPkwdZ/3/cs3/rZy0g1GVQANxFoQ+3oVni+b4AMt22pNYY7zhnp/2adGptH54Uf1k3hTwyfCr432S/VsjeOm3KJ041cZZQoovT6jl2xUAh8DTE9KNoiCXf+7hY7F9yAUY7iAp/KeMPbl3xNEe6tOsQ9w2oiePzHwql5UT6zXUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783927056; c=relaxed/simple;
	bh=ZnUyjYJQ9FcxnRevoO+HwNPLSapZWFHPNg2h7hIMPmE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WzGAd7KNZsTC3DMb1ZUd5PyLSOLfgk8Myv7SFswBHbMFvCHlS2GV/BjO7/AJXFTV/eKDCWl4QwlGb2+GPudMvIxlJtyUqPrzqj/G8jOib/02r2tpDxe0IzpNazdUbihaJ9aIZAM4MlxITh3fvcRLRTVInLCOJQ825/509KmRNBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IEu/n99Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IEu/n99Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64671F00A3D;
	Mon, 13 Jul 2026 07:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783927055;
	bh=KFYeKargova8Ud8wjAeX+s1i+b6lKR01HyMHcvbV2VQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IEu/n99QuYXkErMNPS34wGG3wPAoz82f+IKjx411LSqg1hg5PAvx1ZTiomc+LcMEa
	 0mLgjz4z8EU3xipYaZCuZ7XzAsbHNzfCpwM9Y9UA/WuFfE/uemo+5ng3eVB31CHKPE
	 INQF5CBkEc0Sqq/F/wtcEU3xoJp5eCIypyNFGX0u+b2QPeBVQ1pttYlvIMwS5cz3DP
	 0A7IEOLI6EfULdREoJj4q33cmplEHixakuAkPYaRsrViOhQxf99BE+Y1NFufAZQAfI
	 NjldmWm1CyhuI4njvRw1N1JSf9S8OcrwlTcqcoO+XkiksVyvUi7zuykHoajCIvxTBJ
	 8UXFi9SMQftrw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 13 Jul 2026 10:17:25 +0300
Subject: [PATCH v2 4/5] IB/mthca: allocate mthca_array memory with
 kzalloc()
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-b4-rdma-v2-4-65d2a1a5180c@kernel.org>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
In-Reply-To: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.16-dev

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

