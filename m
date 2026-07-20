Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6227433036
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784560004; cv=none; b=BituOpUH0t/HHEtC1WCDAhCH2GN5HmLeige6WHqtZaoIVxsELU2tI8Jk6DEBqcFj/V5Qd5JVBN7oSRNXZJjP4/T5KivBgCwMRmwDPvNPctXAsk0cN2WUX+fjGH2bFS2ADNuwFPRyCcoF+F6R91btVemttPodbLaNeTJI5ohqQfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784560004; c=relaxed/simple;
	bh=lvGGPxUg6qqnndxGA/aNFDaANt0aJQwgdyiaT7mGbqM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aHwkmLv3NMnsbw5YGhsLtGCz+XdPw8GrvkPaVf/RxpPH1QGUUNhllJDNx1gQPxUhgYrg8o0oc+BNCH+pmS/tX8TtT/pxZC5WuxVWHHfRkEvrLErnAWVMkDt/r+wdKafpZj3loZ8SmIfpO3Dsw2wJ1Xms404XNaLU8dMfFOoLq4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lgP7VNqt; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lgP7VNqt"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ccafc5e82cso92605565ad.3
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 08:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784560002; x=1785164802; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=05o7VYUkCdAGSR73b2hzUktgrPZs5fUnpb2oWqFgEQo=;
        b=lgP7VNqtSYl9op/wKrWO6h2JAjjgXjNenX2D1nwhA86ObF3NQKd5fie/VKxTFiUsq6
         kyd44Z9GhstHi771VC2cXK3ysHfnog788heITgUuH+N8rsurmtcgku2epJtDYAgYh6w2
         Jdk9a2S7LuuxZaTB3D12o+AeWEK3lcWPt2bQDHE7quLvDWXSoe0TPqe+GtjCVIMXPOxF
         wxKQSjcd1VkKD07Qn/F2zCZMEiJ7ORsO7EnVHyReG5Bl0CxqhcVc8rNPo/nJQS8OBMSK
         UomPQGtx3DAxIKim0RyFN2SeGYSs62/e+4gwoJ7WCcUy5qM3y97Y6y0LheO3+7wvEy6q
         GJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784560002; x=1785164802;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=05o7VYUkCdAGSR73b2hzUktgrPZs5fUnpb2oWqFgEQo=;
        b=TPMvBAdwJvy4oHYug4tUqHRA0S2H+ACMiDyKWNqK+UnyE3oX85Qd9Gb/HoZR2cRVYR
         uEkehMREyFPa68szLqqp1ozv3YigmBvM+qH376p8wjpC+1GjAG3LZhq+E+nezp77eoUY
         My6O5/F38VY1g4R4MKo9u+Xu5sySVH/fbAkQ1+r0WO0n149rED3MgsfHgyFPSCMc9dLg
         fagfFvQWmf0WZwGil1EGs6lIcQRx5aU6t7Zv2NBg7KSLnK3/dAEP6UaMi0OLQla7LMrT
         CT+tyURBVJpVdu98M1JfY2ecRGgy9YXaLwOtNXv8NO8r0itJwfqbf4qMiMn+cMmGV2K4
         UgPQ==
X-Forwarded-Encrypted: i=1; AHgh+RptLDs5AvHQapD9UndF9HCrdygItSyyq4PsSKzA38Zb2YMgTS2jHE6MXEaIrUzpumq4trtWZ4zHa1zI@vger.kernel.org
X-Gm-Message-State: AOJu0YxOcJa7FbkLoSBzsDBdSJbRF4oLsSnrR+DDe7rW878cpoPS0wGp
	3cJ/Wrc5lwUrCoS1Ww9pqPHp2hj2V5zhX9gZ0XV8UfMIwCblBa/uJN3Q79F8CiJn/6GHHdSr7+z
	kRQ==
X-Received: from plgn10.prod.google.com ([2002:a17:902:f60a:b0:2cc:cfa0:3117])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2441:b0:2c2:cf20:213
 with SMTP id d9443c01a7336-2cf3499c666mr166695255ad.29.1784560001928; Mon, 20
 Jul 2026 08:06:41 -0700 (PDT)
Date: Mon, 20 Jul 2026 15:06:00 +0000
In-Reply-To: <20260720150601.2702700-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260720150601.2702700-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720150601.2702700-5-praan@google.com>
Subject: [PATCH v4 4/5] nfs: migrate direct I/O to iov_iter_extract_pages
From: Pranjal Shrivastava <praan@google.com>
To: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
	Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"

Migrate the NFS Direct I/O path away from the legacy
iov_iter_get_pages_alloc2() API to the modern iov_iter_extract_pages API.
The transition aligns NFS with the modern VFS extraction model and serves
as a preparatory step for supporting requirements such as page pinning
via GUP for DMA.

The migration fixes a bug in the Direct I/O loop where pages were being
unpinned immediately after request creation. With the new extraction
model, pins are held until the I/O is complete. Manual release in the
loop is correspondingly updated to only clean up failed pages.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Shivaji Kant <shivajikant@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfs/direct.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 96995736fac2..b9ac0a67693c 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -354,16 +354,17 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 	inode_dio_begin(inode);
 
 	while (iov_iter_count(iter)) {
-		struct page **pagevec;
+		struct page **pagevec = NULL;
 		size_t bytes;
 		size_t pgbase;
 		unsigned npages, i;
+		bool pinned = iov_iter_extract_will_pin(iter);
 
-		result = iov_iter_get_pages_alloc2(iter, &pagevec,
-						  rsize, &pgbase);
+		result = iov_iter_extract_pages(iter, &pagevec,
+						rsize, ~0U, 0, &pgbase);
 		if (result < 0)
 			break;
-	
+
 		bytes = result;
 		npages = (result + pgbase + PAGE_SIZE - 1) / PAGE_SIZE;
 		for (i = 0; i < npages; i++) {
@@ -371,7 +372,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 			unsigned int req_len = min_t(size_t, bytes, PAGE_SIZE - pgbase);
 			/* XXX do we need to do the eof zeroing found in async_filler? */
 			req = nfs_page_create_from_page(dreq->ctx, pagevec[i],
-							false, pgbase, pos,
+							pinned, pgbase, pos,
 							req_len);
 			if (IS_ERR(req)) {
 				result = PTR_ERR(req);
@@ -387,7 +388,8 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 			requested_bytes += req_len;
 			pos += req_len;
 		}
-		nfs_direct_release_pages(pagevec, npages, false);
+		if (i < npages)
+			nfs_direct_release_pages(pagevec + i, npages - i, pinned);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
@@ -891,13 +893,14 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 
 	NFS_I(inode)->write_io += iov_iter_count(iter);
 	while (iov_iter_count(iter)) {
-		struct page **pagevec;
+		struct page **pagevec = NULL;
 		size_t bytes;
 		size_t pgbase;
 		unsigned npages, i;
+		bool pinned = iov_iter_extract_will_pin(iter);
 
-		result = iov_iter_get_pages_alloc2(iter, &pagevec,
-						  wsize, &pgbase);
+		result = iov_iter_extract_pages(iter, &pagevec,
+						wsize, ~0U, 0, &pgbase);
 		if (result < 0)
 			break;
 
@@ -908,7 +911,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 			unsigned int req_len = min_t(size_t, bytes, PAGE_SIZE - pgbase);
 
 			req = nfs_page_create_from_page(dreq->ctx, pagevec[i],
-							false, pgbase, pos,
+							pinned, pgbase, pos,
 							req_len);
 			if (IS_ERR(req)) {
 				result = PTR_ERR(req);
@@ -952,7 +955,8 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 			desc.pg_error = 0;
 			defer = true;
 		}
-		nfs_direct_release_pages(pagevec, npages, false);
+		if (i < npages)
+			nfs_direct_release_pages(pagevec + i, npages - i, pinned);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
-- 
2.55.0.229.g6434b31f56-goog

