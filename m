Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C104854EB
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 10:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519191; cv=none; b=k888rdDtVx+varhTPP0x8KKlQoSN70BcS43yJabOt2drBCgx+N2raqhnk4eiS/dUBDMNCyq14DN66FDCuWw9NM17foc0ll2VlR8QgrsFvEoev9bwaQ466tOxFw7MiKYV5WFSwU3/2KdMkMM6lljB1M/n3ruaKWDHWfjndo23Sqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519191; c=relaxed/simple;
	bh=HkTEqZ6sjlxxGMjaeue/XW0Df3UPtwFZcq2SgGPDeto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqV1loIf6nl8h2VxgmtmeVWiqZLjSwOQhntAaFvhkX8U+gmusOKnMVSDHce5G5HRqZRI3CwfzM1UZEzdJAmXtgA5H1fToOcKzvg7r/+jqX5f8UpE+0tfYIekocW2qm4/yuARnSq8dpmOFZdq9mnWVxGEQceqJbD/EIqv31mJXVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PA8UzAAZ; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PA8UzAAZ"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38e58034d05so688949a91.2
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519178; x=1789123978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+8/JgLbE54eU7oy503citsIF4dH0n9XMNj5rOPWa5Ac=;
        b=fip0Ha3Gcfcnb5W7mAZC7ZHJmL6IRt8MmI68GdhXjhjnQiLayBMB5R4OipOreSvW1x
         E2HeWBfg6pezZddZkQLi6DQm+3aUKc/2ZQkEq134Yoz4KVKIG4UX0CeI4X3Trd1M0O6p
         qm17uUIAn6zlzSfNXkxf7Zxdl81L83cEUDItdh+kx0823PSJcE5hQPoLb22NHxz+6sjD
         VbZl3ukfvMIFpVL1lzUZXSg3d4Z+YHfVlhEMQm1ljZFI3xZRQWBH/mZM2FEQ8Ob+28LV
         OU6tXve8G2wSZralOje14NThbUhbWJOhYNTfu5vcCKbJGT08xzzB7DbDhE9c2p1MfDTF
         rBYg==
X-Forwarded-Encrypted: i=1; AKwUvBxsJAhC/PDqFVaavkVOeh13jnZvAcexIhLMel4gwLSq+OOmfQmcvZV26VwlYV0xvn2EED5CHcB/NpI3@vger.kernel.org
X-Gm-Message-State: AFuF++l9XlWzQjalhMTedJzjPWLL7Uy2AGnmHJbe79YNqyGyOgBFD/ne
	Qtc/lDpmurY6ZJFH3KRsENHDMYpUHKUzuE8DlpN7TOqXIk0kH2Vn3GL6F6nZbksrTyOJdzYz095
	kT03ddOhOPJjoxb1jCvP9JEeiLkE0AhlJy+wJzRiuCOz60QSvbkD/aWBSpHvzQdPNvDOei+bJg1
	pYL1D010I5vqSbNUxVLvYHpMZITFAPCUqf2taFYBXofNeDVTiQRQAIIpKy/9Qnr+tPWbCSPAqV+
	jJWfgaKtTF7ISM=
X-Gm-Gg: AYBFou0bInw8SkXl1QbzP8lYiDxyhsXKGjjX38iKJ+eSPZw49+h34bOCrV7mnGWrgoo
	2FRyFKQDBzl3U4yzKScuDwGWKK64wHm4I0OuvPHe7vThbA9L7pHv0QmdpuLQpFXzn9uWkyHgBld
	Jl5DjqBnKbjKMF8sm2fXVn61U/FYQK9j4ezshXgvFnHQtYERpzyCtuIqnhHUEaho+zG9laz1a/w
	atzzRfdEBHCfLjyelO3eIuV0JiiIXPm1dXzmQRBJoutWXbvkVRj/1mbn8e9BdADb2B4DsU1sWaG
	YmPHW1QiVJdNUFfmoLWCx2K13ccFh/LsUaWryqtycTkJQjtc4t3ZTPkGII9bcHIEXgdOgNvTl/3
	x+/jp2TGoeWd+GJy5hXy6ZtheuIwBgkbFaKUC8rvGEGDIXQqJVdbZ+MyCZRjhg88bLQIx4xPbHT
	vSmQTpS4rCjv5U/8ksbF5fn4YDZbJ54xEpRQ==
X-Received: by 2002:a17:90b:3149:b0:393:194d:5366 with SMTP id 98e67ed59e1d1-39b2618060cmr8533752a91.10.1788519177534;
        Fri, 04 Sep 2026 03:52:57 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b28c68f8csm984905a91.5.2026.09.04.03.52.56
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 03:52:57 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc73f47bdcso11997215ad.3
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788519175; x=1789123975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+8/JgLbE54eU7oy503citsIF4dH0n9XMNj5rOPWa5Ac=;
        b=PA8UzAAZXTVKgcELafUoYixYl17EyhOVR9a1vXHt/HQwvi8KjxFxNt+kXxTlJTuXqo
         0BqXyNDYYF/lok8LVAbMoi+fk5bP8GHOlbCskjxNwfgVnQxTfCo5sxHkFq1YY8oVMvGR
         AlGmZASRuKAK4iP7bldIG8Ua9X3uqyvjbuxGI=
X-Forwarded-Encrypted: i=1; AKwUvBwN6nz4ULOgx0hBjguW1oFTDK5s9uyR9WrM5N7qBIVFkanX0aCB+/UnC3ZGqFbRNLdPHzXdwFEhnvaq@vger.kernel.org
X-Received: by 2002:a17:903:3810:b0:2d6:3c22:99bf with SMTP id d9443c01a7336-2db124afcefmr84673435ad.9.1788519175223;
        Fri, 04 Sep 2026 03:52:55 -0700 (PDT)
X-Received: by 2002:a17:903:3810:b0:2d6:3c22:99bf with SMTP id d9443c01a7336-2db124afcefmr84673015ad.9.1788519174773;
        Fri, 04 Sep 2026 03:52:54 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d0asm6171170eec.8.2026.09.04.03.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:52:54 -0700 (PDT)
From: Siva Reddy Kallam <siva.kallam@broadcom.com>
To: leonro@nvidia.com,
	jgg@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [PATCH 15/15] RDMA/bng_re: Register with ib-core
Date: Fri,  4 Sep 2026 03:43:23 -0700
Message-ID: <20260904104328.763768-16-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260904104328.763768-1-siva.kallam@broadcom.com>
References: <20260904104328.763768-1-siva.kallam@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This patch registers with ib-core

Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
---
 drivers/infiniband/hw/bng_re/bng_dev.c | 79 ++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/infiniband/hw/bng_re/bng_dev.c b/drivers/infiniband/hw/bng_re/bng_dev.c
index 6e9df737c751..2633bb289f09 100644
--- a/drivers/infiniband/hw/bng_re/bng_dev.c
+++ b/drivers/infiniband/hw/bng_re/bng_dev.c
@@ -5,6 +5,8 @@
 #include <linux/pci.h>
 #include <linux/auxiliary_bus.h>
 
+#include <net/addrconf.h>
+
 #include <rdma/ib_verbs.h>
 #include <rdma/bng_re-abi.h>
 
@@ -553,6 +555,73 @@ static int bng_re_dev_init(struct bng_re_dev *rdev)
 	return rc;
 }
 
+static void bng_re_dispatch_event(struct ib_device *ibdev, struct ib_qp *qp,
+				  u8 port_num, enum ib_event_type event)
+{
+	struct ib_event ib_event;
+
+	ib_event.device = ibdev;
+	if (qp) {
+		ib_event.element.qp = qp;
+		ib_event.event = event;
+		if (qp->event_handler)
+			qp->event_handler(&ib_event, qp->qp_context);
+
+	} else {
+		ib_event.element.port_num = port_num;
+		ib_event.event = event;
+		ib_dispatch_event(&ib_event);
+	}
+}
+
+static int bng_re_register_ib(struct bng_re_dev *rdev)
+{
+	struct ib_device *ibdev = &rdev->ibdev;
+	int ret;
+
+	/* ib device init */
+	ibdev->node_type = RDMA_NODE_IB_CA;
+	strscpy(ibdev->node_desc, BNG_RE_DESC " HCA");
+	ibdev->phys_port_cnt = 1;
+
+	addrconf_addr_eui48((u8 *)&ibdev->node_guid, rdev->netdev->dev_addr);
+
+	ibdev->num_comp_vectors	= rdev->nqr->num_msix - BNG_RE_MAX_RSVD_IRQ;
+	ibdev->dev.parent = &rdev->aux_dev->pdev->dev;
+	ibdev->local_dma_lkey = BNG_RE_RSVD_LKEY;
+
+	ib_set_device_ops(ibdev, &bng_re_dev_ops);
+	ret = ib_device_set_netdev(&rdev->ibdev, rdev->netdev, 1);
+	if (ret)
+		return ret;
+
+	dma_set_max_seg_size(&rdev->aux_dev->pdev->dev, UINT_MAX);
+	ibdev->uverbs_cmd_mask |= BIT_ULL(IB_USER_VERBS_CMD_POLL_CQ);
+	return ib_register_device(ibdev, "bng_re%d", &rdev->aux_dev->pdev->dev);
+}
+
+static int bng_re_ib_init(struct bng_re_dev *rdev)
+{
+	int rc;
+	u32 event;
+
+	/* Register ib dev */
+	rc = bng_re_register_ib(rdev);
+	if (rc) {
+		pr_err("Failed to register with IB: %#x\n", rc);
+		return rc;
+	}
+	dev_info(rdev_to_dev(rdev), "Device registered with IB successfully");
+	set_bit(BNG_RE_FLAG_ISSUE_ROCE_STATS, &rdev->flags);
+
+	event = netif_running(rdev->netdev) && netif_carrier_ok(rdev->netdev) ?
+		IB_EVENT_PORT_ACTIVE : IB_EVENT_PORT_ERR;
+
+	bng_re_dispatch_event(&rdev->ibdev, NULL, 1, event);
+
+	return rc;
+}
+
 static int bng_re_add_device(struct auxiliary_device *adev)
 {
 	struct bnge_auxr_priv *auxr_priv =
@@ -575,8 +644,17 @@ static int bng_re_add_device(struct auxiliary_device *adev)
 	if (rc)
 		goto re_dev_dealloc;
 
+	rc = bng_re_ib_init(rdev);
+	if (rc) {
+		pr_err("Failed to register with IB: %s",
+			auxr_priv->aux_dev.name);
+		goto re_dev_uninit;
+	}
+
 	return 0;
 
+re_dev_uninit:
+	bng_re_dev_uninit(rdev);
 re_dev_dealloc:
 	ib_dealloc_device(&rdev->ibdev);
 exit:
@@ -586,6 +664,7 @@ static int bng_re_add_device(struct auxiliary_device *adev)
 static void bng_re_remove_device(struct bng_re_dev *rdev,
 				 struct auxiliary_device *aux_dev)
 {
+	ib_unregister_device(&rdev->ibdev);
 	bng_re_dev_uninit(rdev);
 	ib_dealloc_device(&rdev->ibdev);
 }
-- 
2.43.5

