Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793385253;
	b=lDB7xUXrhj1tLkAviH3xLHxXwzWJWjam/3U0z0C+tF4zf86Wwehs7qyVfDnXxM6BgxLs
	 /bmLFpkWIYxNSmlWCYj4o/PAwG90yaCelBeY0DM/7KYR2m4cLfJ9EuI5e6BtPVEb/jY1G
	 Lw3oRwHmu6GYOrJTPiqmfvjBf7RU5exlchLF45Ocnpww0jnzU6bRY39okydQyz4Rh8wfp
	 ttcJXT96Z6UnDiPutPV47PiECggF25IER2yGpQQIqpwwwFDRoozawNiXubRnf1icLDBVD
	 38QkG3FIx4kp5T8xL/HZm99lSjUJy6d002lP+xhEgeO4SvvviWvBi8MTnwLqgmaVyDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793385253;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=or/hcrtFhExIO4tP3jPbR5S7A2yzzhQGok/N2Gaa1/s=;
	b=jdH1vEwMKTI6irmPmTt5//C1+ifGlztCf4oGXHdPYSci80G4TCrPmTVvVF0vNw5B+v7q
	 UrL+m7gDlLM/tWx8gUtTE69paLcUc/YeLhypslILlacRMmEAzWIQyxwuw2MsNyqNtxvjV
	 ifg6Uanr8ZOOE2+VrDCj4z7L8qOu8WUdHwF5ZvLB6/eO3bcolsHDIRTv1DgTt3AJSa9wG
	 PUhtoitqsC/2Cn6HXSNvsNbA8V1qOqbBPk/oO7BPhOiYgdKRDXXSupVecDk+ksZoPqQBC
	 mEiTQzoWuvFKshTuLLFx9z0StiSv6dvTwHLzAnsbYswXU08Ckf64w+zhZ4bqbqCQM7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Iks3YX2/";
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA2C606A31E
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:34:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CA2C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Iks3YX2/
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so10321945e9.1
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 11:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793385251; x=1793990051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=or/hcrtFhExIO4tP3jPbR5S7A2yzzhQGok/N2Gaa1/s=;
        b=Iks3YX2/0EiBYpxyRq9L/+JpAh+bHfsk9Ggk4ukRqOCtNBgh/yBwrfZGim1/R3oe9q
         3yyd+xRPlNqupipQRP14UnptNdOpAD9FrTyheW7gQYXffUddQoov7wpu4d1+LBpI8owP
         XR+ZElHljH/+LZbhB/adYGkKbDqxYsksqBZOEVY0Tpx/KR8H27PvTfVR4xUwRNrq4LW+
         UEpDuSMUJ1gykpC85h9FBkqWPrgq/Moz9MuDxXLr5YOTC1dQ29BsZlN9TEJ50j+Whspz
         uuoawIk2OIL/sveoQdA0VreCFJXKatLvpWo9Uuf3pPVZ6lWTYz7jyTgKwz8OZ2O2NgNS
         3wOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793385251; x=1793990051;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=or/hcrtFhExIO4tP3jPbR5S7A2yzzhQGok/N2Gaa1/s=;
        b=vyjBEUJBBr4MIjcoCgd+I6VOUvgIVTxr/Q5Zl+UOcqsByst2Ymkug7IP9VYO7nkwTj
         Hq7rA7t5ZNB1ju0pJqksGDoHCrevgdTWS81mnYJ2tSFxA7Q0Z3wuj13BYUPpXyUUHhbE
         LVLyfg5B9C1ZvkXUR7bzZxQqQ9fY1Kowz5Se5EDIQ0T2Qo5r2nuhjMvZC0xhTLJROgcQ
         P1cNhfyH996dvaf6YLUF+0vSZEWoOZtmtyoELAXqlKys9m4GNx8GB0Bwz8lig3cSF5NW
         MVump1SFK2f57lletzmbIL7Z1pu8CsqZfU2PqB70noXFATO5aX3xOrVYWhDYmEtjjQTM
         TE+w==
X-Gm-Message-State: AFq9FYKLWP3BQd4DGHzMn6p+Hot1LQz6RF6hhQjEi3PEtsN6AOEr4vNG
	2n2wkzx3438oyFuixO8RnVBuVjbNLjG0+0TDOPl6gRjChlB7/dJMIEI=
X-Gm-Gg: AYBFou3Uv00zUfZQzbUi3/L1Bok4lTDdr+5wyCBbAKIIHCjOggRRxMp+tBu7u1dExgW
	oLe70A8nnx5EWJkfjU8VWhJqzUTRJd+6XbFxc2ZWL0BCAqC1owM35Czwji9SiuQ+eSfhq1oXLbS
	DiOTUaCmhgI/KkP6UKx1V5slJUjB+QSjq3p3g1OiMOsSULvxqiMGcij+DcuMRHQ5bQ5DaqdYOYz
	mfBFOWeC/Ka29HpqxN1/tyBxRtLxBSWBmg30dpHFxbK/yMhsXfVcdramfZSo29HjPOBqL1/QuKc
	KBFTe2O3/hlJuUpSounJ3RKunHJkMdL4scSFKGCxqSO3zYPJDoyCKvG0e4QdUdZpr0AJeQS+BNM
	ddoxWbIg1ok8UTuQ2HDdddeceDLKSpapfdgmy3PlgUT3NcMrzB5uw2OIrdBeFaVK8eM3Ncfro0x
	BeaGeqhfuUzvBVlQSFfQPvQsoeiDMLNA0IgyY/4H/dVFq9ff0+Yr2gaYcd6y7+A3Vhm/ZpJ+PaT
	92urX5t7xJl03XO7Y19BtxAA8Cz6W/nFYyLnTjWnrhwuX4aKqQG/iZEprAyyOaLziglW4oz2l3h
	KczVe9zwhV+3
X-Received: by 2002:a05:600c:1c0f:b0:4a1:ac66:6059 with SMTP id 5b1f17b1804b1-4ac19233381mr69475205e9.26.1793385250702;
        Fri, 30 Oct 2026 11:34:10 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ab61d8b9f4sm114204175e9.12.2026.10.30.11.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 11:34:10 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v9 0/2] RDMA/rxe: copy send WQE to kernel buffer (TOCTOU hardening)
Date: Fri, 30 Oct 2026 18:34:07 +0000
Message-ID: <20261030183409.195671-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

The SoftRoCE (rxe) send queue is mmap-ed into userspace, allowing
the requester and completer to process work queue entries (WQEs)
whose fields can change between kernel reads.

This series copies each WQE to a kernel-private buffer before
processing: patch 1 for the requester, patch 2 for the completer.
Both paths validate opcode bounds and SGE indices after copying,
preserve DMA progress across multi-packet operations, and write
back updated fields to the shared queue via WRITE_ONCE / smp_store_release.

Changes since v8:
  - Patch 1: fix atomic write resid check -- use WR_ATOMIC_WRITE_MASK
    (WR-level) instead of RXE_ATOMIC_WRITE_MASK (packet-level), and
    clamp dma.resid instead of setting mask to 0 (sashiko finding).
  - Patch 1: invalidate completer WQE cache on retry so the
    completer re-reads after retransmission.
  - Patch 2: write back DMA progress after each intermediate response
    packet so a forced cache re-read picks up current progress.

Tristan Madani (2):
  RDMA/rxe: copy send WQE to kernel buffer before processing
  RDMA/rxe: copy send WQE to kernel buffer in completer path

 drivers/infiniband/sw/rxe/rxe_comp.c  | 76 ++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  2 +
 drivers/infiniband/sw/rxe/rxe_req.c   | 72 +++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h | 12 +++++
 4 files changed, 155 insertions(+), 7 deletions(-)

-- 
2.47.3

