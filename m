Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793163779;
	b=bGx3Zr64MldLZnYo4nQOYbJm8xHacMFIo22UqamVsJIgocUV4NAhjltR6kRzI92h7WkH
	 vF0yekXW++fj6Q9VNudJa63bH6c9AeKHxsyhyTI8BlQLxD+2wvs1HjpZEchh+i5mxSvth
	 AKq3otMkQTnGpn+eM0JVqLFld6IRHCc0wYcvp/oKwUQ98R9FtxHk3YIuBACuyxHqV3PrO
	 Xqr5Dw33Oa4QqPloG8KbOTpcXo9xE2eMpBgVrPyFS+zinQOn3I5WvrqmwX+Cu44oIgZ5o
	 KNQ49Ar70dkhaN7P9crbnE7lf1rXXt5serbVkainTxHpERegqYuwgbmjahWAUFnHu3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793163779;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=KZd18GbnGU4FjPw5U6MyhamIQSEO0JvH+SDs2B8FAk0=;
	b=PVpwKzhHBmbf8tRl9o9WihXPWn8uINpwV1M/fgoI9oRI8vyoyJ+9xlq6jdAguc5LUV3W
	 2X6dTayy7P91b7U9l19coItkkNvIcDIcm2ynuRoR85HVz+6ISi7O2IEoV2EgicY83FrK2
	 U1arTWfB4PTbTN8pR2fZdesWQ/HS2oVVCYjkg6zFK53m/MjFDAZq+hMFjH5yFiPCY68/u
	 SwfgFcOeDto0sDysqBw0HFouZuY3Aq9j1JOcJAyaGTAbuB9oHYeuLnFyuC8NT01iHMkFe
	 IlGI22coPPxM07yKwDPfFwxS2kwcyWml5d2ecVoMlhQeF/hytaJdzdAX67FKub9mJng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="O/G3Zrj6";
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82AC606A31A;
	Wed, 28 Oct 2026 05:02:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D82AC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=O/G3Zrj6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=KZ
	d18GbnGU4FjPw5U6MyhamIQSEO0JvH+SDs2B8FAk0=; b=O/G3Zrj69LGrSAGHXx
	7DdCb1z1GnEuSQOSZtB22xbY0w2oLmgFqHd1QcCutmCJirCu1MzA/jtiBsgHpj/g
	2syXnNWAKNlafffpjk/y4X0zcBsesMjXe77dk4M3QNuBEyoG5N2ig2rKZlwOaJC1
	Ie/0gjLr3hKZRtvcS+i0Nr58c=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3P6n1geFqL2RoDQ--.23510S2;
	Wed, 28 Oct 2026 13:02:46 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Parav Pandit <parav@mellanox.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] RDMA/core: skip compat cleanup for init_net
Date: Wed, 28 Oct 2026 13:02:44 +0800
Message-Id: <20261028050245.125370-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
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
X-CM-TRANSID:_____wD3P6n1geFqL2RoDQ--.23510S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZryxKr1DCFWDWw4kJry5Jwb_yoW8JFykpF
	4qya90krnrGF47Ka1UWa48uFy3Jas5J34agrWDt34kuF15WFyYvryrtFy0yFWkAryUJF13
	tFWDZrs5G3s3XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jYa0PUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8Baw6mrhgfZhmQAA34

rdma_dev_init_net() does not allocate an rdma_nets XArray entry or
create compatibility devices for init_net.  rdma_dev_exit_net() still
runs the common cleanup, using the zero-initialized rnet->id to hide and
erase an entry and removing compatibility devices with that ID.  ID zero
may belong to a non-default network namespace.

Handle init_net separately on exit, mirroring the initialization path.
Only tear down its netlink state and leave the XArray and compatibility
devices untouched.

Fixes: 1d2fedd8561d ("RDMA/core: Support netlink commands in non init_net net namespaces")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/infiniband/core/device.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 29af9fe860e2..74460850ccba 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1153,6 +1153,11 @@ static void rdma_dev_exit_net(struct net *net)
 	unsigned long index;
 	int ret;
 
+	if (net_eq(net, &init_net)) {
+		rdma_nl_net_exit(rnet);
+		return;
+	}
+
 	down_write(&rdma_nets_rwsem);
 	/*
 	 * Prevent the ID from being re-used and hide the id from xa_for_each.
-- 
2.34.1

