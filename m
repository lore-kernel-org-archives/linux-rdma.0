Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AFD3BBA0E
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 23:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791329580; cv=none; b=PrXd174qlIvPdCHxvmIXRFBYvtQc+6saddYTP6uGIO1A+wekTNlSOX6kxt0gRjDJ052/mDrvbDmXcOUdPDNtXIJX06tHTCfOAapR3Vi76RoGaEODVn/8P8MK169sen3eq7hUeB4194RQRojszdI8RUXn6w42bJHIbwwvVChwOq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791329580; c=relaxed/simple;
	bh=BLzJmYtg+5WKaReF54gIKTRlGEQtuRHyNEq1blvwsj0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G5tnVknoKoDvs8ve9vLzVoy4yw85vkM5ouDJoyCNHzx23OcfFT73c5u4UyAnHpjwdOf6tjl4EZa9ljUXYRim315MJzLIh2BfCObm5AY6TqG0YjWE4cYV0yku4QWKL46N1AukgRNAagOXxf3eaD2FCc4e8JJ9aCujmlfnODlviS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--praan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X009YX3Q; arc=none smtp.client-ip=209.85.214.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--praan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X009YX3Q"
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e5df3b58a4so8028745ad.1
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 16:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791329578; x=1791934378; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lFAbLk5EwoP2181kRqfEUrgA75aS3jBbGn0jFogrJ+w=;
        b=X009YX3Q1MxqB2dEeibb2KtloF0CEAfzz7tZBoiSbxMprS+GSuTIpFcwiXU7pxJyft
         p7GDpotjoKy7TmLtI1KkKGM8AotC7z/MFR31qGztt7eVm0Jg0TjoDwGvZ3LACddB8LaZ
         8zOWPXX2kJNXE5nvjrTwUPYveJUa+gAaWONFx1lPxBSaSuggLZj+XXxmtRTa3jCvmlsE
         1QDEy0AFc1iJ9qf6plboL928oSdAKUBt6YRNNc3s355XO0rLPe16vtfrEDFVj98QdoyO
         5dcN4wMxRYiT4aMivriyYUgOTqNNAkelMI4RaXkEfbexvpzcARy1i5yYOSCcKB+I/96c
         kFPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791329578; x=1791934378;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lFAbLk5EwoP2181kRqfEUrgA75aS3jBbGn0jFogrJ+w=;
        b=U8DSvf9swckdVR5BTzjUzZNZvQaO+FHnt4oHVzUA3A/HdXJkFaSpnQqqQ0feg6kSgI
         VL3WFboTXOF6QVdW0CegW3OuFnf4jRHUFQc5XM18i5i0xTc8nLII4xDd3DOkv8+VCPtp
         Z5BCetGAmxb3o21v0boy5xUL4QJTTWyNXloCRIOXt/T28fr4eGXlUrXlzZEEsm0XEi2n
         4OukPxBfUrEU0eX2Febj6gekgWMqgMxzlb9ZBtyb2c6k+Dr00xOozyiyAyXXW8qjZQHF
         iiYp3MzbewbPwbo9Xs+r+Rt7pxqMMjtM8nOMbEXCyEn2iXB/XNVIYvRh/mOg//Rrz1ut
         4I2w==
X-Forwarded-Encrypted: i=1; AKwUvByb1TAN5zjCECG71vZQDC5zbhSQoQw/lbBjGCLqCMlSycytVIHdEcFYb3liBnYHpodmY1vFH23TBJCz@vger.kernel.org
X-Gm-Message-State: AFq9FYIHKcQAdDf57vtQT2C0k79SdglLnqgL9/L6mhSb2bwbHXJ4JvTR
	DymbQqf3U3eycqmJz0QqSYGbgOZHTXtZioS/z5+cnvA75Mq10D2jXchpWipcZJsJErGTTi0+dkC
	GSg==
X-Received: from plbbh1.prod.google.com ([2002:a17:902:a981:b0:2e2:f305:e980])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e744:b0:2e4:c7ff:5309
 with SMTP id d9443c01a7336-2e60057c74emr6840235ad.58.1791329577840; Tue, 06
 Oct 2026 16:32:57 -0700 (PDT)
Date: Tue,  6 Oct 2026 23:32:41 +0000
In-Reply-To: <20261006233248.705086-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20261006233248.705086-1-praan@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261006233248.705086-2-praan@google.com>
Subject: [RFC PATCH v1 1/8] sunrpc: introduce XDRBUF_P2PDMA flag
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

The NFS client will soon pass PCI peer-to-peer DMA (P2PDMA) pages
to the transport as READ or WRITE payload. Only a transport that
can DMA directly to and from that memory may move it.

Introduce XDRBUF_P2PDMA and a helper, xprt_rqst_has_p2pdma(), to
mark and detect requests whose pages are P2PDMA memory. The TCP
(including TLS), UDP and AF_LOCAL transports return -EREMOTEIO for
such a request before touching the socket. iov_iter_extract_pages()
returns the same error today for P2PDMA pages the caller did not allow.
Thus, users see no new error code.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 include/linux/sunrpc/xdr.h  |  1 +
 include/linux/sunrpc/xprt.h |  5 +++++
 net/sunrpc/xprtsock.c       | 12 ++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
index b102b4f21e6b..79526f47be2d 100644
--- a/include/linux/sunrpc/xdr.h
+++ b/include/linux/sunrpc/xdr.h
@@ -65,6 +65,7 @@ struct xdr_buf {
 #define XDRBUF_READ		0x01		/* target of file read */
 #define XDRBUF_WRITE		0x02		/* source of file write */
 #define XDRBUF_SPARSE_PAGES	0x04		/* Page array is sparse */
+#define XDRBUF_P2PDMA		0x08		/* Pages are P2PDMA memory */
 
 	unsigned int	buflen,		/* Total length of storage buffer */
 			len;		/* Length of XDR encoded message */
diff --git a/include/linux/sunrpc/xprt.h b/include/linux/sunrpc/xprt.h
index a82045804d34..08ab04fa4509 100644
--- a/include/linux/sunrpc/xprt.h
+++ b/include/linux/sunrpc/xprt.h
@@ -134,6 +134,11 @@ static inline int xprt_rqst_add_seqno(struct rpc_rqst *req, u32 seqno)
 	return 0;
 }
 
+static inline bool xprt_rqst_has_p2pdma(const struct rpc_rqst *req)
+{
+	return (req->rq_snd_buf.flags | req->rq_rcv_buf.flags) & XDRBUF_P2PDMA;
+}
+
 /* RPC transport layer security policies */
 enum xprtsec_policies {
 	RPC_XPRTSEC_NONE = 0,
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index f5a5136327ba..9fa6d7ec207e 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -962,6 +962,10 @@ static int xs_local_send_request(struct rpc_rqst *req)
 	unsigned int sent;
 	int status;
 
+	/* Sockets move data via CPU accesses, so refuse P2PDMA pages */
+	if (xprt_rqst_has_p2pdma(req))
+		return -EREMOTEIO;
+
 	/* Close the stream if the previous transmission was incomplete */
 	if (xs_send_request_was_aborted(transport, req)) {
 		xprt_force_disconnect(xprt);
@@ -1031,6 +1035,10 @@ static int xs_udp_send_request(struct rpc_rqst *req)
 	unsigned int sent;
 	int status;
 
+	/* Sockets move data via CPU accesses, so refuse P2PDMA pages */
+	if (xprt_rqst_has_p2pdma(req))
+		return -EREMOTEIO;
+
 	xs_pktdump("packet data:",
 				req->rq_svec->iov_base,
 				req->rq_svec->iov_len);
@@ -1118,6 +1126,10 @@ static int xs_tcp_send_request(struct rpc_rqst *req)
 	unsigned int sent;
 	int status;
 
+	/* Sockets move data via CPU accesses, so refuse P2PDMA pages */
+	if (xprt_rqst_has_p2pdma(req))
+		return -EREMOTEIO;
+
 	/* Close the stream if the previous transmission was incomplete */
 	if (xs_send_request_was_aborted(transport, req)) {
 		if (transport->sock != NULL)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

