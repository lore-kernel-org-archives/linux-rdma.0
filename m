Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06254FB9D8
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 23:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791329599; cv=none; b=Ssl//2pZmDouLGz3mPF64CL2xnykTOou6KMHMSLcejkxV2ExGCY/HMokCgZP3WssGSVYBDir8rlHnJAcyxoDuhk3ieftLcDIp3ItxO7gj8Mpz6E7pA2mNg6AtXhr2jeiSCu52vhy7+z9zlgl+D0EwXVS8kvrQw+8LkTC5L2cg3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791329599; c=relaxed/simple;
	bh=cmAVV5Tebt0KiKcFh+louzfAxig5TzIduxgkDUtTwzE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bxl6p129/chZxKmSHhk1eljDhcmz5+GjC6ZKc3kvRfaa6roiGmB9nk0bj6SufCYKF3B/+3Z6h3S9QD9JOisCHtPYk9xZLSOuYjXbNFVh0p3UlYhYBtvbOV05toW403QoiXdX8Db0aOznxk4gagBlkl9WfRR6Si8bmcH7L8H0fSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bhx3fQ+a; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bhx3fQ+a"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d55d8cd938so50688575ad.1
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 16:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791329596; x=1791934396; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oXfVAUbw2uFyka/hBHAtN/UFycLnfdN6bRNMp+GlmjI=;
        b=bhx3fQ+aNiyNqBd2k/5JX0P84iK/QOJY5ydyydqPmluL43niR3NIhot+aFHthnDDi7
         FrJijqWNDnc0lES1VL+rxqE4+YSq2UAWphKvaGF9K9uS9C64pdqtEqeGMof2yaYXNIlC
         9nojeQ+/RV6nMlLqzdvZCFlQhMO4cL1aJx9EY+wnJeu8i6XYF07SD8NwQjowQ5TZZ0+h
         neuov25Wela8s1zn5HpJRZYOBSCGmazqKp9tTuLPMFAPdXB9hzrxGwcnYd0aUp6c68Nf
         ZKk/rc1aWmv3HTvVxKW3Gi4EYI2ILs71dYPs6a3GcWJmEYLt1fOJIfIsaEHi44gAFY1U
         eQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791329596; x=1791934396;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oXfVAUbw2uFyka/hBHAtN/UFycLnfdN6bRNMp+GlmjI=;
        b=knrG++isk2FQTbxQapZ4Jf/jxGktmxu+q90/r5nlbNhoxdxnDA/Oe5r1q8in9FXrDS
         j+9NNjqsd2qA9OlO17uA9NPSSSrcTikbhX7ytg+sM9oXsHJuowj9KclVicZtVMa0o1Ck
         +zt2g5eVMsOH3C6uZYi/EZ1Is/jc8x+mcgcth7vUD2VJt4okUezNuk1wNqLt4XOdcLT9
         MtTA9AV1/3/jlY4y58jtVg2U7Krh3dlU3al0tbS5WEh8cFhKr+MKF1PIZu51n/AfX6zv
         M9kvNyvknbKk6Oc87KpHV71dgSbtcDwdZ4wxcaMpsKD4ieNmREH+GUfARhpZDDcBC4NV
         m15Q==
X-Forwarded-Encrypted: i=1; AKwUvBxovjlHUgVy4A08MgMJoNe4iEjBhsx4sRtHkhGF+4otRzzWy1n0R4a5lBlc9tEP71YGlq7kMkBkRtyu@vger.kernel.org
X-Gm-Message-State: AFq9FYLLuTJq16va1gKF6uJm7fC28GwUVMJPgHa4sQnTKZQ/X0rPwgKU
	nquJOBBk9hcnHM1PoY/SrAnagxYGlwRFnzHYWZ5CNbBPf+Mr7knWxkzW2SCvTwTIR58YfXFe9PT
	GhQ==
X-Received: from plhb7.prod.google.com ([2002:a17:903:2287:b0:2e5:9453:2404])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e885:b0:2dd:7646:35cd
 with SMTP id d9443c01a7336-2e5ff85264dmr7379155ad.0.1791329595650; Tue, 06
 Oct 2026 16:33:15 -0700 (PDT)
Date: Tue,  6 Oct 2026 23:32:48 +0000
In-Reply-To: <20261006233248.705086-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261006233248.705086-1-praan@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261006233248.705086-9-praan@google.com>
Subject: [RFC PATCH v1 8/8] nfs: allow P2PDMA pages for O_DIRECT on RDMA mounts
From: Pranjal Shrivastava <praan@google.com>
To: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org, 
	Shivaji Kant <shivajikant@google.com>, Tom Talpey <tom@talpey.com>, 
	Leon Romanovsky <leon@kernel.org>, Unnati Sachan <unnatisachan@google.com>, 
	Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"

Pass ITER_ALLOW_P2PDMA when extracting O_DIRECT pages on mounts that
use the RDMA transport and not pNFS. The RDMA transport moves such pages
only by DMA, and fails the RPC with -EREMOTEIO if the device cannot
reach them.

On other mounts, extracting P2PDMA pages still fails with -EREMOTEIO.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 fs/nfs/direct.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index a3c6e8f4ea06..dbeb4f8274e3 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -157,14 +157,22 @@ static ssize_t nfs_direct_extract_pages(struct nfs_direct_req *dreq,
 					size_t size, loff_t *pos,
 					struct list_head *list)
 {
+	struct nfs_server *server = NFS_SERVER(dreq->inode);
 	bool pinned = iov_iter_extract_will_pin(iter);
+	iov_iter_extraction_t flags = 0;
 	struct page **pagevec = NULL;
 	ssize_t result, bytes = 0;
 	int err = 0;
 	unsigned int npages, i;
 	size_t pgbase;
 
-	result = iov_iter_extract_pages(iter, &pagevec, size, ~0U, 0, &pgbase);
+	/* Allow P2PDMA pages only on RDMA mounts that do not use pNFS */
+	if (server->nfs_client->cl_proto == XPRT_TRANSPORT_RDMA &&
+	    !pnfs_enabled_sb(server))
+		flags = ITER_ALLOW_P2PDMA;
+
+	result = iov_iter_extract_pages(iter, &pagevec, size, ~0U, flags,
+					&pgbase);
 	if (result <= 0)
 		return result;
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

