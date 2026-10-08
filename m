Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DDA486E78
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 09:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791452270; cv=none; b=KEOXQBsCk7CJAKTxDuarHJq7ilGJHaKZ4eWtuJa8IOPMoOWFI7aOxJ9DPiPWxiUT9CpIu9dhQgFAaT5GP0ROX+lh98HFwxmhslzHX1LKwL/SPSIP2/G8ttcriJ3oKsfcGLsaKb9L4sP1lhs5ghCih82ndMNs+UKjbnRVdLy9zqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791452270; c=relaxed/simple;
	bh=ABHrd/M354a4ArtA11rIE3Ji7DNnXn7w410eWOWDECk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N43MmsiZhl+oJArN02Ly9HEXVT0h5MCdj+GIQdT0la5jBetsr/5N+rVm4R8OLLO1SA0V8GLnJo5KRXHIer2TXOp2tScnDsY8GcH5mvHWDX3NWDqW0igIcSq57YpOc4MIZeVCsiNZNnpIFcpKyoNi8XAmIzpW4u1Le9ZIoGDljaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sEpmL3Cn; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sEpmL3Cn"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48b0be347b8so2253839f8f.3
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 02:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791452262; x=1792057062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wo1i32DV2TChJunGiO8ZGVGfgJd2TA+vlw3QeiBuT3o=;
        b=sEpmL3Cn55e3XH51kO14gjsr3O0Ll2/lMXtbsKWog/n29kjs2447xJErsblo9WVLns
         gaoX6y9qh5ZI5PnkM70mgS7S8pv4hps4e9wsF/oHJ19A7AdQDH3cEzwOtlnMk93eQzMi
         +z5824F3rlmzm7HIFpMT6mSbcdNtSrPnXG3mVb3Y74MFTFrOp4Qo6IU5oPS+Zp2Opn0y
         AcBlPkvM8Y5ybRB88F8dURJBDgcOpl3d9ppegxhAlwpn94RzspEhd6b6FwFK64OfQ8+Q
         v0yVh1I+UB9e9BZ6OYfydnm6nKS90r3GoqwJn1twop21bYsJ75JoaUDDVu+LBG/vhX1W
         qQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791452262; x=1792057062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wo1i32DV2TChJunGiO8ZGVGfgJd2TA+vlw3QeiBuT3o=;
        b=ISL2kiSVHq7ahSPcxTh3LzadGnFzVDlyuy93CHat+761bfDXpKkfKLua06PP1OYgts
         +dSMBHwGn3fOnbSt1WrStMjsuC5txBP8JqBZBBqK7dY4sQMHK387IzfMG3+0vyiaows6
         0FvWz6gIcgjo7EtNGhVwnGB30kq5tDjisecPzt+Jzd337r3pQQG3aVxlGkEeoeRUzV5k
         B6QUl44OAyz/sLqwGtwTCic5OdSttoKu0rDyCT2wrdcMX/rEuE4CSdHZT0VVCgpFvV5J
         HymoNVSEIBxKzCjRaL8nRVt0X7DTYFB9uw0KkcW0WD1oozMtmz6EoeRX+FjSxAQLxWQE
         awBg==
X-Gm-Message-State: AFq9FYK067GB0DQZilRND8uolqJ40PaQgw0MpaVhaViJzPgUv0ftEKGb
	vZjqY4xmaRBohkyYqujWuDY8pGOF4YKkRsgpNGckhkzu6owFb8Vbj1w=
X-Gm-Gg: AYBFou2wi3D0RvJIf59+1BDDb/yFDC6LZxP7xo149kvXG5V7Tvln4N+113sYDfPxMYq
	vaNAbmrrWRYEYzj1QnP9zhqrO+fM6vfuyzl1nEJjPHOCC/7ThGolj/0pfgts84CjZrAUpce1iGF
	5piPhSuFNcclR+rJaXSakfh9zsW9kRba7gxA9qFAVwdBNgGLGnRahEQmCGjAkHuYFPG7SbGu6jf
	or5itP+s8iZIUVfhpcFnRXtbO+KZu016Cm6lHwivy//mcYqPkdZC++khlcx3XBRlDtep4m3n21R
	cMBjw55yEw9/kgygbZLA/pAcFWBIB2KG+hThXOgghK2M5M4IWpKJ5/crRZBKucgWr4KF0q5DrcR
	gcwGafF4DZ7kKAk1uQ0QSTzHdQbu1f4R7mm1Anp9ZZo3ovFWtagaKZhDzrQEyPtQMUDIREHE54b
	DKtubXn98LqJdEUn0i7FuOLozBPjmoIiwUxXcxuAc=
X-Received: by 2002:a05:6000:2489:b0:48b:60d:2b28 with SMTP id ffacd0b85a97d-48c7288f27emr9932033f8f.39.1791452262200;
        Thu, 08 Oct 2026 02:37:42 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c7af45d94sm3649370f8f.12.2026.10.08.02.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 02:37:41 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v5 0/2] RDMA/rxe: fix send-path TOCTOU races on shared WQEs
Date: Thu,  8 Oct 2026 09:37:38 +0000
Message-ID: <20261008093740.3034881-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261007223222.2342804-1-tristmd@gmail.com>
References: <20261007223222.2342804-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

The rxe driver maps send queues into userspace. Both the requester and
completer read Work Queue Entries (WQEs) directly from this shared
buffer. Userspace can modify WQE fields between kernel reads, causing
inconsistent state in copy_data() and related paths.

This series copies the send WQE to kernel-private buffers, mirroring
the receive-path fixes (commits 22b8fbded65b8 and d6ab440240a04).

Changes v4 -> v5:
  - Use qp->sq.max_inline instead of qp->sq.max_sge * sizeof(rxe_sge)
    for the copy size, avoiding integer division truncation when
    max_inline_data is not a multiple of sizeof(struct ib_sge)

Changes v3 -> v4:
  - Use full queue element size (max_sge SGEs) for the copy instead of
    per-WQE num_sge. Eliminates inline data gap, sizeof mismatch, and
    simplifies both patches
  - Invalidate requester copy on ERR flush path before writing status
    to shared memory (prevents writeback from clobbering error state)
  - Invalidate both caches on QP reset (rxe_qp.c changes added)

Changes v2 -> v3:
  - Add completer-path copy (patch 2/2) to close the remaining TOCTOU
    window. The completer was still reading directly from shared memory
  - Add smp_load_acquire()/smp_store_release() for state transitions
    between requester and completer

Changes v1 -> v2:
  - Added writeback mechanism using WRITE_ONCE() and smp_store_release()
  - Reuse kernel copy across multi-packet sends to preserve DMA state
  - Invalidate on retry, QP reset, and error paths

Tristan Madani (2):
  RDMA/rxe: copy send WQE to kernel buffer before processing
  RDMA/rxe: copy send WQE to kernel buffer in completer path

 drivers/infiniband/sw/rxe/rxe_comp.c  | 53 ++++++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_qp.c    |  2 ++
 drivers/infiniband/sw/rxe/rxe_req.c   | 55 ++++++++++++++++++++++++++++++---
 drivers/infiniband/sw/rxe/rxe_verbs.h | 12 ++++++++
 4 files changed, 116 insertions(+), 6 deletions(-)

-- 
2.39.5
