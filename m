Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDC142668B
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 13:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.26.1.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553763; cv=none; b=pXVeKdN6o7Nn9ZZmXg1kyoE1PZaby0jft3EKyPPRPrcKwSePUKX87CPjLLFbkdFaTxxZOWRX7MyOIw5+0vp86EuIVny338ciZNGchNT4fO2o/UCf43ZNVz6yYEqoqn6zMKPcmVXiHquw8cb0UmntWvQid4651TUkmphXNwk+P9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553763; c=relaxed/simple;
	bh=izz5vu/DpifqEn+/0fUDndz3RW3xQBqIxfQ+VORwu6c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O4zE7lhHlPIrOQ+TsKfiuGP4Zfdb3nTb0Y9P/NYWqJ82eLg09QkACP/z6UT4tRnSe2GPCo9P8kpu74v/CVBFnEqGDOTRfcY0ntcm7rDrWnqZ0UcHHDVT/s5d/I4YWPEjbvfBiZv/UO2OgshM1uBDDXTTv1L+D5xyu/wKw/fc0KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=qidmYcTq; arc=none smtp.client-ip=52.26.1.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="qidmYcTq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784553762; x=1816089762;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=813Za58SoIn4B+f/BKlA01Esl4bohJufdjNZS8Oj5ew=;
  b=qidmYcTqH45FwlLLggo7D7ngaR2vLoSBccjn/yaJgxPWW6RK+uZn+1V6
   0MD1V7aO8AVerC2b8xLHOAgH5c2UI2YoQcZSeOuO0RQKmjyaXLG09kwta
   EJAHzimOfAC80N28tN29fRD+ZkycSmPH0gqQVIOemUVAwYeRyZdP13hZu
   2GZg5ohpqAVgFnR+fy5jTPTkbWa2ApHRUQkq3Z26SZeXrSl5DBU9nYxXm
   S0F6Pu9WMQbwgMv4+y8ik/wlcTq1v6UQAdvlxLhbXAsval06VRv9T13b9
   gThpteGxImsqmKKNUhzxlyfbGjl1YzUQ1/2oOLEgZZ6sx/L2nvZ1Dw78o
   g==;
X-CSE-ConnectionGUID: 703F67BXSx+ZF+GkVDCfzw==
X-CSE-MsgGUID: Lhj3ijDmTe2DalPk8FKCrA==
X-IronPort-AV: E=Sophos;i="6.25,174,1779148800"; 
   d="scan'208";a="24006441"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2026 13:22:38 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:13267]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.48.250:2525] with esmtp (Farcaster)
 id d6e7462e-5f94-4f7f-a590-a2bb2f208cd7; Mon, 20 Jul 2026 13:22:30 +0000 (UTC)
X-Farcaster-Flow-ID: d6e7462e-5f94-4f7f-a590-a2bb2f208cd7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Mon, 20 Jul 2026 13:22:30 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Mon, 20 Jul 2026
 13:22:28 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>,
	"Yonatan Nachum" <ynachum@amazon.com>
Subject: [PATCH for-next v10 4/6] RDMA/core: Add Completion Counters to resource tracking
Date: Mon, 20 Jul 2026 13:22:19 +0000
Message-ID: <20260720132221.2551-5-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720132221.2551-1-mrgolin@amazon.com>
References: <20260720132221.2551-1-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D039UWA001.ant.amazon.com (10.13.139.110) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Track completion counter objects in the resource tracking database so
they are visible through the rdma netlink interface. The rdma tool
displays the comp_cntr count in the resource summary.

Add RDMA_RESTRACK_COMP_CNTR type, embed rdma_restrack_entry in
ib_comp_cntr, and add the res_to_dev mapping. Register the resource
on create and remove it on destroy.

Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
---
 drivers/infiniband/core/nldev.c                      | 8 ++++++++
 drivers/infiniband/core/restrack.c                   | 2 ++
 drivers/infiniband/core/uverbs_std_types_comp_cntr.c | 6 ++++++
 include/rdma/ib_verbs.h                              | 1 +
 include/rdma/restrack.h                              | 4 ++++
 5 files changed, 21 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index aae4f3f6bcba..a2340d615946 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -451,8 +451,10 @@ static int fill_res_info(struct sk_buff *msg, struct ib_device *device,
 		[RDMA_RESTRACK_MR] = "mr",
 		[RDMA_RESTRACK_CTX] = "ctx",
 		[RDMA_RESTRACK_SRQ] = "srq",
+		[RDMA_RESTRACK_COMP_CNTR] = "comp_cntr",
 	};
 
+	struct ib_comp_cntr_caps comp_cntr_caps = {};
 	struct nlattr *table_attr;
 	u64 curr, max;
 	int ret, i;
@@ -464,6 +466,9 @@ static int fill_res_info(struct sk_buff *msg, struct ib_device *device,
 	if (!table_attr)
 		return -EMSGSIZE;
 
+	if (device->ops.query_comp_cntr_caps)
+		device->ops.query_comp_cntr_caps(device, &comp_cntr_caps, NULL);
+
 	for (i = 0; i < RDMA_RESTRACK_MAX; i++) {
 		if (!names[i])
 			continue;
@@ -484,6 +489,9 @@ static int fill_res_info(struct sk_buff *msg, struct ib_device *device,
 		case RDMA_RESTRACK_SRQ:
 			max = device->attrs.max_srq;
 			break;
+		case RDMA_RESTRACK_COMP_CNTR:
+			max = comp_cntr_caps.max_counters;
+			break;
 		default:
 			max = 0;
 		}
diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 1b2f9df49e28..bf0422e1c1d8 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -104,6 +104,8 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
 		return container_of(res, struct ib_srq, res)->device;
 	case RDMA_RESTRACK_DMAH:
 		return container_of(res, struct ib_dmah, res)->device;
+	case RDMA_RESTRACK_COMP_CNTR:
+		return container_of(res, struct ib_comp_cntr, res)->device;
 	default:
 		WARN_ONCE(true, "Wrong resource tracking type %u\n", res->type);
 		return NULL;
diff --git a/drivers/infiniband/core/uverbs_std_types_comp_cntr.c b/drivers/infiniband/core/uverbs_std_types_comp_cntr.c
index e12aececbb09..5a8fddddc09e 100644
--- a/drivers/infiniband/core/uverbs_std_types_comp_cntr.c
+++ b/drivers/infiniband/core/uverbs_std_types_comp_cntr.c
@@ -6,6 +6,7 @@
 #include <rdma/uverbs_std_types.h>
 #include "rdma_core.h"
 #include "uverbs.h"
+#include "restrack.h"
 
 static int uverbs_free_comp_cntr(struct ib_uobject *uobject, enum rdma_remove_reason why,
 				 struct uverbs_attr_bundle *attrs)
@@ -20,6 +21,7 @@ static int uverbs_free_comp_cntr(struct ib_uobject *uobject, enum rdma_remove_re
 	if (ret)
 		return ret;
 
+	rdma_restrack_del(&cc->res);
 	kfree(cc);
 	return 0;
 }
@@ -48,7 +50,11 @@ static int UVERBS_HANDLER(UVERBS_METHOD_COMP_CNTR_CREATE)(struct uverbs_attr_bun
 	if (ret)
 		goto err_free;
 
+	rdma_restrack_new(&cc->res, RDMA_RESTRACK_COMP_CNTR);
+	rdma_restrack_set_name(&cc->res, NULL);
+
 	uobj->object = cc;
+	rdma_restrack_add(&cc->res);
 	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_CREATE_COMP_CNTR_HANDLE);
 	return 0;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 033f4a2c965f..cb3b6163961b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1765,6 +1765,7 @@ struct ib_comp_cntr {
 	struct ib_device *device;
 	struct ib_uobject *uobject;
 	atomic_t usecnt;
+	struct rdma_restrack_entry res;
 };
 
 enum ib_comp_cntr_entry {
diff --git a/include/rdma/restrack.h b/include/rdma/restrack.h
index c081384740ce..47fec3083d28 100644
--- a/include/rdma/restrack.h
+++ b/include/rdma/restrack.h
@@ -60,6 +60,10 @@ enum rdma_restrack_type {
 	 * @RDMA_RESTRACK_DMAH: DMA handle
 	 */
 	RDMA_RESTRACK_DMAH,
+	/**
+	 * @RDMA_RESTRACK_COMP_CNTR: Completion Counter
+	 */
+	RDMA_RESTRACK_COMP_CNTR,
 	/**
 	 * @RDMA_RESTRACK_MAX: Last entry, used for array dclarations
 	 */
-- 
2.47.3

