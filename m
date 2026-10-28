Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168018;
	b=KX5yzDRi0xPYRz2D5TFSQ1tFWLaE+dGkAaTuL0uuYx2G47daaXkdCuNL/yo+dBOLDriF
	 RTNWTglMH4YSFgl4PlbvQ/6vbojBnlJ5WEvRd5rkZfFelFN+gsAvexsoFhVmD8xb+o6u3
	 4R8e7TZB9eovQNlDsxfTOb2E3YqBVFQ6ZglusOyEVooFRWeOwpPTbdBjWbsgfmf4EsJlo
	 nfBwG7nzwvWwEaiPDbUd1mUrQ6RqC3jKdWtWyny+ZKkK5hRIuBGcbuV4AXj9iFKxoC6Hd
	 O7giBiMG7auczxPwM8sYNAdCLGPDMr8teBA4h6aoL306poESTU4Cuos5Nbeoow5/lVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168018;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=GDBZQW+3Lvfr6n68bI8edC/bpW9MdLMkgTarrjT1RYU=;
	b=mOYJ6269ZP0gjid9DWH7xhxvmhfkhmvUt4KSlxrXPbf06da6UqOR9uKytMc+9m1c1eIj
	 iicLJHAPS2zPWRFKcx4MPju5sX0x/uBk0cp0UVsFz1qf/11Wiacsn79B/5nq9gkCMjv4g
	 wFhledT9IBwGvM5vzFVOcUAGQToTQ1OdOOqRzxTVLO9MVySdHX108OzIQPG57Wn2b8L3j
	 RgS/nto7lXY4RRHdej1O3bukbxrXhSyvrkxRxWFzj+DZWSlfUR4vvNFjXU7O/GaVhpBUK
	 y6vIX5xVdFjsgTwHGZOcsWKqFdoidlK5gsj6XlYQK3P6t/wlNsF2RQ/Bnr3bW3P2B0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=XRnfdk13;
	arc=none smtp.remote-ip=209.85.215.228
Received: from mail-pg1-f228.google.com (mail-pg1-f228.google.com [209.85.215.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF723606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:13:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF723606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=XRnfdk13
Received: by mail-pg1-f228.google.com with SMTP id 41be03b00d2f7-cd5cd8d89a7so308894a12.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168017; x=1793772817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GDBZQW+3Lvfr6n68bI8edC/bpW9MdLMkgTarrjT1RYU=;
        b=vC6/7Z7sq7bORbeTaF7GbVo/0MqgvhRcGkdjfbJk06adlu2iwctUDPmYygoU0Zli3m
         0c/Q3OP+bUCuBBSdPa5tbIBvhHGDF6sH1/0noUb59kxK71y/nmUn4iMv+/8tRpSv4CW8
         W5oP2WPeHXrz2sIP+f/l0838BbsBwqhPuhr4nvWXqD7Po/CLinoBGhaC0RoRSCpb6jqw
         yYhx3wfBreMBbZX+A7DjEKhEgSuTvg9VFmpq26kBvgRmTFiJ8JRs3fhsTEW8Y3kIWpFp
         2+B7EulkrPu9DeUm8BxOBZtbD1GgJJ99mpA+izclC9rYfcVlGrGyJ21E5RXHQcZTq7VA
         Vxhw==
X-Gm-Message-State: AFq9FYLBu0WuAH6+wqPk376touTHARagGryL4ga1dhkWERsckPNEO3jz
	jVx2YkpNn1U6rSHwwbxFj5aoWDcvc/jpri+6vfL4SyODOn8aLiamvIDBgpy9BDUo28AGeYJc3W8
	jcGsdujFiPMn/E9woY2OHiEYCO0NdeImoz8jqlJfGxVNthzn4aRErslct+d4M6rORrAe/0jvE4B
	z6aiHxLjiNBWhJgGd4DqTljlyMOmFO+uhLF9IoeRgAh4jOQvZx5OLN7Uu1oksjyOyHH+eP/bufh
	zV1nq0MYk7mtWLv3Q==
X-Gm-Gg: AYBFou088qc41BCz5dEDkvUcdh4RylFnLYz26+N2052Gh1uhBMbvNdKqKh/x6YdR66Z
	QI99IePpOeXyDU3xpS8fgNfTErm3OfbgaVJBBwoiq/WS6Ass0I94dcZLxXc0BzsH4n3UDs634kO
	Hl4/3oxIAHWcgcu1hycSEVG8xNBO0ht1yzknzlC7ZjOxzJ/iNAAD5SeXks75laep4OaB1qWaTxQ
	X9JvwVV7xpzWvcR7/v6NGRK7MBTHjfkcJfMdeEK8TqlulQt3MweliDe0ZHT2BCdZppHImfUEBeg
	UrD7rzdUYqWpTcaIFy8KWjOhJTA1BV+6r18RgzJL8VrRNyZ8jT4kd6tMdwEGSeG2+LBFcBIOXek
	rXNZ06G3c4AcU1WnES+rb4mxKClc9762Tr1KEyOhbU4InFHIbB/W2VnIZZ65/hs0zU4pFXc2gmX
	KiHCGDW1QOiNrX7gZ4N5fSYNwRujbKo300mWzi
X-Received: by 2002:a17:90b:4c:b0:3ad:9ecf:2b88 with SMTP id 98e67ed59e1d1-3ae580c7a08mr934889a91.19.1793168017226;
        Tue, 27 Oct 2026 23:13:37 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-23.dlp.protect.broadcom.com. [144.49.247.23])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ae5a8a575esm795101a91.2.2026.10.27.23.13.36
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 23:13:37 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a05a4396d2so479015b3a.0
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793168016; x=1793772816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GDBZQW+3Lvfr6n68bI8edC/bpW9MdLMkgTarrjT1RYU=;
        b=XRnfdk13th1TzIgsYp3iahXCj16CgZa5Pv2m+rMMDqGzRSgTzGhhrbEDpLSgBpQTKh
         sVYDIHqcWN86h5HOjhBc5pap79r83jrmGAhs+Id6cga2z2+B8WsmhHR2CivoCVu/TKpu
         izBzYpFPk1wEL1duSI1Q51TYqA7lUp6Y6pCsg=
X-Received: by 2002:a05:6a20:431a:b0:3e2:9470:52f3 with SMTP id adf61e73a8af0-3e902335a53mr1193766637.32.1793168015726;
        Tue, 27 Oct 2026 23:13:35 -0700 (PDT)
X-Received: by 2002:a05:6a20:431a:b0:3e2:9470:52f3 with SMTP id adf61e73a8af0-3e902335a53mr1193747637.32.1793168015289;
        Tue, 27 Oct 2026 23:13:35 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a75cf8fab6sm171717b3a.13.2026.10.27.23.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:13:34 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 5/7] RDMA/bnxt_re: Reset cqe pointer each poll_cq iteration
Date: Wed, 28 Oct 2026 04:34:02 -0700
Message-Id: <20261028113404.33289-6-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261028113404.33289-1-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

In bnxt_re_poll_cq(), cqe advances for every polled CQE, but budget is
decremented only for completions reported to the caller. Skipped CQEs
(looped-back QP1 receive, shadow-QP completions, unknown opcode) leave
cqe ahead of where budget implies, so the next poll can write past the
end of cq->cql[].

cql[] is only scratch space, so reset cqe to the start of the array on
each iteration of the outer loop.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index ac15372376a2..796ea795c5b7 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4328,8 +4328,8 @@ int bnxt_re_poll_cq(struct ib_cq *ib_cq, int num_entries, struct ib_wc *wc)
 		ibdev_err(&cq->rdev->ibdev, "POLL CQ : no CQL to use");
 		goto exit;
 	}
-	cqe = &cq->cql[0];
 	while (budget) {
+		cqe = &cq->cql[0];
 		lib_qp = NULL;
 		ncqe = bnxt_qplib_poll_cq(&cq->qplib_cq, cqe, budget, &lib_qp);
 		if (lib_qp) {
-- 
2.39.3

