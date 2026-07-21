Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE8B414A1E
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 07:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784617254; cv=none; b=EaD/3cdvGan7SouCMMba6XRTSyUQ3DQlI07WIFokS3R7ISjZcSgd+jrUJcpiUm+e9tKtLBeSo2xBDrsvId/ZFnuD0BBJYRGWsan0LsaxiF8mFApmVE8owMb5E+nPjSrn5jL4u1Sd9L49QlTysdOpFLF1KONDYUstHfdX+Z6SgCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784617254; c=relaxed/simple;
	bh=RkGr6GRfhsadkSTKJnq8vxTBtmMU+a1ZmDnTubGrqwE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFImEPhyXCTLJv9wZiOpyEeDUe8BxvsK7VbNy4aWW48x+Fu0zxAUsuwVDJQJkFQSpwoUHJVpNyZG6zLboF63DPUzg/ArXwN89yCB/frKqVhBEAZBX5ARi+RevetV3wWevEteBfzkrjTJqOrgXgBc5vhqXBcbiYDju5D4pW6C5Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=VTzilTqs; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="VTzilTqs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784617253; x=1816153253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jUdKsLokqGPy826OwkcH4wwND6xoJxGTfLs81Mo0rp0=;
  b=VTzilTqsMJD2DBfEUTz04G5z30mUOWeNZzcmZXlR5wqk+ypJzr9ZpT/P
   LgsZs/gGgRPa5nl/pulcsDySTfT3Swj4FDRIfDVoayIhbvrK0xKdVatrW
   r0eGqIUeB7nQXv13+/q6CWyKywsuGlCBB4+KoTjih9DEyIb1QiWsxruEA
   z9lPQCQdB1l+0Iuif+rMeb8XJaoTMUsE/TebH8kqvWiLD6/GcfWqMHx65
   FfmwaVfS6k1CotnaiEDfeeSdsLJY3u6B3e1+bizTrsv00pXlaKXKMl68h
   7B2DLnHkWCwLmLv3ms2XPANMz6g4d3IxTL19bpoJhgDyPaMi4Y9bxOxCQ
   Q==;
X-CSE-ConnectionGUID: bLcVizxUSY+1LV+QPKSeBA==
X-CSE-MsgGUID: hpWkCIDKRwmFPRMT6qLqlw==
X-IronPort-AV: E=Sophos;i="6.25,176,1779148800"; 
   d="scan'208";a="23556555"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 07:00:50 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:27204]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.246:2525] with esmtp (Farcaster)
 id 8b461622-51dc-47d6-a2d7-66c1308e01a8; Tue, 21 Jul 2026 07:00:50 +0000 (UTC)
X-Farcaster-Flow-ID: 8b461622-51dc-47d6-a2d7-66c1308e01a8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 21 Jul 2026 07:00:49 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Tue, 21 Jul 2026
 07:00:48 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>, Tom Sela
	<tomsela@amazon.com>
Subject: [PATCH for-next 2/2] RDMA/efa: Expose 64-bit send WR ID support to userspace
Date: Tue, 21 Jul 2026 07:00:26 +0000
Message-ID: <20260721070026.1635441-3-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260721070026.1635441-1-ynachum@amazon.com>
References: <20260721070026.1635441-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
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
index 001bd8cb4f66..85e32a7c76c3 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -264,6 +264,9 @@ int efa_query_device(struct ib_device *ibdev,
 		if (EFA_DEV_CAP(dev, UNSOLICITED_WRITE_RECV))
 			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_UNSOLICITED_WRITE_RECV;
 
+		if (EFA_DEV_CAP(dev, SQ_64_BIT_REQ_ID))
+			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID;
+
 		if (dev->neqs)
 			resp.device_caps |= EFA_QUERY_DEVICE_CAPS_CQ_NOTIFICATIONS;
 
diff --git a/include/uapi/rdma/efa-abi.h b/include/uapi/rdma/efa-abi.h
index fc4b2eb903c9..1e371bfef6d8 100644
--- a/include/uapi/rdma/efa-abi.h
+++ b/include/uapi/rdma/efa-abi.h
@@ -135,6 +135,7 @@ enum {
 	EFA_QUERY_DEVICE_CAPS_RDMA_WRITE = 1 << 5,
 	EFA_QUERY_DEVICE_CAPS_UNSOLICITED_WRITE_RECV = 1 << 6,
 	EFA_QUERY_DEVICE_CAPS_CQ_WITH_EXT_MEM = 1 << 7,
+	EFA_QUERY_DEVICE_CAPS_SQ_64_BIT_REQ_ID = 1 << 9,
 };
 
 struct efa_ibv_ex_query_device_resp {
-- 
2.50.1

