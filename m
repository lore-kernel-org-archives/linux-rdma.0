Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174949;
	b=U1MGU5IAK7DQ5b8QjScQrzjFYotRoHciRm/d53uHqMtQ4/fBiQAArOzvfz7VuFZQgJ4Q
	 QXxkdLoGkqgmF4BKIlJRO2WCgMD2fsKNRgRfIqr/sstk1W+h0GA2sKo9/ahtJRV0LoMzC
	 hWxbGqgjGHlAL78+jH8tXvLJ2UwUmMyX9Y5kJN73HdGj8XeHkTyy92rteqXmhYO3dakYD
	 AmcHuog6+PVD6xCmaBd99ZSYTGhBBnLaYYUbVMUqfcUIk+QgwltpXPeOvInLCLScLmeFx
	 F0DGtq0pwvyAeRnXqZQsaA7Y+dQcoygzu0p2NO0gK9nSU3w2jOyhzj4P5ghrysee3dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174949;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DF7mXZvTw1RDuVa5ppZVO6UyLu2N+9+2c00mkMOuaDM=;
	b=0cP4Mtb5RuthbjiwmyGN1VpYjKZA1Cy8nQzM1dYhpmZ6xpj2o0UR0n4b6yCKUQ+BcwyM
	 0yGCWpXCdutbYP5Ex8ChH1znSBOy7yZ6CGi7Be8qFrh8XyGtmH3osVKFnd/HG5bL4Hk4H
	 Hx6oKEfYeR5dAfEzP3vy6OBhaedWkNQ6RLjb/40fyoP4Vl7+VQ5jwZLHMtzOQovNZgW+T
	 BCj+rPVgPJDvfU0ngkNlgujQs2N5OkuTJCRoUy+sSB3uqfJ4Kg5x/IrJ+/nsFr7RfJmkG
	 WEXugajouInbZEKFyyVsEo+/SuPaFKcL8FQ3k96WotKB5Kq2+JaSmC9JFpvWDtAUedw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=SXSDi6Za;
	arc=none smtp.remote-ip=203.205.221.233
Received: from out203-205-221-233.mail.qq.com (out203-205-221-233.mail.qq.com [203.205.221.233])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B702606A337;
	Fri, 20 Nov 2026 11:42:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B702606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=SXSDi6Za
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795174937; bh=DF7mXZvTw1RDuVa5ppZVO6UyLu2N+9+2c00mkMOuaDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXSDi6Za0/NOAQcZP04T/uc8vxWiIunXulrXxNSUJwKX8FtuXRFVKUS98yq/+7JBU
	 0hA3vCJQqtVr1j5gwpYlTOVzeRHzEekm4iv/fQeAeSXByIVutl1d0LpRY5Lm5vkkyM
	 TDB8JqXY5S0e91YH7KFWTa31jq0R6ji+MnEt7ll8=
Received: from shuai-VMware-Virtual-Platform.. ([117.158.156.198])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id A8F85298; Fri, 20 Nov 2026 19:42:15 +0800
X-QQ-mid: xmsmtpt1795174935tvdaes88h
Message-ID: <tencent_5B9FB1BCC8EF36C5E2128B7D4D54B867480A@qq.com>
X-QQ-XMAILINFO: NGbyafB8LluuaL9kMVcdPeWjxflf6SMYiIhU3NeQbvBQYEzsK8M3JD0NfiFgMi
	 hLSpAcP8EenyfQqjem/14/ltCXWB1UOAz6VmLJuSxZt/v7voQ4QSeb3tBfbG1H5pigP1BGadfep4
	 KqFIXYOPElk+/sPWD4n4Wv40Xj/rOCBiV6KCIWgtE38lgeGh4c21imd6KdN61zbcLXRBltdU6ef3
	 nN73I1eRc1WRJJXPgclUI15KQc1FI2QMBagetGbaAkmvoVC/L1l/enIDkF2VVPIeVdApdj4GaU8N
	 eQZXcHvNh3G5mJ+wP4Jf4DSn+F6XQ5qu8/nnx1tPsQvam/XmCDH+/Izynrbi9ruDZKFO2cyVQLcd
	 CZGTx4Z49hvldOXSeo1O0GETazCVQaMJOS84qAlc8ENEph/q/ecI7KJ06XDsRgMPVngKJmwPsLW0
	 VAOCgD5CU4OZmUZBtyEO/vnzKXKCso61roPCeJsh0HsLzZC3Q5ptWzrcG3GH0Lk9DgjG1oF9ZlDU
	 uzu/jofe8F6NlO5Atkw1IvXdnbo9MmXpWQK5rVDVlogCDQsd2abwH2xmpdtrElF9m14SjRkihDJ3
	 TlKjbNxCTMepb5ZJrZ3CZSxZGzUa14zzJ3hIq84UUa20OCz2+CSmLTNSKA96oU+8DD6F50Z2mxCI
	 O9rBvDuZQZxtKmVwnjtVsAmQVZtVmz5soxjxsFjjQ76AuHoheGxFpZ6B6ZDXNx1AybBWEsNhuCOY
	 HQfH8haHUWr+ris4r+0deaYo06DSWPKS6aGiZDBjAzG16/6Ku6upX2KfjJAyy5/su72n/Nny0aD2
	 g7g+cUjleypV1bSSv6ACkILoX+h5Ljf9AEo8wFWLV43ApErOB4Gg3CMJpBnYiRsKKlmBTlJT/s2C
	 bAvkZHEbibjQPa4RCJVcHa017nYLzRhpoCx09Z1hMVWpghu3mffv0EHEQT2j3/L+7EDCcMj2/iSf
	 Vcoat8kx51+XNrPjga/VwOekBDRkvek9wCRsJ34ORyhvAfUlDjY8siHBcMUxX/8WrIUXQlLSmWFT
	 /oSZTV3ZZ/7zo7fqIZve6+S9BTOLgNvZTc74SRu8K5sH1lHdIyEVykvx/m5eQ=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: Shuai Liu <847807867@qq.com>
To: linux-rdma@vger.kernel.org
Cc: yanjun.zhu@linux.dev,
	zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	rpearsonhpe@gmail.com,
	syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v1] RDMA/rxe: Don't trust the user space SQ producer index
Date: Fri, 20 Nov 2026 19:42:15 +0800
X-OQ-MSGID: <20261120114215.419797-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6adb54ac.d1cee5ca.8df35.0007.GAE@google.com>
References: <6adb54ac.d1cee5ca.8df35.0007.GAE@google.com>
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

The send queue producer index of a user space QP is stored in the
queue buffer which is shared with and written by user space. The
requester reads it without any validation in req_retry() and
__req_next_wqe().

The requester stops processing WQEs when its local WQE index equals
the producer index. If user space writes an out of range producer
index into the queue buffer, that comparison can never become true.
Once the QP is put into the error state, rxe_requester() then keeps
flushing the same (already errored) WQE forever: the flush loop
advances the WQE index but req_retry() resets it back to the
consumer index, and each pass calls rxe_qp_error() which reschedules
the send task, so the loop never converges. The send task holds a
reference to the QP for as long as this lasts, so ib_destroy_qp()
waits for the QP reference to drop until it times out after 50
seconds and the WARN_ON(!ret) fires in __rxe_cleanup():

  WARNING: drivers/infiniband/sw/rxe/rxe_pool.c:212 at __rxe_cleanup
  Call Trace:
   __rxe_cleanup
   rxe_destroy_qp
   ...
  rxe0: qp#17 rxe_destroy_qp: cleanup failed, err = -110

Fix this by validating the producer index: if it is out of range,
treat the send queue as empty. Verified with the syzbot reproducer
in QEMU: without this patch every destroy_qp hangs for 50 seconds
and hits the WARNING above; with this patch the reproducer runs
cleanly.

Reported-by: syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fef38133c495aeb48297
Fixes: 5bcf5a59c41e1 ("RDMA/rxe: Protext kernel index from user space")
Signed-off-by: Shuai Liu <847807867@qq.com>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 4f353abd76f55..2f7396f40801b 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -48,6 +48,12 @@ static void req_retry(struct rxe_qp *qp)
 	cons = queue_get_consumer(q, QUEUE_TYPE_FROM_CLIENT);
 	prod = queue_get_producer(q, QUEUE_TYPE_FROM_CLIENT);
 
+	/* The producer index is written by user space and cannot
+	 * be trusted; treat an out of range index as an empty queue.
+	 */
+	if (unlikely(prod & ~q->index_mask))
+		prod = cons;
+
 	qp->req.wqe_index	= cons;
 	qp->req.psn		= qp->comp.psn;
 	qp->req.opcode		= -1;
@@ -168,7 +174,7 @@ static struct rxe_send_wqe *__req_next_wqe(struct rxe_qp *qp)
 	unsigned int prod;
 
 	prod = queue_get_producer(q, QUEUE_TYPE_FROM_CLIENT);
-	if (index == prod)
+	if (unlikely(prod & ~q->index_mask) || index == prod)
 		return NULL;
 	else
 		return queue_addr_from_index(q, index);
-- 
2.43.0

