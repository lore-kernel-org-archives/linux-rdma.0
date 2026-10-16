Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22D3446073
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 20:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792182576; cv=none; b=jmt75ogKluS0z12bu9cMqrknNGOKZNS4/wedcwEJ0k7XrJs/eJbXeatj+dRdAdacMzEhEVBLT0/wNJKDRMmiFt7RP9AsyCdoEHTXuHyKwDHmcs9T6sVPvdK9c3jzvtxpLMmAQCk3FHdGjvfoJlhpyfEF2nxox0r6PhtyncxQutw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792182576; c=relaxed/simple;
	bh=AwIYAUE+IDC9LiRwdBTT1Pd1UEL1hzxH1T8RDGwzeb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTvwXXqgfhpgx5EI6jlsLDffYArm6+FsWUOQvKdzo2xojx4+qO5m7ADLjjqFxhEWCzTZ/2dSZDIHUuUbRaannIPhlxZmw37GmvAG8t0QxVCkwGRWFkc/z5IBzBptW66s256a0B8vIFN6ROC6fGpqrhJQNddNyrn3+kiBLPIZE5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co; spf=pass smtp.mailfrom=x6u.co; dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b=X77FX8Ej; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=x6u.co header.i=@x6u.co header.b="X77FX8Ej"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5e9616ae981so239253e0c.3
        for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 13:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1792182571; x=1792787371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3aYFM6YBCwEZLKr+JLdUZp7eLuz8AbhTnX/F18Towkk=;
        b=X77FX8Ejh1vOxjlQuNlI3fQbkxbYLNNxs5haDUtYPRvqxw+z2FN/QekcbgbKMNTTZr
         XSsDAv0ljCvnDLqZ2+YnRRLV7C77QHrmTiRvomUo//nI/jKOUNms4ioZ1qLpuFvuyzGF
         OBtJZWgypEt9UhNpMx9LxaDHwk8MDbGfEW7Xg473l+csDZOVrpxZtP94sgVHIzA6p9xA
         7a+W6ypJ7j7PBH82CFb4JTPTrPBuMzqxZnxe5dwTOA5B4C7cnEYkNSkkt53cWSNagD9x
         4oQg02TrLTTZzQvT82VnZ2Qs6EWIZPmzCaVQ5QoySw+hmEj0C83jwyryjukmJVSnBzEr
         hRrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792182571; x=1792787371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3aYFM6YBCwEZLKr+JLdUZp7eLuz8AbhTnX/F18Towkk=;
        b=j3PsreDVHRedS+c+tVYiq3w1C0Hp033W/Epyz9lw9kusPrYj5g7nX2Gim6y7kSHEfM
         agX+pF2SYgGsKPqvi5YFgyrOsF62XN28XW4CPEvB0hO74iZKkuI5MHorSFWJqMg6zAbx
         ZuHhpsubtEBLk1XP2uVydCWxkZu7P/VqA40AdwhlAJwSQYlEryDg5qDE5JTbJeivQ3tu
         0dJXiu1P+ddhaXjKdf+ji3I/pdCRKjuu4x+z6aiAQVk28iFcIED9CYfnh+l7IrPDR/sW
         YEis+AL0leUYkFRkVTvIPQ405yMXP/y+afYLMwNsQB0VUe5Nzvc90Xmh+N/LpMs38AFu
         x0dw==
X-Gm-Message-State: AFq9FYL9L9zN96/1uUAANUqwpJKnPY8HHBhegWc2d9sEyRw5quxiTGlX
	ZcpnwVtCuAUSpjXZI0KVgYsrIjiEZBD4pVxbzCJawsnEyE0l/LvVuEUemjJQ3wIDf5kX
X-Gm-Gg: AYBFou2k3E0YSBgOPrPl1wNuSc8NYLvK00I1Z8+4gTGCQlgI3PQw0o3cuarVTbY6DSE
	T0RWa5LjjsaiRqeXGrGz3udulkvZ2YIQJ5PovTIH5ueT+3Nib0/bayqtU/+hhI77H8TXl0HVfup
	Jh/FsbGzZEGnXg/Fj7BB2oCf1TE4Baguc6FR7KhBwN8Gz8nEZER8l9a2B0CbMs+d4AC8h60sO/P
	y9J+qKKjdUX1f8oAeFVgR/CNIm/sHcruktLbg9yDkqXozStMNjg4o/hlXXjxb629dqSNfBniqT3
	sT9NrYEpeIv+dBucJIxVvMeRZCPpqfyNlh5i6/s4W2lpu+ZkhFGOr1Pvs8koddn3bAk1DcbRXvI
	/TKODLtcnMOJ8nr99NWdvC+Cx68JTsGG+CisIm6D2n9CBf0v3dwMm3/cDly8j1WNLUA9o/mg0b/
	4QD4NUzb+/uei7OAI0vSiJkjSXjanvyxkIKdRVA/kFrJnYvn3JlFtIQReBmk7hA//TK/vdx0NU6
	Pismqc4HZcm56ZKbsWLN2Te2eUZD6twUztdfXKI4LhCvytv2N9zx7xxjtowXN6e7XKpwLKcDXvC
	ew80QwhYctuu8hWQYjq8mquresy0qTeGi5qqTsdmZIy1/ra52vG5Tpw6fyf8RNMo6Xc=
X-Received: by 2002:a05:6122:4217:b0:5ea:9f07:5134 with SMTP id 71dfb90a1353d-5eaaa37e98dmr511145e0c.5.1792182571428;
        Fri, 16 Oct 2026 13:29:31 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (119.20.221.35.bc.googleusercontent.com. [35.221.20.119])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b5201b1sm2588281e0c.12.2026.10.16.13.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 13:29:30 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next v3 2/6] RDMA/irdma: Register irdma UVERBS ioctl namespace
Date: Fri, 16 Oct 2026 20:29:05 +0000
Message-ID: <20261016202909.1289496-3-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016202909.1289496-1-dhu@x6u.co>
References: <20261016202909.1289496-1-dhu@x6u.co>
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
2.56.0.176.g3575e65682-goog

