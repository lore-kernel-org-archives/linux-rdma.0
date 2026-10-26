Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792973649;
	b=5lq7sS++W0l32z95YFXikh1sF+1AEKHKBQUC/UjFeYtz3LYGlFDZQwQc5ngR+VrIwPqK
	 guWHu4mYTa3xzoYWJkTBFULjRV6YMGDgUGXOsXsLkpEpOK6185LZxT4+kjJNguONci0bf
	 Y9y906YPgPeTD7gaTsU5VlgpGFwhA3dUok1NTAtbcamwuXLk2LbqQ6NlUezzcXLQch3ej
	 LPsfuwdzk2n51ed1lgtgbhvs9fSNa0TRkTeWKpfGzrIPAT1x4YsV+q6TOgijzoAjV/6LD
	 PSIl9w3hzdvsU1LGPrdAicw09avbri1Dg962z06Wg1FncJuwkU6S6KIgkor8LnLnReQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792973649;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AwBm3icRAU5TD3bLHrP0Vo3BXzzi5oN3rjyjf2GKYC0=;
	b=bmNuSJMyhISViYlRIH7Isss5nzHj2Iio7ASMLlUKe9yh5BtrXwdSbud6nOcDFGLxVJ94
	 HKq86lZKMx7U4DQWBAIzEvNyk/j6VBXfhPn8aVyM1eCxviKSNZ9ryD2DhsqXiBh/M6BWU
	 qc7BSShn9wrrCHdRTYrlacyuDoAjqPTN0zIfuhD1sYwhwGVgmvYEtR4iLcmgFEfiXppGj
	 QdzEvRl8gysOOwyWYSStqWcsm2XxygbAWNj7dPMJ9izBA3tZMXr9Ym875/5CHCbO08F8G
	 eALw98+ebG8+bcJJjWM6gx0HbFova6vXszWCMJz3csGH7w+g6smteZzgCWaXpeqXn+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="Eh8jM6v/";
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAF7606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 00:14:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCAF7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Eh8jM6v/
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso22594645e9.1
        for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 17:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792973647; x=1793578447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AwBm3icRAU5TD3bLHrP0Vo3BXzzi5oN3rjyjf2GKYC0=;
        b=Eh8jM6v/66U76UN0QBBcLTUTqgAtcHgpgVM1r4vu74skjuiSNpkLl+kQfqzK5wvEEi
         p8xUQN6GrkV71Pzt3/QCBcsHx9NZlSKxF3f2RoN6uVVgot7G/JSvJmEtM2njTtyGxlcR
         ftqRDofTF5YxTHk2YIdhtWQ0gUSQGkBmN/w+qKKX8ooQ4zhAA7xT69wupiOYBX+BeFBt
         ausR+k9X8OEpBbCOM9tFls5jEDxgyD2RgWCbf7Ru4X6f2e5XbqybzCYGmPugad0XsUt4
         TQBp3rFCgz1rmX/miB585NrEDfY8Hd7FRmg5sIyLDfGNh04jyfpjpD4ROWrR4tHgBESM
         kMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792973647; x=1793578447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AwBm3icRAU5TD3bLHrP0Vo3BXzzi5oN3rjyjf2GKYC0=;
        b=V120tY83+vtbXCwXDZTJmHrvO7vgL3doDi6u19E33iTIx8f/9/5Fqc3n8370vPClqf
         zJzs0n+647jGhIe7f1+jwdT934sR5fqF921qE5qjyaIHizekaXmB1JhzFqAUudM4bwTD
         8oQ1oFmBO6uVYhSLUgSWxevtVyLq9FSRWrZzSuUW9aIAu4jiqSzvHYrluhFC0ARNPseI
         3BgrW6mDUgB1V6TfN65YU1Lbdh7wuB4uzevDbLxC6/AkS7Mu3Ir6HcGUk+6pzPTBD2T0
         e9qZGDin9i0T7gPjcdarl7XTT1JmePmPndR9nCW/+PJqah8/dWoYB40dUIkPtVnHU5wB
         45VA==
X-Gm-Message-State: AFq9FYIm/YVUZafYaxs6Pu+lbDpfQiRWmrZzzyDHdNJP03pq6caGvj6K
	LxIm+IskZy/6eAlL87pPcWB0dqcla72hz1oQQrgeyCrMLYpDBqc9bK1P0L/R
X-Gm-Gg: AYBFou28/pNbcp5eatfTLWtcTtQppREgJl2QLBj7SBVaf84geUMvlBZ/2G0I8C63hA4
	YcN3Y7RxfDoEheiGTRF6+K3lndf3I1nKlUFPVROaRSEnzBZBWmaSrt3TwZm66/ZcvQ+LtKy8mRx
	eNybYkmEJLwoCQ+hBRl/N6r37g0+kaV+2e+s+jxbJmCAwiOuqZCDQo/J1LXHsR6T5MrgkkYc/it
	XJ+jUyrJyA9mq+m3dOfDzozMcfxKzUh8dv1l9mLYb1Tpt9wE2hVbWCjORBwJXLPuFWv3G4VG51Q
	S7Zu3pnqVMHF1hKX0izcZiQnPvcbtzSFvNjbE7VNSr912zRboMlMstGDXyqRetDdlcDTUMlJbQ1
	vq0h7Y2ZrVjWvZ7VknnnTz0BVbhoGhOo5yTuvgLH7Yt1sjbZ04jCPEv0F00AsOkWuvy4y3ZqrKF
	7oSeNg6Fn1hngyHcLwC/iTCRQj/lmFORE98clxH3FCQy5ns7mh0uzHJMJzshgtKfBYGGgiSFOlI
	9ZGimMUTKNve6qQf9jsIYSoZCuOok9PGgi1EA==
X-Received: by 2002:a05:600c:c056:b0:4a4:4d57:8487 with SMTP id 5b1f17b1804b1-4a44d57864amr50720885e9.5.1792973647059;
        Sun, 25 Oct 2026 17:14:07 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ece13aasm11940830f8f.58.2026.10.25.17.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 17:14:06 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	zyjzyj2000@gmail.com,
	yanjun.zhu@linux.dev,
	rpearsonhpe@gmail.com
Subject: [PATCH v6 0/2] RDMA/rxe: fix TOCTOU races in send WQE processing
Date: Mon, 26 Oct 2026 00:14:03 +0000
Message-ID: <20261026001405.1698455-1-tristan@talencesecurity.com>
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

The SoftRoCE driver maps its send work queue into userspace for direct
posting. The kernel reads WQE fields directly from this shared mapping,
which allows a concurrent userspace thread to modify fields between
kernel reads -- classic TOCTOU.

This series copies each send WQE to a kernel-private buffer before
processing, in both the requester (patch 1) and completer (patch 2)
paths.

v6 adds post-copy sanitization of attacker-controlled fields to address
the automated review findings from v4/v5:

  - wr_opcode_mask() OOB: both patches now reject opcodes >
    IB_WR_ATOMIC_WRITE before the array access.

  - num_sge clamp: both patches now clamp dma.num_sge against
    qp->sq.max_sge immediately after copy, before any SGE walk.

  - sge_offset / resid / cur_sge: the requester already had a
    num_sge + cur_sge bounds check after req_next_wqe() (lines
    754-760 of rxe_req.c). With the copy, these fields are now
    frozen, so the existing check is sufficient.

  - FORTIFY_SOURCE: struct rxe_send_wqe ends with a flex array
    (__DECLARE_FLEX_ARRAY in rxe_dma_info), so __builtin_object_size
    returns (size_t)-1 for the memcpy. This is identical to the
    merged receive-path fix (d6ab440240a04) and is a tooling
    limitation, not a bug.

  - Flush/retry/posted-state paths: these write directly to shared
    memory (flush, posted) or invalidate the cache and take a fresh
    copy (retry), identical to pre-patch behavior. Not affected by
    this series.

Changes since v5:
  - Added opcode bounds check after copy in both requester and
    completer to prevent OOB access via wr_opcode_mask().
  - Added num_sge clamp in requester after copy (completer already
    had it in v5).
  - Resent as standalone patchset from the correct sender address.

Changes since v4:
  - Resent from the correct sender address. No code changes vs v4.

Changes since v3:
  - Copy the full queue element (max_sge SGEs) instead of computing a
    per-WQE copy size from num_sge. This ensures inline data (which
    shares the flex array with SGEs) is always captured, and eliminates
    a TOCTOU on the copy size itself.
  - Clamp dma.num_sge against qp->sq.max_sge after copy (patch 2)
    instead of against the global RXE_MAX_SGE constant.
  - Invalidate the cached copy on QP reset (rxe_qp_reset), on the
    ERR flush path, and on the RESET state check in the requester.
    This prevents stale-cache reuse after state transitions.
  - Each patch now also touches rxe_qp.c for the reset invalidation.

Changes since v2:
  - Addressed review comments on naming and ordering.
  - Writeback status using WRITE_ONCE() instead of plain store.
  - Added smp_store_release() in requester for state transitions.

Changes since v1:
  - Split into per-path patches (requester, completer).
  - Cache the local copy across retransmits and multi-packet operations.
  - Added writeback of completion status and rd_atomic state.

Tristan Madani (2):
  RDMA/rxe: copy send WQE to kernel buffer before processing
  RDMA/rxe: copy send WQE to kernel buffer in completer path

 drivers/infiniband/sw/rxe/rxe_comp.c  | 60 +++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  2 +
 drivers/infiniband/sw/rxe/rxe_req.c   | 64 +++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h | 12 +++++
 4 files changed, 132 insertions(+), 6 deletions(-)

-- 
2.47.3
