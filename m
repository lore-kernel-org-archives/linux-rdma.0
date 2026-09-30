Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC66C517BAF
	for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 18:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792503; cv=none; b=qjnvNbnYzFmhdVYpVFEu3kzb6mpyCERzI5K26IBkjofB8p9lZvO/qRHeeQkvuXge+CO+oKEObAYmgIpYqUkWwOVrUZ0SR95GovOWHasg73T3DXQRSM4aLUZMt7B3eSN+skh/DjIwjWAD9sy0T3dO/LngqbNDV3bXdcpOuU33emo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792503; c=relaxed/simple;
	bh=5zQtacQbOiksM4CGUd4tB6BTdzzpQhy/dXDsAKvy5JE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HnpGp0r2eQvYSKxz+/6Le+4rM2Be+tehSQRPeRRCbhf6ARJt9wr0O1jL7V4VBqyKz+YJSuxHDZ5CxnmwihssZMzZFjVp+X/6FsdtWtjC1G7v3CmDDX+FLHWsasSLb+U13IKFafKHzu73sHcT4eIK6fY4jsCuXIyAWAIL0drmlZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TgxMRljF; arc=none smtp.client-ip=74.125.228.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TgxMRljF"
Received: by mail-pz2-f38.google.com with SMTP id 41be03b00d2f7-cc7a15ba46fso1736615a12.2
        for <linux-rdma@vger.kernel.org>; Wed, 30 Sep 2026 11:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790792501; x=1791397301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hHa7/Q/9hFlruvaLMggKwDfk7K0CDlBA1+Zf5zo6bgo=;
        b=TgxMRljFH/SM+fI1gjmkwUyAbOO2WcruyEph/roOmH+tQVqo1i8MJmJvGoDMhHuGPf
         lQAXGKczIzyTlAJoOFl9jn433eZ8pwmSBhsBrem1Le/7ixBG0tpiX/sTYz+zTJXMWmil
         SNuD1/ulM7TabA81/OCvGOHXThC0NXo+Do369a45IoKnjYVzILCC/rqvhHRB+ooEl/A+
         XE1M5iUceNPAMc/o2rwHAnJE4aj7k6WjVF6eV+7SUY25lv2Lf7WlSKZX4xGwAXRGBdAe
         anJfZ4b045yFvRfdqU3h1s4LUFmewzx+C53AuvhipsoKarHFmvx5hZIjs9qwXTqsjfxz
         sN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790792501; x=1791397301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hHa7/Q/9hFlruvaLMggKwDfk7K0CDlBA1+Zf5zo6bgo=;
        b=2GiE5YIQVsP3L43LFB4N9BIS5Sz0usYRxMWj6tSC9Gf5+0mgfKEywHTEDiiVemGq19
         2fFYmlgLUNQOHqMzvqZ8uGL/YkAciiUyWhLMNMH+ee9E2ERQu4FhsLLHSTcFHG62mUO9
         yWX5yFZSEfh5mEcXVgMImlQvd910a7/zP3Y+xxb5c6s3Bcl6/B7kuaqaC5GhNCeliRmo
         j4NIwzbHaeqRKa7wFl7bVQuypknWdfPMNgPNPUP4jsO5Z87hXG6MIp3kKf+1iqu5Z1z+
         9IyonBoLjjTb9JuRMLg3oU25AC4OMgnZGzYdWbKK5lVUevATRYILOZEX/X0TEaarHmlr
         mQhg==
X-Gm-Message-State: AFuF++k1gV89MFI+XC/3pvKl2jtThrNbrdEpH3cGxIEHaQq5+IUqsGMO
	6pDz6oP/shL0DCSVcbepvLX/26d9UPsq27zBnV6032OcRuHJfLu0LmuM
X-Gm-Gg: AYBFou1oNrMC7ZpehDlxrx/oaTKNMxFnfLd0AKStfaEHi35DeO6xALEfaBjhQVFIQUw
	5vFTAZaNyB3wOyGhIxCXBn7+bugmWQhLrw84zq3LUv6SidSAHx0ltGV8L9lXvWGU995nMlS/mdF
	1U9vS3vzEAF4ljKYtK/FjszMJ0Fv9QRsmF7LZT84DJDxkcGKXQkakOeRwavzy8hRrNJsXetpQG1
	g3Dt8z3/5DdkiOoZUb0DX0RXY9JNjkrl3WlYUOwab1CRc1zhJzcAExUmB+EVbv49z7wq5jF5h9l
	osn9+ekUs4zyIeXQmiY1b2t3eIXB+3cTaNyWF/2vHc8j0MQCGA8SltjwCTvbeYp2EjV9vmdsxDJ
	5hHgxcvZ621x+I8wa4tnSTGeJoMCPsPdc+3gMW2Ozqll36BLTQIdsRNKCsEGvUHiI0Ya7AVwlde
	GWyFWQgnURwlZhLkn7MkEbl5da5JDuFTb5c0ZKOql0deBbROJ03JodNfx4ygr/8pEBcsRIGotUY
	Swk2OIitg==
X-Received: by 2002:a05:6a21:6e96:b0:3de:7dd6:ff9d with SMTP id adf61e73a8af0-3de9e7b3784mr2257718637.43.1790792501147;
        Wed, 30 Sep 2026 11:21:41 -0700 (PDT)
Received: from localhost.localdomain ([112.171.72.75])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88818fe3eedsm36659b3a.32.2026.09.30.11.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 11:21:40 -0700 (PDT)
From: Youngsung Ahn <ays511.kr@gmail.com>
To: zyjzyj2000@gmail.com
Cc: linux-rdma@vger.kernel.org,
	security@kernel.org
Subject: [PATCH] RDMA/rxe: reject IB_WR_REG_MR from user QPs in rxe_reg_fast_mr()
Date: Thu,  1 Oct 2026 03:21:26 +0900
Message-ID: <20260930182126.2510559-1-ays511.kr@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IB_WR_REG_MR is documented as kernel-only ("can not be issued by
userspace"), but nothing enforces it.
rxe_wr_opcode_info[IB_WR_REG_MR] sets WR_LOCAL_OP_MASK for IB_QPT_RC,
a QP type userspace can create, so a user QP that writes
opcode = IB_WR_REG_MR into its mmap'd SQ ring reaches
rxe_do_local_ops() -> rxe_reg_fast_mr(). That function then trusts
the ring-supplied fields:

	struct rxe_mr *mr = to_rmr(wqe->wr.wr.reg.mr);
	...
	if (unlikely(mr->state != RXE_MR_STATE_FREE))    /* deref */
	...
	mr->access = access;                             /* write */

For a user QP wqe->wr.wr.reg.mr is a fully attacker-chosen pointer,
so this is an arbitrary-kernel-address dereference (arbitrary read
confirmed, oops). No existing check distinguishes a user QP on this
path.

Reject IB_WR_REG_MR for user QPs before dereferencing the supplied
pointer.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>
---
Notes (not part of the commit):
Reproduced on 7.3-rc4 as uid 1000 (arbitrary-address read dereference / oops).
Present unchanged in mainline 551c722f4080 (2026-09-29) and rdma for-next;
note that commit 2dac7006b9fb ("RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes
after MR creation") recently touched this function for the ACCESS_ON_DEMAND
flag but left the pointer dereference in place. Compile-tested (KASAN+RDMA_RXE),
not runtime-tested. Found through manual review; per security-bugs.rst this is
public and a reproducer can be shared on request. The Fixes: tag should be
refined to the commit that added rxe_reg_fast_mr() when preparing for merge.

 drivers/infiniband/sw/rxe/rxe_mr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 71d9ea477289..3a914c243829 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -777,6 +777,10 @@ int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	u32 key = wqe->wr.wr.reg.key;
 	u32 access = wqe->wr.wr.reg.access;

+	/* IB_WR_REG_MR is a kernel-only op; a user QP must not reach here. */
+	if (qp->is_user)
+		return -EOPNOTSUPP;
+
 	/* user can only register MR in free state */
 	if (unlikely(mr->state != RXE_MR_STATE_FREE)) {
 		rxe_dbg_mr(mr, "mr->lkey = 0x%x not free\n", mr->lkey);
--
2.43.0
