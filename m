Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792703213;
	b=okh3L4GH1zFGcnOhViPPMOvWykKZWlyVEAJL/BtdBIwWoSYkIEX0ZoTvm10jRwT4bFp1
	 EwkmzqQPLW3uVZghkmUQCNoDIzQZ34rpLq7Turscwyd+t7zTTMMm34dpPzcb6/HmW/pVu
	 ulDa3uPe2BIb1aSIkb10rlF2x8nE6/QBAL+xfzJK2Ti9G4fdKzbFmD+8Z97Ff/Dns12f2
	 ivB7LCChuTTXScNIwoeupUOXuDsl/n9FHFJgOtuZGEFJTgEPBNzsr6cL70av/cU89Gw6F
	 qop+H9Us/SeMY6Hqik9Lex74v84llIJomMPWtbtdEIufmManD5E/sHCSIGdHfn2b+Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703213;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=i2wynOsy6bqCzxaX0nvl5mi6m4eDCe1m0oQeplC6764=;
	b=v5OmcuQLcckHwSX8qqRGVvbPJD5lRj+vSJAc/4SQW7iqqk/lkCh0bt5RK0Ghr1lU1lMB
	 6naiE+47PO/hHwqR48QIZL100WoNdczYxtn38HcIpm8Pi+FbM6Vi6efxdVvh+lA5wAjur
	 H9rM+HgybrJDU0fDqkY2dTque5yl3T8mIGmvXrU7FwRNsrx6qKuaXv/OGxccqlnV66VgL
	 FIoKRsMIlBkHa89apJfr70CmiTesArsGMx2Rnj/eNc63m0orHHJKPY1LE67cNsXGK6gdQ
	 UAxk3VMeOag6SB4j6ZsT6O9iXQOif88NH5m/aJyEo5baS/5i9mGLivTTDpH3t8UvfqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=iVdxS7MA;
	arc=none smtp.remote-ip=209.85.219.70
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5656A606A319
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 21:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5656A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=iVdxS7MA
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91b4bf686ceso8388626d6.3
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 14:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792703212; x=1793308012; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i2wynOsy6bqCzxaX0nvl5mi6m4eDCe1m0oQeplC6764=;
        b=iVdxS7MAi6AkiHR6U1ARGuOdqibCfET90VY1RGMhbDEPNMY5tDu3JOm7CEFaAcTF3G
         euXBS3g0Nq9NIjmCcuVHOihhL6NJbs4q1HhtjvL3HRtrS/iRjODvwjqOpcmrh8Pq/CkQ
         wCpsCrfsftaxP8rNLeIiWfMVFN3PYXwipAFfb7eEceZ3tIVk3FHsS5tbxUi9USCoJdLL
         geVKuOKSkQ0Pbuzwe7YQgZbnvukwYKDRuEbeVSk79rD+DgElcyTq+4gut6p518PJurhF
         huxVEYc+SpNqYIbcnJr7+b+ehq0SOVc7iumhknokuLGfLdA9gY7XLuvvNuUOEri8Ovk0
         d6RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792703212; x=1793308012;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i2wynOsy6bqCzxaX0nvl5mi6m4eDCe1m0oQeplC6764=;
        b=AbTOYdCWAv0W9gjz+m66Qj+FUHNAEgsimgUvZ0DI2yNWIDw+s0ZK8E53+BBfYNN5S6
         lxnAjYDfivwnso076XJkpTvMMs/cE35aI0vh1wlD0f3NlVF+XBstBBlE78M7dua96Ogp
         sXDVv6uebNHTo4f1JKKJJGKCMlmQ5fvTRra+dZSephjxBIgpNgR7MVV1mOUnrYdCGVXA
         isoDCpjk+DrHa0iT9oAr1idYOtfF1W8pVjdr+wadaiSQvz9nNO87yKrb8/a7zwNsGWQo
         1RwJUCdi2/D2iVxsU5562jO5e4npcOMhbbZZY2nC8dMgqfMICm/jnFf7ieZpk3vxHPoS
         xTUQ==
X-Gm-Message-State: AFq9FYImmtvqv+ULnGyZsyIu11axXRxluPAcISLr/FiuBY9H5FlL34NK
	aCSRvKT259CfCn9VdhPhd2CPgZwS2CCFwqHVx5ynnebLlEffCSrzjWOkh12MhpLQRSF0kDVRvH6
	SS4OSYideUA==
X-Received: from qkcbb6-n1.prod.google.com ([2002:a05:620a:6e86:10b0:93e:63fd:dab9])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:801c:b0:93e:7834:3940
 with SMTP id af79cd13be357-93f6f78720dmr106087485a.18.1792703211961; Thu, 22
 Oct 2026 14:06:51 -0700 (PDT)
Date: Thu, 22 Oct 2026 21:06:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022210650.1182000-1-jmoroni@google.com>
Subject: [PATCH rdma-next 0/2] RDMA/irdma: Fix FRWR and PBLE handling for
 PAGE_SIZE > 4K
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

The irdma HW only supports 4K and 2M pages (plus 1G on newer HW), but
parts of the driver assumed PAGE_SIZE == 4K. On kernels with a larger
PAGE_SIZE (like arm64 with 64K pages), this resulted in a few issues:

  - FRWRs from ULPs that pass PAGE_SIZE to ib_map_mr_sg() end up
    getting mistranslated by the HW (discovered by observing SMMU
    faults).
  - Paged PBLE chunks and the virtual AEQ PBL point to the wrong
    offsets compared to what the driver assumed.

The first issue is fixed by building the FRWR page list from 4K pages
when the requested page size isn't supported (and scaling the PBL
allocation accordingly) and the second issue is fixed by accounting
for the potential difference between PAGE_SIZE and the HW's expected
4K page size (so a single page may end up populating multiple HW page
descriptors). Patch 2 depends on IRDMA_HW_PAGES_PER_PAGE, which is
added by patch 1.

Tested by running the same NFS/RDMA test that previously resulted
in SMMU errors on an arm64 system with a 64K kernel.

Jacob Moroni (2):
  RDMA/irdma: Fix FRWR logic for PAGE_SIZE > 4K
  RDMA/irdma: Fix paged PBLE and virtual AEQ for PAGE_SIZE > 4K

 drivers/infiniband/hw/irdma/ctrl.c  |  4 +++-
 drivers/infiniband/hw/irdma/defs.h  |  1 +
 drivers/infiniband/hw/irdma/hw.c    |  4 ++--
 drivers/infiniband/hw/irdma/utils.c | 22 ++++++++++--------
 drivers/infiniband/hw/irdma/verbs.c | 36 +++++++++++++++++++++++++++--
 5 files changed, 53 insertions(+), 14 deletions(-)


base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
-- 
2.56.0.218.g1ec904b173-goog

