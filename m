Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824B04749E4
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 14:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786718002; cv=none; b=gJyfUdTV6nXlYt6B1yjqG+ShE7D9XLRFpTQGAQu6H6iXO4Q70MvQMFS7xSCI7rJjfPnzQZaUghufyUgsXfUDciZpQa6hx6j8mp+O8wRtnHu9/b4cmTenYzVkpEp1IBxPHQyWapGZ/86ZFp98tAwVDcdoZ/FoCEbUAL1ZuRIu/rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786718002; c=relaxed/simple;
	bh=TmXCqyPZhqD8tZHxAFnz34BnUbGwD3NFtE9dcxrrwvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AH2m8ETYT69OCOfD5n2yyQbJxvrtR9pypywBmeciQa6h4hTfLTU/LB2uGWcvNPkG3e0caZ3b+egV3dpNWG3zjeTjHGWwdWM9Lvx2//as5q7uwTnsNqSMgcr1uDVIvHHemW637IxVn6D81OIfiVsIWai1OCKVvudH+xtKkNho1Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oKq5Flzn; arc=none smtp.client-ip=209.85.216.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oKq5Flzn"
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dbf293831so2380410a91.3
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 07:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786717996; x=1787322796; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0SgqAzIQu/0Bu39tyhAL9Ik5goBfz/9VI07g1fTVYzY=;
        b=oKq5FlzntHvK0Symg2Q7ZFAtfC/q3L57oSLdkLQgJc74r/meGKp/vDvu+wCuD1nwot
         FeAOWKlRmQoO/9c/RjWxQPvK/M9EfVDHHS7o+59U3V5t+ALLdm9ty/M/nrAACVFIXGWU
         x8slsx8YGGJhr6ZrwWYNSEcpoUinK2kPytxZ9+fkiUHcBvxZhQ+8s559H4GlSP7q2jOT
         iSk9XY5ulmLGfvfomNX5c7DihcZxY1P/T13YnhHjBeKRjrUKNlEu/1RS/Y/pPSkAhsLL
         h5jOLEEjmWENr/L6BW5JF/vcbmRZfFagpRsWpsSn1NPExXXfJb3xP5jyplvenwBKCKYE
         v19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786717996; x=1787322796;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0SgqAzIQu/0Bu39tyhAL9Ik5goBfz/9VI07g1fTVYzY=;
        b=fNLyB340eDFTxHYuHpTLWzKkitqovUrJTQ1z+H8j+ljAqt187xAZ13wQYf5xMnLhk6
         d2qqF879/KfqknBMZbVRjIkAGE/14yCopaUgnrCnJrzXOakDp+vKSGpuJGczVSJqqBN0
         HY9YtSKA6JBzU8tId73ry6yaHwnnJLyawXwN6dZQQTZMpI4XzSpee7iMvjJNdfAA0PxB
         HlXgX2OWp3Z/3uf/roaJpR4n+F+ukubjOG5IoH77VaK27r2oODBlacYGp8Q+v42YUya/
         f3jGP+0JVWGzeb/VhAuGy0td3iD2w5YDsX+Gpb4s/x+jIr+5rWYE1KTLSmnnVelNsjyK
         APtA==
X-Forwarded-Encrypted: i=1; AHgh+RrqufxUZG+3K8Fs4SDZ+FSionD2vqOKdRtGkvo8Tup+eoVow3m3KrKJLkL5foc7rstYax4uvEhVmuLq@vger.kernel.org
X-Gm-Message-State: AOJu0YwtMbrOnYWjwN+CEMCkJRBTb7rJJzHy93X3+Li0KbKm5jEmg9UD
	EIUiNHNj/WXCR1eqhY9FZ1xKyht6HNsH1RGPAA1uEeb6yaPP4L3Uyu9yT89ZUBpsozfItxfBzD7
	TbA==
X-Received: from pjab15.prod.google.com ([2002:a17:90a:100f:b0:381:171e:961c])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2747:b0:38e:2f21:3bb5
 with SMTP id 98e67ed59e1d1-3933baa0da9mr7909118a91.21.1786717995686; Fri, 14
 Aug 2026 07:33:15 -0700 (PDT)
Date: Fri, 14 Aug 2026 14:32:55 +0000
In-Reply-To: <20260814143255.861084-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260814143255.861084-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260814143255.861084-6-praan@google.com>
Subject: [PATCH v6 5/5] nfs: introduce nfs_direct_extract_pages helper
From: Pranjal Shrivastava <praan@google.com>
To: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
	Shivaji Kant <shivajikant@google.com>, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce nfs_direct_extract_pages() in direct.c to centralize page
extraction and request creation for the Direct I/O path. The helper
manages extraction from the iters and builds a list of nfs_page requests

Refactor nfs_direct_read_schedule_iovec() and
nfs_direct_write_schedule_iovec() to utilize the new helper, unifying
the extraction logic on both paths.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Shivaji Kant <shivajikant@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/nfs/direct.c | 130 ++++++++++++++++++++++++------------------------
 1 file changed, 64 insertions(+), 66 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index a1479fbf4f9e..76c954bbc9af 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -172,6 +172,50 @@ static void nfs_direct_release_pages(struct page **pages, unsigned int npages,
 		unpin_user_pages(pages, npages);
 }
 
+static ssize_t nfs_direct_extract_pages(struct nfs_direct_req *dreq,
+					struct iov_iter *iter,
+					size_t size, loff_t *pos,
+					struct list_head *list)
+{
+	bool pinned = iov_iter_extract_will_pin(iter);
+	struct page **pagevec = NULL;
+	ssize_t result, bytes = 0;
+	int err = 0;
+	unsigned int npages, i;
+	size_t pgbase;
+
+	result = iov_iter_extract_pages(iter, &pagevec, size, ~0U, 0, &pgbase);
+	if (result <= 0)
+		return result;
+
+	npages = (result + pgbase + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	for (i = 0; i < npages; i++) {
+		struct nfs_page *req;
+		unsigned int req_len = min_t(size_t, result - bytes, PAGE_SIZE - pgbase);
+
+		req = nfs_page_create_from_page(dreq->ctx, pagevec[i],
+						pinned, pgbase, *pos,
+						req_len);
+		if (IS_ERR(req)) {
+			err = PTR_ERR(req);
+			break;
+		}
+
+		list_add_tail(&req->wb_list, list);
+		pgbase = 0;
+		bytes += req_len;
+		*pos += req_len;
+	}
+
+	if (i < npages) {
+		iov_iter_revert(iter, result - bytes);
+		nfs_direct_release_pages(pagevec + i, npages - i, pinned);
+	}
+
+	kvfree(pagevec);
+	return bytes ? bytes : err;
+}
+
 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
 			      struct nfs_direct_req *dreq)
 {
@@ -340,6 +384,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 	ssize_t result = -EINVAL;
 	size_t requested_bytes = 0;
 	size_t rsize = max_t(size_t, NFS_SERVER(inode)->rsize, PAGE_SIZE);
+	LIST_HEAD(nfs_page_list);
 
 	nfs_pageio_init_read(&desc, dreq->inode, false,
 			     &nfs_direct_read_completion_ops);
@@ -348,44 +393,23 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 	inode_dio_begin(inode);
 
 	while (iov_iter_count(iter)) {
-		struct page **pagevec = NULL;
-		size_t bytes;
-		size_t pgbase;
-		unsigned npages, i;
-		bool pinned = iov_iter_extract_will_pin(iter);
-
-		result = iov_iter_extract_pages(iter, &pagevec,
-						rsize, ~0U, 0, &pgbase);
+		result = nfs_direct_extract_pages(dreq, iter, rsize, &pos, &nfs_page_list);
 		if (result < 0)
 			break;
 
-		bytes = result;
-		npages = (result + pgbase + PAGE_SIZE - 1) / PAGE_SIZE;
-		for (i = 0; i < npages; i++) {
-			struct nfs_page *req;
-			unsigned int req_len = min_t(size_t, bytes, PAGE_SIZE - pgbase);
-			/* XXX do we need to do the eof zeroing found in async_filler? */
-			req = nfs_page_create_from_page(dreq->ctx, pagevec[i],
-							pinned, pgbase, pos,
-							req_len);
-			if (IS_ERR(req)) {
-				result = PTR_ERR(req);
-				break;
-			}
+		while (!list_empty(&nfs_page_list)) {
+			struct nfs_page *req = nfs_list_entry(nfs_page_list.next);
+			size_t req_len = req->wb_bytes;
+
+			nfs_list_remove_request(req);
 			if (!nfs_pageio_add_request(&desc, req)) {
 				result = desc.pg_error;
 				nfs_release_request(req);
-				i++;
+				nfs_release_request_list(&nfs_page_list);
 				break;
 			}
-			pgbase = 0;
-			bytes -= req_len;
 			requested_bytes += req_len;
-			pos += req_len;
 		}
-		if (i < npages)
-			nfs_direct_release_pages(pagevec + i, npages - i, pinned);
-		kvfree(pagevec);
 		if (result < 0)
 			break;
 	}
@@ -876,6 +900,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 	ssize_t result = 0;
 	size_t requested_bytes = 0;
 	size_t wsize = max_t(size_t, NFS_SERVER(inode)->wsize, PAGE_SIZE);
+	LIST_HEAD(nfs_page_list);
 	bool defer = false;
 
 	trace_nfs_direct_write_schedule_iovec(dreq);
@@ -888,57 +913,32 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 
 	NFS_I(inode)->write_io += iov_iter_count(iter);
 	while (iov_iter_count(iter)) {
-		struct page **pagevec = NULL;
-		size_t bytes;
-		size_t pgbase;
-		unsigned npages, i;
-		bool pinned = iov_iter_extract_will_pin(iter);
-
-		result = iov_iter_extract_pages(iter, &pagevec,
-						wsize, ~0U, 0, &pgbase);
+		result = nfs_direct_extract_pages(dreq, iter, wsize, &pos, &nfs_page_list);
 		if (result < 0)
 			break;
 
-		bytes = result;
-		npages = (result + pgbase + PAGE_SIZE - 1) / PAGE_SIZE;
-		for (i = 0; i < npages; i++) {
-			struct nfs_page *req;
-			unsigned int req_len = min_t(size_t, bytes, PAGE_SIZE - pgbase);
-
-			req = nfs_page_create_from_page(dreq->ctx, pagevec[i],
-							pinned, pgbase, pos,
-							req_len);
-			if (IS_ERR(req)) {
-				result = PTR_ERR(req);
-				break;
-			}
-
-			if (desc.pg_error < 0) {
-				nfs_free_request(req);
-				result = desc.pg_error;
-				i++;
-				break;
-			}
-
-			pgbase = 0;
-			bytes -= req_len;
-			requested_bytes += req_len;
-			pos += req_len;
+		while (!list_empty(&nfs_page_list)) {
+			struct nfs_page *req = nfs_list_entry(nfs_page_list.next);
+			size_t req_len = req->wb_bytes;
 
+			nfs_list_remove_request(req);
 			if (defer) {
 				nfs_mark_request_commit(req, NULL, &cinfo, 0);
+				requested_bytes += req_len;
 				continue;
 			}
 
 			nfs_lock_request(req);
-			if (nfs_pageio_add_request(&desc, req))
+			if (nfs_pageio_add_request(&desc, req)) {
+				requested_bytes += req_len;
 				continue;
+			}
 
 			/* Exit on hard errors */
 			if (desc.pg_error < 0 && desc.pg_error != -EAGAIN) {
 				result = desc.pg_error;
 				nfs_unlock_and_release_request(req);
-				i++;
+				nfs_release_request_list(&nfs_page_list);
 				break;
 			}
 
@@ -949,12 +949,10 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 			spin_unlock(&dreq->lock);
 			nfs_unlock_request(req);
 			nfs_mark_request_commit(req, NULL, &cinfo, 0);
+			requested_bytes += req_len;
 			desc.pg_error = 0;
 			defer = true;
 		}
-		if (i < npages)
-			nfs_direct_release_pages(pagevec + i, npages - i, pinned);
-		kvfree(pagevec);
 		if (result < 0)
 			break;
 	}
-- 
2.55.0.691.gc56d675ccc-goog

