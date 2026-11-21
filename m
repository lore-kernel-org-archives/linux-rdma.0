Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795253972;
	b=TJNIrxn4RSAh0kieD/1I99x/29QmJVPX4sJ8QSGsW1f3OsJ7l7+gBk0EgHyCpxy+KFQQ
	 E+gofxZqobjoUUHZ0N41g2bacyW9f6zOewLBjmEdZYxmLFk+bKwFRowMy0PFKNwg2nmHS
	 djt/9soCgjC/sW5VjTdyvv5OGDweRcQM0TO9bUW066BHGy4BjWzuXSZA7uu409yun/Z6a
	 heZVUE5F5r3I0HEI5qJ2XCi4t2MtWcKNQtVPGHkGbptQOZwlV3DwGKwgx6DJBNvXz5QJU
	 GGXkQpBBIjGdgqsjIZ7ZkxBilw65hzbew9mp4kcNZvOOum1ovyhNoCPRtomynlhZBpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795253972;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=vHyM4Cv4BGb7ADvxlq0KJx6cFo+10F6V1rtiSbfbDRg=;
	b=UdlrJ9fO1LTVwETy25NHjUmehKEnL5pLD/NfU9OL+k+9pU35UlT9B9O/49y7E6bf9swp
	 27BPY8RjoXjvR8bviP385Y6kBvIlZj7FceHc9TOg2+YOsA8vXq7t4uw5GULU95CQzRiJT
	 nryAUpAXQbBknQmZzGEull5YMvekm/068NTp/c9DGDfs2eCJ6POpMzPinWkduVBqMKmYm
	 ByzlaF8UdDtakVSnSZDgVxk4Tx7sQKe8CAwpmdFqt4yl+T1H6cCs2pmbfZmWKyzxxd0rN
	 pxHGAth6JP5bvl7770Do2cB6fFdnKv6JFRBeENLRkoe5vVXCg3Tc7QOK2Mnv6zEvYzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=VtuG8tXk;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEBB606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 09:39:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CEBB606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=VtuG8tXk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=vH
	yM4Cv4BGb7ADvxlq0KJx6cFo+10F6V1rtiSbfbDRg=; b=VtuG8tXk8t3kXukkgw
	FuWAYanNff+b24FZEqfeImqMpwIs3WO9APeQSPSnt5FCmFQ3G3cSf+Lg51eULMWZ
	TyW6E8YQ7C2doLHwCnYq243rirE2Owj/v2a3u0CZ/CEvaEFV5q7KzlvgtoHqFa51
	iGKVHI+H146lol2vsdfnhevW0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3XyO2ZgFrHFnrJA--.47981S2;
	Sat, 21 Nov 2026 17:39:07 +0800 (CST)
From: Wanhui Fu <fuwh1120@163.com>
To: dennis.dalessandro@cornelisnetworks.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	Wanhui Fu <fuwh1120@163.com>
Subject: [PATCH] IB/hfi1: fix error paths in hfi1_mod_init()
Date: Sat, 21 Nov 2026 17:39:01 +0800
Message-Id: <20261121093901.427880-1-fuwh1120@163.com>
X-Mailer: git-send-email 2.25.1
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
X-CM-TRANSID:_____wD3XyO2ZgFrHFnrJA--.47981S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF1DAr4xKFWfXr43Ar18Krg_yoW8JFykpF
	Wjgw1jkry8Xa1xGr4DKa1UuryUta97X34xCF42kwn5XFnI9F1jqw1vqa42vFyDGFZ5CF1f
	tr48XFn5Kw1xCFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UzwZsUUUUU=
X-CM-SenderInfo: xixzxiqrsqqiywtou0bp/xtbC7hzjg2sBZrz3JgAA3z

The error path in hfi1_mod_init() is not completed.
Fix this by add some goto label.

Signed-off-by: Wanhui Fu <fuwh1120@163.com>
---
 drivers/infiniband/hw/hfi1/init.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index f94d896e7212..c66d4dea5fc6 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -1388,7 +1388,7 @@ static int __init hfi1_mod_init(void)
 
 	ret = node_affinity_init();
 	if (ret)
-		goto bail;
+		goto bail_dev;
 
 	/* validate max MTU before any devices start */
 	if (!valid_opa_max_mtu(hfi1_max_mtu)) {
@@ -1438,7 +1438,7 @@ static int __init hfi1_mod_init(void)
 	ret = opfn_init();
 	if (ret < 0) {
 		pr_err("Failed to allocate opfn_wq");
-		goto bail_dev;
+		goto bail_affinity;
 	}
 
 	/*
@@ -1449,12 +1449,16 @@ static int __init hfi1_mod_init(void)
 	ret = pci_register_driver(&hfi1_pci_driver);
 	if (ret < 0) {
 		pr_err("Unable to register driver: error %d\n", -ret);
-		goto bail_dev;
+		goto bail_opfn;
 	}
 	goto bail; /* all OK */
 
-bail_dev:
+bail_opfn:
 	hfi1_dbg_exit();
+	opfn_exit();
+bail_affinity:
+	node_affinity_destroy_all();
+bail_dev:
 	dev_cleanup();
 bail:
 	return ret;
-- 
2.25.1

