Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3831C336881
	for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 12:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786537060; cv=none; b=O/TgfHRjEp0YQrNhFOBRAk3bVLE44EQUdCQXEUxB2hiVGQ3D82BPs8mTKVXpmPUSNWPxXnrwLAf4Z9qNc7GY+DLgzRNViWHNiUTD/tqTSVjK/dr0Kz/ENmMIyS769GcWxGHAqEIKsuorge3b5R8NOhLhsgrlGjGw6n7N1VhIeuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786537060; c=relaxed/simple;
	bh=l2MLkyi44kFNQ0D5E7dOskxyy0yCtDP9qHbcB528uQg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iYnIZHWiiaVnrDfkdKlXG3Qw2ulFeCARZEs4p2brPUBGFsR3YBsrmcessBbhxNoi0CBWoxspVuh5AcmHTGbQV3RMkKfxyTOLLwqmA0up9ZuKBRpI6UfdrVK92yGAg5e0gZmPH89PzGrCXubPAlCIjhJ703XEd5cCp0Bc9x+elmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=Yzti0OHW; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="Yzti0OHW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1786537059; x=1818073059;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mbRNS0kSVdHl4Hhz83gNXmz8Xb6w38W2CBT5YMsqwHo=;
  b=Yzti0OHWgnH0f1OD2b23mx7y3M4urq2jR+r8akSPqSUvPHrDX5lmuYPE
   8vJfyLtzy4/O5vPEKMDW5qWfc1D9UYjHDvxwwbC8RiviFcV4gPfq41Ldg
   jFyofUJVVDsrfRfSdtC4ze/nIq9Mpgo1BarzhRkDFOVr/T1j6ATZKOtHx
   00dk1hSGEaEpr0zoutCDip2pNwuSmO6MwHMWgwRL1NqS4gbOTogA+r6L8
   0NrFUaEGpMFd4G/gAaTbO1feZoATvJ8cPmyQL47Bc9G1krjIWtVL7FGlF
   jm4fHfmpgh9t3L2y2KQcI3U7BVh/h28SDmLdsWSps/gE6Irt4WYiBvRcS
   w==;
X-CSE-ConnectionGUID: tefHz/g3SfeQ5DFSa94xfw==
X-CSE-MsgGUID: E6EYwRrySweiXjRdQnNj6w==
X-IronPort-AV: E=Sophos;i="6.25,219,1779148800"; 
   d="scan'208";a="25790844"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 12:17:36 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:28510]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.23.46:2525] with esmtp (Farcaster)
 id 6f5cf527-6279-42de-8b13-1e9994a39a99; Wed, 12 Aug 2026 12:17:36 +0000 (UTC)
X-Farcaster-Flow-ID: 6f5cf527-6279-42de-8b13-1e9994a39a99
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 12 Aug 2026 12:17:36 +0000
Received: from dev-dsk-ynachum-1b-0ecf7b87.eu-west-1.amazon.com
 (10.13.226.176) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Wed, 12 Aug 2026
 12:17:34 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>, Yonatan Nachum <ynachum@amazon.com>
Subject: [PATCH for-next v3 0/3] RDMA/efa: Add support for 128B admin v2 SQ entry
Date: Wed, 12 Aug 2026 12:17:15 +0000
Message-ID: <20260812121718.2904349-1-ynachum@amazon.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D043UWC002.ant.amazon.com (10.13.139.222) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Changelog:
v3:
 * Ensure proper alignment of stack admin buffer to prevent unaligned memory
   accesses.
v2: https://lore.kernel.org/all/20260731075007.3878376-1-ynachum@amazon.com/
 * Rebase on for-next branch instead of wip/leon-for-next.
v1: https://lore.kernel.org/all/20260726123854.638687-1-ynachum@amazon.com/

-------------------------------------------------------------------------
Add support for the new 128-byte admin v2 SQ entry format. The v2 entry
extends the v1 header with checksum and payload version fields, and
carries a larger inline payload.

The series first decouples admin command payloads from admin headers,
then generalizes the SQ ring to use a configurable entry size, and
finally adds the v2 entry format selection based on device API version.

Yonatan Nachum (3):
  RDMA/efa: Decouple admin command payload from admin header
  RDMA/efa: Generalize the admin SQ
  RDMA/efa: Add support for 128B admin v2 SQ entry

 .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 116 +++--------
 drivers/infiniband/hw/efa/efa_admin_defs.h    |  33 ++-
 drivers/infiniband/hw/efa/efa_com.c           | 194 +++++++++++-------
 drivers/infiniband/hw/efa/efa_com.h           |  16 +-
 drivers/infiniband/hw/efa/efa_com_cmd.c       | 170 +++++----------
 5 files changed, 240 insertions(+), 289 deletions(-)

-- 
2.50.1

