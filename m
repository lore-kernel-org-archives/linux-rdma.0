Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349470;
	b=xHrRgsx4JqhDEuP+7/C3arINb8jDY11EyohATcJCNzm81dSp8G6JYp0V/ulayvJjTex0
	 x4LcDSmd6lg7HvC9I32IAGkc2BD3AeiF8SLmLWROekoa7hEn7ktvgqWBoNoORzsVF5kq/
	 omh7XQa1oSeds6QF8pLag0C71aNVi4H+ykhluiJwEiYnH8HPQfETJB/aeSLKkp/c9Mfb+
	 gFms+iQr+GF3pTAosFSebSKtbY8aaRk6cQ9ANn6K3zeatctQS3EsfAf02uU3E0uQBGsSi
	 N5+PUODsvzwyd4WhpSy7zdC8Dxfsurg7f6FBw75/WyI0CR/6abWyIMMxtztJO+vq28A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349470;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EBeS7Y1h+n1TS1fYH/iVVovPRJYz5qCi7WG3/RLe+mQ=;
	b=GSE21lxWl3VH63Y1qI2mk70PFxqm4BJWyVN0Kj3m8e+1kDyCGnnHBgOFlzSceLMPOgdQ
	 YhsM79vxrYo8fougXRFK+Hhe/tgrgV2U0wG3FKU9kzMS3yndgRvIqr7Je911Ly93Tjt4i
	 vkP8K2lsbagIrvyXx4RFReRVwPSh6hh9tCZ3Uw1VF22KWKMsJoPmHqiCg2RPPgebbkXRL
	 mBDHwUulNmgBA5mAkztEq/4cIPZVLAT8IXOkzyedbE5n1aDkP70yrFNMIWLkxWUBlE2qL
	 D1Ss35ge6ogNwH2bdjfUIHoOtGG+FWM1zpcKfP0Jcw27EgaF1GUS6Q8grwanx+T28Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wWD3spZB;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C05606A326
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 22:24:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89C05606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wWD3spZB
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso4873784eec.0
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 14:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794349470; x=1794954270; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EBeS7Y1h+n1TS1fYH/iVVovPRJYz5qCi7WG3/RLe+mQ=;
        b=wWD3spZBqdkBsKXg2//dXCaL1KoOC0mC5l/ga4Ed/fPmhyA1O/0XxD2M6dr8Z8ahL1
         BQc8ybMtzpR3HK9WJ8H7E8/HMXDCJgPiPay+Hkzlrbcw8eKl0ieGfEdAsc1dulWSlklC
         3tgUP5TufP/1AYB+ikYSgt35uS25CbbWMY/oelHdOtWYEqRJc7ieXneLJD9fcw+sBtcU
         6eZQex9eIRW1Vjoo6MxHuu877kzGAxN6GsvLvB9/k7ZGyqKutYYaSLzTMHTxqdM0rfQ+
         JD9BRqrwALOHzvmWooTHUdSeF9bhHtrGtFyEudzq3n1U0ticE3DzkQd0BcLy38IhaE9f
         6KKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794349470; x=1794954270;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EBeS7Y1h+n1TS1fYH/iVVovPRJYz5qCi7WG3/RLe+mQ=;
        b=XJmVOl9k/W5NH1o2vzdWzzQ0BvXR2sDFxrkbgW4V3B6ygzlM4NOYwEnEBbSxjzIPG4
         a92k8E0PGox2AfVc7H5R4vjrJANcZ3hg9Nhl14vppZGZWPQu3WlvevaznnN2URFbhkMg
         DOalxtpvu26Qy3grZH2EKjlHV5slyKqsw0Fq1Y5aesN9QpfWaRE2yMFkBu+iiRxouvpp
         ZoueFCVGfLSZ4UVbk+W+FOu9HSJ6B/SMTLNmWQmnQPNuV69owycpRFn9i5HDRkGqZcBT
         SfvpFt+NyBmhKbFL387zrTb+8+FPPKmxHl2FxfLnlIIcMd6erzyL+hKvlptFRoYpjvne
         fyRw==
X-Gm-Message-State: APuU4Z953Rhr5efCDu5MSqdLysRvBZtjBMVHybLPWfZQjMVNEn0HWkxn
	sHyvmzdLQybyg5fpO8azJVjQi6iVihCz9dLyQALoszXndycF+8FiWy8V
X-Gm-Gg: AYBFou0dA3g3tXI1CUs+G2rM/xUld5CKJsQysxCNWqbCOJUElLgKw2NZ/RIP6C07XDb
	D7k75tp5znuNgmQNR0Xb4W5izr5jrHkxQIpjQKrpU8XdtY8lt02/O+mJGdGPBu/C5oq8c/UMqQY
	xhkYacCyN1v46oput4DIxqP3nWP5J1n9rmaXlXpSzzCTLUGbJvL630N8wFDXjXqcPc4hMwKWqdP
	yskJBMFwBzS73D1i0jGGcTkiy8M0kJXG8QSGDkzwoi0tNk/2pgqf/dt72Cx5+8fmzm2QSC+SY0Q
	UE1OyBPFgPh1USxuTOLIkDHQoUS3algbKBBZhE03mR4W/veYpzJkf4JEkwYVqes1GF2J1z32tr9
	wCM35joL3sxg16y06J+aZCgwevQREMiWRy/9Utz0J5pMJNRt/PXm6PFZEd1Dk/RtmKsAmvRD+V7
	UK6Fv92p7GYj9tEsG+nCpYPyBKG4eR65/IcvqFSsHc7r9imRzrCoqPhMO3XkK1YizhGyXR9RWr0
	RUMPSdT9syYd1M4Hw42fWEhQMlzIXdFbAH35o/t9YFlCopkqEZ4uyPMbDRJW2VY2S6TINkvC1W7
	pxW7XJ4gTjx2IGDb6CuwCJnAUghhYM80/aaXF5HY1dtXb+xo04wVHKEIpGTl
X-Received: by 2002:a05:7022:ef16:b0:1b2:4188:840b with SMTP id a92af1059eb24-1b3c0311ab7mr489976c88.25.1794349469455;
        Tue, 10 Nov 2026 14:24:29 -0800 (PST)
Received: from localhost.localdomain (wood.seclab.cs.ucsb.edu. [128.111.49.37])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b11346sm11566320c88.7.2026.11.10.14.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 14:24:29 -0800 (PST)
From: Praneeth Balasubramanian <praneethb2002@gmail.com>
X-Google-Original-From: Praneeth Balasubramanian <praneeth@ucsb.edu>
To: Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Praneeth Balasubramanian <praneeth@ucsb.edu>
Subject: [PATCH] RDMA/srp: Reserve send queue and CQ space for ib_drain_qp()
Date: Tue, 10 Nov 2026 14:24:21 -0800
Message-Id: <20261110222421.205573-1-praneeth@ucsb.edu>
X-Mailer: git-send-email 2.25.1
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

srp_destroy_qp() calls ib_drain_qp(), which also drains the send queue.
ib_drain_sq() requires the caller to "ensure there is room in the CQ and
SQ for the drain work request and completion".

SRP reserves that room on the receive side, where the queue and CQ have
queue_size + 1 entries. Commit 9294000d6d89 ("IB/srp: Drain the send
queue before destroying a QP") switched from ib_drain_rq() to
ib_drain_qp() but did not grow the send side. The send queue and send
CQ hold exactly m * queue_size entries, which is the most work requests
SRP can have outstanding. If the channel is torn down while the send
queue is full, for example during error handling after a target stops
responding, posting the drain work request can fail with "failed to
drain send queue", or its completion can find the CQ full. The QP is
then destroyed without the guarantee that ib_drain_qp() is meant to
provide.

Add one entry to the send queue and the send CQ, as nvme-rdma and iser
already do.

The missing reservation was found with an LLM-based tool that checks
callers against the rules stated in kernel comments.

Fixes: 9294000d6d89 ("IB/srp: Drain the send queue before destroying a QP")
Signed-off-by: Praneeth Balasubramanian <praneeth@ucsb.edu>
---

Notes:
    This was found by an LLM-based static analysis (GPT-5.6) that checks
    kernel code against the rules stated in its comments, as part of research
    at UCSB SecLab. The patch and changelog were drafted with Claude Opus 5.5.
    I reviewed the patch and take responsibility for it.
    
    Testing: builds without new warnings with W=1 (x86_64). Not
    runtime-tested. I do not have an SRP target setup, and I have not
    observed the drain failure myself. The change only follows the
    ib_drain_sq() contract and matches the receive side and nvme-rdma.
    
    The patch applies to mainline 9ba46df34488 and to next-20261109.

 drivers/infiniband/ulp/srp/ib_srp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 955f36efeebd..2cd0b728424e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -546,7 +546,8 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 		goto err;
 	}
 
-	send_cq = ib_alloc_cq(dev->dev, ch, m * target->queue_size,
+	/* m * queue_size + 1 for ib_drain_sq() */
+	send_cq = ib_alloc_cq(dev->dev, ch, m * target->queue_size + 1,
 				ch->comp_vector, IB_POLL_DIRECT);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
@@ -554,7 +555,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	}
 
 	init_attr->event_handler       = srp_qp_event;
-	init_attr->cap.max_send_wr     = m * target->queue_size;
+	init_attr->cap.max_send_wr     = m * target->queue_size + 1;
 	init_attr->cap.max_recv_wr     = target->queue_size + 1;
 	init_attr->cap.max_recv_sge    = 1;
 	init_attr->cap.max_send_sge    = min(attr->max_send_sge, SRP_MAX_SGE);
-- 
2.25.1

