Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458A0486638
	for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 18:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784832422; cv=none; b=Iv3ROfDk4kdLkFA7EI8gFnzBAGMmnghKc8qlV1V7mF9MCTDaIObTnuzkGpmt3xkqeJqESvpBPjlnsTGtK8y0uIVFiOtN3eVn1sNZ6/Zwboxn/f0FWddzN36+N8kt+0cVCHk5kNQKzZSODhz35Su1HciBRzdRv4dpTQTs9lMa9TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784832422; c=relaxed/simple;
	bh=MtaJxvWtcMxwy7KysGC7Xw5ElTrFk+fHV4mJQzPjRfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZA0SA73l5hMl2MycG2b9lx/J3uVs0VtTbKjaEx79Y/uS2UPVVKgAHBkcA4WBIsWTmsUfwk3pkooR3kA8VBfoVmw5f5ALsUDyPNIW5N1pPL2HHxhQBdJSOdIaPe29xlmsPoVz2sJdh9OaNb7RCShMWx7Qookkg9AfNzhv4vLVac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K48vG5E4; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K48vG5E4"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38e041ea211so989910a91.0
        for <linux-rdma@vger.kernel.org>; Thu, 23 Jul 2026 11:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784832413; x=1785437213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vcxLMkMQkwFPgPh32AUwe5n1PBUGwnayfW8DiD3NhNU=;
        b=K48vG5E4cJ1J2x93yJxYL3G0T60/XocQlB+Qo6stdYGkRu1E+4OR38wENw6xhLGsno
         8rIpbVfXzJziWjmyxLz0gg6T/yOEeFcOwAjNnRMykKTQgPj2HpnO73yKA2Uw4X6hWzcV
         KNO1z3JQpxG+woaEP6enBtG475G1fhAEs92OkAYCjvNs51PBGqLZV2leHWXD4DpmEyOF
         UV5cELD/8mzBS5HhzTnD2jJh7USJiOiq2axVsAe5ycOfjyhG70NFb9bmhTVEWdkDSblE
         HC+2CWN5bFUEhjmRvkmAZVhyLUSoJ777mdmHExy0A8MQWu390MdOfyH5iswJm4Lu6pq/
         YBnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784832413; x=1785437213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vcxLMkMQkwFPgPh32AUwe5n1PBUGwnayfW8DiD3NhNU=;
        b=BjL54ALKmyziFYdh8LDtk/YXA1O0CgFjoY/0CUOclHvxBjb1TMQZomyzOFIZ3pswnV
         yXRmCoPmw0MRlp1vxYnQj+E3OTDwpjS2RAm6RDJi3c9bdsp4dPRySlnvfQtVc+EqrVUZ
         vkNklxDgD5cU7PI9l2k82rTdiNUP0LtddjyKS26VZhdjocCo/g/tG7ho4o2CHHni3dae
         xfEZJxsCL7GR4dCw/mu6IZqM4NznmRFYJsuMRvv9UTmTA8UH0NBLGnqAZOUYwHA9vdLM
         uyVjR7KCoFBpHO0xGzTiVVyWpBX+QKQDVNeSYJ0+StuWacJRUyQxra8KrQcNE6Va/i8J
         nAMQ==
X-Forwarded-Encrypted: i=1; AHgh+RpBKPFWzlHik/iH12HWO4yhfxqP+9HDpIExR0tZzMkBYhdnVaw+8uSP0Yl78k44xo8sSgtRLCVlrz4q@vger.kernel.org
X-Gm-Message-State: AOJu0YwlPblrw5lfSur7b13NhZ5pu14UuWtrb/z+bTL9VMxq3TLtBI9i
	bepqnx27MnVmzEYqoAsoUi10saQO2ETWZNM32cw7v0Zi1xM7k36MCQGe
X-Gm-Gg: AR+sD10uaak7In24T0JzW4zLkAoXB1IWprKWHVI6pvW2AyhDtes5GcgFRiYHYqTNFo1
	M7BNo2ViJtgIDitoO5UgzpDSmSf0ruo08fvkzwOEmatiy8DMA549QRXciDfd7RCFaa0F4Sc+gRZ
	g2mkbZP90tqF0zVbGLWdq4kIsiJnYGy307SNr6SSQLBh7MYz1MEYKovnYvoBMowHnajWtaHcBbT
	SJ4CQFWj3EC5a8atc94eepJJiROdN5we62iXSmVOZoc6Ca0+gqGYdmdwiJPe2BoDL0FhZSDZKD6
	+YVLA1KmgicfBL8HYMuRhS4IAAXsGo4czY8rb23lC7XpdoLfL+wvEII/nYFRZlemJ8nDoyETOAb
	jqkUi/ZtGPQ1AVw4D7ffziLXMmwBzssgTO0zqlYL2uAZ91bLR8lSvJTbjtSWrj82gJFkiUOeI
X-Received: by 2002:a17:90a:e7c5:b0:38e:895f:25fc with SMTP id 98e67ed59e1d1-38ec6a9b239mr3870068a91.38.1784832412757;
        Thu, 23 Jul 2026 11:46:52 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03af8a45sm308155a91.10.2026.07.23.11.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 11:46:52 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Julia.Lawall@inria.fr,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: cocci@inria.fr,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH 21/36] RDMA/ocrdma: remove conditional return with no effect
Date: Fri, 24 Jul 2026 03:45:23 +0900
Message-ID: <20260723184538.3888637-22-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index cfe3d19b73b3..017b3660173e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1749,11 +1749,8 @@ static int ocrdma_copy_srq_uresp(struct ocrdma_dev *dev, struct ocrdma_srq *srq,
 	status = ib_respond_udata(udata, uresp);
 	if (status)
 		return status;
-	status = ocrdma_add_mmap(srq->pd->uctx, uresp.rq_page_addr[0],
-				 uresp.rq_page_size);
-	if (status)
-		return status;
-	return status;
+	return ocrdma_add_mmap(srq->pd->uctx, uresp.rq_page_addr[0],
+			       uresp.rq_page_size);
 }
 
 int ocrdma_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *init_attr,
-- 
2.43.0

