Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795714474;
	b=2QLCDKOUtdWGLHsLqe7MJjY9AoLWIZpMwmjmfgwJE61ikV+NknIfeedU0Hwjq1Bm+/SZ
	 RWILPuONnppdZ790cUw8ABp3LGPVQ3/hWcs4eHGTR435bgdBAfN+4i3YMqV5GLUCEnSJx
	 0WAdVhoirodEtsvtsBGiQTz+VzAdkPD0cgqWNxapiQKpWbV0GBGSwAwHlgZgL+zn5is2N
	 biChOVafwS9u4JO52Zf1ajSUUnfX6MgSUDp9fQCRkkacHd60mMYN25rRKnLH2A1yX6gZJ
	 0cazt0J7i/2q6juDixSribp120f1rWheCkMXFqnj2WhbnMWVxfBTE+mvLhG/gpNygBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795714474;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=XPTorJVFcdy/2alRWn73VMTkoZOEiadWkCbwmwD+Ebc=;
	b=u7canI4XnOU1kubdk1TTsKckZLSWCboyGC9Z/QNrwsNUOKDL2vshX33TvJsLoM+1Nb9m
	 UaC8EdJ/jua/CWSQ6srmG4sq9mmeWkTL3CHd8vL4ORra8d2SAiik37a6J+B76O0HXrt5j
	 rw0kS7FU6zpzprvUJd5QOSjvwVPRd6ZUvhuLjvmU4fVnYGs8f0/xh/+GrEILSoP+odMW0
	 C1Pjwc0ZYyRlcgcDnEpW5ev6ziolR+OtV8Hwg0CXdA0NLzjzyIOnpvVfiJBt3qK3JA2Zg
	 tYB4b895gVPQELRvYruyR3AMDC11BJQjY6gnonPwgHB+BXZtcjp9/WnpHX8B3rWPsEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B0Qq9dFl;
	arc=none smtp.remote-ip=209.85.222.197
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6543606A32C
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 17:34:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6543606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=B0Qq9dFl
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f2005ce21so1126044485a.3
        for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 09:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795714473; x=1796319273; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XPTorJVFcdy/2alRWn73VMTkoZOEiadWkCbwmwD+Ebc=;
        b=B0Qq9dFlGYmY4wZNEE2zzTDbGHWhVsOqWlJi12sOY/J8pDHEhySukEcVnFevt4p6cS
         pM5OK0knBATIZABy5wMZ0zEOVIHkZUyxm1yLoD11NNUDtn5mSP+tvRSZ5cFU7kZb5rGC
         2r+q0RNZ5I04s5dzC/H1fGCM995MIAVacjvxQkeZ9kAyIESgkGRZJrHNFsAPa3v0nsp/
         8iyO2uSB2q1UanmDAM0drEGZMRGKcKUU3RCGrS9E/JVXusP+122utABaNFV9Br3ctAmd
         UktKpVQfshvOwnEFigVwlOqKOlSNBmDEB6Z4cV4gcJRZVPYWk0BLb1RTupvETQw6d60L
         /CMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795714473; x=1796319273;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XPTorJVFcdy/2alRWn73VMTkoZOEiadWkCbwmwD+Ebc=;
        b=Rp+Nau7yrK2C/UgEmXkLg0Dn4o1/L8d4zNkZhum4T0dNQcfQwZyVf9fihyaneRKHX5
         5dkpPFizvJPIUrunE6eWbiKy6pOXN68BPDLSqwOIy07GeDdKyPDRtIfGPt2uLn21R71N
         YPT0z/mxEYiWUoVkcb1tQIErzQ7JuX/MQCZTtQtnrQlP0DXpxG2WmAF4Pz747bR/8nLj
         tde9w8vrc2vHBcVpxV74YrQuliwRfKZ7LTfjfi+fbHWcq+Pzeskcc44kujcB04FwJmww
         O4+U8BiP7s7LKQqsYsM9BzPnsa8vdRKwMt4DOOK9Y+/50R9PwCZahREajEWAN7Oy2Nzn
         gLdQ==
X-Gm-Message-State: APuU4Z/h/TysAGC2IHHKs2YrAwJ2RFFQ+15PJCADE9O400tBDyffGenU
	3vXI9pX34vupLA2uOYuCRXMmirlcCYSyGXhQEJeIJNGk0sv+4ouepleuAuCjGbsyoFTk8GO1fBe
	7WLwE7ajCWQ==
X-Received: from qkbaz38.prod.google.com ([2002:a05:620a:1726:b0:949:36c7:f0d8])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:4453:b0:949:7781:6a31
 with SMTP id af79cd13be357-949bab45c09mr3793369885a.76.1795714472382; Thu, 26
 Nov 2026 09:34:32 -0800 (PST)
Date: Thu, 26 Nov 2026 17:34:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261126173430.2097445-1-jmoroni@google.com>
Subject: [PATCH rdma-next] RDMA/irdma: Add budget to CEQE processing loop
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

irdma_process_ceq() processes CEQEs until the CEQ is empty and
runs in a tasklet. Under heavy load, CEQEs can be emitted as
fast as they are processed, so the tasklet does not return,
which leads to RCU stalls.

Fix this by implementing a budget in the CEQ handling loop. If
the budget is exhausted, the tasklet is rescheduled, which gives
the kernel a chance to defer to ksoftirqd appropriately.

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/hw.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index 53aa1491c4f6..e71089fd5f56 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -166,25 +166,31 @@ static void irdma_process_reserved_ceqe(struct irdma_pci_f *rf,
 	}
 }
 
+/* CEQEs handled by one run of a CEQ tasklet before it reschedules itself */
+#define IRDMA_CEQ_BUDGET	256
+
 /**
  * irdma_process_ceq - handle ceq for completions
  * @rf: RDMA PCI function
  * @ceq: ceq having cq for completion
+ *
+ * Return: True if the CEQ was found empty, false if the budget ran out.
  */
-static void irdma_process_ceq(struct irdma_pci_f *rf, struct irdma_ceq *ceq)
+static bool irdma_process_ceq(struct irdma_pci_f *rf, struct irdma_ceq *ceq)
 {
 	struct irdma_sc_dev *dev = &rf->sc_dev;
+	u32 budget = IRDMA_CEQ_BUDGET;
 	struct irdma_sc_ceq *sc_ceq;
 	unsigned long flags;
 	u32 cq_idx;
 
 	sc_ceq = &ceq->sc_ceq;
-	do {
+	while (budget--) {
 		spin_lock_irqsave(&ceq->ce_lock, flags);
 
 		if (!irdma_sc_process_ceq(dev, sc_ceq, &cq_idx)) {
 			spin_unlock_irqrestore(&ceq->ce_lock, flags);
-			break;
+			return true;
 		}
 
 		/* Normal CQs must be handled while holding CEQ lock. */
@@ -197,7 +203,9 @@ static void irdma_process_ceq(struct irdma_pci_f *rf, struct irdma_ceq *ceq)
 		spin_unlock_irqrestore(&ceq->ce_lock, flags);
 
 		irdma_process_reserved_ceqe(rf, dev, cq_idx);
-	} while (1);
+	}
+
+	return false;
 }
 
 static void irdma_set_flush_fields(struct irdma_sc_qp *qp,
@@ -548,10 +556,15 @@ static void irdma_ena_intr(struct irdma_sc_dev *dev, u32 msix_id)
 static void irdma_dpc(struct tasklet_struct *t)
 {
 	struct irdma_pci_f *rf = from_tasklet(rf, t, dpc_tasklet);
+	bool ceq_done = true;
 
 	if (rf->msix_shared)
-		irdma_process_ceq(rf, rf->ceqlist);
+		ceq_done = irdma_process_ceq(rf, rf->ceqlist);
 	irdma_process_aeq(rf);
+	if (!ceq_done) {
+		tasklet_schedule(&rf->dpc_tasklet);
+		return;
+	}
 	irdma_ena_intr(&rf->sc_dev, rf->iw_msixtbl[0].idx);
 }
 
@@ -564,7 +577,10 @@ static void irdma_ceq_dpc(struct tasklet_struct *t)
 	struct irdma_ceq *iwceq = from_tasklet(iwceq, t, dpc_tasklet);
 	struct irdma_pci_f *rf = iwceq->rf;
 
-	irdma_process_ceq(rf, iwceq);
+	if (!irdma_process_ceq(rf, iwceq)) {
+		tasklet_schedule(&iwceq->dpc_tasklet);
+		return;
+	}
 	irdma_ena_intr(&rf->sc_dev, iwceq->msix_idx);
 }
 

base-commit: 94e81a1f3ffabb388f7d0a9674bb1d3acc067e00
-- 
2.56.1.839.g22a8290db9-goog

