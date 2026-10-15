Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B04399003
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 16:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792081094; cv=none; b=sWjib+GrgFxK/BQ/H9UEJu6LqYl7NUpbi7gxEFLzYker03nJoZErxDF2ywN7qgLjcLwGO0V3X+142cpW6MU44d0Afv2MGjg1K2+b+ZL+V6wauiPXzot7B9RWjdok7Px7Xvk+c0x2RJoytxPYqd96JQHcdfJJmVd6N52ua6pkAPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792081094; c=relaxed/simple;
	bh=VrUR1eE0MAXaMIprL+dKn4SI4GAzlMpCyD3hsSqHy5k=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FnR1+jaFLYstMJOcONKTnhkoAGJsEkQBdap378VziVB4bexZ0jHqCCaWlTDz4ldY1Lq63P+rzUCUXAYav9OUMqxL4wcdUIOLvI6jSC3hwI+rPseCiERh3qFJZv7GLraOWgC9orcIti6UXwIaxvTK1Yhw5oRgJ0TqMd0t/kJaSpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rcl6qsoy; arc=none smtp.client-ip=209.85.217.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rcl6qsoy"
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-7bf21ebcc4aso1298150137.3
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 09:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792081079; x=1792685879; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gVDk2NK8sv78MRNIIKPdBP50EGlZpFQMWRB3uVlQaQA=;
        b=rcl6qsoyPElxG8O5DsUqjJstELd4Z6q4K05ZoMtuwZPsvBmro0897pMFHTKUtMDZW9
         17cRx+v73+XXPwFUV86C4B3AqSBjDqCOEvbYS0bGIm+BGfz60h2uS/hyyEiyG6sd8SIy
         8qg8Meb9PMw0z0EFPxNmO8UQTio6n22OQBZFsrriYymxdES3p2W/3jgJxJ81Igwokkk1
         SBMbqb8rl4SoeOmit1TG+MIerqJthU/0bZxufQxbURXI+NUTA2IQDuFjlEE+vQ5IdFvF
         TrjL2MJNULYX6WU3phmZhh8wrFT0MQaufNrgnOTa2mPDhe9HvuV8l7NZZddiPBZzUq+i
         2t1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792081079; x=1792685879;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gVDk2NK8sv78MRNIIKPdBP50EGlZpFQMWRB3uVlQaQA=;
        b=bFrJ7LdO9wROtgsQ4JDuoeRST5Gv6w86knn3aFNTXaoG6ii+eEL43v6+juUhc4fD+c
         0y61AacXWUviPkgiIUcx6CRbghL2awK+3j45FW0FiTIkK0bXVOJHB/NoEDK2JukBDHYM
         ZuQSNYNF1fNljtykjg5qltExLV0cwUkVEBlwwQe/OVYQRWdEw8CFom+tS89D7f3HCplD
         icGzB7GoufF0j0ONns0a3aSJPGhgC0SrGUzWr/va2l49y/S8lCaSs1agzOAJWMXHWdmn
         LRk9OXm/gdDItT4/UJJCpHdo62u6S2K7Z8q+kHWZMBP1RrscO/m1i/wnfVNvK3mZbOYp
         PSHg==
X-Gm-Message-State: AFq9FYLo6+uZmTCqtMk2niLTDtheGJRtt0/b8G7/TiAMFGTKuAhnuH0z
	aVlYN3P5nWjnWXWDHXLTTz6SnwFKyS06SlNQTrQBWUcBdIaQTAwMTvZKN3/xo2QFLVOj7mU1z5M
	5rSUBLyYwtg==
X-Received: from qvbdr14.prod.google.com ([2002:a05:6214:8ee:b0:91b:7eca:ffa1])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6102:fa0:b0:7c3:90db:ed50
 with SMTP id ada2fe7eead31-7cb3729bd6amr6869205137.17.1792081077591; Thu, 15
 Oct 2026 09:17:57 -0700 (PDT)
Date: Thu, 15 Oct 2026 16:17:55 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015161756.3078300-1-jmoroni@google.com>
Subject: [PATCH] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, metze@samba.org, 
	Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Previously, the IRDMAQPSQ_PBLADDR FRWR WQE field was being populated
using a mask that was right-shifted, whereas it should have been the
address being right-shifted.

This ended up working fine in many cases because the lowermost 12 bits
are always zero (the addresses are page aligned) and the uppermost 12
bits are usually zero too, but it could break for DMA addresses that
are wider than 52 bits.

Fix this by right-shifting the address instead of the mask, similar
to how it was done in the original i40iw driver.

Tested with NFS over RDMA with some added debug logs to ensure it
was hitting both the direct (single page) path as well as multi
page (< 512).

Fixes: 3f49d6842569 ("RDMA/irdma: Implement HW Admin Queue OPs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/irdma/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 0db73fd7d01b..b62bf4d11829 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1727,7 +1727,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 			 info->first_pm_pbl_index >> 16);
 	set_64bit_val(wqe, 8,
 		      FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXHI, temp) |
-		      FIELD_PREP(IRDMAQPSQ_PBLADDR >> IRDMA_HW_PAGE_SHIFT, info->reg_addr_pa));
+		      FIELD_PREP(IRDMAQPSQ_PBLADDR, info->reg_addr_pa >> IRDMA_HW_PAGE_SHIFT));
 	set_64bit_val(wqe, 16,
 		      info->total_len |
 		      FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXLO, info->first_pm_pbl_index));
-- 
2.56.0.385.gd3acb90ef8-goog

