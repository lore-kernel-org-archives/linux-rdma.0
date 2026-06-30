Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D713F8EDA;
	Tue, 30 Jun 2026 10:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782816762; cv=none; b=DN1+Vnak6qqr3h5WZ57yd3RaATDKJeN47G30XQzG5agw6Yav4rlQnHNTMHaIxU6jPdpsdXVUNy8jmtXNvAV/VE0enRf0vVUCmLPJBCECWBE09IVQjCRgawIPG/Ch/Wh6iYhFVTGx2IX7MYkh/6hCsaj+P9xz9zbmotDw1+GbsBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782816762; c=relaxed/simple;
	bh=Dz2agsNXnIpErK3hvQaWBKqYDMIOWWjir+TLa2waK/4=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Pylp80EqMXopxAvI+YZ5TP+Cx333nYC+ON92NDgr6U2zwQDIs4RdyWevK/+OGFY0AyMyiWS7pnbXJxeZglTAQeQDNXCksAg2LpsCA9rzS4QqjMFAtopjx58Z5NsHIOVMzydnERbVJF/7iMGl/vkHJo0QMqVguZjw/9JBi8LMzvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPi4dWR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPi4dWR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7591F000E9;
	Tue, 30 Jun 2026 10:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816754;
	bh=bOKPhFGTJ86jvnMjbZoaau33s5xEcyP30nMyJtIcVHs=;
	h=From:Subject:Date:To:Cc;
	b=RPi4dWR9zUKEQydt7dzmtalQ9G2Qo4u61ROaqpb6uEkJf3XllkWPBqUMliGXBmE2L
	 4gsTOBDJIMG6l1eba9K0jJFPK4XrK7nK/KbqnMmAfKIxYCXe/L+PY5l/bvBaNcJjFL
	 4ZPhoMWoPDMuoG85vL+ZWHvxk5iV1drj4q4L8cLVvD2Axz8Zz0DHZgjWvHHlvyuDNc
	 sS12j+2D0qdswekgMN7G4tGFpbcv1bLQBqzqVHiL9HtoHMBWx2Nc6MHU9h2DXOlYpn
	 Bv/xUt7/auFMKLMf+xMpPemJlGgx/C/ALBh+7Uq50twF4L8UmnuuSWdo0KgXTHZcoL
	 I1YuzYeS0HPOQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/5] RDMA, IB: replace __get_free_pages() with kmalloc()
Date: Tue, 30 Jun 2026 13:52:28 +0300
Message-Id: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOyfQ2oC/yXMwQrCMBAE0F8pe3YhWdKA/op4SNKtXcEouypC6
 b+b1OMbZmYFYxU2OA0rKH/E5FEb/GGAsqR6ZZSpGchRdNE7zAF1uicMIdJ4JJrZR2jtp/Is3/3
 pfPnb3vnG5dXnvZGTMWZNtSw96oRt+wHDOMXHggAAAA==
X-Change-ID: 20260610-b4-rdma-44625922fe16
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/rdma

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/ 

---
Mike Rapoport (Microsoft) (5):
      RDMA/umem: ib_umem_get(): use kmalloc() to allocate page array
      RDMA/mlx5: replace __get_free_page() with kmalloc()
      IB/mthca: mthca_reg_user_mr(): use kmalloc() to allocate addresses array
      IB/mthca: allocate mthca_array memory with kzalloc()
      IB/rdmavt: use kzalloc() to allocate QPN-map pages

 drivers/infiniband/core/umem.c                | 4 ++--
 drivers/infiniband/hw/mlx5/odp.c              | 5 +++--
 drivers/infiniband/hw/mthca/mthca_allocator.c | 6 +++---
 drivers/infiniband/hw/mthca/mthca_provider.c  | 4 ++--
 drivers/infiniband/sw/rdmavt/qp.c             | 8 ++++----
 5 files changed, 14 insertions(+), 13 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260610-b4-rdma-44625922fe16

Best regards,
--  
Sincerely yours,
Mike.

