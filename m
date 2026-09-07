Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520143F1076
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 16:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788797763; cv=none; b=k5yDeShpcd5k7OA626owk1rYRpdfU/XaiEk63ibUaXunCp+5ExW8d/DOKzapURAH6sZ1Khzngy8HfCtwDzjxt0yzg/djJzhp3/4yqbsokwaooLmOaIpLvfcaKW+H5NfWu/kkXW7AYiAohDDlxKnBhc0snFUJRF9+XWZrWLUlchg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788797763; c=relaxed/simple;
	bh=JCDusU5yMtFiNa58wXllxAjkEnKbfVExcumys8M0kbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=POcSilfEzJrrNdmy53jeK+Poq1HXRbxaKE0VR8CyRWg+0CgRlBm0aQ+veWaK3zmkIryjEzu1eDwjm/xoU28rlOdkRPsOWiIFxeNcA8ehWh2R0ilOXdiPE4XsJKlQ77bKNzcrnZ2e3hWV1wrH8ISPDvaqwsajt8FgBQX+YC4LryU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C0Ae7Ftl; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C0Ae7Ftl"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482e1b55da9so389512f8f.2
        for <linux-rdma@vger.kernel.org>; Mon, 07 Sep 2026 09:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788797758; x=1789402558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yRxj5rjaARLzRIcmrNAgb8kIoY2uZyj+0l3SvbMV904=;
        b=C0Ae7Ftll6HczaF9OhbuBIySZtlvos+bU0XY2KcSjspOx03nstTWTXskLh1HFZvIXj
         djOiJHvOmQDS4G/HO/Tq4GzhZNia3qv7h0BJpRswtP1fmt1X4tgDG7rfqlw89j4hYApy
         2gyNsEpI2aR1tLt/AzY8ubJslK+Ozkm6AGC/Qm8CIRkG74NxCnUe1wcGMj17J1GiPOA6
         qdCMUO80Gr35euUB6Gv6pdAvBJDI0VMPE6LCazCZ8AnWVlK9VdsDrAdr9z/suw+pCNaK
         JjJEC9FULmfRCUkKkIkq9rtURUaryu/BiJHhKtP3fSqEPV1my0AYhe6fghGHkxm9F7FH
         QeLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788797758; x=1789402558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yRxj5rjaARLzRIcmrNAgb8kIoY2uZyj+0l3SvbMV904=;
        b=LYeM4P63ZZMuJ4rPrYBAUlXs664i66HNmHefz/BUamfsyZwkw29cjvpNM9yZzLXRwh
         btRo1ql162PRGVfF/tFvmfVO3AulTNqvlmQ/l/8bcA9tOYz9/b83GUwOttCHprZUcnyx
         8FIeDCmvYb7NGbzap1rJdbWH4VF47cN9jCg0LBIWfKdVI+yRFzH4bvBxZG+ulw5WH4a3
         BRxx5LI/Ec20h4Yqlbmh5KALLj9eEOE779csCCnKxp8uDqm2JnWYFtHS2CpNhpCA/vu5
         AaT40kfLu6jAAs/Xns7qSdZMGQ6vJd5ogO/yXzws56X+LOUKPQCYvJ3umOwNyD7t3nie
         pRVw==
X-Forwarded-Encrypted: i=1; AKwUvBzqJIifQZgnFwAeZ7thWZuhMTopu2YPjIRkRuaU8MCwJTeuaWkY2pvguvBOO7jA35O6UzIls/w/qlOQ@vger.kernel.org
X-Gm-Message-State: AFuF++neGpoy7Szb7kWORnsnWDaSq0hJ/+oZARuGeMgjaknBQY2HRSUH
	n5lIcPh9mnjVkXFXIbBUzmvUSTQt36dNG4d99dVJ95Br1Q0DswkHxzgTxw0jBBZ7qYA=
X-Gm-Gg: AYBFou0G5q5fa0+nGt9dHmvXuEv9B0vmpVZZxDiPCmlEUBw9YVIed9+Wd6wjnM0ScTY
	ep7lzZuqq0PuD8ut0yo40g6/GM2iFvxEHr9x+RjSnkOkhIrOjhOKLaphuxd7Rt6z93rG4XqjzbM
	LSIyRvavqgMQbYilc7TQ4nYh9lQfC6xoabhCV3Up7h1UZgAI5iZOykf75d9yX/BmeFhNwbGBtAq
	rDEOSvM7TrvNMkRnQahUbuc3XAinNdldQNTMfhQmRnd6ku04FvuAbmZFRAfHhTDffiyJpTzmLE7
	Mhr/xo6W+rW9VY751Hfk04f6mS5eNjhLL3K5ezDXP/WdCvha5ebOGbgJXtPDTTLyUWkxPoRFPJw
	bJwZdWNC7qek1QvcrHjOyEIC4WuEakDJqgUUvM65MrcooC6z/R1Y9EPyVdBO0gDwuinqRCkNn/y
	ziYvG9IeinIuKkLBHeucb1lF4SmuoemWnRR5HLypGN2BnwJleoD+N7CjNxR/YHjuFjWg86Sntrn
	9+oH9vY+a/VzUFa/UMjLu4bXjiSsu0ykEZ+
X-Received: by 2002:a5d:6f1a:0:b0:485:8508:d510 with SMTP id ffacd0b85a97d-485892cc927mr23060856f8f.6.1788797758410;
        Mon, 07 Sep 2026 09:15:58 -0700 (PDT)
Received: from nicolas.morey.ovh (lfbn-ann-1-199-252.w86-200.abo.wanadoo.fr. [86.200.161.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858e239862sm24667614f8f.9.2026.09.07.09.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:15:58 -0700 (PDT)
From: Nicolas Morey <nmorey@suse.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Tristan Madani <tristmd@gmail.com>,
	linux-rdma@vger.kernel.org (open list:SOFT-ROCE DRIVER (rxe)),
	linux-kernel@vger.kernel.org (open list)
Cc: Nicolas Morey <nmorey@suse.com>
Subject: [PATCH] RDMA/rxe: Use validated num_sge in local buffer
Date: Mon,  7 Sep 2026 18:15:49 +0200
Message-ID: <20260907161550.716670-1-nmorey@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For both SRQ and non-SRQ receive paths, the WQE is copied into a local
buffer to provide a kernel-owned, validated copy. While calculating the
memcpy size from the validated num_sge prevents overflow during the
copy, memcpy() itself still copies num_sge from shared memory.

A concurrent userspace modification before or during memcpy() leaves
an unvalidated num_sge in the local buffer, leading to potential
out-of-bounds reads in rxe_resp_check_length() and copy_data().

Explicitly assign the validated num_sge to the local buffer after the
copy to prevent this race.

Fixes: 22b8fbded65b ("RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe")
Fixes: d6ab440240a0 ("RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path")
Signed-off-by: Nicolas Morey <nmorey@suse.com>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 02b16e2b49b8..cd51042857d6 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -288,6 +288,7 @@ static enum resp_states get_srq_wqe(struct rxe_qp *qp)
 	}
 	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
+	qp->resp.srq_wqe.wqe.dma.num_sge = num_sge;
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
 	queue_advance_consumer(q, QUEUE_TYPE_FROM_CLIENT);
@@ -328,6 +329,7 @@ static enum resp_states rxe_get_recv_wqe(struct rxe_qp *qp)
 	}
 	size = sizeof(*wqe) + num_sge * sizeof(struct rxe_sge);
 	memcpy(&qp->resp.srq_wqe, wqe, size);
+	qp->resp.srq_wqe.wqe.dma.num_sge = num_sge;
 
 	qp->resp.wqe = &qp->resp.srq_wqe.wqe;
 	return RESPST_CHK_LENGTH;
-- 
2.54.0

