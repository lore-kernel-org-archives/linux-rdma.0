Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D967394EBD
	for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 07:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787556683; cv=none; b=qwziL0qswmzxtuBz+0btHaAQR5W2GXL9N/kFfkJ0eYYF63wb2tf6hUCpLshc3p2fpK7Cbn20r9OP+sVt0s9tl3Kocq7h90d8+KFgiJDtW0bqSG66ixyH0zqMRiryf6s6WWWLr3NfSI99Q8bO04+o08TAM7gpLwKKM0SL74v3tVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787556683; c=relaxed/simple;
	bh=74Hxus3V+/Nlafxfm9Ii5LLCyfXnT2rjIzyEydwW1Mg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=szgQUtsi3zBrDlFu92jethX4Ix0xIKj9OH296cR2+tjgyfG69cCNJMevEWrDW8mguOpbhM8zasoVx4dz3CGp65OdxOM/dYkdM/DFbeSf8ef5SklCOfef4bS3dLrhiiXpmSrzCwzO6znhHFPr4wmUg8cJoKYhsP5IYY9mmArVq84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=fGNxRimc; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="fGNxRimc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1787556681; x=1819092681;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d1YivOsd4Zb38zq8WGaOGiw/XsM+0UrTORs7vChitrk=;
  b=fGNxRimcrw4908AyFYG3mpKljP+Fpwq/wFU9QVMQC3IXoE9ug/lFjNFH
   SSHEeMscy3ozNuQhqi0NcGSdjZ1r0wjT16VyC/N1K9iDW3BCjKZ67TdiM
   fngfaDeyowdoYGjRwJOjoHyl0nWH5AcmnKCGqZU7h0JIVDx2Gnqc0wjT4
   lPs+RQgiSw4gHT9jTEkjgd+ktxsrw1+4v95BjLl+rse12J69/NIacpeHe
   87yCl3rjZ/vLAk80QCLaJV30c6e9Ia+JeZYig6UwkLM08w/95Mevz0AAR
   8imk/1fcLAAHLpSTtnaltkWmyrwS6cQTuwZWXhxOWlW5g7vzeg+yv1DeG
   g==;
X-CSE-ConnectionGUID: PvhO4ZlsSwav6vj7rte25Q==
X-CSE-MsgGUID: PlYq/uihTW6rf2j657A9Cg==
X-IronPort-AV: E=Sophos;i="6.25,240,1779148800"; 
   d="scan'208";a="26744757"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 07:31:17 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:16772]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.53.153:2525] with esmtp (Farcaster)
 id 66b6ec55-63d6-4b97-a197-f4b5e04f4dfe; Mon, 24 Aug 2026 07:31:17 +0000 (UTC)
X-Farcaster-Flow-ID: 66b6ec55-63d6-4b97-a197-f4b5e04f4dfe
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 24 Aug 2026 07:31:17 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46; Mon, 24 Aug 2026
 07:31:15 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, <danamala@amazon.com>, Yonatan Nachum
	<ynachum@amazon.com>
Subject: [PATCH for-next v2 0/2] RDMA/efa: Add support for MR relaxed ordering
Date: Mon, 24 Aug 2026 07:30:55 +0000
Message-ID: <20260824073057.1046630-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Changelog:
v2:
 * Remove the relaxed ordering device capability.
v1: https://lore.kernel.org/all/20260806075758.3476667-1-ynachum@amazon.com/

-------------------------------------------------------------------------
Add support for MR relaxed ordering access flag, allowing userspace to
create PCIe relaxed ordering MRs.

Dana Malachi (2):
  RDMA/efa: Use device ABI MR permissions instead of verbs flags
  RDMA/efa: Pass relaxed ordering flag to device

 drivers/infiniband/hw/efa/efa_admin_cmds_defs.h | 5 +++--
 drivers/infiniband/hw/efa/efa_com_cmd.c         | 9 ++++++++-
 drivers/infiniband/hw/efa/efa_com_cmd.h         | 8 ++++++--
 drivers/infiniband/hw/efa/efa_verbs.c           | 5 ++++-
 4 files changed, 21 insertions(+), 6 deletions(-)

-- 
2.50.1

