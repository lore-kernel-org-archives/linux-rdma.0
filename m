Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794611345;
	b=nS3TxnthKT60dJfOs86b/946Ppz25JNGCcons3luDQQxJyqljfWv/6bPCGd7oezQ5R0N
	 0yEA7qyc8ahZQ07LOmuA+ZLyPZvSiffZo+ZgXeEW1mMYwzsq8Q44XMQEGYYwfJU+mTlSs
	 hyrYu6R0PoRWEb7tKhm33eHe99LeQK8EUPXBiGlLDHCUh5IAig10kton7SAfL2VBpT7Cy
	 yh0SLe7XrKtmsqRS4TcPA9ezxAceVy/z31b4pkNwljiCWylmpF8LRrrj7s71gPuwqqX66
	 ZkZ0R6g3MNYjKGi6lkJo2rOMe/83AeRF+LKXSbdPbPxPCGiwQl60Jo/+CvGZXl7OmcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794611345;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5DlzMUMtEfBl4sH+z/6/msTIw6TRSjv0D6qDnAX+XMg=;
	b=GGAB6LUC0m2wI6AVQK5sds9yEWND4HHt7qj23fLDeQHbkH89g/gvXco/D4j1799GVTbA
	 wiHiE7/2Z7nCS0OHgwOUGcfDUOtQzVMl7KPxqZRUFNI5BxqdO+n+HvM1pAlmjjLeHhGAi
	 69wovhKpw7tcjeYo9uJeW2E9ulUqm7VlDWRPcUy/SzT25NPqFT2o4FKs0bLoKLw9pDA3S
	 NmUCBFXSHLLrXjVOgZT2N7tgICrLdfnLbboHHV7Eh5TcT1/nfeghDJDAEu1lBSErGBwQi
	 vEzmjNxYuqo7/zpRJXoLrk4acCzNMOMETLMisvmAL+DLopplP354PbJ6OoIuufVOz6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=XDxqczw+;
	arc=none smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B65B606A32E
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 23:09:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B65B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=XDxqczw+
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-33fb4680717so4400729eec.1
        for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 15:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1794611343; x=1795216143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5DlzMUMtEfBl4sH+z/6/msTIw6TRSjv0D6qDnAX+XMg=;
        b=XDxqczw+fhNCa5AT80FKOoJM6Ou3zh6RfXXx+DM/pNL8ZMxraPW2kO3doqaHkVmNF3
         uDe28tAUfDd1xKaE8lrESwZxTLQrTEO587sFSdjD9nVv5CYdVlXFckIfZILP2Mc00zI+
         fyJjy/CKt7RywPBU8e1v5SiBILoWKHGLoIKFn3m3jkXkYJ59L9YBF7KguyzMRkTFmmBg
         2r1310P1aFqsutcsuq/r+FsKbWN/nxE0fyCJxGYZ6iJDv2fmyQHlhhQdfctS6CXF0wgF
         FYfN07y5mx0Obeji+cDo3Cqr7H79D5Zsw0nyKHmP4Xav54MRv+Xcdwmy64eWcP2BJVjt
         NLyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794611343; x=1795216143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5DlzMUMtEfBl4sH+z/6/msTIw6TRSjv0D6qDnAX+XMg=;
        b=b5SJTIzECVPFZN3I2Ro/s5z+yTjv8XL+/5N/fVUWxAH71gN8bNb2A0uc+pOVHmATTF
         eQJO6vSM2gs9EWvlS5VF07ZE3UM0UYUZCuguk5cQsZRgk88r+bXgAw+KAcw7SDs9g1IN
         7D6VvExmze7WeQvxn+4cXPrUoYtjw36KkGdDUfVLojxeKYdVSGKlXO9q/oTQT+tl321I
         TZfuaVAjkGveRFZNwYZUm3fasQgxouX53RpgB5o5YZbTtxeWp6Y/vM3F4oN31fHvL8Yk
         6jQxgPVRFGZVIGoTksn1VbVYhG64A9fCdYASCKQCx+IxoVV0DIqt0KM5e28L56ZkBOJP
         IyLw==
X-Forwarded-Encrypted: i=1; AL+hErGjCCImQMcqre1rIDAbD2o3/InPqx/ELTlCy6aLit6rvyxiKY80ssX9v04iEQ65PEaXEpTnqbO+UIwn@vger.kernel.org
X-Gm-Message-State: APuU4Z8C6hCqKpnrzMzjbrlHtu5jIZmjbo22SWmTYEMixx9HONDWRqng
	gd/eIYibNZLd45JXIXfKohyBvHXp+ZQc+SmcunjpCQFF3p1f42wHxAndcKeiqwuEyR4=
X-Gm-Gg: AYBFou0oyKwtgWzcslhnPYBeyqOpB/anuKMMQOnex8gebGz1PER/nj4R8itkQwshdJw
	rd6s2GsUBEVOhfBYFSflSRD/H+8vR1ieaF/WgHzH8/0s0NPajOw23QrB6Hmg9uKzy9vGO8eThm9
	kS0RrNbT9nvtGjhupg19uW5AfR7p1om774iPuImjLcL4oG4r+6tJHYgW4WlVZYJ3tBnc10nqfxk
	cl2NfheT3QNpxpQRs74HlkSFLXqJWUT1QRq+UFBzu61bLYKcfFHYh0Mf6L0GOcpEYDRwbPIxB0+
	iTwMZc1g+9b9Y1wvlsL2/igsSuFoF18n/5ivxeXwPdT7TEPgrxgA83tgkqURI20rKTPVQemil7g
	8ck/g4jkK3he9ecjNkjIq3Ny/hFBm5WUBRfXc1tUxrW6Rbmgjb+B9nxeBqzuhuXtFJB+pGP96kY
	UGkUSdpbtKByWhLitxYHMvD51V94Ok99TeG4ePLJnSm44YsXK9mrFWmGhXco/VHWbecoKJ0LYaJ
	THOCp70R9us1vhm0nlz1PaVRV86D6wV1dTZZVXZ8BcqIagAVMRG6t5wUsyM65icX2Di3zo/4bm1
	yfMOFQRsySrPJmQahxkH/soqeAvktle6eiKtRhGyFuV/MoLF8ccTtU5wjx+y6bdRmp6bRPkZyQ=
	=
X-Received: by 2002:a05:7301:db16:b0:376:9e80:2bf5 with SMTP id 5a478bee46e88-379680cf4b9mr3687174eec.38.1794611343074;
        Fri, 13 Nov 2026 15:09:03 -0800 (PST)
Received: from apollo.purestorage.com ([208.88.152.253])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-3795378d73dsm10737887eec.2.2026.11.13.15.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 15:09:02 -0800 (PST)
From: Mohamed Khalfella <mkhalfella@purestorage.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Mohamed Khalfella <mkhalfella@purestorage.com>
Subject: [PATCH] RDMA/rxe: Do not re-execute completed local ops after a retry
Date: Fri, 13 Nov 2026 15:08:31 -0800
Message-ID: <20261113230831.2682071-1-mkhalfella@purestorage.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Local operations (IB_WR_REG_MR, IB_WR_LOCAL_INV, IB_WR_BIND_MW) are
executed inline by rxe_requester() through rxe_do_local_ops(), which
marks the wqe wqe_state_done and advances qp->req.wqe_index past it.
Unlike wire operations, nothing is posted to the network and no ack is
expected.

The completer only consumes wqes from the head of the send queue, in
order. A done local op wqe therefore stays in the queue until every
older wqe has completed, so it can sit behind a SEND or RDMA WRITE that
is still waiting for an ack. With nvme-rdma, which posts REG_MR + SEND
for every I/O, the queue regularly looks like:

  SEND(A) pending, REG_MR(B) done, SEND(B) pending, REG_MR(C) done ...

When a retransmit timeout fires or a NAK arrives, req_retry() rewinds
qp->req.wqe_index to the consumer so that every unacked wqe is resent.
Its loop skips wqe_state_done entries when resetting DMA state, but
rxe_requester() itself has no such check. After the rewind it walks
forward through the queue, reaches REG_MR(B), sees WR_LOCAL_OP_MASK and
calls rxe_do_local_ops() on it a second time.

rxe_reg_fast_mr() rejects the repeated registration because the MR is
already RXE_MR_STATE_VALID, not FREE. The wqe is given
IB_WC_LOC_QP_OP_ERR and the QP is moved to the error state. The
completer then flushes the entire send queue with IB_WC_WR_FLUSH_ERR,
including the wqe that failed, so the consumer never sees the real
error status. nvme-rdma logs only "SEND ... failed with status WR
flushed (5)" and tears down the controller.

Any packet loss that triggers a retry while a later request is queued
is enough to hit this. On a soft-RoCE setup with a few hundred lost
frames per run every controller reconnect traced back to the same
rxe_dbg_mr() line:

  rxe1: mr#776 rxe_reg_fast_mr:  mr->lkey = 0x3084c not free

Skip local op wqes that are already done when the requester reaches
them again after a rewind. Advance wqe_index past them exactly as a
successful execution would and continue with the next wqe. The MR keeps
its registered state and the completer still reports the wqe in order
with its original status. Only local ops can be in wqe_state_done ahead
of the consumer on an RC QP, since wire operations stay pending until
acked, so the check cannot match anything else.

Fixes: 001345339f4c ("RDMA/rxe: Separate HW and SW l/rkeys")
Cc: stable@vger.kernel.org
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 4f353abd76f5..fdb55366d668 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -723,6 +723,20 @@ int rxe_requester(struct rxe_qp *qp)
 		goto err;
 	}
 
+	/*
+	 * A retry rewinds wqe_index to the send queue consumer. Local
+	 * operations that were already executed may still sit in the
+	 * queue behind an unacked wqe waiting for in-order completion.
+	 * Re-executing them fails (e.g. REG_MR on an MR that is no
+	 * longer free) and would move the QP to the error state, so
+	 * skip them instead.
+	 */
+	if ((wqe->mask & WR_LOCAL_OP_MASK) &&
+	    wqe->state == wqe_state_done) {
+		qp->req.wqe_index = queue_next_index(q, qp->req.wqe_index);
+		goto done;
+	}
+
 	if (rxe_wqe_is_fenced(qp, wqe)) {
 		qp->req.wait_fence = 1;
 		goto exit;
-- 
2.56.0

