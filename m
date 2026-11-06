Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794003138;
	b=GmqJdkbDMDwy3AufJH8pjfYkPdp+Hz3iPPbRVrsH1LahmiOycF7e/e0YzsyB444zyD4K
	 OcPNLTYFIdEV6zUJ4vcvCBEW+yOt46W83gQhHU8UA3KU8PBW/6NY9eGQRZdotOzGbnkgA
	 QFCfKa3W8Kt1+EY1bLt5tyEbva3BIolYPywqgHL7lenkJCuqCC8So9kXxfsDg/+EFGmiy
	 oNrYzBEpSpNVkTIw95Ycd7SXH8WuUQT5ol5TE+X/Z2i9Isw//NXtTtNnVNbB0FmPCPWq4
	 9VCmG9YyNtCzsQhAxMHGONsKrygdhbqJ4OKSUUoV8IpGiI0+tXzr6aWGFeBaz1D1Flg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794003138;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=yFkSEfEDlxMaxuj5iyNeuGnAVTE8cNzfPZxJHC8MsBw=;
	b=2DM2hVWA0Hza/yA2W+rAhyeaqCxxbsMgx+hsMHzMBC6kNwUHempkMUzI6D6JRakSPIBR
	 Q7hRsnmvQnsUz2ZE8J8Va3A9mvXWSDxOloTe4TWodTanOYqqXIikn27y6QAMnFmilfBQz
	 StxRz5Kgd6Y8tvpFXvZIlfGRuYBrwVVzu08HEaV7mFmpMDlVWJ75+jx30W7yXA1W3kj0n
	 J2mGbMLDYtLKD8StsavI7nWGScUpr+QGte+0851vPuRFFVlNs8POoa2xzFXpHT4jvDiRB
	 q6DdPaYH6lLZ9klkp+nUfm2siLtPZ1B7r5Tc7bxmfCVhkmT5BiJjPNdqA1h3ro+neoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=o2z72G4f;
	arc=none smtp.remote-ip=209.85.219.69
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3B8606A33B
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:12:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B3B8606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=o2z72G4f
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91e98b67c0fso22353106d6.3
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2026 14:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794003137; x=1794607937; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yFkSEfEDlxMaxuj5iyNeuGnAVTE8cNzfPZxJHC8MsBw=;
        b=o2z72G4fKDjqiQAf01OAIg4qo3pylX1Q7pomoYEaev075QP6kz+vJlHLjmmd0zD+GI
         AAZMSyIq+xVPRo2eH4GUmIiSODuG5FCdcfLvN51qunhtNyb3QG8Jk0PPYfn2Zq1sQt96
         DMD1/QZfZsqsTeC3SEMbZ3rGaBT1H4UnU2Ugmg0R+P8zUOeK1cW1hAoGx6e28KUO+sOn
         r8n1n4QKik0m3GESCf12oNM+vQdwDzri+F41yRIe2OOwYxsPDANNf3pYAPthEWIMXlO3
         NcyZhH/D3T8a5vAOg1yg5iMG1GJLFSIT6/JIqbIsNkoy61ScB/fjH62VbYvpJyWPP/Rm
         FzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794003137; x=1794607937;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yFkSEfEDlxMaxuj5iyNeuGnAVTE8cNzfPZxJHC8MsBw=;
        b=ivHtBH4AtFGtHSZSXbspP5G8a/WKqe/ssw5mDmGtRSkQKF45e9uv71+jgHVYGok7v0
         ev4Ix6tJd+nW9+rPGNEve0evbsVyWLhXiKoXlnYc9gPFhUEyKMkV3njKSVR1fvDrWszE
         Y+CY6VqlXNsBt00H1T6+Fk/4DX9OEVdbMSxCIuw9kerKrV9Nc9gu2ojET263r7qn4U3B
         sD1uE52t3FZmCf/lhQMgvKwEf4c4Dx+fPJtutPTrrJvCtHDiCnP5jBf/jagrJ9FaVsk4
         EE68QcCzdkl04nJo+dEm7QyVfBpdUFxPycpNCnNjHIy0E9yMWanSBCHunImKaEFMUNgA
         vORg==
X-Gm-Message-State: APuU4Z/FwSdQVD0rtHtzbViCuWlTdofEcBHJggxRMaFqF+Sq6eha+mK1
	joO98h9qBjuPGQQsfbY1/Ef+eWSDea865LrWCeQFYR7iq+yc0S18a0fhfhDRxdhXgixvO1PSK42
	WS664fT5FYQ==
X-Received: from qkca21-n1.prod.google.com ([2002:a05:620a:a795:10b0:93f:22ca:10eb])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:45ab:b0:93f:24c5:f561
 with SMTP id af79cd13be357-945f352b1cemr599890085a.33.1794003136933; Fri, 06
 Nov 2026 14:12:16 -0800 (PST)
Date: Fri,  6 Nov 2026 22:11:58 +0000
In-Reply-To: <20261106221201.2266301-1-jmoroni@google.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261106221201.2266301-1-jmoroni@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106221201.2266301-3-jmoroni@google.com>
Subject: [PATCH rdma-next 2/4] RDMA/irdma: Check QP handle before decoding CQE errors
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

When a QP is destroyed, any pending completions for it are scrubbed
from the associated CQ ring(s) by setting the QP handle value to NULL.

When completions are polled, these scrubbed CQEs are identified and
skipped by checking for a NULL QP handle, but this check was
located after the QP handle could already be dereferenced.

Fix this by moving the NULL check earlier, right after the handle
is obtained.

Fixes: 42f1d099093b ("RDMA/irdma: Extend CQE Error and Flush Handling for GEN3 Devices")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/uk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/uk.c b/drivers/infiniband/hw/irdma/uk.c
index 250267ef5727..800b51003e18 100644
--- a/drivers/infiniband/hw/irdma/uk.c
+++ b/drivers/infiniband/hw/irdma/uk.c
@@ -1225,6 +1225,10 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 	else
 		get_64bit_val(cqe, 8, &comp_ctx);
 	qp = (struct irdma_qp_uk *)(unsigned long)comp_ctx;
+	if (!qp || qp->destroy_pending) {
+		ret_code = -EFAULT;
+		goto exit;
+	}
 	if (info->error) {
 		info->major_err = FIELD_GET(IRDMA_CQ_MAJERR, qword3);
 		info->minor_err = FIELD_GET(IRDMA_CQ_MINERR, qword3);
@@ -1269,10 +1273,6 @@ int irdma_uk_cq_poll_cmpl(struct irdma_cq_uk *cq,
 	info->ud_src_qpn = (u32)FIELD_GET(IRDMACQ_UDSRCQPN, qword2);
 
 	info->solicited_event = (bool)FIELD_GET(IRDMACQ_SOEVENT, qword3);
-	if (!qp || qp->destroy_pending) {
-		ret_code = -EFAULT;
-		goto exit;
-	}
 	wqe_idx = (u32)FIELD_GET(IRDMA_CQ_WQEIDX, qword3);
 	info->qp_handle = (irdma_qp_handle)(unsigned long)qp;
 	info->op_type = (u8)FIELD_GET(IRDMACQ_OP, qword3);
-- 
2.56.0.455.g6c5a503b38-goog

