Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3FC2931D7;
	Wed, 15 Jul 2026 11:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784113404; cv=none; b=gZL7g4KcnqLRjofq9oYXZr6N62g8Rin3OUg74MPZc7yJhp/MlLdnj8PgKR3ogo3/3NkptZ+2P2HBjvxCPUmBtoz6oFzDzz3L283KYkK/9iuL3wIf8wXMG/5AyPZZpmq033/Q+VdWT8W/rWhfflv2Acxj1iVwdIxBzbrnxKk/cAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784113404; c=relaxed/simple;
	bh=/BdL2GdqmmuQJc6XwqHfslwjJuI/zwzwUFcf5QOwiA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Wesg/k9bsV2852YkBWTJNCR4JwCHzlJUjL6v1M+nY9942eNhrmNPrTMBwxmnPbi4fIXQvuwahsMBsRKg/TZzggw5KKUW/XD1aFgZCzbQ7V9ZML4CAWbYGm6/ArIMPDCxg4YANGfwVQSYRHetPMEiHk3gb1U3jQReQcMz/LmsYvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZT3NwXFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZT3NwXFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898911F000E9;
	Wed, 15 Jul 2026 11:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784113402;
	bh=DUu0AwG90AaRxrH2GEjGVf9+wVO5GoWg2E/q2g7TGv4=;
	h=From:To:Cc:Subject:Date;
	b=ZT3NwXFhfc34+ushvad6IE3yVD/l4ytXkwcLI3uxwB3Rp1oJQyUoIiOcBFLo2qzjg
	 GJUZOyBB0iISiEAqPrCN/OPc0J6sLZq/N/QgZ4WHBQ339VePOoGng2KyE7ynJlQt65
	 fHosFDYOco1JOTAJiyjBhwdYcgoPGP1VN9P5s0tV9Xwy/XVaqPmxD3nNat6zkB6/AC
	 XdqupT5J7tqneJjWdgB5NyvG1Ir08PiiAKLFC0K7Jp6Z6sgNUVf2F9KtSmlX2O7L1X
	 4+8s4sekleGVQdWx4Wks2gGu/aIbB7oIqwKwGmshBj1Zoh8AxYNHND6N52KoF35rMp
	 g/2H+aV9skjnA==
From: Leon Romanovsky <leon@kernel.org>
To: Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH rdma-next 0/4] RDMA: use kmalloc() for remaining scratch buffers
Date: Wed, 15 Jul 2026 14:03:08 +0300
Message-ID: <20260715-get_pages-to-kmalloc-v1-0-b0b7fce288be@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260715-get_pages-to-kmalloc-fff6f623114e
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

The series [PATCH v2 0/5] RDMA, IB: replace __get_free_pages() with
kmalloc() [1] replaced direct page allocator use in RDMA buffers that
have no page-specific requirements. Continue that cleanup for the remaining
scratch buffers in cxgb4, mlx4, usnic and mlx5.

Use kmalloc() or kzalloc() to retain the existing physically contiguous
storage and alignment while avoiding casts and allowing kfree() to derive
the allocation size. The mlx5 patch converts every allocation tier in the
shared UMR buffer allocator so its cleanup path does not mix allocator
families.

Allocations in qedr, cxgb4 and bnxt_re that back userspace mappings are
intentionally unchanged. Those buffers are passed to vm_insert_page() or
io_remap_pfn_range() and must remain individual page allocations rather
than slab pages.

[1] https://lore.kernel.org/all/20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org/

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (4):
      RDMA/cxgb4: use kmalloc() for the PBL address array
      RDMA/mlx4: use kzalloc() for the fast registration page list
      RDMA/usnic: use kmalloc() for the page pointer array
      RDMA/mlx5: use kmalloc() for UMR translation buffers

 drivers/infiniband/hw/cxgb4/mem.c        |  4 ++--
 drivers/infiniband/hw/mlx4/mr.c          |  6 +++---
 drivers/infiniband/hw/mlx5/main.c        |  8 ++++----
 drivers/infiniband/hw/mlx5/umr.c         | 11 +++++------
 drivers/infiniband/hw/usnic/usnic_uiom.c |  4 ++--
 5 files changed, 16 insertions(+), 17 deletions(-)
---
base-commit: e952e079d226209a132110acc1de96a099701292
change-id: 20260715-get_pages-to-kmalloc-fff6f623114e

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>

