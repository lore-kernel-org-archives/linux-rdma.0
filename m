Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793379049;
	b=lJrkmI7ANFrdBYEKCJnPcMr5QNEnEy+c6O9vZh6OldwkvBE8uJVNbf2wgQd2n1X011qk
	 m4n4rZwEdmD1wr4dQBfApJfvoafn5O4ugwOItMqn0nS2VLzKatWT66VswtODHHb7hnbl8
	 xSkxX0sB55wuucCDBl9RdpVr4BUbZcwu8nkHTKdOG1Hw3PbWNpkLpfnHbq5xq1nZLNb6k
	 kE6t6fBTrQHFJkwSAMza4lQ4imCVzq/4xGYbCyXhnaKnFuiZUcYV9r1qhHk68ikumek9L
	 U+sz8Ld6GGeN+1OAS+xH9AzLI445c4MMewa18P6xuL2mP2GmgK16353gcxbrWmBYkCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793379049;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gzV6WXzPcFzRX8VB8o7goTo1RH2RiPQDDsNBXgNksVA=;
	b=rPGoFvLbqPOf7gKfV9nRVlqePKHgvYNAPDfm96pzcxDj9wzQM+W6VlhwSOxpZ/OLpB1V
	 mI0WktINxflRWeLguvzXNf0f9vpwAqhu2nLW3UD1Tvw+XtuisKUPgY5dc3Wz4BdjC+Ofx
	 uV90r6N2r3AbFpqm1CgNI2jlyAJllZ3r4j7P1sk2ZeBnwlsMRlAZXCTNVezNhZ4aVQSB7
	 U4oZDWQVwZEwJOjhbW5hHAZyrrCqf9pFEtLmXE3KBaB9TkSQ9lO0CKeuVW6mg0xA2fbIz
	 KMHgxIBqApDFuln3vVMGEgO+FUzcbAIc6C0+dVBlIaa+tmhWruUhL1BUtGKcC91Z+AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XqGTI6OU;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EF0606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 16:50:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41EF0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XqGTI6OU
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so10609185e9.0
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 09:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793379048; x=1793983848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gzV6WXzPcFzRX8VB8o7goTo1RH2RiPQDDsNBXgNksVA=;
        b=XqGTI6OUecTTaaf49qWDvR+vr2Vei3Sw0oVZPnz9BfHkMLJdwcL/zzGA0EGQY0grky
         uy/08+N7oVRIw9WHLIlXQ5rZ/2pyH9p1T45RNy7ldqs+VJunQVqrInsEzSLJKFzdC+P2
         04DbvXLUlhwy9vGSU469Oq5zkSdUQbkhC6owWbXuahelT2nxiAjyF1GcyLvhLNZeqlAl
         b6E2LKhFnWZlJcHLgDulwwaIiFHl4AIPHsJvP3F7sy1RB/nevpfkP7iqFIOaKcI6JGaz
         5X5GP4W5T3FLl5I21Ac85lgHGmwGpP25CYGRXkiBmKpG5iePIJiBmwk6kvldz7cJNCC1
         wCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793379048; x=1793983848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gzV6WXzPcFzRX8VB8o7goTo1RH2RiPQDDsNBXgNksVA=;
        b=j36okyX2Y8OFnxxDuC6tq/SkgJ6nQ2qCGM0ydnWVNHMjjbDGh/XTZwKcwtSvWW/wKt
         al7EKhdn5ABTmAfsK0WsGZEHB/DjadFz3Di2ou0VkQigGvJaDRLbmE8ZEN9qz6mHMWTZ
         1DD6Ikt0Uumn+z2kxKH3Fjo4cAPaoTGBh3BaUunYMvYuFs5FsOW0IyQ1qKETar1prEbf
         SyACe3emgm1d6FeW+Gkvr2l6JTNN6QDgHfAzhqX9Jh6TUJQdXwtyuVm9zhXuY/NAfvkK
         mVUaBD7SKqMnVlChxH2ws9zVe9yPczeqgzGxrp//YgYiJ7KuljY2Ii/7VDeGp+JYMazP
         jBJA==
X-Gm-Message-State: AFq9FYLRHSjRjbmh5ay6MNZu1p8uCtsqvCqCHZV3QC0PtUa31EH5Du3G
	UNPSiFHVOQG5/WCuIf3KAsL9OmBLCqhPcIEiHTp/m74Gc4mbRRPHPsM=
X-Gm-Gg: AYBFou35U7GeIww8k4NY4azJZPPHpwq/0HSJh/yXKE039kbwhfZEUgZgUMvByn7J/Kw
	/Cl1pwL+aPrVVNdtfijPBkIMfVu5JYVcwNy/gKxAv07noF82Nv1YQ2e3J71GXDBTgBSZU0BLDJS
	vxtJz/ZlLctIu4QiucRIlezQWJ2ghWwRsjN+CxYASCTHlQRzRuqXI6sUaD5eQ38sCDCMTU5EW07
	dMkrsLC13ZiotbjVmqg3wuPwSxoF+8YJD4r2yVH7ArwjwZovJ4ucMTfXzvyFpC9tdu2oo/bBxmW
	ndUBi4sRwGK4s+dgjV3SVhH1Czij2BsyAgJuaVPnqyc2LcWnEYnR364TDGhfmjBVCEDDYa4Gt1z
	qOHNAaErdznav7CrYUVi4LAsF10VT93P5P7rcFDUWoXPxdRIcKqQ7/BnXkMagAp9DuGTNkrNhZY
	hKRM+cz9vyFO9klXobBms4zsWS0eBWptlfDqRhx948zVVBXQaFeAPPN/Db6dd/vX10G9EuS0ykU
	JSgUSDHT5/0+aDLLy0u4F25K8WtL3I694B8qucqb0D4cJ9g8rQMxCHi579d7Ng80yzT5NwcatN4
	XQyOulxfmBsn
X-Received: by 2002:a05:600c:848c:b0:4a6:42cc:bf65 with SMTP id 5b1f17b1804b1-4ac1709b206mr69703855e9.17.1793379047454;
        Fri, 30 Oct 2026 09:50:47 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf6e63e0esm94366765e9.12.2026.10.30.09.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 09:50:45 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v8 0/2] RDMA/rxe: copy send WQE to kernel buffer before processing
Date: Fri, 30 Oct 2026 16:50:42 +0000
Message-ID: <20261030165044.2799619-1-tristan@talencesecurity.com>
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

The SoftRoCE send queue is mmapped into userspace. Both the requester and
completer read WQE fields directly from shared memory, so userspace can
modify them between kernel reads.

This series copies each send WQE to a kernel-private buffer before
processing in both the requester and completer paths, with field-level
writeback to the shared queue and cache invalidation on completion,
retry, and QP reset.

Patch 1 covers the requester path (req_next_wqe).
Patch 2 covers the completer path (get_wqe).

Changes since v7:
  - Patch 1/2: reject atomic write WQEs with oversized resid to
    prevent OOB read in finish_packet() (sashiko finding).
  - Patch 2/2: write back DMA progress before invalidating completer
    cache on error retry, so req_retry() resumes multi-packet reads
    from the correct offset (sashiko finding).
  - Patch 2/2: invalidate completer cache in COMPST_RNR_RETRY to
    prevent stale state after RNR timer fires (sashiko finding).

Changes since v6:
  - Fixed all sashiko review findings (2 Critical + 9 High).
  - FORTIFY_SOURCE: memcpy into enclosing struct, not inner member.
  - Copy size: max(max_sge * sizeof(ib_sge), max_inline).
  - Opcode bound: IB_WR_REG_MR (was IB_WR_ATOMIC_WRITE).
  - Requester: removed silent num_sge clamp, use mask=0 for invalid opcodes.
  - Completer: validate num_sge + cur_sge, preserve smp_load_acquire state.
  - Both paths: DMA progress writeback (resid, cur_sge, sge_offset).
  - Completer: *wqe_p = NULL for posted state, invalidate on retry.
  - Addressed Zhu Yanjun review feedback.

Changes since v5:
  - Added opcode bounds check and num_sge clamp after copy.

Changes since v4:
  - Resent from the correct sender address.

Changes since v3:
  - Copy full queue element (max_sge SGEs) instead of per-WQE size.
  - Invalidate on QP reset, ERR flush, RESET state check.

Changes since v2:
  - WRITE_ONCE/smp_store_release for field writeback.

Changes since v1:
  - Split into per-path patches. Cache across multi-packet ops.

Tristan Madani (2):
  RDMA/rxe: copy send WQE to kernel buffer before processing
  RDMA/rxe: copy send WQE to kernel buffer in completer path

 drivers/infiniband/sw/rxe/rxe_comp.c  | 75 +++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  2 +
 drivers/infiniband/sw/rxe/rxe_req.c   | 71 ++++++++++++++++++++++---
 drivers/infiniband/sw/rxe/rxe_verbs.h | 12 +++++
 4 files changed, 151 insertions(+), 9 deletions(-)

-- 
2.47.3
