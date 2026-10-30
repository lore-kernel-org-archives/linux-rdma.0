Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384148;
	b=l+KvEu1hhcvrZZnmVDMwe7efKiKyku7MjYFUB/798Ah5UjlW2kJv1LA2zLAcIQFh5kYG
	 /87/NXj0lhyIoVMeW8dlnr2dlOWO+U8Abi4o+TjIXuXxQsC7zTCT4/r6QhZoeDrlpnf8D
	 MGzl18KDI6Jg+KoxGhFRxxqelEdctNJsg7Llj5WysUTg5tWY3U8UQRc+tjAiiu+l6S1EK
	 9CeulazaCN7K0yxFjSYcJf/4et3qjn0QANCV3jQzxrBXXthLf3RmzDRLXoAmaSZGkxJXD
	 oud6iJ+wiIIUEWSd7C7VijRLs4xgUstnxIQ9rnyuy2R+2ymvkTeRJeq1zjSJ70VcKeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384148;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yypjsQQLN14RvHd1ipvvq2CtwzVsovNmzy30kWecM9U=;
	b=y7Rn6TLd53nIW4asBxY9IUweSFtZ9+X1QakBf6u9Cbyi4onaeD18S7O+CbdEPVDHRtYQ
	 epgxSLJMToK3mr/QQvk2maWReniPOXyPiQzJHwe99uSHIQvBl7dM1SylRoF1LsijfudLi
	 VtIipPtzX0wMNRItJqKtbzJ10KNhgo+UcDPjYr2OvneLxKyJKmsqSbi80pC11b0bZGM/Y
	 USL5Bn2qIZI2pon1rTILndOptIl4YWK+5bpt5wpm/Z79KXxS6l4BOgU+Lv4CnnkEWElNY
	 fPnnA6J5VSfT7O/irAfjVpoaKDHcbPxnv+TeU0CVr5RRQQuUr9jNTY4VPQI/gvNvOow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=MwN8lnYT;
	arc=none smtp.remote-ip=209.85.217.50
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D428E606A339
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:15:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D428E606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=MwN8lnYT
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-745497ac8fcso392063137.0
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 11:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1793384147; x=1793988947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yypjsQQLN14RvHd1ipvvq2CtwzVsovNmzy30kWecM9U=;
        b=MwN8lnYTee2WexfvX1dUv7loi+nZULFlEnpRuBpX/fbfovtMBDNUzTgkpSL+piEEMd
         6n3jIYNM4gzQPoC7cyA2G6OLZirD2blR9EQkfBcrfmugVOTw8oTllp6/LqS7I130OJuP
         knjNkiOlpTawGedEd7fFLQfi13RjzzwXn4OrfrLpczaeK3eZ/xfu0+1UovAKbhOxk9DA
         8EkuId46uTBoYPSeCTayngJsbHRJSLDtsvaVX+Dq+6vN62rrpEq7moo6pGmXejvJS+dQ
         sVzaShyfeJcZIchrF/8NKcTINQS9V/qvTAK6xHix6GJ6378mUEvdCOWzu0h8QWwkUerR
         gf9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793384147; x=1793988947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yypjsQQLN14RvHd1ipvvq2CtwzVsovNmzy30kWecM9U=;
        b=2vN648cOQUdxjFL4cQrVu2d3D7ef9kVQx8bDm/DtSs7yx8obBendW/Fo05PvygDPsW
         JeAwLNp9Ty44fsypis+74dlxHOj5edZRsCQneycVz4wwagWpxN4tHnhvlXWqFiilJvtz
         Wu1aBAv//UQzHBJ40CwL6caSsvV5CdgaFxOOO3ixnhcHA2ZKYFKn3RkCCNXNOvUYSQB2
         7GB1D+vczVkR/KfB2m+B2gN9vs4iZ18Nr0CUIOZso2M3jZj2k2fyfA/bO02O3NMIJGdr
         +zFIEAbNsJvXvLm98WaCCCEDDp7x5Z3ffQ+vEqtlphrm9z6HYk6LOeDqYBIlK07MPpZs
         EwkA==
X-Forwarded-Encrypted: i=1; AKwUvBzVo7B7T+hLus5nw7HmNd9Xv7SMLkqNVXrhbJlm0QBehuj777uay6l0s09Zn0nhOXD8TCYDPyzZ9jmD@vger.kernel.org
X-Gm-Message-State: AFq9FYJgk6ma73RYdoJb54oK2ignBJtx1E0/s1+MDKsFAARRrXuCOq6u
	ikB2VlJKNs6sBJNghj1HE/Aw0OtdkuosDMVVxohtc9pRlcAHo6r4pVMd5XL5HbrwcvyL
X-Gm-Gg: AYBFou2WzKSqqjlw4/b+L5YE/0zD+MzJGnYofPBE0c2X7j1T6Zng6qeqH8YQQHYH5hX
	cs0/JZzc2pv5x89Lxdfw/tt+vOkxS2vVFJ1kNSgUd0l4XzPNZOjNXzDtlw/vg8jI8jEp9bm6Lrr
	+DbjKrbrxoOhcJLtAl63y9li8j9bNJBbVtfN6oS430hcC5b8s3K3/Q1GUozbqI+Ji7+38cdBpje
	WO8atLQvU2WRP6hCeqGFvoq009g1OtqlEsEksq9UvnbYtMhe5SRXU09rBrhxoggNxC/m2t+JxOH
	at1iZe5FIp1xQgGM/YHRD223KxkgZyqVrNX2ThLUsdTPfowcVQMgDtFH1VdrUukthlLU+c0iADH
	xYdLH2NK8OqMswI769XEoL9+5RlrA6XXlpNlW0CafEXAI7Ia/5mFK+J1gi6dgpC9i+VWlJIT/Vi
	rVEEwQVAVUvLNTfAe0wT/Pnit1oeKlaxBNOjARZmdeocfb727Zz1lkk5poabWBdiciPW06dYdwz
	it9rSDwcCRbYLPvz9xwrQIjyNlFPEi74sKi6IEkq+dw4+VFWaWynKSeKSJ10NvAuPofsVqk7c24
	+cSpjfLmezt70YhnnAIoQI2ySgbgTLahEggsqWWK72o2YB9yv0zrX4JY0tyXzPjHYye4fQQKP+G
	dGQf+uPwSmlBzaL1KnVY0N810lIOlvCZxPMvjTjuJ/TLQGb/8sAZd1Ha07FJZ0h/v
X-Received: by 2002:a05:6102:5126:b0:7d0:6db8:dc33 with SMTP id ada2fe7eead31-7d0727ada6emr1650413137.2.1793384146946;
        Fri, 30 Oct 2026 11:15:46 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (109.243.150.34.bc.googleusercontent.com. [34.150.243.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d07754c1c6sm3077931137.3.2026.10.30.11.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 11:15:46 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jacob Moroni <jmoroni@google.com>,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next v4 2/6] RDMA/irdma: Register irdma UVERBS ioctl namespace
Date: Fri, 30 Oct 2026 18:15:08 +0000
Message-ID: <20261030181512.2056056-3-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
In-Reply-To: <20261030181512.2056056-1-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
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
index 811b1d532599..dd824720671c 100644
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
@@ -5602,6 +5618,8 @@ static void irdma_init_rdma_device(struct irdma_device *iwdev)
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
2.56.0.317.g454f8302e1-goog

