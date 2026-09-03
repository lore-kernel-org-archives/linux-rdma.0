Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC693509EE3;
	Thu,  3 Sep 2026 20:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788466174; cv=none; b=ZgEGC4YNP3DMirHK1zsuWXg9YDS7bHv1Ze1THkiOgAeR2NAsE/lkhXCto+clg0aI57LNX8L98fYy3PhD6qitGvm2W4nSEORkoqaoTcVqmx0jzIkmNSMg5DRciHYvZvIZxPijOE/2PjBVG2gRw92EBtm8VGG+C0tVLcgRayNJUrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788466174; c=relaxed/simple;
	bh=OS5IY88/zugstvdSWGtad6RE5fXp6XdMUN0noYSRA3k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tXKXEgxCe44AM5hR665vtefC0Cx3bB8gsvAjmPE0lU1C0aAsMD/gkUC6Pow3kvQujRhVNhu+T9wlgDHHe9TzO2W/vswjvJ8YX77TZCoZC1Hg5gGoDgxcAhHCfi3vT5oJfem/25ph07XowOSt3D5nE4fGg3L220PaJuZvcVYB+bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=jFlYX2wJ; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="jFlYX2wJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1788466166; x=1820002166;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=f8vn0bYs8qbw2jm3hjw0A29bvP8MUx2KpOum1FLJJ8I=;
  b=jFlYX2wJLSsQ/+/7ci+e5wJSL981gImbmkj1IbpEwyZmjp68kpaXq/kH
   4PcQddD19oJVQtAPQncRA42KouHgncTkxOCJ8FzgrcLmYnBIdK74baH7a
   ifFO99hQn8xwd/z/oNPLUrIgble/s3CZTKRe7AFQpXe4UOGL264olFaeZ
   ZUvd1Nlrasa9hxz3EZAfoTG63vx4ELwTMvojKFUFjUGY41nTITeTtBT3n
   XYTmNCnWwup/rtaiAaFHuqhYvQw9BbmN0nXwn/nhBltHUClGzXMeKH3T/
   AgGYZjJgMLQmrmDSd/QzEz0bHlgjpOtiSt79cukqgRdqN9jOwYDHxfOg2
   g==;
X-CSE-ConnectionGUID: m5VADiluTkKz6khTLj3sMQ==
X-CSE-MsgGUID: UfYefFTgSX6G8Kw+MpEVrg==
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="27524691"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 20:09:07 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:26945]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.234:2525] with esmtp (Farcaster)
 id d7db81c1-6f51-4046-a9b7-eee94f227f69; Thu, 3 Sep 2026 20:09:06 +0000 (UTC)
X-Farcaster-Flow-ID: d7db81c1-6f51-4046-a9b7-eee94f227f69
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Thu, 3 Sep 2026 20:09:06 +0000
Received: from dev-dsk-doebel-1a-7b355d76.us-east-1.amazon.com (10.169.119.5)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Thu, 3 Sep 2026 20:09:05 +0000
From: Bjoern Doebel <doebel@amazon.de>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <sashal@kernel.org>,
	<linux-rdma@vger.kernel.org>, Tristan Madani <tristan@talencesecurity.com>,
	Bob Pearson <rpearsonhpe@gmail.com>, Dan Carpenter
	<dan.carpenter@linaro.org>, Jason Gunthorpe <jgg@nvidia.com>, Zhu Yanjun
	<yanjun.zhu@linux.dev>, <doebel@amazon.de>
Subject: [PATCH 5.10.y 0/4] RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
Date: Thu, 3 Sep 2026 20:08:47 +0000
Message-ID: <20260903200851.566276-1-doebel@amazon.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D038UWC004.ant.amazon.com (10.13.139.229) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Upstream commit 22b8fbded65b ("RDMA/rxe: Fix TOCTOU heap overflow in
get_srq_wqe") fixes a heap buffer overflow in the rxe responder.

The fix does not apply to 5.10.y as-is because get_srq_wqe() there
predates three earlier cleanups. This series therefore backports those
prerequisites from 5.14 first, and then the actual fix:

  1/4 ec0fa2445c18 RDMA/rxe: Fix over copying in get_srq_wqe
      (context adjusted for 5.10)
  2/4 36941dfe0e8c RDMA/rxe: Missing unlock on error in get_srq_wqe()
      (clean cherry-pick)
  3/4 e2a05339fa11 RDMA/rxe: Use the correct size of wqe when processing SRQ
      (clean cherry-pick)
  4/4 22b8fbded65b RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe
      (cherry-picked from the v6.1.178 backport 3cfa2a3adc51, context
       adjusted)

Tested in the Amazon Linux kernel test suite.

Bjoern

Bob Pearson (2):
  RDMA/rxe: Fix over copying in get_srq_wqe
  RDMA/rxe: Use the correct size of wqe when processing SRQ

Dan Carpenter (1):
  RDMA/rxe: Missing unlock on error in get_srq_wqe()

Tristan Madani (1):
  RDMA/rxe: Fix TOCTOU heap overflow in get_srq_wqe

 drivers/infiniband/sw/rxe/rxe_resp.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

-- 
2.50.1

