Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29AFE5540A0
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 16:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788969707; cv=none; b=sz8xUmBm5ne4Ju4jkm6mMEaUHTsgBD7MkLiEdal3mOW3GcJGZcjlRs+k4DB4EjDF7bNiFlrXwi7GznTXuHylSrp28do/q2Tld8iZNa4y9dmCDJf/wGEcFIj/fhScZMiUqGawoG4xuYq5yqzgLi2+h8HHRr4pARLhbiN5LxXaDEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788969707; c=relaxed/simple;
	bh=YEBjBW7ZQ8lRJ1cxPS2oC6saYhsYFUETZ1kabLc/JHc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tPWJTEmDvXaBObnPNVRtXtbvtJRqdpIkOfbpNWt5ETrnZG8zeWBW5te8qZho8TRkSegrX90bJfBP3Z6U1/WpkOapCZ4f8S1zTZn4hWnreUjM17dijlg9HhheOyIV+Hd1jSPajU9MKmkmPQSXCSLUCF35Mh5yv5SOYMwJAf9CrdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Q9Qb29R2; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Q9Qb29R2"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843af75de5so608060f8f.3
        for <linux-rdma@vger.kernel.org>; Wed, 09 Sep 2026 09:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788969704; x=1789574504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EmyV/DBd0HhNzGdblZ2Da89S6yCLZ2ddzSwyXNnbqP0=;
        b=Q9Qb29R2Adgxgmwnz/Srt3CthAVnIcZXk9VhUSCZPsj64rYFk5+YxzHy/ruu8nj//c
         annogvTi9RWQDMBUAlwHVogAOIm2ahJEmfRmiQEW14AqinfnsG9FKcvIZ+v3xZ6NF7Mo
         TrGKJpL9oLRSSWGb+OsEaorxVdN20uoTBebAVUt/69LQ3IrUaiEmQnr+M3+hIKUMitZx
         6T0LnxnO0cIVaGZF7xtTRzJIIkBXtiMbPj9uxz8n3w7562yRCppOZ+84pdOeA1eizS/U
         61lck2ZYAfq0dLGTebr38u+BNekdtRRtR4p7j6ZkhLLEN4fx9NxLccuV5Mh1H2AhoMfC
         CEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788969704; x=1789574504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EmyV/DBd0HhNzGdblZ2Da89S6yCLZ2ddzSwyXNnbqP0=;
        b=UgIbrTqxSiH3WY8Ti/Ke/9f2IjokYT0Ts6E/U114Tl3NFT2OkAwMeMgU2uKLNDudUu
         PhWxzPiJsr53n/URhzw15o4V+IkApIHnX03IzeV38WQ/9MM+NVzDBJZ6J+SUZ/ONpkSl
         xeBtRQ51NWwlkFn01L04TcNhrhcu0WMAxl5WxcoOlCJEAPEOlCAgK3YgG9FkPHS5XnIW
         iaFSFVrBmSkOQfNlJb8ntjCIU68jULsQXdja+jTFmj89JNK0EPXcxMF4Y/LLl7arviFs
         bwNZaaM5U2kda4cvMEghVaERpWqPyl2UfaeglMdMRit/BEVB1QFg0XVk9UjKzV+tCuGo
         MV4w==
X-Forwarded-Encrypted: i=1; AKwUvBwmLzDey6JW9cv8GzABCnlk93qFmU84XR3vmI/5mHb2siQJFj9LPCrtmO9qDvKddxsxJNJzKdKiVbKm@vger.kernel.org
X-Gm-Message-State: AFuF++k/Y2W8zJBHOdLEHfxG06jPH0N15wCgaVqLwsXy6drFESXXnGjg
	8k2BaGDMnXVnZMm1ujTMDDxwL1dyOi3LvOej3XMVEDE0TlUuq/SraXozv4EkhS05EJ4=
X-Gm-Gg: AYBFou0sp7GO2HXCGeYmFOAiYgTxwELFB0UJD3rK4Mo+3CYtHz0HH6t2OidkTcFzZ/W
	LGRcHOzePE4Vnppj3jNvMFCL2dE84OpydgpbzVJjO0SmagJMYoW9yNwdbAWOXGoO8klcga9rGGQ
	4NDG4mv+G5npZ/gIPcxiwQIvB8ZHqi81mO5IBPWJp4AimiTNe/NwSi5WqjPl6Jl8e5kA+GT6LwF
	NYz8UevKpgYpGQOdtremg57W58EvlEguny09StoC/l2ZUP3UTC0uaQpbZn62TGazvRPS6GWZIw+
	WjL1d3Y2AHpM/iCYvJH0+SSW1Mx5COoXokoTrGPQHvbkolEAeCvjcN3VOWPIyUh2YRe1o8kLRUM
	iJ4NUOnH3v0qR72lpW1Xp3Ye9p4v11IguBeDhBkAuR34zjZ7IBB3ryFBkrBH3FabM/XsLqh54U2
	NY1HQ0tiswOfowfEq++tfSJ/kcrk8Ubjsx2b+FdgB8jZCRdUFcRzfACk425vsMU5+XlHmB9wZ2x
	3kZ4bQRaNOMon9cD1vsxI0jZxD6TlGgje/fstn/b1n6lfg=
X-Received: by 2002:a05:6000:40e1:b0:485:b0bb:38a3 with SMTP id ffacd0b85a97d-485b0bb3ac2mr3570567f8f.6.1788969704228;
        Wed, 09 Sep 2026 09:01:44 -0700 (PDT)
Received: from nicolas.morey.ovh (lfbn-ann-1-199-252.w86-200.abo.wanadoo.fr. [86.200.161.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883acd33sm44865981f8f.18.2026.09.09.09.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 09:01:43 -0700 (PDT)
From: Nicolas Morey <nmorey@suse.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Tristan Madani <tristmd@gmail.com>,
	linux-rdma@vger.kernel.org (open list:SOFT-ROCE DRIVER (rxe)),
	linux-kernel@vger.kernel.org (open list)
Cc: Nicolas Morey <nmorey@suse.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH v2] RDMA/rxe: Use validated num_sge in local buffer
Date: Wed,  9 Sep 2026 18:01:31 +0200
Message-ID: <20260909160132.1491248-1-nmorey@suse.com>
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
out-of-bounds reads in rxe_resp_check_length() and copy_data() causing:

  BUG: KASAN: slab-out-of-bounds in rxe_receiver+0x8109/0x9ec0 [rdma_rxe]
  Read of size 4 at addr ffff88812c4867f8 by task kworker/u9:6/361
  Workqueue: rxe_wq do_work [rdma_rxe]
  Call Trace:
   rxe_receiver+0x8109/0x9ec0 [rdma_rxe]
   do_work+0x149/0x610 [rdma_rxe]
   process_one_work+0x726/0x10a0

  The buggy address belongs to the object at ffff88812c486000
   which belongs to the cache kmalloc-part-13-2k of size 2048
  The buggy address is located 0 bytes to the right of
   allocated 2040-byte region [ffff88812c486000, ffff88812c4867f8)

Explicitly assign the validated num_sge to the local buffer after the
copy to prevent this race.

Fixes: 22b8fbded65b ("RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe")
Fixes: d6ab440240a0 ("RDMA/rxe: Copy WQE to local buffer in non-SRQ receive path")
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Nicolas Morey <nmorey@suse.com>
---
v1 -> v2:
 - Added KASAN call trace to the commit log
 - Collected Reviewed-by tag.

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

