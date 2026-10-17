Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ADD3CB2FE
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 05:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792214942; cv=none; b=bEVg5Va2ahq/R3aDpcAMiCHl+NaADvH/kPW3DUclD4CCSAB2/GDZHM57lQQkKkjSZGtp6Qs30SopjDRxSSq1LSPbOAuqiGe3yBVinOCeE+2kAqbZmhNgraXoIy972z+MTSwVjsvhlI6Ijt2BZmkNmqQJxj9agV+u8N45pSvyisk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792214942; c=relaxed/simple;
	bh=oNWX2LFWYbcmqin4NlTi4Bdax8CyD7L5Xu9sfGxAVDE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=s7Oj9T2CkTbFxv3vS+ZQgBTNPH9Oe/4rRZW8Jf20avT7mOFxPIskqnfsdqr+y8Fle/p526UCuNX/Fo74eMT+KHIX8+UltO5s74Txca3NuvXvUFo4r7qJG+wf50WZwgJ9xt1dcZ7JN8KHpKYidjoZq1gH61co0ywORRt2Vb+HnrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sunnytiwari.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hM79jg0g; arc=none smtp.client-ip=209.85.215.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sunnytiwari.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hM79jg0g"
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc4ac5feaa4so331765a12.1
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 22:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792214941; x=1792819741; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bhcQVbCqJBa3gmSsi15raWgfiXqRO7hRuPkXvqhFkXU=;
        b=hM79jg0g6mjju6ShUWTYZXue2GokL6ksugEgQ6iIpz1RzO+VJ6oZn7fGZpigh0HgSr
         5/ZZfmuEBCD/GEOTJbsaWbrPoIndAIldWxRZedo6XMMOZ/hk8RAgCkSJfwy3TOW8QJwA
         EC7kVi+GaaRHiGTRGCwEOKqaNHY9sCMQf12BaSPqUEKPieVKzXzcDt0p0qLnr4TlVNkO
         /jln4Irgpc4n8RDB/fAyQJ03Hxw4KALX9bZIfQQSzpotyvKgZ7q0lOlARERblElzwgVJ
         OlUP0SCfdwfT40F/ApXUpmZQJrbo8XzhJnbRNv9lZzGagwFNHy+JTv5kv+FIaXuLJWF7
         jdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792214941; x=1792819741;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bhcQVbCqJBa3gmSsi15raWgfiXqRO7hRuPkXvqhFkXU=;
        b=Iiril3ymr2e0uk4ArnQV8wi6e2DdOVSOgbFhDc5xUB15G4QVCN3KzqR5lDmz8bJ+1j
         qcUaJNxy2rq8ldv6M1Ulo9gPt3BrpKMDFZnVGqmk3oh+ZcMgLxsm7RW14mKCCQQa+dqe
         zMRVW9LWTW9ugU+NJHWh2Mh0NQGI3d2nRJXy54041hxMc5Lbs/Ft1aDNcgimAdUYb0i7
         5de8VeSDEPzIT0MPmjyY3iChDioYwO+H4GebuH6eqNevdF7zFSIxWs026p7SvCV2yA9V
         KBO0gc03As0LBLZ6nAVINhGtyPNkE+cwlM8XerPRz+NOf0jvx1yW3yAq+T3F+nkVOBLG
         PHxg==
X-Gm-Message-State: AFq9FYJmbVCZuoTRpPxgaZUSGTLPdKcpT/XeRe0I+pHWgeWLuaHh/Dr7
	sg5nqFr1Ye+34WZ5AGXkaSc42AOwQX0C2JfX110SpTxal+kfjdZekan7xBLmnNzhcFZ9ySRpCzf
	Ojiox4wMrI68+aYh3MzFEYIdOnw==
X-Received: from pgni7-n2.prod.google.com ([2002:a05:6a02:6a47:20b0:cc7:e02f:b64f])
 (user=sunnytiwari job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:c5aa:b0:3e2:c3e:b237 with SMTP id adf61e73a8af0-3e225f917d0mr1284924637.28.1792214940518;
 Fri, 16 Oct 2026 22:29:00 -0700 (PDT)
Date: Sat, 17 Oct 2026 05:28:56 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261017052856.3570063-1-sunnytiwari@google.com>
Subject: [PATCH] RDMA/irdma: Bound in-flight CQP ops across deferred completions
From: Sunny Tiwari <sunnytiwari@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, jmoroni@google.com, 
	Sunny Tiwari <sunnytiwari@google.com>
Content-Type: text/plain; charset="UTF-8"

On IRDMA_GEN_3+ devices, CQP operations can complete in two stages:
Stage-1 on the CCQ acknowledges receipt and moves an entry from
cqp->ooo_avail to cqp->ooo_pnd, while Stage-2 signals final completion
via an AEQ event or a subsequent CCQ CQE.

In irdma_sc_ccq_get_cqe_info(), Stage-1 processing advances
cqp->sq_ring.tail so the SQ descriptor slot can be reused once consumed
by hardware, whereas cqp->completed_ops is only incremented on Stage-2.
Because irdma_cqp_ring_full() only checks cqp->sq_ring, a burst of
backlogged commands in dev->cqp_cmd_head allows irdma_process_bh() to
submit more concurrent in-flight CQP commands than the maximum supported
limit (cqp->sq_size - 1) while earlier commands await Stage-2. This
causes CQP completions to be lost and synchronous waiters to time out
with -ETIMEDOUT (-110).

Fix this by:
  - Updating irdma_cqp_ring_full() to bound total in-flight CQP
    operations (cqp->requested_ops - cqp->completed_ops) to
    (cqp->sq_size - 1).
  - Calling irdma_process_bh() at the end of irdma_process_ae_def_cmpl()
    so backlogged commands are drained after Stage-2 AEQ completions
    increment cqp->completed_ops and free in-flight capacity.

Fixes: c7db0abe5f2b ("RDMA/irdma: Add GEN3 CQP support with deferred completions")
Assisted-by: Gemini
Signed-off-by: Sunny Tiwari <sunnytiwari@google.com>
---
 drivers/infiniband/hw/irdma/ctrl.c | 6 +++++-
 drivers/infiniband/hw/irdma/hw.c   | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 335ae3c82e17..99fc9bf4face 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -5331,7 +5331,11 @@ int irdma_sc_static_hmc_pages_allocated(struct irdma_sc_cqp *cqp, u64 scratch,
  */
 static bool irdma_cqp_ring_full(struct irdma_sc_cqp *cqp)
 {
-	return IRDMA_RING_FULL_ERR(cqp->sq_ring);
+	u64 in_flight = cqp->requested_ops -
+			atomic64_read(&cqp->completed_ops);
+
+	return IRDMA_RING_FULL_ERR(cqp->sq_ring) ||
+	       in_flight >= (cqp->sq_size - 1);
 }
 
 /**
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index c345cc654256..f678ef8c1d24 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -265,6 +265,7 @@ static void irdma_process_ae_def_cmpl(struct irdma_pci_f *rf,
 		irdma_sc_cqp_def_cmpl_ae_handler(&rf->sc_dev, info, false,
 						 &scratch, &sw_def_info);
 	}
+	irdma_process_bh(&rf->sc_dev);
 }
 
 /**
-- 
2.56.0.176.g3575e65682-goog

