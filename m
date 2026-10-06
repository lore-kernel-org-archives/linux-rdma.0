Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A613BED1F
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 23:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791329592; cv=none; b=GnaHmsMYsdvyfkaEqsX7d4rypbTdtZec8zVT0R6dgvlIvu1/j5YbXRDwYMue/ZRsniJDmbWtBL64sHSCvbgbcvAR68yN61CcZ5bBzwYkEEoIWE9/0j9RpGoJWklTrAXHdZG8W/9mi4QcSl0KUBMdzsI1NhX/CvZvArZGZBu0AlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791329592; c=relaxed/simple;
	bh=6do5GILneM2SelSiDGSkhgGo9BTvgOAIY7d7Bg1SjQ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HLFxp5jt1o6Fj9cjLbh+aK0ENN1PyK6g6Rw9qAJ7byGJvHMA9+ClPifzmYGTKXKXyy8rAELTTQrdgRZolpW4POk8Vk59m8GOoaMNFxLDg4Jj5bolvZTqDDZSgp0++AMLWj8tNU8ERqHwfQULJ7rb8R5lxOJf3hhKpYSWQx3DdTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MnEnWh2f; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MnEnWh2f"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cca35cf9f77so2002007a12.2
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 16:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791329588; x=1791934388; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uzjnm4DC8/yngbTXbJn1X0a1+gZkIVZaTLffWNrxWJE=;
        b=MnEnWh2fR6g1/Zzg1XlOWgScAw+AQt1DDv2dqPeh/wfRdCXRJ4kPh3e2uOOe1gVAc6
         uSRyBWI2PLCHM3h7GjbPRSAg/QCv2P1Ly34zAkdXv85tyZSuY881wgoeU9FxTVRLu3qo
         yfVgXbpIbOY5gdxNLIwsGKen3+CKHErb2JfKlFF+AEx9fHcOt2Vbz8eLV9gQ6duWctaW
         ujoR4ERDLpk8dZIu+CP1LYUt0lNoI3dG2kj3JBcjvdfejJ5an520et1SL1kTqQkyT4Ue
         Hkc1H/WySsePnInMCowfSCQWij7R4pcg/Aq8yv7WZaFKqsZ0tDSk/b4QMXjCjGBQvKFq
         ajzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791329588; x=1791934388;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uzjnm4DC8/yngbTXbJn1X0a1+gZkIVZaTLffWNrxWJE=;
        b=DMcqg+Fq+xkFHuJjBXse6VNKBJ/un/FbBtUZW1hUAvwU+BdwCopMtdf7Pz4Bf/pBBl
         DX9dN7ed/7vWMxn8oAn4SuNEJLIHa0967vJdXUo8zjlD75/nQ4jBq30dxuiriWQcaoSM
         jSOGMLRudpMy6tOoSt2+0fUUs4cgBe6s8aHQ4FI3Wszw23lSzQB+9hiDW9bjatSZduEN
         GnAMNzGrSqh1eZ8iFW0KjEXJx9qB8dfP+I8i8utUPqRdN6BF6hL++kp8l1CSCtEhlGhG
         Ef3Z91GOCGc+4NuOz4CO/pGP2nkkMNbY9Nr+0h5CWar0ZY1HZLlnxAr7WgD9VpI5ZYV2
         Ez9w==
X-Forwarded-Encrypted: i=1; AKwUvBzCmxyG3NIypnbPnBsUZW2UMcY3gVfCisM2Ir0JR7kC2c7Nvol2Anhi3BgmMG2C5HkZBfq5f+yRYhKy@vger.kernel.org
X-Gm-Message-State: AFuF++lpT+s62m70a3Bx0BjxtBL68HzbO9f5BMxPy0OAulKjb1N+dmz6
	xCrgnQho3uuyfxYM4x4/Q9brSkQaiIDnG78/62CY+8cziZSjkPQlZaX1FCa6WSfSWATtnTE8zk4
	Aeg==
X-Received: from pgbd18-n1.prod.google.com ([2002:a05:6a02:64d2:10b0:cc7:b263:342e])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:484:b0:3de:247d:73de
 with SMTP id adf61e73a8af0-3e133fffe0bmr404483637.19.1791329588288; Tue, 06
 Oct 2026 16:33:08 -0700 (PDT)
Date: Tue,  6 Oct 2026 23:32:45 +0000
In-Reply-To: <20261006233248.705086-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261006233248.705086-1-praan@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261006233248.705086-6-praan@google.com>
Subject: [RFC PATCH v1 5/8] nfs: tag READ/WRITE RPCs carrying P2PDMA pages
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

A transport must know when an RPC's payload pages are P2PDMA memory,
so it can move them by DMA or refuse the RPC.

Check each page as nfs_generic_pgio() builds the page array, and
record the result in nfs_pgio_args. The READ and WRITE encoders of
every NFS version then set XDRBUF_P2PDMA on the buffer holding the
payload.

Additionally, avoid using READ_PLUS when the pages are P2PDMA memory.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 fs/nfs/nfs2xdr.c        | 4 ++++
 fs/nfs/nfs3xdr.c        | 4 ++++
 fs/nfs/nfs4proc.c       | 3 +++
 fs/nfs/nfs4xdr.c        | 4 ++++
 fs/nfs/pagelist.c       | 2 ++
 include/linux/nfs_xdr.h | 1 +
 6 files changed, 18 insertions(+)

diff --git a/fs/nfs/nfs2xdr.c b/fs/nfs/nfs2xdr.c
index 9eff09158518..5a8f2eccd068 100644
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -628,6 +628,8 @@ static void nfs2_xdr_enc_readargs(struct rpc_rqst *req,
 	rpc_prepare_reply_pages(req, args->pages, args->pgbase, args->count,
 				NFS_readres_sz - NFS_pagepad_sz);
 	req->rq_rcv_buf.flags |= XDRBUF_READ;
+	if (args->p2pdma)
+		req->rq_rcv_buf.flags |= XDRBUF_P2PDMA;
 }
 
 /*
@@ -668,6 +670,8 @@ static void nfs2_xdr_enc_writeargs(struct rpc_rqst *req,
 
 	encode_writeargs(xdr, args);
 	xdr->buf->flags |= XDRBUF_WRITE;
+	if (args->p2pdma)
+		xdr->buf->flags |= XDRBUF_P2PDMA;
 }
 
 /*
diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index e745e78faab0..e39c58883a2a 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -946,6 +946,8 @@ static void nfs3_xdr_enc_read3args(struct rpc_rqst *req,
 	rpc_prepare_reply_pages(req, args->pages, args->pgbase,
 				args->count, replen);
 	req->rq_rcv_buf.flags |= XDRBUF_READ;
+	if (args->p2pdma)
+		req->rq_rcv_buf.flags |= XDRBUF_P2PDMA;
 }
 
 /*
@@ -988,6 +990,8 @@ static void nfs3_xdr_enc_write3args(struct rpc_rqst *req,
 
 	encode_write3args(xdr, args);
 	xdr->buf->flags |= XDRBUF_WRITE;
+	if (args->p2pdma)
+		xdr->buf->flags |= XDRBUF_P2PDMA;
 }
 
 /*
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index beb659744760..443079f5adc9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5721,6 +5721,9 @@ static int nfs4_read_done(struct rpc_task *task, struct nfs_pgio_header *hdr)
 static bool nfs42_read_plus_support(struct nfs_pgio_header *hdr,
 				    struct rpc_message *msg)
 {
+	/* P2PDMA payloads move only by DMA */
+	if (hdr->args.p2pdma)
+		return false;
 	/* Note: We don't use READ_PLUS with pNFS yet */
 	if (nfs_server_capable(hdr->inode, NFS_CAP_READ_PLUS) && !hdr->ds_clp) {
 		msg->rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_READ_PLUS];
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 8b3d96b4a0f0..04765b56de28 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -2621,6 +2621,8 @@ static void nfs4_xdr_enc_read(struct rpc_rqst *req, struct xdr_stream *xdr,
 	rpc_prepare_reply_pages(req, args->pages, args->pgbase,
 				args->count, hdr.replen - pagepad_maxsz);
 	req->rq_rcv_buf.flags |= XDRBUF_READ;
+	if (args->p2pdma)
+		req->rq_rcv_buf.flags |= XDRBUF_P2PDMA;
 	encode_nops(&hdr);
 }
 
@@ -2686,6 +2688,8 @@ static void nfs4_xdr_enc_write(struct rpc_rqst *req, struct xdr_stream *xdr,
 	encode_putfh(xdr, args->fh, &hdr);
 	encode_write(xdr, args, &hdr);
 	req->rq_snd_buf.flags |= XDRBUF_WRITE;
+	if (args->p2pdma)
+		req->rq_snd_buf.flags |= XDRBUF_P2PDMA;
 	if (args->bitmask)
 		encode_getfattr(xdr, args->bitmask, &hdr);
 	encode_nops(&hdr);
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 71f0ce2bc4ea..3ec4e1e5fe1f 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -970,6 +970,8 @@ int nfs_generic_pgio(struct nfs_pageio_descriptor *desc,
 				if (pageused > pagecount)
 					goto full;
 				*pages++ = last_page = page;
+				if (is_pci_p2pdma_page(page))
+					hdr->args.p2pdma = true;
 			}
 		}
 	}
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index c0e29b4dfa62..85cdee107559 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -685,6 +685,7 @@ struct nfs_pgio_args {
 	__u32			count;
 	unsigned int		pgbase;
 	struct page **		pages;
+	bool			p2pdma;		/* pages include P2PDMA memory */
 	union {
 		unsigned int		replen;			/* used by read */
 		struct {
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

