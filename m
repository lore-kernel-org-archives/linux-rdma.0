Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF30E4D8D85
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784720039; cv=none; b=ryMRFZrAPE6CfGVBqhNGhXYtJyDhKHnGkL6Vz3epPDYdCXzOplhReKbFmUjBIekgD6RVJPEzQ0y8KNCVKV85pCB21RW6x6VAkM5vh7j+zptsoK96A8531yxssXITcsvfETraOVwrSQcrqHaTu8DYY+rShQzHcdt5Eemcn5RIxSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784720039; c=relaxed/simple;
	bh=O1c5vpNVponawLHE8qmLH7X7J/qJJXmx3q0RUxUXu2I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+hJQq8Uvtf6630FOMzHoupVHyr39ZBVnF87h1HNY1h6VT2umg5vpx0yj8H9N46f5Uw2/gjSOC8/xhIoaGOjlWchg3tiyEAmZlMUjmW926Qw/Uww4txmo0q4KMU7V5/CU4Jk3TfBq08Py1jGBp/eLZevy9C49+Ivo0tee9GLWPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=DLPAR5cg; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="DLPAR5cg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784720037; x=1816256037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sYToJns/VQYzSNEL40TsmisRUOjxSYpSIlScqWGsN6Q=;
  b=DLPAR5cgRWwsRQqcvuUwFAig9nWwkgmGvgWkbiKf1B1EuzTjz9CmOITN
   b0JHZJpJaDumpHjhZ8dOvpl+O+EfnyX0XzrnDeRWnQlmW2YK+DFTeIQB2
   H8TCtH8SO72KiLXY5nbuBdE7QluhMhctUclSwrhHRdrMjf+S3f+hRQ5Tr
   ijLQ87lrikcds+UkG7UUC9tyuOUr1znrWB+KGc/OHORu7bgnXAemM9JaC
   T9aE85f0tHdsjeYHMcs9RqR7oysK/dpJIPmqMxlADAD5w89JJ8hzeB3bg
   jVFPVLRVFfs+BkzStdhEkEpKBET0bGoYRxx3lkYuQuI1ccGQj8fJw1DvK
   g==;
X-CSE-ConnectionGUID: MJbv594uT9eviaplClc+GA==
X-CSE-MsgGUID: VZfitgILRiqNJlAKmQB77w==
X-IronPort-AV: E=Sophos;i="6.25,178,1779148800"; 
   d="scan'208";a="24167942"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 11:33:55 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:23890]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.176:2525] with esmtp (Farcaster)
 id be1fd588-c326-4856-97a6-ef570b960f09; Wed, 22 Jul 2026 11:33:55 +0000 (UTC)
X-Farcaster-Flow-ID: be1fd588-c326-4856-97a6-ef570b960f09
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 11:33:54 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 11:33:53 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>, Tom Sela
	<tomsela@amazon.com>
Subject: [PATCH for-next v2 2/2] RDMA/efa: Expose 64-bit send WR ID support to userspace
Date: Wed, 22 Jul 2026 11:33:31 +0000
Message-ID: <20260722113331.2515247-3-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260722113331.2515247-1-ynachum@amazon.com>
References: <20260722113331.2515247-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWA001.ant.amazon.com (10.13.139.112) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Currently EFA WRs support 16-bit request ID, this requires EFA to manage
a translation table to translate the IB WR ID from 64-bits to 16-bits
and translating it back on CQ completion.
Expose a new device capability to handle 64-bit request ID for SQ WRs
allowing userspace to directly post the 64-bit ID to the device.

Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Tom Sela <tomsela@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 3 +++
 include/uapi/rdma/efa-abi.h           | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 73a80caca7e2..6abb93b50731 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -272,6 +272,9 @@ int efa_query_device(struct ib_device *ibdev,
 		if (EFA_DEV_CAP(dev, EVENT_COUNTERS))
 			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_COMP_CNTR;
 
+		if (EFA_DEV_CAP(dev, SQ_64_BIT_REQ_ID))
+			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID;
+
 		if (dev->neqs)
 			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_CQ_NOTIFICATIONS;
 
diff --git a/include/uapi/rdma/efa-abi.h b/include/uapi/rdma/efa-abi.h
index 5d3d01b6333e..2094b4bcc5cf 100644
--- a/include/uapi/rdma/efa-abi.h
+++ b/include/uapi/rdma/efa-abi.h
@@ -136,6 +136,7 @@ enum {
 	EFA_QUERY_DEVICE_CAPS_UNSOLICITED_WRITE_RECV = 1 << 6,
 	EFA_QUERY_DEVICE_CAPS_CQ_WITH_EXT_MEM = 1 << 7,
 	EFA_QUERY_DEVICE_CAPS_COMP_CNTR = 1 << 8,
+	EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID = 1 << 9,
 };
 
 struct efa_ibv_ex_query_device_resp {
-- 
2.50.1

