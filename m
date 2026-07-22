Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BC7439351
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 11:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784720032; cv=none; b=ZDS7+gjA0Q7FMoZ48szjgKHtl+jeSxvAq94qQnFZE6J1xll1ocQHF1VlEpqzFM8R2oa8an5UOJuK9sFa5n6L6HkFkzs+L/leqJEkG8F+txaJeM2U727RlTFAWTIlwOwLHY2cfj8ef9gl7Cgu9fu1Yov6/q1YgKnYnpPi5e22I+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784720032; c=relaxed/simple;
	bh=HKRsyv22rKRKKtVGvH0fvNCPwHNyFIiw7iYvD77+BCk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zazx571aDv/LFEeEDhABg9kVsaxDAwLYtlmPFt6pFXTc0z8VPb0YLFLC/7rwcCSLVoAIDohO6IX42DIsb6JtFzdCzJopjChwFwXmQnoFAjzHES8VeQ3r8ZP5alRnF8In5ZAekUvnH8A39umLsL6cQ6r/xvUBVCYCZ7yhCoyOnpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=OWCUYgR6; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="OWCUYgR6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784720031; x=1816256031;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dbCevWZnO5H8uLNI17UkrnWYww4W9ZOuYmahEMOEKvY=;
  b=OWCUYgR6qCosZFHh/bd5RJLbawUcHxyGwbjBViOIYxy6jcp0IHaeotGV
   9O+jPh931c/O3TUmKdB40Jv57KoK17hzy5pPprdrOctm9GeVLUj7C03dr
   4cZc9eNcsQQVxLvtuj1UMtW6/klCUm/d7HVn+dH2qzk+6JN3vHSCtTQ/t
   6piwnPWsdP8DFFyoSMwSAdZ/8JlP5aRyKDs/67gdueLKSZMXL43hIggdg
   7HkGfTP/wzHBWooImFTigOBKPxZOUXvQbRqAEa9DyA5ail3bnayz9PjRu
   2wymsgrkH2CuvApBTFUk436WvLnnMOAJPFY2DbazXAUc7cYROb68ApEO0
   A==;
X-CSE-ConnectionGUID: tSplqUBRQPy680t+0KA5KQ==
X-CSE-MsgGUID: BO0Xai/RQ8+w1WKk1U7nVg==
X-IronPort-AV: E=Sophos;i="6.25,178,1779148800"; 
   d="scan'208";a="23947717"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 11:33:48 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:13285]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.10.59:2525] with esmtp (Farcaster)
 id 517963a1-bb3e-419a-89d4-6e837869cd8b; Wed, 22 Jul 2026 11:33:48 +0000 (UTC)
X-Farcaster-Flow-ID: 517963a1-bb3e-419a-89d4-6e837869cd8b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 11:33:48 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 11:33:46 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next v2 0/2] RDMA/efa: Add 64-bit SQ request ID support
Date: Wed, 22 Jul 2026 11:33:29 +0000
Message-ID: <20260722113331.2515247-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
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

Changelog:
v2:
 * Rebased on top of completion counters series:
   https://lore.kernel.org/all/20260722083603.30334-1-mrgolin@amazon.com
v1: https://lore.kernel.org/all/20260721070026.1635441-1-ynachum@amazon.com

-------------------------------------------------------------------------
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

