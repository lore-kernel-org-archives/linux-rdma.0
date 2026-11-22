Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795374689;
	b=kSKI+l09f7XIgBzZx/bYW7Zl1HfyOjFqLAVvXUEfckA3L2TxxacqmIDaKaatzm7isHq1
	 niBoA2/Ns/skcsWX6iQfo/AY0NgIuuKLuh04xDGkZtGbZWIezmQxfe3lQrNg3EuPK4K0q
	 QX00mx07thDOK9hfTZXNPZGvvU7upWUpD8irw72v3nqZ6cDHOXEagCBr71EIO/FFX+6TD
	 d2/23ggvMYlugq/ZeDle85GOoFCqcQBcow2D3JJGBpXfVjE8lnvK7Fs4bOM4htxPG9t4e
	 01wIdWGPhcJz1U+AoeyTLhKxkYxxcAaLIbbPcEPRKCfnBdGXfacImVRwsKxnFftArkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795374689;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2GpSzR4G5U9X0KrEU6CxhUyVa6azEyHRM8XovyPKyw4=;
	b=JFbIIu6dPInvc8CSPFgvwLuNvOG5j2LhFROmG9J4Tm43tTUgM0toXImQR+GljN1ivo6a
	 7KAGrmVOD7c2mGcAi47U9dCw94SGYI8mydjCdrXpofPEVNkeJ72A/EHiHvmPKVbyRRJMq
	 w+Q8sOWZfvbbJQNDa0IVZRcjQaCxZS5YUMiC8uDMjzLCIRjFr3sy32cOQUSLu/QYaiMte
	 vJzIjWdOw4sDz53Lm3TJGnQnqSl24xPiWo5PoRAGl9lWWIVR2At1B2L2cJ2EuzYzyvpYg
	 eJjgzMkWV1yJEbo4Jio/PtF6n5ZErN85gRigd2O1v5moWt2chH4YB8mU8Lk43nlvtcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VM1PBTOV;
	arc=none smtp.remote-ip=209.85.222.176
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16391606A32C
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 19:11:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16391606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VM1PBTOV
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9496577d4c4so321142485a.1
        for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 11:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795374688; x=1795979488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2GpSzR4G5U9X0KrEU6CxhUyVa6azEyHRM8XovyPKyw4=;
        b=VM1PBTOVgp50bkFiS9MNgPv9jpbAUqgl2cSKf5aBhvUNm6Ls0zgqO9i/+ycC0ocbBY
         yeWkT9hyjyaomJ9DWbxopzlsgUIy41tpjLcShe/qIvJrx/30dm4m4IWCdXiW024SbqQs
         6qq5bO9dGdZ0oSpTZ/Epa9U5U8hw/Q5t19nBYvV7d9QF/mr7dMEd4YQ5D1alUlIh/b3K
         OfnrX/rhGPW+mglrCujyb3rEEkvthPhVxoWqu58EMIHyhsLFMP8F3+dRL2xqyIs+zwQw
         zFwWP43UxDFffv+zipFfSdS/3jek8mGgwDSyBmbSOTtxrxradXfAtQu4YSNjCDa+Czoo
         qmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795374688; x=1795979488;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2GpSzR4G5U9X0KrEU6CxhUyVa6azEyHRM8XovyPKyw4=;
        b=vfu05FAc22RQEs5sjFbxaJ18MEEnBMsQnyrwEvQ4MuC5mn0ChoEuGZJnlTO0mhsG3C
         DVXj4jgeLB/Lw7tx6aUbuT1hfdzuMtfcgsJwQ0bxnOaK51YXNQHO3hHoO3UUkOewvCNc
         Jp8yk+SwdH01VwiuuWHQsEHrunmhpEhRBbfsIiV38EePjwfKKo93beJw7xFMG/ZesXSv
         O7EK9PH2mgWiBtOLnixdcY53Zxai6Pnwf90/T21IamJ4aO0lR8vY7Fa5n0JnMWzMhrPG
         4VnyW6+1n8okx9Aknw7mVo4mxnmgCfGofBuRdT6h78U2E5ds63yLnUadsDTcwLKloMT8
         oa4g==
X-Forwarded-Encrypted: i=1; AL+hErFlGPUxmDDIczGUwA8/ItBQFIhcE9Gw41zVT95Xp8e0c0sSqSJaKy4zZDwBhtoxnhK4p65PyT2SVC8K@vger.kernel.org
X-Gm-Message-State: APuU4Z99vqBDDShSj1IIhOy9eIrS9uWw/fXhUtJf30nYtVayQ3Th7oSo
	bjHlXg2gNtfKvD5Y/HKscqPzQ+5bE4lZmXog2xFPN6PINXzNiTVFWstl
X-Gm-Gg: AZFdTZdP+GH8Pd1rnH/jnjBQOiHNjGSk0tJSthMcjm+GKgephTcxjbt7lasEwYzTwCW
	Gu20qU2Tv68u7kXMHVuNDC1r9ZveONSwG6nAgMJwBfcA9JACDVJspUWOmYnrW3e+nUX0eBGc5xW
	pE518yx3S+IMz9OE+/DxbaNL3E5oQ1Y9Ry2Is7UdoFgOiTbQTFRtWdt/ZyBJyE2O7sgtBgJgrCS
	wIFjeH65th+o9vMp/dQo3SMj2ftZ4C6C4Gqv/adeDbfvErjBWl9o+zCgbX/S/OjfLjOko6okvHF
	ecQHADxTu35Q2H5BF09xyqWalcXoLnXfltTFpBMofKI2snjwwV7pttXBmXTPnMyYJ294Gr11AIE
	je9zg1ANjqVJfAad4VjGbJkPT/PWalGsKiQFVqcvBskBvMGt58RMt8GrRA+XcSskK6t4GRDP8Gs
	AjQH9TgVB5N9B/lE4ZeZTZSHq762qjPj3WOFP8BEJnNc4pDnuMocBiJRR1D1dB08eAKWKpl+RSZ
	515+6qwITWGZXJ40GftMf31+o6a0PiTo/4RsveGmiB4baX8AjCtacOIuy1/Y+166fIyLlBjXLUc
	JvS4hRJ/ezVtvIi2bdWyQrmfDxMzdTwfV8G5wnY2edzMhGHv3UrsB4LLt97RQX3JjVCATX34W+U
	d5iaLEaiJh3Z0YuWA09YGoYnplXRZ3/3uzYJvmTlEusnHzN2U6FqXA6YxCrj5OYoh1ysdATiP+7
	ZGC76rjGH6yPYoa9dek+IstJrsOw==
X-Received: by 2002:a05:620a:2986:b0:949:aceb:b799 with SMTP id af79cd13be357-949b357272amr1785474285a.13.1795374687873;
        Sun, 22 Nov 2026 11:11:27 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:c8ee:a73:9097:862f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949c555faf9sm536397585a.0.2026.11.22.11.11.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 11:11:27 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Bernard Metzler <bernard.metzler@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/siw: Don't send stale data for a queued zero length Read Request
Date: Sun, 22 Nov 2026 14:11:22 -0500
Message-ID: <20261122191122.65240-1-astellman@stellman-greene.com>
X-Mailer: git-send-email 2.53.0
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

siw_init_rresp() queues an inbound RDMA Read Request in the inbound read
queue (IRQ) when the TX work request is busy. For a zero length Read
Request the IRQ entry has num_sge 0, and siw_activate_tx() then leaves
wqe->sqe.sge[0] as the previous work request left it.
siw_qp_sq_proc_tx() sets num_sge to 1 for every Read Response, so the
Read Response is built from the previous work request's sge[0]. RFC
5040, section 5.2.1, requires a zero length Read Response.

A plain TCP peer that speaks MPA rev 1 sent two Read Requests in one
write(): 64 bytes from an MR with remote read access, then a zero
length Read Request. The second Read Response carried the same 64
bytes of the MR:

  Read Response, sink STag 0x11110000: 64 bytes "SIW016-REMOTE-RD..."
  Read Response, sink STag 0x22220000: 64 bytes "SIW016-REMOTE-RD..."

When the zero length Read Request was sent 500 ms after the first one,
its Read Response had no payload.

Copy sge[0] from the IRQ entry whatever its length, as the immediate
path in siw_init_rresp() does. With this change the second Read
Response has no payload in both cases.

The issue was found by Claude Opus 5.5 running Quality Playbook, an
LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with Claude Opus 5.5 and
reviewed by me.

Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---
Tested in QEMU on v7.4-rc3 with KASAN, with a plain TCP peer that speaks
MPA rev 1. A reproducer is available on request.

 drivers/infiniband/sw/siw/siw_qp.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
index bb780e3904a..f3eb1c85f3e 100644
--- a/drivers/infiniband/sw/siw/siw_qp.c
+++ b/drivers/infiniband/sw/siw/siw_qp.c
@@ -972,14 +972,15 @@ int siw_activate_tx(struct siw_qp *qp)
 	/* start READ RESPONSE */
 	wqe->sqe.opcode = SIW_OP_READ_RESPONSE;
 	wqe->sqe.flags = 0;
-	if (irqe->num_sge) {
-		wqe->sqe.num_sge = 1;
-		wqe->sqe.sge[0].length = irqe->sge[0].length;
-		wqe->sqe.sge[0].laddr = irqe->sge[0].laddr;
-		wqe->sqe.sge[0].lkey = irqe->sge[0].lkey;
-	} else {
-		wqe->sqe.num_sge = 0;
-	}
+	/*
+	 * Copy sge[0] also for a zero length Read Request. The TX path
+	 * sends sge[0] of every Read Response, and the previous work
+	 * request's sge[0] must not be sent in its place.
+	 */
+	wqe->sqe.num_sge = irqe->num_sge;
+	wqe->sqe.sge[0].length = irqe->sge[0].length;
+	wqe->sqe.sge[0].laddr = irqe->sge[0].laddr;
+	wqe->sqe.sge[0].lkey = irqe->sge[0].lkey;
 
 	/* Retain original RREQ's message sequence number for
 	 * potential error reporting cases.
-- 
2.43.0

