Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E64456291
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 09:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786698680; cv=none; b=n6MZ1FTu8mN499UgV63W5s0lXDOGkhmkCMRp6hp8b/Hyz6fBsslBwYVKs3yEZ1QZaRZ5cXCdSPIiPgeYleVTQY8UBnhoLM3StN32yWKr3Zb6CuvnM4ZtFMCfUrrYYYHMBsyxGRbbtjy8oEFBHcsQJKctjoVfl8oLTTCcOegoBIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786698680; c=relaxed/simple;
	bh=4T3TGrPOmCcuyK6wQdLMcII19a6AyfhLY97Res9looE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lafLLzC0Pq06x0btOTOvWotLXCK3Ga4I/zvTfPBK4R/CYuhCRWAgRV/oO1JbQdHGStPMVFFRiayXuq5LavFkiuVel7lxg7bBRLJiUcOlf+hVuBUuwiVOUTiQxspOl1oH7MRMUkNM+NtKcHzTJa0YaP5Ql2NbCLWCj0KD2/6ybSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=X3gM1PmX; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="X3gM1PmX"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-38e041ea211so845897a91.0
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 02:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786698678; x=1787303478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TSV0sSSXYSyAmLjxbnCOORhk+yB6Zbd6HUBS6OIrdiQ=;
        b=nGSMLObnoKXgOijYgtJDwPIDcdjnD/f0ep1mAs1TU6gqsStZiXuGiU6SFBe/Cb0Zsv
         GuHWTxbnYTgWpu5Hd5MoKzyZBpWLmREzsvzN0wEw4dl70RiQNlEZLvGItFPVM/DyGJAT
         nlU8XSR8ELVc3s5wz73KmGOklerQl3IhKiruQ5hq38DtrxzHQgxi1mhzJidQKeUw3vsZ
         GoDXPtUpB6XJf6fDzQ6U07udN6aFkVWYquQH+CHSkryqLDMC729eM7HDYpffD77ni1mq
         x6EPFUXKAlKJIVkmh1ktoihBN/NUYd1Xpj1k+FzkowE7Ip7lovYYq0NmI9jzmuRhYZV9
         4kjA==
X-Forwarded-Encrypted: i=1; AHgh+Ro0QHFsaIXzgwd98U3jRJwqbnqT5fvCEDLB/GlJr1ufa6cLl14K6mTV67p19NZcV3q+r/6hs8v0gbVa@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5VigPqNCEItLTjhSdrObvAlsMH9HITR+5qr0OsHwFJZrOUtJt
	j+1xGEjU4RtrdkzEEmQd3AVPCI82fb0MhMincmfCN4xE0PAIP+O+BogOocawt0C4AENEWyIlVdh
	GmtUq1KJkhkT0WNiieu3f1/3Z24ypee3dVLb9Vak8Pd7yfZIq4Mba0MwyP0L5h7QgQVHNpuEuIb
	gmxJesfEDNxKy/+1uGggSVMJ0GC9w6wOQsgjsUlIeUL+K4wCNRo4L2R3cXKaxrLE0vBS+ud1tYw
	ynyCOw0Qj5Wru8=
X-Gm-Gg: AR+sD11bV0VcdfOC9Bw3RHZhaCVpxczPxnkikYzelXGc4nebDmXNamUet5rSpBzpzyY
	5b9RCOYogxkp0qfGiBPCe2X+EgMV8c1P/Zl4YpnaKZ8Tx9DbBT5EEYkTLQ0LZ83feH/eQSFWu+8
	H112myPKcrKTJDeMJwe5UozIEYb6rLgLuWV99qphK/DlVN8NhBrSB41xww44CcPi0k6kceBc29A
	fNrPKzhnCAyNnuD56tv0WxmLprMTDPcTs/sgnyO21CUKDCg7Z+eaQm8Mrshfdz3tao3g7wVaduM
	4ESUkUbaemlVOxzUNnrYasgrQ5ZGlRPJ4DxHpvsNWZ5OFyqPC4ETNHPw2tx5y8K09H+tE4ZQVFE
	7zwpuN7ZzLLK46P8yDW7BQusuvjCjF2GnQ9Sgg/wUEBfRZkzNLVdLvIzsQQIh0Bs3A2bZ2reklD
	wYebKEcbzJox/bYkG5yrxVZpOE8/QVKXeKJw==
X-Received: by 2002:a17:90b:1650:b0:37f:e326:6557 with SMTP id 98e67ed59e1d1-3933b6f3882mr4261519a91.4.1786698678329;
        Fri, 14 Aug 2026 02:11:18 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-394ebbb53bcsm653105a91.11.2026.08.14.02.11.17
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Aug 2026 02:11:18 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cbb20f82a0eso573262a12.0
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 02:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1786698677; x=1787303477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TSV0sSSXYSyAmLjxbnCOORhk+yB6Zbd6HUBS6OIrdiQ=;
        b=X3gM1PmXSAetu4Jt8VHim1DnBbOwS8gwu1gMybOF+I4HdQPmB6d031kRaiQbg8WgWo
         GuH2y/l0yAIePgAkz2gTErZSgtui+SQnjAJoryOwlDRTaMTsGKrYCkLrzJErpJqDkCzd
         +VV3g/iS9R9MQxkjvqJVfSrPhZnLwDwBN3Y/0=
X-Forwarded-Encrypted: i=1; AHgh+RqEPc97H2fTxe4TEjVs0BrasknQYbQOSU5wFCKlDT4tqcaOOPVa9nbTUX1kgt4wwwBAljttHfOglDS6@vger.kernel.org
X-Received: by 2002:a05:6a20:6f93:b0:3b4:9171:2573 with SMTP id adf61e73a8af0-3cc71e32e45mr4481822637.37.1786698676589;
        Fri, 14 Aug 2026 02:11:16 -0700 (PDT)
X-Received: by 2002:a05:6a20:6f93:b0:3b4:9171:2573 with SMTP id adf61e73a8af0-3cc71e32e45mr4481785637.37.1786698676204;
        Fri, 14 Aug 2026 02:11:16 -0700 (PDT)
Received: from localhost.localdomain ([192.19.203.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1413887e3e7sm7056408c88.9.2026.08.14.02.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 02:11:15 -0700 (PDT)
From: Vikas Gupta <vikas.gupta@broadcom.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	leonro@nvidia.com,
	jgg@nvidia.com,
	bhargava.marreddy@broadcom.com,
	rahul-rg.gupta@broadcom.com,
	vsrama-krishna.nemani@broadcom.com,
	rajashekar.hudumula@broadcom.com,
	ajit.khaparde@broadcom.com,
	siva.kallam@broadcom.com,
	usman.ansari@broadcom.com,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>
Subject: [PATCH net-next 2/2] bnge: add steps in bnge_shutdown()
Date: Fri, 14 Aug 2026 14:40:54 +0530
Message-ID: <20260814091054.359508-3-vikas.gupta@broadcom.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260814091054.359508-1-vikas.gupta@broadcom.com>
References: <20260814091054.359508-1-vikas.gupta@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Since the driver now implements ndo_open and ndo_close with full link
management, the shutdown callback must mirror the close sequence to
ensure the device is brought down cleanly.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Dharmender Garg <dharmender.garg@broadcom.com>
Reviewed-by: Rahul Gupta <rahul-rg.gupta@broadcom.com>
---
 .../net/ethernet/broadcom/bnge/bnge_core.c    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_core.c b/drivers/net/ethernet/broadcom/bnge/bnge_core.c
index 68b74eb2c3a2..9846d29b4fe3 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_core.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_core.c
@@ -5,12 +5,14 @@
 #include <linux/crash_dump.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/rtnetlink.h>
 
 #include "bnge.h"
 #include "bnge_devlink.h"
 #include "bnge_hwrm.h"
 #include "bnge_hwrm_lib.h"
 #include "bnge_link.h"
+#include "bnge_resc.h"
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION(DRV_SUMMARY);
@@ -406,12 +408,34 @@ static void bnge_remove_one(struct pci_dev *pdev)
 
 static void bnge_shutdown(struct pci_dev *pdev)
 {
+	struct bnge_dev *bd = pci_get_drvdata(pdev);
+	struct net_device *dev;
+
+	dev = bd ? bd->netdev : NULL;
+	if (!dev)
+		return;
+
+	rtnl_lock();
+	netdev_lock(dev);
+
+	if (netif_running(dev))
+		netif_close(dev);
+
+	if (bnge_hwrm_func_drv_unrgtr(bd)) {
+		pcie_flr(pdev);
+		goto shutdown_exit;
+	}
+	bnge_free_irqs(bd);
 	pci_disable_device(pdev);
 
 	if (system_state == SYSTEM_POWER_OFF) {
 		pci_wake_from_d3(pdev, 0);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
+
+shutdown_exit:
+	netdev_unlock(dev);
+	rtnl_unlock();
 }
 
 static struct pci_driver bnge_driver = {
-- 
2.47.1

