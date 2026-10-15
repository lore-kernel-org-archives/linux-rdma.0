Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1283264D6
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 01:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792027237; cv=none; b=U3x4l+JsrAySPVfXTgMnwFTI5YlaWVx0MbVk5vCEkF14lX/lH9qmrkDnZeWU8I4wUKl/9K4Oa6hiBDaRQ1/UNaHhn/L4ICT2ngEUKa/IDSDVS1UBuZ+ztsUXDkhrCzTCDXrBSVTqj/REuwg3VS3Pbiy7a3iSqRnPLv3cateyyEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792027237; c=relaxed/simple;
	bh=L0KQQ8xq4Y44BF6U2LVsAuBIdnFeV//SMhA/e3LFNKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBy7NqKMZCmkRF9CzKRZMj7OWufC35GQeBdUsGiU5zsLfGCmDCKEzI60s2aQFjMUYBtFZwcuMqrkUupOSQnVEJczPp4fVDnoQb4i/qQ1IgzLRI4fZYKBBO3GJgxHEdmOA+AsmxsYp/dEPTVW2jbJEoQe/HIHDSO3vew/q4jBwMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=L1CKsUvE; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="L1CKsUvE"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5d8e5624261so363709e0c.0
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792027235; x=1792632035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=srRgKprJCTM16UQUnNEbwiln2ybPBfVZxDDC43IfN+E=;
        b=L1CKsUvEDIF6sSVChcwZAMt5YNsl8S0W4n2NBGlUDmjpqi3cxAFgLnVEhrSh55Xzw9
         SSCq07gIcjGbZmdKoY4jNmPEErd5qv/xtVH9Vmc+vHtL1ba3YQ5wJKLS29ueMhWpU+nO
         pynCyfrE+GJC0bcDmQP0Ma/zyX5gISIp93JPMipjmJ0uSssd0eme4wrRjlS6SdwkH6nR
         eNN2a6VS2/BjoIfh0Daqogix2ObmyyEF2+/VLycgl5Nh1hO8EOkE8bw0g4FmmpjB9LrC
         UyKOXv5Ukw313d2wC9+1XQdI769BsEY/8uuuOAo+BKze6gYpB2TLVCRPsXitLH0omuGV
         GWrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792027235; x=1792632035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=srRgKprJCTM16UQUnNEbwiln2ybPBfVZxDDC43IfN+E=;
        b=yJvvBiQb368RluDJUuRUfQV0wWYVKfUeJwnD4xdn+OBaLEf76tka5MPSQXZu63c8ab
         UDDciIjEyc+E+4ekJGmwH8Y9Tj6PWULLwrP84ZCThyvlHftLJuJQmYIxLQ82yf+nGlX0
         AsDnUWnw9eb4iHwzTvW3OEAuXatxQTfNaNarJ9VF16wYQKQ3BvmlMaCtAqmB3CJUjl6O
         MZ2IiTohR5CM3fiQhWT/cKDPAD2XBuVyt44mcaQC3SAVBTn2WGEzmmNjNIxYI7PGz0jP
         K0Xxx6fJ4q9HZPpggP8PEjwV4/Fhwhgyq4tcLg6l4rbum0WbUCc5YwaJzh3fiCzfdPsD
         vJEg==
X-Gm-Message-State: AFq9FYJ9AVL5K7Woqsza1t9JEJVV99eRrgoX9YkHqY9JshaFZRPXs8UD
	r7sq28ZzsGavLoMUkGgN1IzFjurj9LgUPWDd5j3WyISuxTjHAJVJ2lUw7NAugYvPQl+P
X-Gm-Gg: AYBFou2DAD00VsUweRk0EullXxw/TTOwCG3nIYfn9eN6rSXK3OXlIFyTdRFrOKW3yU0
	uKm8tmYdJ+qQF8KE1hG4BLGHgtMYxgNF93Zdvp87mZelWlxU+2+hVA5MR9TXO5rsmK1cAmf9IOR
	sg96Q3AqW9y+DS+s7MEIeV3v58KUlyaAm6IrA0hp38Cc9kpgkKJkycKhkxKyVYbWXWkzaTcwDtM
	776rtV16A7zy5gmtNDTZJOOTrl4Pf9xH9qGqwk6R+4MToEmhKqIlpBbrMquYfFgZAFFFKxK+i86
	wEIjwO+Rpp5s3WRgA1Ck+J3KlzwGuUJLOnRVa/U0oztAAmfV5HPGRfUFLbPtlnP/Nf8X57lhhsh
	e62iyrD9tfCIGtdc92mGmcJDi429W9cHoilCFV/0gsLwrtRIiQkO3eCpgBiJSSFr4ZYonw95r93
	wpuOHo1Nxu0n3z3/e/Ha1kHTIMlle18ChAw6mHjwwb1jusRhtQebnK/pktQpEcdwDHJsr5fk7IL
	dBPt8PjzwXmYeRItA9H0DVeFjlCv/PLzuuoneI4WQrwyEWba+WakEM5WRwUBoaeFbO5aadGisgx
	jVivlY+wGA==
X-Received: by 2002:a05:6122:180a:b0:5c9:c60e:f4b5 with SMTP id 71dfb90a1353d-5e91f516df2mr5363084e0c.19.1792027235094;
        Wed, 14 Oct 2026 18:20:35 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5e91cab57c8sm12406159e0c.5.2026.10.14.18.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 18:20:34 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmoroni@google.com,
	eagleshaw@google.com,
	xuehaohu@google.com
Subject: [PATCH rdma-next v2 2/6] RDMA/irdma: Register irdma UVERBS ioctl namespace
Date: Thu, 15 Oct 2026 01:19:36 +0000
Message-ID: <20261015011940.4122452-3-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015011940.4122452-1-dhu@x6u.co>
References: <20261015011940.4122452-1-dhu@x6u.co>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Hu <xuehaohu@google.com>

An irdma UVERBS module is now created. An irdma specific shadow buf is
defined for CQ, while QP and SRQ reuses core's uapi definitions. This
works since core builds shared core ioctl parsing tree first, before adding
driver specific `uapi_definition`.

Destroy paths are automatically handled by core dispatchers, as objects
are now registered in the parsing tree and no additional driver specifics
are needed in destroy ioctls. Resize, Query, and Modify continue to go
through write() cmds.

Signed-off-by: David Hu <xuehaohu@google.com>
---
 drivers/infiniband/hw/irdma/verbs.c | 18 ++++++++++++++++++
 include/uapi/rdma/irdma-abi.h       |  5 +++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 10c790fdfc57..b2ffdc8e3d67 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1,6 +1,22 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2015 - 2021 Intel Corporation */
 #include "main.h"
+#include <rdma/uverbs_ioctl.h>
+#define UVERBS_MODULE_NAME irdma
+#include <rdma/uverbs_named_ioctl.h>
+#include <rdma/ib_user_ioctl_cmds.h>
+
+ADD_UVERBS_ATTRIBUTES_SIMPLE(
+	irdma_cq_attrs,
+	UVERBS_OBJECT_CQ,
+	UVERBS_METHOD_CQ_CREATE,
+	UVERBS_ATTR_UMEM(IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM, UA_OPTIONAL)
+);
+
+static const struct uapi_definition irdma_uapi_defs[] = {
+	UAPI_DEF_CHAIN_OBJ_TREE(UVERBS_OBJECT_CQ, &irdma_cq_attrs),
+	{}
+};
 
 /**
  * irdma_query_device - get device attributes
@@ -5629,6 +5645,8 @@ static void irdma_init_rdma_device(struct irdma_device *iwdev)
 	iwdev->ibdev.phys_port_cnt = 1;
 	iwdev->ibdev.num_comp_vectors = iwdev->rf->ceqs_count;
 	iwdev->ibdev.dev.parent = &pcidev->dev;
+	if (IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS))
+		iwdev->ibdev.driver_def = irdma_uapi_defs;
 	ib_set_device_ops(&iwdev->ibdev, &irdma_dev_ops);
 	if (iwdev->rf->rdma_ver == IRDMA_GEN_1)
 		ib_set_device_ops(&iwdev->ibdev, &irdma_gen1_dev_ops);
diff --git a/include/uapi/rdma/irdma-abi.h b/include/uapi/rdma/irdma-abi.h
index 38155affc8b4..a1a26529aa85 100644
--- a/include/uapi/rdma/irdma-abi.h
+++ b/include/uapi/rdma/irdma-abi.h
@@ -10,6 +10,7 @@
 #define IRDMA_ABI_H
 
 #include <linux/types.h>
+#include <rdma/ib_user_ioctl_cmds.h>
 
 /* irdma must support legacy GEN_1 i40iw kernel
  * and user-space whose last ABI ver is 5
@@ -23,6 +24,10 @@ enum irdma_memreg_type {
 	IRDMA_MEMREG_TYPE_SRQ  = 3,
 };
 
+enum irdma_ib_create_cq_attrs {
+	IRDMA_IB_ATTR_CREATE_CQ_SHADOW_BUF_UMEM = UVERBS_ID_DRIVER_NS_WITH_UHW,
+};
+
 enum {
 	IRDMA_ALLOC_UCTX_USE_RAW_ATTR = 1 << 0,
 	IRDMA_ALLOC_UCTX_MIN_HW_WQ_SIZE = 1 << 1,
-- 
2.56.0.385.gd3acb90ef8-goog

