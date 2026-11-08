Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.71.153.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794139323;
	b=Eh27+H56cTLGAE3eoVNk8h0PK/69TRrZvc2TuYkd4Ct3yxKnjA2hd4SM6C1W8wEoyWDD
	 EmeV+5uqBcuYUDFh2zS4IVyV+6L0xT/6ed5yppJWfRrJec5rvt8j7frhlirnFMJAiUwM3
	 qS5JFZwdbLqPizueZNZzcZmf7sJX4uWWB2RIX6CH9a2pQyH3Emo3fHdqN5ukJ+QEqtUXe
	 z5OoDijRizb5pOW/J6FzUMvx+YdwUsKDI9PlC4gctI8kbmfG6kZ08ySfG52eGW38Can4Q
	 VNjqG9K9wlUwxH/CbK8itF2VwcQswcmsh0gyhQlIqhwPm4Du2VHlNIv997pGGYdblIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794139323;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 IronPort-SDR:Received:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 WDCIronportException:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SrtOqLPHEQesKMXWnC2VfE0FsZF53cDo8UzjqjuS/RE=;
	b=dY0tPQTueR0WnY56vh90VZql7d1OHKpMVQhDxdBx+9Lm7CUz0cAjvtbveAaVXa4trxGz
	 r4EdNzvRryvsU7+UVLEudf7jBOV3jQdypwkmETWYklcMtpf802iUUbXvhaqfUSi2u8B15
	 Y8j65TJdgbPPHq5roQUgizEKMEFCYu0A0am2jXLVDHiVv4Xsb2DlYziN2+s9CkGBQnev8
	 YTNG4BbKNfHhx+xShgwR6KzP4Ik4UHmvyKe+1Tjq1k+piHrFJGzQjl4ozG2EiAy89fzei
	 RwF8/neaYHe2olJIxNgQOID0v1quvf1NahNfChSZRjuxzrYZOQy0SkyAKQ3tnTReYiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=LzLPBFPs;
	arc=none smtp.remote-ip=216.71.153.144
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E713606A326
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 12:02:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E713606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=LzLPBFPs
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794139330; x=1825675330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=edMmME5am0w8M0ppsUjClJjEUbA7Gkdq3winU2NcTKE=;
  b=LzLPBFPsIPnsXSi6MCJmAdpeu4IROPVlYWFJEKxk1AWjBRDU5UW+lx6T
   NlkSePDeGJhQ+V89Jn8AXfnNZVrmrtCywGbWZlb/4oKbl6FHxO4hzPIqi
   Ks/Pg3HLbVyd+FNk2vqzWI9u7JN7jGWCJV8GBZwgvDUuexshSxiiIzzq8
   n5X5ZwGWX3ZspyXYl0oas+dS9a/XKrr3negpcd0AHLQJg3I3WkaGcVVLr
   qh3JoTB3rJcAWSktBKirtGZDq9Jg0ozM9po21G94OzDAwnLbH6mwq1SKa
   Q9nls2MUqyG8XOt8H49IehMnTwXU9aK9A4jBpVwg3mD/wCZkBMmZQKd2M
   g==;
X-CSE-ConnectionGUID: 6yDgdEzgTDmqhntcPzGrlw==
X-CSE-MsgGUID: zjTMMFQQQQiQ1moniYxtxQ==
X-IronPort-AV: E=Sophos;i="6.27,202,1786982400"; 
   d="scan'208";a="159266836"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-esad3-o.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2026 20:02:07 +0800
X-CSE-ConnectionGUID: NGWTio0gSIySLWXT5jKwvg==
X-CSE-MsgGUID: 0YEm1qg3QFC05+O2YrAWnA==
IronPort-SDR: 6af064b8_Qn31bRD9UJPgZzFLfnHNhkB8f5gIQIEi0j8OyYSwTmglgdR
 3L1JOxomH1uyaNh01B/Kmd5Vgm5WkoiaEMz6fQw==
Received: from uls-op-esai1-o.wdc.com ([10.248.3.45])
  by uls-op-esad3-o.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2026 04:02:00 -0800
X-CSE-ConnectionGUID: xkdL1M3HQaiFe5e0KrB2cA==
X-CSE-MsgGUID: VI+I45xdSyC7ABpjRQ766g==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-esai1-o.wdc.com with ESMTP; 08 Nov 2026 04:01:58 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-rdma@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Surabhi Gogte <sgogte@purestorage.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH RFC 2/2] nvmet-rdma: use a separate lockdep class for the listening cm_id
Date: Sun,  8 Nov 2026 21:01:54 +0900
Message-ID: <20261108120154.148824-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261108120154.148824-1-shinichiro.kawasaki@wdc.com>
References: <20261108120154.148824-1-shinichiro.kawasaki@wdc.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the commit 2a8513091d2f ("nvme-rdma: parallelize I/O queue
allocation and startup"), the host sends commands on an I/O queue before
the target has seen RDMA_CM_EVENT_ESTABLISHED for that queue. nvmet-rdma
keeps such commands on queue->rsp_wait_list and executes them from
nvmet_rdma_cm_handler() when the ESTABLISHED event arrives, that is,
with the handler_mutex of the queue's cm_id held. Executing a connect
command takes nvmet_config_sem, which creates a handler_mutex ->
nvmet_config_sem dependency. This is the reverse of the order in
nvmet_port_subsys_drop_link(), which holds nvmet_config_sem and calls
rdma_destroy_id() on the port's listening cm_id via nvmet_disable_port().
Lockdep then reports a possible circular locking dependency:

     Possible unsafe locking scenario:

           CPU0                    CPU1
           ----                    ----
      lock(nvmet_config_sem);
                                   lock(&id_priv->handler_mutex);
                                   lock(nvmet_config_sem);
      lock(&id_priv->handler_mutex);

The warning is a false positive. The handler_mutex on CPU1 belongs to a
connected queue's cm_id, while the one on CPU0 belongs to the listening
cm_id, and nvmet-rdma does not take nvmet_config_sem while handling
events of the listening cm_id.

To silence the warning, call rdma_reclassify_id_for_listen() on the
listening cm_id right after it is created in nvmet_rdma_enable_port(),
so that its handler_mutex gets a lockdep class of its own.

This depends on the previous patch, which adds
rdma_reclassify_id_for_listen() to the RDMA CM.

Fixes: 2a8513091d2f ("nvme-rdma: parallelize I/O queue allocation and startup")
Link: https://lore.kernel.org/linux-nvme/at36um4zrsfOr3kh@shinmob/
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/nvme/target/rdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index b9e39d1657d2..94f6d8edb517 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1914,6 +1914,8 @@ static int nvmet_rdma_enable_port(struct nvmet_rdma_port *port)
 		return PTR_ERR(cm_id);
 	}
 
+	rdma_reclassify_id_for_listen(cm_id);
+
 	/*
 	 * Allow both IPv4 and IPv6 sockets to bind a single port
 	 * at the same time.
-- 
2.56.0

