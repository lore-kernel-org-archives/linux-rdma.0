Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE1F4AE127
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 23:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791329585; cv=none; b=E3VCwq2YlHqnhYmTdJGxusDMyeVEpdXi2HdkUOEehYfbKrFKnT7rB9C8wzJ3WYAQVNMiUjF0TriNYPvsSFjdWth1QMr7hcYRyEnlNHC7KHBORAhRXIiW59mmgc5pyS2AGmhGXlRDU2YCPwP38LZ+Hse+5DD3SFAf1XnMTrGnReM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791329585; c=relaxed/simple;
	bh=4atyhY9fTcsB3GlrBYP9BUvTBeuPwypYLVWtYtxc3So=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SfaCew0qMw6Den8McDKxAI8dXvvhm+TI8dVzoWch77G9oIyH4zJI2tKm3oDKcK80dp2+0gVWq6JT93pbSQyWWIm+COYrLLUtfb3OKlLawf/WrNlFduAMZY1LD5qc9V9gQYsvr32LJo+l9nfEuZi1TObX8k8Ee4AO7bnxQKLQR8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qxoG6cQc; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qxoG6cQc"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-88bbc27f85cso4349907b3a.0
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 16:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791329584; x=1791934384; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x0xrcKnbRBTR48fIc2D2hZM5KuvFTZf5IeOdw+pi4O8=;
        b=qxoG6cQcuaVS4YxsfHxDJHY2wh6OVYbzAT5tqeQmAYoeSh/E2AcdKIpBtfpKcNQNWo
         fZFugTWkygRvd3AINghh4BpRg3ruCkik/mjCyG6maWjjHhyDbtHXBOvbxlbV2yhhZWCW
         XnghCwGxPLJeFzFrspEJPwGNkxJtR8b8GzpA7UnSaY7RHAzxSDPR4JFkqVvwYTmSxUbq
         mwDnCxdoiua8EG8nheL5/u7FdESY5p/tsZtn7wNLdrB0dv2bN1khHFyoU+K5FankpUMT
         FLAGlfnS2v7cBMbMXRwPpk59FSRAUuwcb3RZXjr1JZAUUlahY4ISF7qgHoytuEYT7z0h
         MQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791329584; x=1791934384;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x0xrcKnbRBTR48fIc2D2hZM5KuvFTZf5IeOdw+pi4O8=;
        b=ydgkuSBLcd2plUC+9RQCfuc7EPzMfTz8Y8zl6ngXy2LU6VUU3TWrw5hX3LSpJ8fwzz
         4UBoBRv6ibl5dJcUsSgkmhPB+PKc9VLLwxGFZhJfP1EaCnYWJhM6xTeImCG2g3fAnTNP
         lZU9LVabwOSTY0X1FhAVOtMbAOo0o+PE1DUyNK5DOrErHCyayfLokeXWWwpgzMpMPQzC
         IUtE/SYQ6bRYzEJsfocRPmXlKno8Rs2GFxRGy5WzPbjV/pur7lp4tsdbhP9Z0/OKZova
         frlb4c4h9ttgJ/jv0eqDd0KOhYppYDTVh/L6/iaa/MeSEsGlLN+oFe6HLeeIzfjQnfmB
         d+qg==
X-Forwarded-Encrypted: i=1; AKwUvBy3te5qbq/Nu+lRlYyC8H2SJID2ifQB/TU13rrnPHr0XiGxSRJV/wul/GUa3sFqOL0+8xYwUEUqP8w3@vger.kernel.org
X-Gm-Message-State: AFuF++mQq69kYSTfyB8kWSuaIxCJggz448vqzInxEViOWSX0KeU2W418
	hYai4xTK7x4x44KHKw6svhnml5WCbzRNPg1DWmDjQCY7cWQR10WZzRqXOyig92q60QRy/UE24/2
	s6Q==
X-Received: from pfme17.prod.google.com ([2002:aa7:98d1:0:b0:888:251d:f561])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:489:b0:3de:53ba:4081
 with SMTP id adf61e73a8af0-3e134124b04mr441996637.47.1791329583368; Tue, 06
 Oct 2026 16:33:03 -0700 (PDT)
Date: Tue,  6 Oct 2026 23:32:43 +0000
In-Reply-To: <20261006233248.705086-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261006233248.705086-1-praan@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261006233248.705086-4-praan@google.com>
Subject: [RFC PATCH v1 3/8] xprtrdma: move P2PDMA payloads only via chunks
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

Only chunks move a P2PDMA payload by DMA directly between the NIC
and the device memory. The inline paths copy the payload via CPU
accesses or DMA-map it with calls that do not handle P2PDMA pages.

Always send a P2PDMA WRITE payload in a Read chunk, and receive a
P2PDMA READ payload in a Write chunk, whatever its size. Return
-EREMOTEIO when that is not possible: the NIC cannot DMA to PCI
peer-to-peer memory (e.g. rxe, siw), the GSS service forbids direct
data placement (krb5i, krb5p), or the rest of the READ reply does
not fit inline.

If a server returns READ data inline anyway, fail the RPC with
-EREMOTEIO instead of copying the data into the P2PDMA pages.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 40 ++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 1285f04cdac1..065ab9a7edc9 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -175,6 +175,22 @@ rpcrdma_nonpayload_inline(const struct rpcrdma_xprt *r_xprt,
 		r_xprt->rx_ep->re_max_inline_recv;
 }
 
+/* A P2PDMA payload moves only by DMA between the NIC and device
+ * memory, in its own Read or Write chunk. That requires a NIC that
+ * can DMA to PCI peer-to-peer memory and, for a READ, a Reply whose
+ * non-payload part fits inline.
+ */
+static bool
+rpcrdma_p2pdma_allowed(const struct rpcrdma_xprt *r_xprt,
+		       const struct rpc_rqst *rqst)
+{
+	if (!ib_dma_pci_p2p_dma_supported(r_xprt->rx_ep->re_id->device))
+		return false;
+	if (rqst->rq_rcv_buf.flags & XDRBUF_P2PDMA)
+		return rpcrdma_nonpayload_inline(r_xprt, rqst);
+	return true;
+}
+
 /* ACL likes to be lazy in allocating pages. For TCP, these
  * pages can be allocated during receive processing. Not true
  * for RDMA, which must always provision receive buffers
@@ -815,6 +831,7 @@ inline int rpcrdma_prepare_send_sges(struct rpcrdma_xprt *r_xprt,
  *	%-EAGAIN if the caller should call again with the same arguments,
  *	%-ENOBUFS if the caller should call again after a delay,
  *	%-EMSGSIZE if the transport header is too small,
+ *	%-EREMOTEIO if the device cannot move the request's P2PDMA pages,
  *	%-EIO if a permanent problem occurred while marshaling.
  */
 int
@@ -854,16 +871,25 @@ rpcrdma_marshal_req(struct rpcrdma_xprt *r_xprt, struct rpc_rqst *rqst)
 	ddp_allowed = !test_bit(RPCAUTH_AUTH_DATATOUCH,
 				&rqst->rq_cred->cr_auth->au_flags);
 
+	if (xprt_rqst_has_p2pdma(rqst) &&
+	    (!ddp_allowed || !rpcrdma_p2pdma_allowed(r_xprt, rqst))) {
+		ret = -EREMOTEIO;
+		goto out_err;
+	}
+
 	/*
 	 * Chunks needed for results?
 	 *
+	 * o A P2PDMA read payload always returns in a write chunk.
 	 * o If the expected result is under the inline threshold, all ops
 	 *   return as inline.
 	 * o Large read ops return data as write chunk(s), header as
 	 *   inline.
 	 * o Large non-read ops return as a single reply chunk.
 	 */
-	if (rpcrdma_results_inline(r_xprt, rqst))
+	if (rqst->rq_rcv_buf.flags & XDRBUF_P2PDMA)
+		wtype = rpcrdma_writech;
+	else if (rpcrdma_results_inline(r_xprt, rqst))
 		wtype = rpcrdma_noch;
 	else if ((ddp_allowed && rqst->rq_rcv_buf.flags & XDRBUF_READ) &&
 		 rpcrdma_nonpayload_inline(r_xprt, rqst))
@@ -874,6 +900,7 @@ rpcrdma_marshal_req(struct rpcrdma_xprt *r_xprt, struct rpc_rqst *rqst)
 	/*
 	 * Chunks needed for arguments?
 	 *
+	 * o A P2PDMA write payload is always sent as a read chunk.
 	 * o If the total request is under the inline threshold, all ops
 	 *   are sent as inline.
 	 * o Large write ops transmit data as read chunk(s), header as
@@ -885,7 +912,10 @@ rpcrdma_marshal_req(struct rpcrdma_xprt *r_xprt, struct rpc_rqst *rqst)
 	 * that both has a data payload, and whose non-data arguments
 	 * by themselves are larger than the inline threshold.
 	 */
-	if (rpcrdma_args_inline(r_xprt, rqst)) {
+	if (buf->flags & XDRBUF_P2PDMA) {
+		*p++ = rdma_msg;
+		rtype = rpcrdma_readch;
+	} else if (rpcrdma_args_inline(r_xprt, rqst)) {
 		*p++ = rdma_msg;
 		rtype = buf->len < rdmab_length(req->rl_sendbuf) ?
 			rpcrdma_noch_pullup : rpcrdma_noch_mapped;
@@ -1244,6 +1274,12 @@ rpcrdma_decode_msg(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep,
 	/* Build the RPC reply's Payload stream in rqst->rq_rcv_buf */
 	base = (char *)xdr_inline_decode(xdr, 0);
 	rpclen = xdr_stream_remaining(xdr);
+
+	/* Never copy inline reply data into P2PDMA pages */
+	if (unlikely(rqst->rq_rcv_buf.flags & XDRBUF_P2PDMA &&
+		     rpclen > rqst->rq_rcv_buf.head[0].iov_len))
+		return -EREMOTEIO;
+
 	r_xprt->rx_stats.fixup_copy_count +=
 		rpcrdma_inline_fixup(rqst, base, rpclen, writelist & 3);
 
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

