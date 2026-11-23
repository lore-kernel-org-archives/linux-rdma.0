Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795407401;
	b=sU/KHG/V2BObgxO24NtN1BLOJbCyntVDO1CifKNV/j0xrUhYh0L4WKP0UskxtDQyPw4j
	 vUtdWl7HfQ8t6+Sq6D5ntElKEL8iVmzx/Yi0uHtbpL4dhSPZZerMDZKglzPBIg9K8J+lg
	 pNXjmY3TDnx2IZrWbSwNvqKiUVC9twTVX6cZKtzxLO8lGrpbvgxwgXhADVB2wXK+0x0HD
	 5QnHcESsCWUTJ+Io6Nl8Zm7GI8iWu8wlOA7jBQRxMiCN6moehMhihbhZraFxQ8YuYQL+5
	 Dvep4yFUZsLGAGp9YRed5IE0sPnKiqFoWkOd4Ulhvm/y6stg09Q9d9i9Q6qTr/pS5qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795407401;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=s4LPnJjhOpaI6sbylETTowLoZMx18QBamxiMhWn58wQ=;
	b=05Zki9+C7n3vmyhLRmKl/M9bbRECGvNz5SV43d5WWBNBiog7JGoR/XmsRqwmOQqZqSw8
	 fLuUVutHlrnV3KR0ewVJcPC/2w45ZKKsHaq5JBliVU1JlBXqa6VB44hBVISFWwmuDfVoq
	 B0L2ebvJ4hxEqRnnloVw10HSaS76qKyFEkAOBG/LwsxsTp5nlRpbTmbfmFOeO6yTaS8b1
	 CKuR1qzuwGCPRLNbdX4g0zFPwDbbDAh4QLMlwQeBWOTrX+PUFgP5fseIvFhyZkD928zzW
	 GhCYwo13SPbHPMxLp8DI/JEMZhE+I7MkZ0EDQb9UoJ99ZvSf+PeHoLmb6vLKOzd8m2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Jrsk5mno;
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB81606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 04:16:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFB81606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Jrsk5mno
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=s4
	LPnJjhOpaI6sbylETTowLoZMx18QBamxiMhWn58wQ=; b=Jrsk5mno+9qX3sptTy
	5MviQPu0a8kBeLPISKrvRNPV/LEkkvPSvdFWmRfTJojONgluMFj04WDi/bOVtjmf
	dcCXOKzHKz/OY/VKVlvhjQaZw9is25/dnKsbRV3lFUAPieRobQI6Crt95lFNeW7E
	/f21WN2/DHnpIAToqrPQbbOVs=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD3h6IHvgNrCiN5Hg--.47897S2;
	Mon, 23 Nov 2026 12:16:09 +0800 (CST)
From: Wanhui Fu <fuwh1120@163.com>
To: dennis.dalessandro@cornelisnetworks.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	dledford@redhat.com,
	sebastian.sanchez@intel.com,
	dean.luick@intel.com,
	mitko.haralanov@intel.com,
	mike.marciniszyn@intel.com,
	kaike.wan@intel.com
Cc: linux-rdma@vger.kernel.org,
	Wanhui Fu <fuwh1120@163.com>
Subject: [PATCH v2] IB/hfi1: fix error paths in hfi1_mod_init()
Date: Mon, 23 Nov 2026 12:15:56 +0800
Message-Id: <20261123041556.1888113-1-fuwh1120@163.com>
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
X-CM-TRANSID:PygvCgD3h6IHvgNrCiN5Hg--.47897S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tryUGrWfJr4UCw43Ar1xuFg_yoW8XF13pF
	Wjgw1jkry8Xa1xWFsFka12gryUKa97t34xuF42kwn5XFsI9F1jq3sYqa4jkFyDGFZ3AFyS
	yr48X3Z5Kr1xuaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UfhL5UUUUU=
X-CM-SenderInfo: xixzxiqrsqqiywtou0bp/xtbC7QlN7GsDvgnanQAA3d

The error path in hfi1_mod_init() is not completed.
Fix this by add some goto label.

Fixes: d63730192f59 ("IB/hfi1: Reserve and collapse CPU cores for contexts")
Fixes: 48a615dc00ae ("IB/hfi1: Integrate OPFN into RC transactions")
Signed-off-by: Wanhui Fu <fuwh1120@163.com>
---
Changes in v2:
 - Add Fixes tags as suggested by Sashiko.
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

