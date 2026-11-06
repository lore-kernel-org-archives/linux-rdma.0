Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794003134;
	b=mQ52Q1AtRKhFhkD+Eh1kTF+QGrx6AxNUjwIRUGtyOqTK+75IbvDAc62EIRuLMrvKK0tF
	 RODDfOhEqef0Z5RsM3H8xmByj/uK5ogs4uFWeOkwxJ0FWvqjzfxX4/Oh6hgkgZhuMXvGu
	 LYi2rUVGZm/1GGNo0hyCeTUc6r96lWpGBt5g9JiGvZb4NsP9EpgvjU3sUk16EPoABQjL0
	 fhzyBSR+T+ajPz2h2MdyeH2mbQs52tYmij1z1HjdTd6KRfHtn6Cg/4X4JsSnLIFx9jyMS
	 MkAZb0/+77WB3duBj8wZFSfVBSYnBEa4NRVPjGHivItDL2U1tJAX8MpcSqCjeC4iZlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794003134;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=P4WslyGEpm5DMO3yHzEDgZloAN0KLUiYlagEpVLQDqA=;
	b=1l2hP/QCWsBtUxj9rQUF/to4GUZ+7LAZU4TcubqXbPQvlh/0JtfmGVbkUHB/Cyq6E/5m
	 oZc9qG+PyCPzBM6dO2JNpGVK397AW0k8+aP6qqShjRZ3QWZ7RErT1OULExx6ES25F0w2d
	 z+GzLhnrQ+sQlcu1YhTs/Us8pzp5g2QEySp13S2LNkk9Ci5A0bIvWlBaamlg2rK+y7Qam
	 SI0Bw34mcTJa503JebxPLcUs4VM7njbs0dSi3g+AnQX8T1QXdP8KFcsizW9r5a/9kfCnp
	 PZDPQ8G73j6Kr4/Qbv/f0u04NtPaNrtc8WzGqmo4/N19HcET8LV+AcpPpx9E0PF1iLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GrxLGQvV;
	arc=none smtp.remote-ip=209.85.128.198
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607FE606A336
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 607FE606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GrxLGQvV
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-8a88d53c7a6so15662367b3.2
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2026 14:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794003133; x=1794607933; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P4WslyGEpm5DMO3yHzEDgZloAN0KLUiYlagEpVLQDqA=;
        b=GrxLGQvVckUUfQjoVmNrfyXMNn8HxrVHe1Q3dfiqUD4lQ3JzJNYAWmVDM4OnKzSF6/
         EwJwAjhhA+Pm+mHH9KGjekkaSvCQrXlABc40WR5GcJazlGZ3gKmkFDxDmjGZf1FgD7ke
         vID0tvsgxlxQhckMrAEGx00c06MMfJca8F/X/ap+hkOxJTRR1eX9Dd6HiPD6HYQaHCX7
         COqIaolXaiXpp0CYCmC1Cn/yMPEF5E4Ksx0cXyxwXFwjEEgL1+UoZEUQJyFtF6r2uHaM
         aDhmlsMGkGwj7k53zy5pux+dwxD6jv/ZT+egvT6pUNlZ5L/w1TZO1M7JsHJtUVuBG4bf
         ldxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794003133; x=1794607933;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P4WslyGEpm5DMO3yHzEDgZloAN0KLUiYlagEpVLQDqA=;
        b=j/pmIuh5KVe7HcXUg3TYsUncjVtcxShcLPCTdRs6k9cfinrBoG/qHe0yf01cRWyqFP
         uJW2CPFx+xHQrXH9zMSpU4p+mZjp8sil6olzttWXxPfHeSbT5VkYk+05791D2cT9zuoq
         deql0cEsYTshG7M/LF/XUjoTAVq/wc7H++ZLzurBq0jcMreMZ9buzncnwvQuaYAGSWLE
         dkBvG6NboO7bxe7PMh5y3gf8kh0aBPnA81BGrfech2njwWGwvAz4KyTWXpXVWbyaQXw1
         Zq7Ov3LU0RccgO8BoEaj0U+BG6UtXWBDQXSbevsnqFc947rBB9bCbjGwy0+Fdm70H/pa
         BXzg==
X-Gm-Message-State: APuU4Z9xbD/eiVDnv0ejO7yc53lXryHoAskFCBicJJnEGZ4lMQUGBuQq
	klsqlOXZ996E/xBoB8Pa/ZxkqpzzX/41cnKSSzwg4Jv7acVYGsYXd1dqQqKxg7MzFC+H+ptHxRu
	CThrbayUCNA==
X-Received: from ywbhq5.prod.google.com ([2002:a05:690c:63c5:b0:8b1:26db:a6d3])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690c:e1ce:10b0:8b0:ee4a:326c
 with SMTP id 00721157ae682-8b341b651a8mr13886097b3.111.1794003133226; Fri, 06
 Nov 2026 14:12:13 -0800 (PST)
Date: Fri,  6 Nov 2026 22:11:57 +0000
In-Reply-To: <20261106221201.2266301-1-jmoroni@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261106221201.2266301-1-jmoroni@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106221201.2266301-2-jmoroni@google.com>
Subject: [PATCH rdma-next 1/4] RDMA/irdma: Fix QP handle assignment for SRQ completions
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

The QP handle comes from a different location in the CQE depending
on whether it's an SRQ or normal completion. For normal SQ/RQ CQEs,
it comes from offset 8, but for SRQs, it comes from offset 40.

This was correctly handled when the QP handle was initially loaded
in irdma_uk_cq_poll_cmpl(), but there was a leftover re-load of
the QP handle later on in that function which unconditionally
loaded it from offset 8. This would result in a bogus QP handle
being used when processing SRQ completions.

Fix this by removing the extra QP handle load.

While at it, load the QP handle into the u64 comp_ctx and cast
it rather than loading directly into the QP pointer since this
could overflow on 32 bit systems.

Fixes: 563e1feb5f6e ("RDMA/irdma: Add SRQ support")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/uk.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index a34883fe9983..250267ef5727 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1220,11 +1220,11 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 	is_srq = (u8)FIELD_GET(IRDMA_CQ_SRQ, qword3);
 	info->error = (bool)FIELD_GET(IRDMA_CQ_ERROR, qword3);
 	info->ipv4 = (bool)FIELD_GET(IRDMACQ_IPV4, qword3);
-	get_64bit_val(cqe, 8, &comp_ctx);
 	if (is_srq)
-		get_64bit_val(cqe, 40, (u64 *)&qp);
+		get_64bit_val(cqe, 40, &comp_ctx);
 	else
-		qp = (struct irdma_qp_uk *)(unsigned long)comp_ctx;
+		get_64bit_val(cqe, 8, &comp_ctx);
+	qp = (struct irdma_qp_uk *)(unsigned long)comp_ctx;
 	if (info->error) {
 		info->major_err = FIELD_GET(IRDMA_CQ_MAJERR, qword3);
 		info->minor_err = FIELD_GET(IRDMA_CQ_MINERR, qword3);
@@ -1268,10 +1268,7 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 	info->qp_id = (u32)FIELD_GET(IRDMACQ_QPID, qword2);
 	info->ud_src_qpn = (u32)FIELD_GET(IRDMACQ_UDSRCQPN, qword2);
 
-	get_64bit_val(cqe, 8, &comp_ctx);
-
 	info->solicited_event = (bool)FIELD_GET(IRDMACQ_SOEVENT, qword3);
-	qp = (struct irdma_qp_uk *)(unsigned long)comp_ctx;
 	if (!qp || qp->destroy_pending) {
 		ret_code = -EFAULT;
 		goto exit;
-- 
2.56.0.455.g6c5a503b38-goog

