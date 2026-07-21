Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83213FDBF7
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 07:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784617246; cv=none; b=rHPtbdxWkkoaphhrVofZhg/zr1D6ixb/S3LUep9a/pIWjfsBjOFP21G8YGSsllrTW37o3T9RT12k6A7r00Ut8ZTHF7jtmRgbbi5uwzsJ/bx57EoN0pj/eGCNCxpdslv4Q/wEOCUr0tHo8UXbco/LLrclKLmyfnH/i57NddfCAO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784617246; c=relaxed/simple;
	bh=G7RMgN+DCiXqa9nFVUfBlGo54H52dJsVrvUBqrbz8Vc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P+iokz4gsXDNJj3miOBbC2cNKwilkgk/M7ieI4kPU60T6aomr0Fig9G7w+0lBS9ueIhK7Ujlv/Oge6LXMjq5JWqP1HWSpFfT5YDYKrbSS34QLktbPVArsHYAf+GQJjKvd5uMaR8LdN29LfK7L6DOblnigBdWp0qD+dEQkXafxcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=pe1UgVGY; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="pe1UgVGY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784617245; x=1816153245;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1jbnVbAriyZquorPzXqxz7XetDnaya+LMEs+rjKZS3k=;
  b=pe1UgVGYUAtzvg4kLdDkHtoVjLB1WM9rReT+ioPlRn5q3yepef+oJJMB
   b/4WAv+QLCKeuJXCLyocH43EUauhPqlXP/YePYhKJkCmnFweM/Ocimtz9
   BEHgSWqNO98iarA6duFebgCiMQTyMro2Eg/y4TAYTevtA3LnQ/Lqv2MpK
   Of1vyC9/3vMR82t0lL5G/ho5zvfl6ZjhfMGwlVJk0mnE6QgApcMVHuD2u
   xfWhn6Q1R/JokCGa8fhQGl0SnzpZ0oYRefBdpeOhdzs58JHQXwP4UHMf0
   CrSO/YshcOeIBqfvzFAiw6V02Ssdd3thn11GZ40ui1qaNAUPgiWb3293p
   A==;
X-CSE-ConnectionGUID: t0Hfh0X7SnyLx+fIEdfxhQ==
X-CSE-MsgGUID: aZ16BuuVRN6ZQELPWXiD4g==
X-IronPort-AV: E=Sophos;i="6.25,176,1779148800"; 
   d="scan'208";a="24049416"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 07:00:43 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:17126]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.246:2525] with esmtp (Farcaster)
 id 19aaa196-33b2-4dba-9ed2-36a369f04232; Tue, 21 Jul 2026 07:00:43 +0000 (UTC)
X-Farcaster-Flow-ID: 19aaa196-33b2-4dba-9ed2-36a369f04232
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 21 Jul 2026 07:00:42 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Tue, 21 Jul 2026
 07:00:41 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next 0/2] RDMA/efa: Add 64-bit SQ request ID support
Date: Tue, 21 Jul 2026 07:00:24 +0000
Message-ID: <20260721070026.1635441-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
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

This series adds support for a device capability that allows SQ WRs to
carry a full 64-bit request ID, removing the need for that translation
table on devices that support it.

The first patch adds the CQ/QP creation plumbing needed to negotiate
64-bit request ID support with the device. The second patch exposes
the new device capability bit to userspace so that the driver can
report support for it.

Yonatan Nachum (2):
  RDMA/efa: Add CQ/QP creation with 64-bit SQ req ID support
  RDMA/efa: Expose 64-bit send WR ID support to userspace

 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 20 ++++++++++++++++---
 drivers/infiniband/hw/efa/efa_com_cmd.c       |  8 ++++++++
 drivers/infiniband/hw/efa/efa_com_cmd.h       |  2 ++
 drivers/infiniband/hw/efa/efa_io_defs.h       | 12 +++++++++--
 drivers/infiniband/hw/efa/efa_verbs.c         | 10 ++++++++++
 include/uapi/rdma/efa-abi.h                   |  5 ++++-
 6 files changed, 51 insertions(+), 6 deletions(-)

-- 
2.50.1

