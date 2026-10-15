Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8BC4D9548;
	Thu, 15 Oct 2026 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068683; cv=none; b=hxvAa7LXAs4L3GB6y9mDt3n9PCSfCBF5Zoy07baPjNDn7MbGi1ydyosQxRurs65jWPDltvdmYQXhJP234SXiwCX6BPd/YjLMyQydvEtBMIyVhnxm6YelDbGAcUAXuN1d5sZxB+4Z6v/+4fZ+prYmPNRU0D9JVRfgTP0gcrUISmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068683; c=relaxed/simple;
	bh=HHbIF6RaXmDx1+l/hJwzVShBeCZf7Dkyz1ahTDKlAow=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OuE8deCMcxQMwCvRnyDg/4Bk6EOHWLzqU+H6mi/5V/PXIzHxjPt5gtRM3E7/BXy/oOJOyQICCFcVfI9VDAiGD4ZnSU0pQZUEn3AvICyVIbI4zEjcAR9E0pwb7oYHG2Ah1hCCrt+CTIsB/2ModD3CL+NNju6u6kEX2/36yM3BNDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=MQgLkQ7L; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="MQgLkQ7L"
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 802EA21B06;
	Thu, 15 Oct 2026 15:51:20 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=sig1; bh=yeBPD5vteRecIAFFRg+6QLtmP3VGsur6gCZBaDbOcbs=; b=
	MQgLkQ7Li3pgamtm7a8JZmUuuKMcPSCv4OWsZrKuiEKpWbvbh5KtSGOn4mcVv+SQ
	M3IKYgN8u3Gfpi9edymuMd5ZY7QWUN501CfMqKXRYBT/ETXvjaFwka7khLvZE8PM
	Bi715524jCEQhMuerUvtqogAbBsalKgCUVp2LesHO1JaWrVlk4fi4oYCalbUIa6g
	cFzNvUHjmKFs/rWqFTSs9Rd7j0BYnuK5Th1gnyV3OABlT3e2jmJgiTY4WPOB+N2n
	7NitLzsKA5j/xK6Ht5Ul2If/gm7Rq/ivb/NxuX5eIu94itzWjCWFJyG4xCMh2MWA
	NdDoGdxkYBcfQBb7Temnmw==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id C0B9221953;
	Thu, 15 Oct 2026 15:51:18 +0300 (EEST)
Received: from [10.89.11.73] (10.57.8.14) by VTJ-MX.corp.irix.systems
 (2a02:2f04:1:9c24::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 15 Oct
 2026 15:51:18 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Sagi
 Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>, Bart Van
 Assche <bvanassche@acm.org>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack
 Wang <jinpu.wang@ionos.com>, <linux-rdma@vger.kernel.org>
CC: Andrei-Alexandru Bleortu <me@andrei-z.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 0/3] RDMA: Post small ULP command messages inline
Date: Thu, 15 Oct 2026 15:51:15 +0300
Message-ID: <20261015125118.2966247-1-me@andrei-z.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

The iSER initiator, the SRP initiator and the RTRS client each send a
small per-command message by reference, on a QP that asks for no
inline data. The HCA therefore has to DMA-read the message from host
memory before it can put the command on the wire.

Each patch asks for a little inline data when creating the QP and
creates it without inline data if the device refuses. SRP asks for
116 bytes and tries smaller sizes before none. The message goes out with
IB_SEND_INLINE when it fits, with the SGE pointing at the buffer's
kernel virtual address. The messages are:

  iSER  PDUs without a data segment (76 bytes of headers)
  SRP   SRP_CMD IUs without immediate data
  RTRS  read requests, about 60 bytes for RNBD

I measured them on two Xeon Platinum 8360Y hosts with ConnectX-6 Dx
(RoCEv2, 100 Gb/s), with the patches backported to an Ubuntu 6.8 kernel
(same added and removed lines). Every QP was granted 120 bytes of inline
data. Inlining lowered fio's mean 4 KiB random-read latency at queue
depth 1 (io_uring, null_blk target, fio's lat, which includes
submission) by:

  iSER, PDU posted alone              0.479 us (95% CI 0.270-0.689)
  iSER, behind a registration WR      0.701 us (0.375-1.026)
  RNBD over RTRS                      0.348 us (0.309-0.387)
  SRP                                 0.383 us (0.320-0.446)

Each is the mean of 15 paired runs, 10 for SRP. The second iSER line is
with always_register=Y. Each patch inlines the message even when
registration WRs go ahead of it in the same call, since it still saved
time there. Tell me if you would rather inline only when it is posted
alone. Before going further I would like to know whether you want these.

I am sending the same change for the NVMe/RDMA host's command capsule to
linux-nvme. An earlier version of it lowered fio's mean 4 KiB
random-read latency at queue depth 1 by 0.998 us (95% CI 0.943-1.049)
between two AMD EPYC 7452 hosts with ConnectX-5 Ex. Between two Xeon
Platinum 8360Y hosts with ConnectX-6 Dx it fell by 0.589 us
(0.558-0.618). Both used RoCEv2 at 100 Gb/s. I could not find earlier
discussion of inline sends for these ULPs on linux-rdma.

All three build with W=1 on rdma for-next without new warnings, and
the backports ran on the hosts above. RTRS also ran in a QEMU guest
with rdma_rxe, where an RNBD client and server on one host mapped a
null_blk device. 8 MiB of 4 KiB O_DIRECT writes and reads compared
equal, and 2050 of the 2051 read requests went inline. With rxe changed
to refuse inline data, QP creation fell back, every request went by
reference and the data still compared equal.

I wrote these patches with an LLM coding assistant (Claude Code),
which also drafted the commit messages and ran the build and the VM
test.

Andrei-Alexandru Bleortu (3):
  IB/iser: Post header-only PDUs inline
  RDMA/srp: Post command IUs inline
  RDMA/rtrs: Post client read requests inline

 drivers/infiniband/ulp/iser/iscsi_iser.h |   2 +
 drivers/infiniband/ulp/iser/iser_verbs.c |  29 ++++++-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c   |  17 +++-
 drivers/infiniband/ulp/rtrs/rtrs-pri.h   |  10 ++-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c   |   2 +-
 drivers/infiniband/ulp/rtrs/rtrs.c       |  22 +++--
 drivers/infiniband/ulp/srp/ib_srp.c      | 102 ++++++++++++++++++++---
 drivers/infiniband/ulp/srp/ib_srp.h      |   9 ++
 8 files changed, 170 insertions(+), 23 deletions(-)


base-commit: 978361dd2ccff357d4fe6aac6ce057d1bfae8312
-- 
2.56.0


