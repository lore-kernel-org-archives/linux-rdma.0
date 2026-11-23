Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442788;
	b=ZNb8+S6Ndm+Q8rwuOfe3AzhUP5iLyXYpFXWRksLE8J/tEDVAXXRnYgECUlwOTKMRnhYq
	 PjKxzu7WfGD28BIwLB5ZhsfttIykqFUb7ypfWGZ7t/sRvjvyVs8TeLKyRCClWCR3Tv/Dw
	 /6CUMniQjdScF2ow0v46/A0/wt9jyXjPtlbrDy2G+tZEW7YsYW1gerJwVfGWFmR10VhRR
	 ILmxkSNWhvNd5qcAK7YNq7fc+pSzONUk70pGS41LaurxUBH1moqmhssLy7++d+TiH8WlL
	 Eap0lPHg4MdZdUDdI4YmcL4gZFC2PwH+hcf+DVbmwCYdUqnAQI9U6shRw+W6KU84gXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442788;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Bu5wY55r6MxEDWtvWV/v9nM7+LfCe+RWbKpq2oatC5w=;
	b=tUFjnxBQqHElKf1pgOwnfikBHzNvXziF3j4bhqQnP4cF9qyS+5wM+RI0hThRX0eepl1T
	 lUzk8C/08nUP0J1oo2uY2nJyTd4oY2BKv5QgsvTA0lJhyLtsTJVFDDv+Ia0j8Vjikcr0P
	 gef0ePi23KI2i8CYyPwiuxNpk3QTVsFyB8aKmWusx3lebjwgLI8ZqeFr8ESSs0OrIq9M0
	 +lfq3mxPTVWZRNW0CuNve1H2B3gsDa1ITXRabnGFCUvaCFq4fo1YnMKvQQbmffvYou6bm
	 1hrO2RJaZ+1vCZo+CIwIGwfomlb7PHArULEugoZlLrk9lh+JlR97GUo6CgSsODSi1GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=stellman-greene.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OAaxT1Ha;
	arc=none smtp.remote-ip=209.85.160.170
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC92D606A330
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:06:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC92D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stellman-greene.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OAaxT1Ha
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-537548b811aso28397831cf.3
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795442787; x=1796047587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bu5wY55r6MxEDWtvWV/v9nM7+LfCe+RWbKpq2oatC5w=;
        b=OAaxT1HapvnkRFx8BdOhkETfVDa2kMX0iasWTpYBdgmsIC1o5rMUNXeUdcCyHH4nT/
         XqUcDDSu6VsK97gfoURNIXaNN0tmEMcIHLZ22qxJICETJHi2BCHaZCdpglqrnayxDlei
         YBr20RknzY5kscvp9qgJHTzXfPYaMWkRTzprLMIboGhpdcghtm85IvHyUj2YSorzIerm
         OqNedr/UVCQXoa5OpSbUvPT/BhdjqnonmLTYop98TGByW3DBfWhi1eaoPzvsIHAtYg4/
         oy5O4hNSSjvkCkUHH0zOcgxL3rX/+OJGyGpyTMx+S+Nbt9m6bteMLNkLULUjDDpHNidG
         iFAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442787; x=1796047587;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bu5wY55r6MxEDWtvWV/v9nM7+LfCe+RWbKpq2oatC5w=;
        b=upu3kDuYUw+GU/RvUTeq5DMK0/Lax8BG9i5QTgT2Zasc73Mu6ayDc7mkgra37u+xj4
         Nc3dD0U3iQnZp0cOhm5n4RsXVib58pOMoNVjubAyqLBLNjTxsFnaUiOWDRhzE1/3oJdU
         RfVOl02ti7aSRxbigXC7kBpdq1UMdR5NG/n/QziwunOZl76x281YHtdNHwCjkqjOP3dJ
         UQPd6ZnLboQTSZP7m7ON7EXGTPN/cqZGTj86X8DbfRcGxl+jVxVoGoTHIO8E0mjkQV0g
         0rHn5bkbtSxzhM4tSXjxEaQEGOzcwEbaIN+lo4NpmZRcVPxm8liWcZuOMKNYkPhhHZud
         lGNw==
X-Forwarded-Encrypted: i=1; AL+hErHBbORVYHT4fcBKny3u3UybZZd8jG39mQ7kXqSKXbXjfDMBA9jNvJRJsMRtWGQwHT/M3RgG/tAvf3Yh@vger.kernel.org
X-Gm-Message-State: APuU4Z8DfddpFMKbICoArfSmMKwKITMXVaVmPg/bvX8KTQRlFbZLBkVR
	l1ctcTBDucJT2M1wcAcd3YOdJjPDjLIbqz6vPoQeW8wOHPKpGMlZhNgD
X-Gm-Gg: AZFdTZc7X9yhlN1rEEmnJ25hG6iNJnWENmfkLgn49jovEIBvu/Lf2d9E2apaBu1CvAM
	hqSUM1ZQAzHDpFnFRbAsHLa76PKmrFuDjPVzYM4C+YUXd3S68mWMh9Y/LljHW3klQFgfPpHrFhu
	5+UT1Yx99znj8GzjSMbi9eLimF8YKRuqacylTXI9Fd6MVz6/A9v54YUr1N2oaLwGhOml7c74r5z
	Ieg4U0JvLsls1+K3CZpeZeGM9uzjuR4dJ2ISMErj6yooxU+Harm1aa1q1G8BENf3DAICtbtvUmP
	5qzOCVS/a0zVNjRuR+oY24QAmyxImQxhVk4V6YMEwgd5MlAtUwgfcln66FwJkH5S2en8RbseiDk
	9pxm9laEombE2nyRh9kK2QlrR/8K5FAQWESt0lVaGnyjdxyIT/8M0Y9FRT8VVVA/3BzasvhDcIT
	f2ON3DM5rpd2VWpMQrPW1TMQtk2O/yMnbcWSg1JFUZC2LwHo5mHb9fulMqCdqygKpMNY7P/9Iyl
	luu/BaN+TSXgC9hDPNo+f7Zv6YysmXliBiRvXjBhFFwXQ/DKDkugsb/+9ng11c/5i/bgwGD1B1w
	QxS6YI3H2KjXcj+IgAoVmu4Aj0qptB+HdN+Vxd+IIH5eyfaByMXMZxe0uOO6yg2Tu/sJ17PpFMo
	xjgnNyRqmnpVvnnRWjo0uugef+KfBfGAee7Np3zoB/a2KhM+8oVGHDW2czSrBL0xSmeXbAisjzr
	9tnlzXRW5L0fzD2QvIvX6jlD4HQZ0=
X-Received: by 2002:a05:6214:1d27:b0:91e:8e90:90af with SMTP id 6a1803df08f44-92134987eb9mr224158296d6.1.1795442786561;
        Mon, 23 Nov 2026 06:06:26 -0800 (PST)
Received: from Mac.mynetworksettings.com ([2600:4041:5c28:200:c1e4:47d6:99db:6f6c])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349b0b10sm107672366d6.10.2026.11.23.06.06.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:06:26 -0800 (PST)
Sender: Andrew Stellman <stellman@gmail.com>
From: Andrew Stellman <astellman@stellman-greene.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Xiao Yang <yangx.jy@fujitsu.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-rc] RDMA/rxe: Fail ATOMIC_WRITE WQEs whose length is not 8 bytes
Date: Mon, 23 Nov 2026 09:06:25 -0500
Message-ID: <20261123140625.64448-1-astellman@stellman-greene.com>
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

For IB_WR_ATOMIC_WRITE, rxe_requester() uses wqe->dma.resid as the
payload length and finish_packet() copies that many bytes (up to the
path MTU) from wqe->dma.atomic_wr, which holds 8 bytes. For a user QP,
resid is written by userspace in the mmap'd send ring and is not
checked.

On x86_64 v7.4-rc3 under QEMU with KASAN, an unprivileged user wrote
an ATOMIC_WRITE WQE with resid 1024 into the last send ring slot of an
RC QP. KASAN reported a vmalloc-out-of-bounds read of size 1024 in
rxe_requester(). With resid 64 and 1024 in another slot, a test-only
printk in the responder showed packets of 64 and 1024 bytes, including
bytes I had placed after the value in the slot. The sender's completion
was IB_WC_REM_INV_REQ_ERR. With resid 8 the write succeeded.

The responder already rejects an ATOMIC_WRITE whose length is not 8.
Make the requester fail such a WQE with IB_WC_LOC_QP_OP_ERR before
building the packet. With this patch, resid 64 and 1024 (in another
slot and in the last slot) completed with IB_WC_WR_FLUSH_ERR instead of
IB_WC_REM_INV_REQ_ERR, resid 4 also completed with IB_WC_WR_FLUSH_ERR,
KASAN reported nothing, and resid 8 still succeeded.

The issue was found by Claude Opus 5.5 running Quality Playbook, an LLM-driven code review tool:
https://github.com/andrewstellman/quality-playbook
The fix and this changelog were drafted with Claude Sonnet 5.5 and reviewed by me.

Fixes: abb633cf2804 ("RDMA/rxe: Make requester support atomic write on RC service")
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
---
A reproducer is available on request.

 drivers/infiniband/sw/rxe/rxe_req.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 4f353abd7..bc3d5cae5 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -766,6 +766,11 @@ int rxe_requester(struct rxe_qp *qp)
 	mtu = get_mtu(qp);
 	payload = (mask & (RXE_WRITE_OR_SEND_MASK | RXE_ATOMIC_WRITE_MASK)) ?
 			wqe->dma.resid : 0;
+	/* use the local copies: a user QP's WQE can change under us */
+	if ((mask & RXE_ATOMIC_WRITE_MASK) && payload != sizeof(u64)) {
+		wqe->status = IB_WC_LOC_QP_OP_ERR;
+		goto err;
+	}
 	if (payload > mtu) {
 		if (qp_type(qp) == IB_QPT_UD) {
 			/* C10-93.1.1: If the total sum of all the buffer lengths specified for a
-- 
2.43.0

