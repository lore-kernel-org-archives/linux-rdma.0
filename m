Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179543655C4;
	Mon, 27 Jul 2026 05:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785128905; cv=none; b=A1HYCZiEhY755JwTYBMLPd299NvmDhKEzYWX2RJj0H6nugy+1P9c/gzgP46e/5Lge/jV8FH27ZJzum8bqtaju3kwJrpyv0UGpGlGcbYPX211pdlOsOc3pea+bnGOJzMzUr1K9lQ5t3f4AeXMMXFXLlpvK2pyHZUypd4q5advqRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785128905; c=relaxed/simple;
	bh=15ohz7bfxrnp7N+QHD2+BbcvUcoYjeUou6BXvxW504Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lQ6PxeGAURmMhkb/MJgTpewA9DW1+gnnjk3jOfQrehplPC/Rrn5KVVJLUqRokTzFuLJkKaa/2DIYPCgAIh+YMRt1DCyhn1MbqPdCjjJWhgByo6L3sg2ZCMH7RT6R6tF6PWIqsrluGzSFO5ARWv+r11aA3cQL2tTUo/eOKhzgeSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=OXM3hur0; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="OXM3hur0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1785128867;
	bh=b47Atr9pZZ4R28EfatuBji+pq7qI4ijen7GaX7E/1Ro=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=OXM3hur0pC5ZjFxTZbF4yOIOIl+0l/x+ft4F6pPDgIN634Czj4OPQfQLrQJHIGWmz
	 Qeq+/iq5h3ptwRkD5H47tsajMVKIwP9R7tasQeh660PArOnn8zmTs4OPpl1neEWmSA
	 Ys/za0u77PZricn74+U7F+sjGFDh3+0utW3JsMCI=
X-QQ-mid: zesmtpsz5t1785128852t4945f142
X-QQ-Originating-IP: BZJx8WcQG11eTLGgH6zCjynLKn+6loNa3SGF8PSAQbc=
Received: from hepeiyang-vm.wu.lxd ( [218.94.142.195])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 27 Jul 2026 13:07:30 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12250581771191435385
EX-QQ-RecipientCnt: 8
From: Peiyang He <peiyang_he@smail.nju.edu.cn>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-kernel@vger.kernel.org,
	matsuda-daisuke@fujitsu.com,
	stable@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Peiyang He <peiyang_he@smail.nju.edu.cn>
Subject: [PATCH] RDMA/rxe: Fix UAF in ODP init error-handling path
Date: Mon, 27 Jul 2026 13:06:59 +0800
Message-ID: <70CB6DBCB19624C7+20260727050659.1543627-1-peiyang_he@smail.nju.edu.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:smail.nju.edu.cn:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: Nfbfy7LnyhchmQ5IENxvQtLm+MUZQ9c4GvDr2E9/mVPUSRTIMxypTo6j
	Du8WEWC28w8kfy4GCUC1YQa5QrsCw9iYs839djMQalY63mMGRQLUy0GFnVcFBt8y+vwnz+e
	4cq9QfMX6t1QFDat2U5h8ZE6kyiyx0ZIFGHExW4Up1pBwJrIWBxeXdE+odeEWdguzSPe+ra
	10+awEq2puj9oTU030Uvdwl6TYKgqc7ICg5AXM+bS/+CqObRbzJh7Jms5U0yiPCWGzTAFVY
	aBNJYuU6GBCWp3g7bT7UiuIDUOUeZz2Nd5GS8VGQhs965/N+/LbNjSb+d9KIrjhHQsGlQJ9
	wM95DKtckU/1O5711WbBqvUGTQ3Tpq/YznTCtZe53xxN9gnZeSyGpJcFoD7mwY5uIcZsiv9
	f8yUkKtnVkyn0XgnUyQFVL6fqLMLMLpgwgzRRK2NxdE4NGJFFV0A0ajcL9gYmdUvSBKGcFv
	3/vw0lYCu05lCWYsuj99athBaUALr1Mp/PN9VY5l1Cqo+avSkwc1ntLyse2PkS/kWdBumW7
	yHeFFBtAw9w1DJWAwW9YGj5YSrSfPqvZJkQJ8l+M8sUNQx4jlHQ3RzioamjS4a3sXAnUBTp
	30PNYMUEzrjLhunMLrFFjNqiBh28MEr+TEOlhDjAMz0Jjy+J4AReRudTWSkT1W67j+OgGx8
	Sv+ksZ9QKvHjhLQ1j6cE0AN66op+1HgyiT3lGjg661QwAQCK83XzTmafnA9mzcimPyMNBYR
	4ZV4XLl+yqMDPcMRf4n8OqynZBE/nPCkAugeb8Qe1uro8etV5M1f8X/GL4kTbg0Ot232xuW
	+74zcC8apy/Zv+2BSOFVVG3/wdIbCGL0Av4n06MtxYRWxK1HgH4sAV3xTOb7qS8cHGFcp3r
	NFVexJ+BUrg4zUmixFtKXQfWLwgNn61AyuV2qQfyYnYNWdEZA/lb+yAnGqY76aYS2HGsHpV
	6umgxFvBwSoPJWc/exRx0Iz1beli67AIjx5iyCHpDK76ODWvC5xeD5mqyyjV4VJrqXNUBHZ
	opNm4/pYBdB6mcwn4JgamvlPbAovFwS3nFVxGibQ==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

rxe_odp_mr_init_user() stores &umem_odp->umem in mr->umem before
calling rxe_odp_init_pages(). If rxe_odp_init_pages() fails,
rxe_odp_mr_init_user() releases umem_odp and returns an error.

rxe_reg_user_mr() then unwinds the error through rxe_cleanup(),
rxe_mr_cleanup(), ib_umem_release(mr->umem). There is an
IS_ERR_OR_NULL(umem) check at the start of ib_umem_release().
But since mr->umem is NOT reset to NULL in the error handling
path of rxe_odp_mr_init_user(), the check passes and it reads
already-freed fields like umem->is_dmabuf, causing UAF.

Fix the UAF by clearing mr->umem after releasing the failed
ODP umem so the MR cleanup path does not release it again.

Fixes: d03fb5c6599e ("RDMA/rxe: Allow registering MRs for On-Demand Paging")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
---
 drivers/infiniband/sw/rxe/rxe_odp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c b/drivers/infiniband/sw/rxe/rxe_odp.c
index ff904d5e54a7..1b1c4a0c7110 100644
--- a/drivers/infiniband/sw/rxe/rxe_odp.c
+++ b/drivers/infiniband/sw/rxe/rxe_odp.c
@@ -114,6 +114,7 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length,
 	err = rxe_odp_init_pages(mr);
 	if (err) {
 		ib_umem_odp_release(umem_odp);
+		mr->umem = NULL;
 		return err;
 	}
 
-- 
2.43.0

