Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBA644CF25
	for <linux-rdma@vger.kernel.org>; Thu,  4 Jun 2026 11:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780573599; cv=none; b=HZSYe6jQ8MDXoGFYjbBv0r3rC2qGPAhmQn59K7z4a242VAvCd7Mj3W7QnOMuWdsQdKT7L97RVnHouumMA+qRY7kvphy27tJu/5JoCBSzs5hF7y88KmZiVNKqwBQ6eddpFLDLFVb2qGTgs0wAX3zJiZcMXpptFMqSM+l4Owqny1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780573599; c=relaxed/simple;
	bh=/8gO7J3bhzCvIti3bfsQRRdglSV7VAREq9eteCnZaeY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lqZTMmNH+U2pjwMYdFqXPLdmVA1Hjoniqml18edE13NH9YBDEyWFWvWEA6DqrCu8v4g3xQEAztnBllUExvqKiLBqzi6AUY854tKQp2SnsD5PXHhbq87Ly1f68qXMBiKGfixip3H0H00vs8rEThLNwxJKAhaTc37iVVJl7Tm6dGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=b8tJrY93; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="b8tJrY93"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1780573598; x=1812109598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NOV9XNpUioa3sHSe2kwErnnEa/SZu0nbGnUv+qK3HyM=;
  b=b8tJrY93CYkhlaqDujhQUmaYWwLPI59Vw/u8IMD4FMbSUtfRJrcKwT3s
   /9uDGfImQjwf+5kW2SHnZ5HfcpijTX9PMw9l52/5mA16LbM9VUzhB2Fvh
   kXjtFR6rWaNjaNvKttHRxfRdjOaEjqMGraplp3UO/V6N6libcyR1XFH+3
   ahvCbJqGBR3FSc2QOyo3N7SY1itwRijm1LcTOk3DtoAUgQ/UuOIy4YGHq
   FTMEE3HIaMZjUy0cBtt8qVfU9dF1XOhgCh0NXU/9RTCKb0WNXZC72g4a0
   Vlp9k53Kisy5W0EJTwrHsv7bX6IiLvK2qBznTfPA/S89uH/lj6/hM5SFF
   A==;
X-CSE-ConnectionGUID: S8SrlGPQQw+Go5Qr921Ucw==
X-CSE-MsgGUID: Q7WJ3R/xTPmdHpqT8onL0A==
X-IronPort-AV: E=Sophos;i="6.24,187,1774310400"; 
   d="scan'208";a="21098828"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 11:46:35 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:19111]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.40.245:2525] with esmtp (Farcaster)
 id d352bf9c-c699-40b7-9d57-62336423fd7d; Thu, 4 Jun 2026 11:46:35 +0000 (UTC)
X-Farcaster-Flow-ID: d352bf9c-c699-40b7-9d57-62336423fd7d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 4 Jun 2026 11:46:34 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Thu, 4 Jun 2026
 11:46:33 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>,
	"Yonatan Nachum" <ynachum@amazon.com>
Subject: [PATCH for-next v6 3/5] RDMA/core: Add Completion Counters to resource tracking
Date: Thu, 4 Jun 2026 11:46:25 +0000
Message-ID: <20260604114627.6086-4-mrgolin@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260604114627.6086-1-mrgolin@amazon.com>
References: <20260604114627.6086-1-mrgolin@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWA003.ant.amazon.com (10.13.139.43) To
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
 drivers/infiniband/core/nldev.c                      | 1 +
 drivers/infiniband/core/restrack.c                   | 2 ++
 drivers/infiniband/core/uverbs_std_types_comp_cntr.c | 6 ++++++
 include/rdma/ib_verbs.h                              | 1 +
 include/rdma/restrack.h                              | 4 ++++
 5 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 5aaba2b9746b..9165f741dbdc 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -447,6 +447,7 @@ static int fill_res_info(struct sk_buff *msg, struct ib_device *device,
 		[RDMA_RESTRACK_MR] = "mr",
 		[RDMA_RESTRACK_CTX] = "ctx",
 		[RDMA_RESTRACK_SRQ] = "srq",
+		[RDMA_RESTRACK_COMP_CNTR] = "comp_cntr",
 	};
 
 	struct nlattr *table_attr;
diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index ac3688952cab..d152cc5f042b 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -102,6 +102,8 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
 		return container_of(res, struct ib_srq, res)->device;
 	case RDMA_RESTRACK_DMAH:
 		return container_of(res, struct ib_dmah, res)->device;
+	case RDMA_RESTRACK_COMP_CNTR:
+		return container_of(res, struct ib_comp_cntr, res)->device;
 	default:
 		WARN_ONCE(true, "Wrong resource tracking type %u\n", res->type);
 		return NULL;
diff --git a/drivers/infiniband/core/uverbs_std_types_comp_cntr.c b/drivers/infiniband/core/uverbs_std_types_comp_cntr.c
index 967f05f76bbe..41236cb39703 100644
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
 
 	ret = uverbs_copy_to(attrs, UVERBS_ATTR_CREATE_COMP_CNTR_RESP_COUNT_MAX_VALUE,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 2c59e71cb1de..d708f2217bc5 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1753,6 +1753,7 @@ struct ib_comp_cntr {
 	u64 comp_count_max_value;
 	u64 err_count_max_value;
 	atomic_t usecnt;
+	struct rdma_restrack_entry res;
 };
 
 enum ib_comp_cntr_entry {
diff --git a/include/rdma/restrack.h b/include/rdma/restrack.h
index 451f99e3717d..4ab72bc6d8c7 100644
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

