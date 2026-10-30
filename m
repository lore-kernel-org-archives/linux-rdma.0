Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793373361;
	b=g56V4KJMUazGm5ACrniuT+koaS8K4340kdFcn6BJXm+7BNsbJLYFloJRiAf8e+KDoDKl
	 dlxYIbSJUlhGitR+EB6yKQ/pZhc6FKZMU/XydjVaYhDWPhlr75hSNj4puYPhBKxHGKQfv
	 aL6lk1Jgs5tWSJ8AnDFEJQ/TDMMXMVBykspjb0yVDo/6/zA53GGXJ23bMQnV27zWOIO83
	 I1lCHZIQQ8T9YKi7XeiPddgH2feJeEoFiRiNvdWDRZZWRM8yBCXIMMHwc9zH2tprYbLul
	 Jy/45enDJ4doNYJ+lxN68s9V8ke3JjNNH8sFRYNv9vZ8bITql1ghMOXWXl1OGYUlXyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793373361;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L2/e4wODw173tyqkrdAOHBh5VI6/G81+0Qf78PMO8VY=;
	b=Tbij+3xq+837mw8CjcxXaDFmiKGQyQqLehJnlgKjg35iB9WB+ttbCcx3s8NtHFHvy6Pa
	 oIM3pZxEJX0jwuc2NJyjF+V4UctoZ8CzYp07tBwXubukXGmx7VSlqRBuoFmusodtaMPb7
	 aUj+NB63zh3pvcURHepkR2ieDw+t/z/YTL6CtCmhJL3iOGyzXLup3FBcUDFKbVj2Wa6qg
	 wLl7FATuMqCoc5vmS3mUlt6F1AqqOaefvbLNa68voRFyjtMupUXB9+GSZHOjpIGsrL581
	 fdaQE7D07sjSUhYs/kzrpzlWxfydf/4FKv5NKyfsqsftpSSZsgl7/rUyrtT6YXqoGag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ayGxPgig;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCE9606A31D
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 15:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FCE9606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ayGxPgig
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a208d93758so8667135e9.3
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 08:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793373360; x=1793978160; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=L2/e4wODw173tyqkrdAOHBh5VI6/G81+0Qf78PMO8VY=;
        b=ayGxPgigL5J/cpcMGBIcHx/evVBem8vl5U+JZErgRMB4V+ZS5qpxtPsOv42n62rOr3
         n8MYb24p/cZ19oHFJ0n2N+gxtlGu0PZBoWf5KnDdns4dwRwj4q0KNZNaRy3HW99AdARj
         rdSI59D60oOzFOrpFnpAC3qeqnymed6B2gqHoUL5sHluvdiTeHzrKqz+Q9H5/yHSu2XD
         S0fA/Ycukg4IVIpJbkZLJxG91/EY+IwyKLmx/j9LZ72IFuT+pOmJEC3ZtDLeRoPOTuU0
         4gvrmOskGU5ZvtIPbAmtyEqeJ16ZaZQfxpGvx+PTiOElV6KNvWEiqW8NslHgrA1y5HD9
         XO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793373360; x=1793978160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L2/e4wODw173tyqkrdAOHBh5VI6/G81+0Qf78PMO8VY=;
        b=zgsGpXpVbyNpFf9PB4UEZTSBLICDgaoveZIXZPhJS9UFhJuzoWokj6CmutJ18gNvsp
         7dsWc85V07bSjuZ1czI01Oci3biiRI3YGTSIYOLZkK/26o0TQScEHNsikR3axMNUfkHi
         nyOlV3wcS/PKFQceKOtPG7GlMZIBb5QsTNyJOEwp151RdX6bfcX4uAcWfHtvCLWkcPav
         S4Ia5l/Plm8Dw8tQ4Iig8Pex56Npcbs7blCa5M+KMSvIYGLA+CJ4hCaeXP8U/lgslytO
         BaKuKGJNimidZfVh51URkF3aMrN6tMkekUPbCbJWulE3kJd5lPRMyfMuieeueZzPvltI
         kVew==
X-Forwarded-Encrypted: i=1; AKwUvBx7+nMBIv2izbzqyAMiz228R36QPMxEIrkf/q9+ojlwwg6zOs8NvUC1i731hhx7jupGeEW5aL1uHUFQ@vger.kernel.org
X-Gm-Message-State: AFq9FYLnrRvJxMWXZIDEMXIvdcvugcKgEFaZR13UJzWzyN/pse44rKWs
	U5Zvs6wOKZ07NYDYTR/qULtkN7Fgi1wINyCUiL2aFa0hST6/bnWqig8=
X-Gm-Gg: AYBFou29HgEBBLmj9HqlpT9R3FRkshXGJ1ygzxb4Xq9ukXynBPcLWJGSjuccweToBkl
	Iz4jgYbeH7ZZpRNWjr+86adIdElgfuCe0oVpKkPArrqymhly0q+0cDHeFHDTpGXxIlt4GHQMjrm
	VnsEf04e/5ZcPCQu54VZYSq6yQjJ3YQXzpQYUzXIAdt6FC5lr4XRYKSoYu7v+yGlziQ9OZOTsmM
	ftkc98EaYKbo9WmNBfb5UbhI5QqzR5EdnkRPij9BkVV+uR9WjI3KYNQVq7rk6WkYT7wdwuXoZdy
	P/1CSFlAGMrAEjZx/CeNok/WEVNmVDLCayieUneQft3m920mtCjzL6QeRzE1K+ztKFoF07EVjTj
	cVXjkaf5YbFg0wNKasWDmrXhD/30QkVBdE5Nob735m2NeRTSN6KPs1FfAIrc0uXNRL5XVTfOYTD
	/tYrG1EtMUi34Z2jJfcTkH+WCKt+vmJNt6ycxDj6QFYGEtiWUGGOpItYeWl33hkKcJ/yFxxQd4e
	bHBXUvaqo6vYPqzqPK29qoM6VDgli4sbRleOP+XzO8dQ3IEaeqRV0U6UjufHqsRrzZnuTY0qMkU
	r1IzFjxvoiQ=
X-Received: by 2002:a05:600c:5397:b0:4a4:4d57:8462 with SMTP id 5b1f17b1804b1-4ac18b7e65bmr58193635e9.24.1793373359758;
        Fri, 30 Oct 2026 08:15:59 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71bae0f4sm3268511f8f.58.2026.10.30.08.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 08:15:59 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>,
	Bob Pearson <rpearsonhpe@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v7 0/2] RDMA/rxe: fix TOCTOU races in send WQE processing
Date: Fri, 30 Oct 2026 15:15:55 +0000
Message-ID: <20261030151558.1458444-1-tristan@talencesecurity.com>
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

v7 addresses all findings from the v6 sashiko AI review and Zhu Yanjun
review:

  - FORTIFY_SOURCE: memcpy destination is now the enclosing struct
    (send_wqe/comp_wqe) rather than the inner wqe member, so
    __member_size() sees the full buffer including the trailing SGE
    array.

  - Copy size: uses max(max_sge * sizeof(ib_sge), max_inline) to
    match the actual queue element data area, ensuring all SGE entries
    are captured even when max_sge * sizeof(ib_sge) exceeds max_inline.

  - IB_WR_REG_MR: opcode bound raised from IB_WR_ATOMIC_WRITE to
    IB_WR_REG_MR so kernel ULP fast registration is not rejected.
    Invalid opcodes get mask=0 in the requester (normal error path)
    or COMPST_ERROR in the completer.

  - num_sge: the requester no longer silently clamps num_sge, letting
    the existing rxe_requester() validation detect and error the QP.
    The completer validates num_sge and cur_sge bounds, returning
    COMPST_ERROR on violation to prevent OOB SGE walks.

  - DMA progress writeback: both paths now write back dma.resid,
    dma.cur_sge, and dma.sge_offset so retries resume from the correct
    offset (fixing IB_WR_FLUSH and partial READ retry regressions).

  - State TOCTOU in completer: the smp_load_acquire()d state is
    restored after memcpy to prevent a concurrent write from overwriting
    it.

  - Posted WQE: get_wqe() sets *wqe_p = NULL for posted state,
    preventing the timeout_retry path from operating on an uncopied
    shared WQE.

  - Retry: comp_wqe_valid is invalidated when a retry is initiated,
    ensuring retried responses get a fresh copy with updated PSNs.

Tristan Madani (2):
  RDMA/rxe: copy send WQE to kernel buffer before processing
  RDMA/rxe: copy send WQE to kernel buffer in completer path

 drivers/infiniband/sw/rxe/rxe_comp.c  | 72 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  2 ++
 drivers/infiniband/sw/rxe/rxe_req.c   | 64 +++++++++++++++++++++++++++++---
 drivers/infiniband/sw/rxe/rxe_verbs.h | 12 ++++++
 4 files changed, 143 insertions(+), 7 deletions(-)

Tristan Madani (2):
  RDMA/rxe: copy send WQE to kernel buffer before processing
  RDMA/rxe: copy send WQE to kernel buffer in completer path

 drivers/infiniband/sw/rxe/rxe_comp.c  | 72 ++++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  2 +
 drivers/infiniband/sw/rxe/rxe_req.c   | 64 ++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h | 12 +++++
 4 files changed, 143 insertions(+), 7 deletions(-)

-- 
2.47.3

