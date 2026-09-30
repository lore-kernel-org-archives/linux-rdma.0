Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36C6502D5A
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792543; cv=none; b=ARih9hMEJqU5unQqziRY4IjbMbyCznDmEPZADXmd6KwQjEOJntLHJm4YX4iTx3UDhh0BFBvdHWMCh0lVvuOAbm6kfkj7A1RrVn7RBJMrwVABsze2NDblCCjtmzvf8eOC/Q9cGZSgOFOyonkPZX5ZAKAzDrcxgHRgW4orVvkhXpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792543; c=relaxed/simple;
	bh=ut3nHIqBlKs1IAZr5S8LtmDedrCb8RgLEJKEm8OOk5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HmnxGq6hjkA6Vl5R8uuTrDyhudhAaSrByb2zj/FCuQEV/lzYaYKnW8N9vC0Q9497VQoiBWWFMeHLqn+dLgatAwsrjhsyeoelg+S2/SXpGNd+8zqj1Dv43V1NXV9QMGJ2Hw5TVms+R0Qdiqybueop1Kwrloj7WaehdAXVKkooaFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ac4i0cIN; arc=none smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ac4i0cIN"
Received: by mail-pz2-f37.google.com with SMTP id d2e1a72fcca58-887ba76d5afso344255b3a.2
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790792541; x=1791397341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QhTtoP8r7vND87YUZYcyNOk3w86T2QGWKplD2Y24uZA=;
        b=Ac4i0cINfstATlqdul1zvOSiXshg9+IS1IGlunJE/6bchAvugAvk/Km5CbdUX4Kf79
         lv0SIAZb1UKGxWuq/pJFuCjJ2qfkfne1y8i1mnGHcyk9BkQ5BRFV/aLmAtASbQH/QGRm
         kT66Ibft06EDouuH+2eMqbC/T8X7yB6yQRmcIOOa/1KZR6XcQ06GoqiKDdOnS1isl5EP
         wPD2QBYDU1sP+7OfqZIXwNwaSP0KLGxNX3yBoGGA2CYvlCeVwZpWv/VJuqCwIEt5YPRg
         PSpBZHjg7gc1CvvzB9pScLi2eiJnYqhSzxroIa+l3bacEBT+a36wwRT7V2xmyihA/Xj1
         gcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790792541; x=1791397341;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QhTtoP8r7vND87YUZYcyNOk3w86T2QGWKplD2Y24uZA=;
        b=bVmOn9v/875swH5NKOEzs//SVdwPnN1gNUImRmhBLQkGcn87o3yAjNmh4pdmxqiwD9
         vIB4LNiBqRbSmeJvdMGvAPKLPxXxmpqn4JpdcRtrjUCUIV0xZsQBBlb6woy8NSCtfi8f
         2h/6sVMI0682V1QVEBMHlv0/tpLhxTqKh66gJ/AbDYU2ya2B0XaGXcHsO/dkyNgez4sn
         DM7At0l0B6yeXtkzmVSWfrc4ea9btzzH+ZwmfVqKqtDituFORMZ3FHnv4588PXb84pMy
         VPB2DElw9qGOxIB+dJ3Pql+1Ezx3/19dgImjhLS8ufDg61iMkYiFNmFVR3s3d9vtI8BX
         F0MA==
X-Gm-Message-State: AFuF++mrAXzY7ExBAHqU41JTgNu4PTvPIRrSNRh/22zVHV03D+L2LCoz
	EnAAfIouQGEYk0RSQjnrTe/2b0s2q27IaLcGCiXdeGNPKI5CbSfELJTe
X-Gm-Gg: AYBFou1O6iCgQTGfKxxohxRl8cgNQmnoKB2GYCTr3mr0189uEawe/H5GBnXAK2qKWrA
	Gf02O+N0eZBYQ2bATIR4MhhDNJjiE96plcfdGIvbZ5komc2WUF2mxEEf/Lo5WVjGxcZJIpNsNuZ
	Ar6jBQnSRlcznyNKYr9gqo1/9Z88R/+BkesQq5ez77yDE1YZ2W5lSm3Ums1+T/G9FheCPKTbc59
	62fnejTaEZRFRQj4aC9vEUKC/bC/csPtFZU+N7aCGGb39jSv+dP62ga7y3JjSTcNq/xe4KB23aZ
	nQ/sMFH0LTHMM1/cnxeVsCMpZbH24u6/wWaYtSEzJwBr06apHjrZImZ4+viIhT1cNzTPr4M5sng
	kro2VoQSqhe+QUzkeRhUVDnr434gWJbIx5cejy57tsdkdgE4nmgdhtuqckPPh+knF7h9+BJP+31
	2dotCcxnrn1BsFHNB7ShOt7xQtncofL9x4n+i5/1IhStKVfr/rZomMG8oFaZ+knckwi2K5RntlV
	9wsRQYtdw==
X-Received: by 2002:a05:6a21:7a86:b0:3dd:a196:906e with SMTP id adf61e73a8af0-3de9e814080mr2110792637.56.1790792541188;
        Wed, 30 Sep 2026 11:22:21 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-888158991a0sm49869b3a.2.2026.09.30.11.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 11:22:20 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org,
	security@kernel.org
Subject: [PATCH] RDMA/rxe: validate inline sge_offset in finish_packet() before indexing inline_data[]
Date: Thu,  1 Oct 2026 03:22:16 +0900
Message-ID: <20260930182216.2510953-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a user QP, rxe_post_send() takes the qp->is_user branch and
never runs init_send_wqe(), so
dma.length/resid/num_sge/cur_sge/sge_offset all come straight from
the mmap'd SQ ring. In the inline send path finish_packet() uses
sge_offset directly as an index:

	u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
	memcpy(payload_addr(pkt), tmp, payload);

inline_data is a flex array whose capacity is qp->sq.max_inline, but
sge_offset is a u32 from user space, so the source pointer is
displaced arbitrarily past the WQE and the memcpy reads out of
bounds.
commit 126c757e4cd4 ("RDMA/rxe: Validate num_sge/cur_sge before indexing wqe->dma.sge[]")
added num_sge/cur_sge checks on the send path but not sge_offset, the
third attacker-controlled index in the same struct.

Bound sge_offset (and the payload that follows it) by
qp->sq.max_inline before the copy.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
---
Notes (not part of the commit):
Reproduced on 7.3-rc4 as uid 1000: "BUG: unable to handle page fault ...
memcpy+0xc/0x30" from rxe_requester, 4/4. Present unchanged in mainline
551c722f4080 (2026-09-29) and rdma for-next. Compile-tested (KASAN+RDMA_RXE),
not runtime-tested. Found through manual review; per security-bugs.rst this is
public and a reproducer can be shared on request.

 drivers/infiniband/sw/rxe/rxe_req.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 24f5c044363f..06e24d818075 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -510,7 +510,14 @@ static int finish_packet(struct rxe_qp *qp, struct rxe_av *av,

 	if (pkt->mask & RXE_WRITE_OR_SEND_MASK) {
 		if (wqe->wr.send_flags & IB_SEND_INLINE) {
-			u8 *tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];
+			u8 *tmp;
+
+			if (unlikely(wqe->dma.sge_offset > (u32)qp->sq.max_inline ||
+				     payload > (u32)qp->sq.max_inline -
+					       wqe->dma.sge_offset))
+				return -EINVAL;
+
+			tmp = &wqe->dma.inline_data[wqe->dma.sge_offset];

 			memcpy(payload_addr(pkt), tmp, payload);

--
2.43.0
