Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793381587;
	b=Jwpsz2POLv1NgYPNkj8V83YKsQdg8A7oDR26nFrcSS6W7ajQFsHTLHbuuWQ2eLihLk9k
	 OThNM+qtIUaxVQ5Aoi4nl0zzpFPNwQpcUcKR7vynTS4I9wVgufYXjtMFtJ4qXhwbBTqrf
	 UFJ/ZTDJAg8WpLz6Tq/10nwjCXd2O/DJaKhm4QySnjIBZJwoUuhU/vUG1QEw1O2gKyZlX
	 3m8txNwCJAuZCdlE9VgGHwuPMb4xwCZbFYwhA0M1IN+gTGjb3txGu17zlFhFz0MADe8TR
	 kMH9tCLyi/5yVOYFSz7DVPwJnjEOWksouUdSkeVZs975l+tkgtRVbhOlJc7brXlJRvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793381587;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LmO/5PcIMkJ1uNOlzQOm4Yq03gMmohmS4XStYh/BI0o=;
	b=io7nEkhPPVT93eaqRPovEEi9q9H+AdEjm3AC571868TDV8MzRL+9Ae2WwyXXJlJ1YzIG
	 sl2gNu7CxxvBc5FuZ1znPldKATx1jZOXKKGmnLQRSVgjZVr7Tbshv0Y8rLS0ZVLl8006M
	 sCLag9vC6SDWNhR71SvWVipIjQ0RofBtQHAYK47ZCHJDKcURwSeDKT3ps7v5IKRN76SbN
	 c/gIoAmv4Gm+aDoeln134xaEHHjzQcKCkspENgTq9Vk5DBCbGaady8cFvJgMZOBsF/CoI
	 L2n38/6niQ+sMl4lFo8Xn3+94vypTXo+QkQ1//Qp0ldjkP5JH3Q9pL9KFqBwmD8dM3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=OmCpwhLQ;
	arc=none smtp.remote-ip=209.85.222.45
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9EE606A33B
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 17:33:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B9EE606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=OmCpwhLQ
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-988c7371716so318412241.1
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 10:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1793381586; x=1793986386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LmO/5PcIMkJ1uNOlzQOm4Yq03gMmohmS4XStYh/BI0o=;
        b=OmCpwhLQs8mRsBB38fbMQFHJbO5RylCWJwHdV9f0RPoa8dtDKTb7bQo+6Lc0nc8RPY
         LfKFazuWh8hUBcCW2Xys6fZeU6hk07DsVEqpomTZcr7lrKUhgoBo82ND3pAwJ0Zgbg4U
         n9UHjbjCh9KOm63fPh26+rbz+ddqe8DZGdNC+Vxnw1Xc3FNiMb8rJqLzzLHBzsBAo+jv
         EcWCi35+8LevwcjkMfXatB8EfF8ObZGCjyORxzAGjqsSL4X75OKSGsVRpq1jWYJpV2os
         U/mesixiP/ens+yV9BgTCDHeq3okp7sJIt6jrA0De0RDGwldM2+FpSp9sOR5eb9YRKe/
         UPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381586; x=1793986386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LmO/5PcIMkJ1uNOlzQOm4Yq03gMmohmS4XStYh/BI0o=;
        b=va3J6BknKvHdsXTRKUluacMNDNFYdNJx645DPlYUrR4rpqiOmTAdjX6PjRXQlUVtA0
         4arPtRpmvw9joHFPsw0Ikxf+XRklGZ7LoFdJYwy4oRtwJTfsYjepbe1S/LMVWvYK2xt/
         fApxDSgrmVPBQX0j2+rdqt2JERZf2W4zaj2S54lObKPiwcrnEVP3k2VAde1Gghprc7aP
         kwPaGeQ5UtEUST6I67oHZFkE85sW3vjaQlm6TzfH/pwDJ/fII1s1PNdvymPmpdf/YVnA
         TqjE3aCINWkrm5GAJ/xj6j20eAwpfqQQioEHaXS3QeEGi2BmHVkPBNsq48aozugJ/jCH
         moyA==
X-Forwarded-Encrypted: i=1; AKwUvBxDmRj9xw69NK2thjorXSoXU3xDneuod5x/QM7awC90Sd6IFnxK9Q8/WKfLdI26WeTpxYtXqcm7uU4S@vger.kernel.org
X-Gm-Message-State: AFq9FYIsPYWzPQF+uoWt5PHkJWnE7APgoqI7E+D/cSONj+welJ8rfv/I
	Yz8izxe/qxcz+spahAiX7xhehXnwOupwNP19CHNgCrALacGTHwQPHAWqvI6fxEYcTSE7
X-Gm-Gg: AYBFou0ml8bt+28cCOzcR7BKiExYKNdCPlv6dzTjW/qnBzxK+VKog4BYwihrWRUMx15
	HJJV7vq7lN7PceA9egPemJp8fabB+exe1vgo+19JlCHzscoOhUrqhjaOum0JdNI0C7OYAkdZ2oi
	NIIqhe62ZdThypRcQ1osFDH2gC/CIFp2wLiFplr9HhSTZUTbuhVqiaBohb54wv64FnRGoIeTn5y
	4xdNLiG7MLznYqIB/FAc1MDQjccGZISNyE9qTeKThyv8a9L2d0/23skxotJpT97KxCDl7gkbCCU
	CoXfRnexVhcXUQgJFfQ2492B2NqxuFWvX77g8+bgCDk2w+pF4btSGvk6bKMNICXUpa6jTwVmIYn
	PgmH7VScMNH3PicgHiiEfMZkbwFzSQY4Ai5kMgVSlPprErHpHulataeT5B41X86c7DMbFqBahFi
	5KLpDZw44oVTf3eCcs843Je0k2hM72bT63oFCNus4EVm5lsQb32X8r2msbnpHN+gYghLAaPgOc/
	OhEVXS7ln3g/vf2XEtCz4me/eEqMf4Hx0Q66yI3PQJgzQqgR5kI47GSk+d4wgxf2Bck3NZH0F7Y
	Zg3ujWSFN/9Il8P7uLIlmMTSixgOEW3M+/mZK5VClz9BFL2lFawhX3dQVP8D8h3eRmWoVf2cpBn
	nF47YQ/M+ZymGZlhKJIYuryWZJ1QsvUozNa5AfTTS+3g=
X-Received: by 2002:a05:6102:4457:b0:7cc:32da:56e with SMTP id ada2fe7eead31-7d0725b9fb5mr1123902137.19.1793381586290;
        Fri, 30 Oct 2026 10:33:06 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (109.243.150.34.bc.googleusercontent.com. [34.150.243.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d077606b7asm2816323137.8.2026.10.30.10.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:33:05 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: Jacob Moroni <jmoroni@google.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Hu <xuehaohu@google.com>,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH rdma-next] RDMA/irdma: Free cq with a safer cq num reference
Date: Fri, 30 Oct 2026 17:32:54 +0000
Message-ID: <20261030173254.2000665-1-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
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

From: David Hu <xuehaohu@google.com>

Within a iwcq, `cq_num` is allocated first, and only
copied to an inner uk structure, `cq_uk.cq_id` at a
later stage. Freeing cq by `cq_uk.cq_id` before the
later stage leads to a cq id leak.

Free `iwcq->cq_num` instead, which is allocated
right after initial rsrc allocation.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261016202909.1289496-1-dhu@x6u.co?part=4
Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index c91c55917de9..1726a0ddeac8 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1948,8 +1948,6 @@ static void irdma_srq_free_rsrc(struct irdma_pci_f *rf, struct irdma_srq *iwsrq)
  */
 static void irdma_cq_free_rsrc(struct irdma_pci_f *rf, struct irdma_cq *iwcq)
 {
-	struct irdma_sc_cq *cq = &iwcq->sc_cq;
-
 	if (!iwcq->user_mode) {
 		dma_free_coherent(rf->sc_dev.hw->device, iwcq->kmem.size,
 				  iwcq->kmem.va, iwcq->kmem.pa);
@@ -1975,7 +1973,7 @@ static void irdma_cq_free_rsrc(struct irdma_pci_f *rf, struct irdma_cq *iwcq)
 		}
 	}
 
-	irdma_free_rsrc(rf, rf->allocated_cqs, cq->cq_uk.cq_id);
+	irdma_free_rsrc(rf, rf->allocated_cqs, iwcq->cq_num);
 }
 
 /**

base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
-- 
2.56.0.317.g454f8302e1-goog

