Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E7D3B3C03
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791354; cv=none; b=AfIk8CwmoagKkA8kIZ/MTwvpo8CUJN2pMfta8Gp56L9h5cagJKNeWIUGtvSkH/qJ9SPk1QFHPmj0WgqsxubXEoeK8sOuLFIwzEyEhj1wjD7v2xuduDIqw4LveT1RSBMm0twGFvmml4ZSgbTWa3KwKmGNm8LRrYGo2gd4ItXfy/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791354; c=relaxed/simple;
	bh=2GxkFhnK8sN2KEQhVGgRF+ndEX12kV6gCDZ8gxPW6Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gbF9V7N5/Ytc9Y+O3h2O/rPjZgbHAGiJQwXFXshDvTlNdw9RysRSQq77/QMmJ5XE++sm0cfdofVoniV3N0MLT2s5DajcsWQ+Y45GpdeBVYKmwwSZRpxpr1jhZ2xbtRNqUlbpKMcA9Eb9PZ1GvtSiJAP3Ds9xA1LrV4HHW4Zvak8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i4g43NFd; arc=none smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4g43NFd"
Received: by mail-pz2-f37.google.com with SMTP id d2e1a72fcca58-88732460a36so606045b3a.2
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790791352; x=1791396152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tJm24dgdtoGLSxRlfvOqKZqr+GICiZZnWj3gHGCJq2g=;
        b=i4g43NFdR30uJy3AaYz4PR6CEcED4eoy09apOlXeH6xTSVJYC5YU0UFwZP3MuunhXM
         gcuHDd441I9w9PwZPuJ8ZBnskRRudnnoB5HY3L+eenhMdryXJ8vyCHfJD15sMY0vpI1o
         XzkVlAwgQZ962rxTevS/O5xMiJCCIRKGyJnBjy0whaW9/cr1HCUfxT1MoOgAjr1xG0m0
         vSopd5Z4753zPP5ak2D6zu1p/MqGFHxzP8o4ZcSvNywoLEmFEK+L0jFPcA9rZa+jJFRE
         FoHqHsxymvFIKwml8eMJZPPlP3HYw/ZLyeG16rnk0X+pBPmXqx0TOFOQflClmT5WBuip
         KdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790791352; x=1791396152;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tJm24dgdtoGLSxRlfvOqKZqr+GICiZZnWj3gHGCJq2g=;
        b=F27i/bMMqyOT6btRjqZi96rvtnWJ/7v15Bt5wHA9daXK1AVKLAs4Vjz9B0NlkGj2uD
         j8XcYED4x5wlO76nPS8D5zATTE1xa8Fr+ouNXEP5V3fW6Lob8RA2CqPQA9ubpCuIK+J3
         8AnlwCuZDJ10eo242VaqH5vS81Bt3g2st+MGVGImtXzTrxxMiOANnEKN1uOFYMTDgd5P
         PuFRJeOdVnAYYc7PBjoftm1TUewPLUdOmSopMLa1dL5Is3/ZcXC6NjgKrcT2Lzr9ew8U
         cqE2L3pSGwOUpy3jseGPrjKnFrCQa02V9p7q6l93Euy2uZ4sH8qAMoGg+pMZd79MLVbB
         x6Xg==
X-Gm-Message-State: AFuF++lCBcv5M+snTAKqau0CxJHeSVpiYHo9D7SmBqBS9Xlh5/xvcPgZ
	Aeik6zh4owNJKiVkpnk0NlJNNDY0ubYkq1AaTHsaaDXaxXbMNxd/YLLp
X-Gm-Gg: AYBFou1HJPh3+hcyY9+uvr1ZK8iGwyjexwvInRjKi+NrqFXPrWjmrcjuchQWeKvV9Jg
	7QdAEfhqCKP21NGcb6N6L4HXrV6a+pEGYeoI/F3r3qiyjqcj9b1iAzU15YXTHba3yF3FTdfqlU+
	3GIvBVH8VqNEbHuWytBF3UUD3JKjYwAmcGNny6biHWl2EXXnPCr548XX6FE57AYdWX34TJnQFrT
	Yz+gGcL4WqHHWvTXuLr8da0APxmQ9u22AsUt0K08YHYjIaj+SBll9/8sBUpaHQkuffAxZkWFSG2
	ClChdT7bt6KEOXOgnBxtYcDJDeJHd17ZBnSevtlKGrPUHdvV3/BMnJEjdceSn6871dLRyQEgANl
	D1GBQo7Ul/GxuZzxrAj5uk56ngSlhzkgFeOn0twoPBwN+wc3/zpwvjL+kYU/dMlO2syRvTHz5n/
	3SKj2Jb1VL7N25tyrNDf9YdDjEJj5frIRUe53u5JHUW0dcmWMm8RFs5bASmglLkV69C2JJqGnHO
	pzzk2q/xw==
X-Received: by 2002:a05:6a00:1396:b0:886:b762:8bfe with SMTP id d2e1a72fcca58-88749034cd1mr1601185b3a.7.1790791351860;
        Wed, 30 Sep 2026 11:02:31 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88819bbc9eesm15426b3a.54.2026.09.30.11.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 11:02:31 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org,
	security@kernel.org
Subject: [PATCH] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
Date: Thu,  1 Oct 2026 03:02:21 +0900
Message-ID: <20260930180221.2497908-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with
a caller-supplied opcode and no bounds check. For a user QP the WQE
comes from an mmap'd SQ ring, so wqe->wr.opcode is an
attacker-controlled __u32 read back by the requester
(req_next_wqe() -> rxe_requester()); rxe_post_send() takes the
qp->is_user branch and never runs validate_send_wr(), whose only
opcode check is itself !wr_opcode_mask() (it indexes before it
checks). rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR,
so an out-of-range opcode reads out of bounds and the result is used
as a mask and dereferenced; observed as a KASAN global-out-of-bounds
"Read of size 4" and a wild-pointer oops.

Return a zero mask for an out-of-range opcode, matching how
validate_send_wr() already treats a zero mask (an invalid WR), so no
path indexes the array out of bounds.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
---
Notes (not part of the commit):
Reproduced on a KASAN x86-64 build of 7.3-rc4 as uid 1000. Present unchanged
in mainline 551c722f4080 (2026-09-29) and rdma for-next. Compile-tested
(KASAN+RDMA_RXE), not runtime-tested. Found through manual review; per
security-bugs.rst this is public and a reproducer can be shared on request.
IB_WR_REG_MR is the highest index the array initializes; an
ARRAY_SIZE(rxe_wr_opcode_info) bound would be equivalent but the array is
extern to this header.

 drivers/infiniband/sw/rxe/rxe_loc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 64d636bf80fd..dcc0788db90a 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -184,6 +184,9 @@ void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb);

 static inline unsigned int wr_opcode_mask(int opcode, struct rxe_qp *qp)
 {
+	if (unlikely(opcode < 0 || opcode > IB_WR_REG_MR))
+		return 0;
+
 	return rxe_wr_opcode_info[opcode].mask[qp->ibqp.qp_type];
 }

--
2.43.0
