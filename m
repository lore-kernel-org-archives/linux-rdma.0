Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2494F447811
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 10:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788519133; cv=none; b=F7hRUsJyyQK4Pu25iWuEAPQACbZOocch/dgzfwSCXBVGohgmb76BF8PKmT2XNSoKxmBR5OKsuueNx+I/XtR6EY1xFr7CsO3oGPXIWQlR8IC1dpUXLNGECv5kwCYZEyMEiNABu1xTICAqrps4yjZlwh1iKc3HRpv/AcYkQJFIy+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788519133; c=relaxed/simple;
	bh=WRG9UgShlNfxyLPPBnUHhlfjXfFCUHshugncnalnY60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTmpAInQmxMf2a6SkfRUb2BKQD9WDb2dLWBQ5LPRcMHKGYCtfhed08ciLOVeKxvmLv6jLue91PnWqKXBqEjYavx6LpLL4KrKAIok1DVdihe5VBc9XDBymAbYRQlwtS9xFOF8bQBb2FJc4HbLCNfwLTk4vL61HMDb0AuErzklUKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KEZ3OCHJ; arc=none smtp.client-ip=209.85.215.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KEZ3OCHJ"
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cbe827e3cb4so1026863a12.3
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788519131; x=1789123931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4T8JhJl+n0cUcmlbairws+PCdmkJbE8LYyhZ18WIdqw=;
        b=SP6TZ9ibT/aVDJmi4FWGQQSMoz4kmUbe6tFmcyCY/Rh20SxOxvp/uUWSPl7mt+ojyj
         8pC/tuy4Q/7LcsrrQyCkpOexla5T6vuritFV6Fljp1o8PCyWwJnJoVLKMfWfyJ3ymPhy
         WMHkSlUher/ws/Guq3WcGWgMrHdTFQSMJAmbFuNEtQtjRULllTTcObzXhsTI4jiK60+R
         eEDKA7pVpgpBBEmZBbzT8iWNcs8KyTszdRH2Dg4VrHtDj32OsXZ9kdBlCPdXZsn///kS
         qxmHh9vXZuv867dDXqLOxvZQyA2KfYnHxREYJAJaeFLTyYZ6uytidiBZki8IuK672BoF
         RjEg==
X-Forwarded-Encrypted: i=1; AKwUvByZMH1ZyQUNSXWhG/m5zeGYUVmWSPtPFykj2r9IdFcL+T3G+ma9XUMwznRvTT5HrANNxSKmJjN/ULYb@vger.kernel.org
X-Gm-Message-State: AFuF++lZafyIPluI3RIPTqfOM6iHXJkmeCppC69/YxLXOAZJTsDXyFOe
	5dLgycVAWKu3Fe/rKLVHlWVNK5dzvBAhsu7iWKsahHYw+z8DDqyqpxp/H7Vh17eSTCpRP60x35J
	aU2nRIAuq2bb0WDj89/A4nvMtwX9th8ODBQVPgt3N4YxrKdK7csXz45HcsIEKzMjSw03gbSx/Hd
	X7N8qih+nZGBg1rxKOfD95eHIU7PX6AFv0SPqvF+gscsd4DzGRuClAq1ZpQObuX3Sxfj0KZxiSu
	oMw/U83UIRTXQs=
X-Gm-Gg: AYBFou2SnM25RTE1xD71kdwwFdN10IGatxHvGRuo0rqxX0NeMo7RJKNu6aunX2zqLPB
	BYoroWhEntvtttX13bu7/wgZnWPNYrpo9RpFIYvgiy15h3BYBicTcFaO7RevZ4p61Er4L8Vmn26
	iqLNVTHWTowJ67sHaPgDVD+4b9GScdGaOeSve6Jce7p9n1lNE4+EkEbFgQbXtj7swOIfLCwjwYj
	Kvygan4gpqzhQz8in5tFVmSzvXjU6yhonuvMbEtRr5SHGVQpNBoyHF/qpgVAPHxK7FZ3ICfqcnL
	THh6ALuJDDJHIgSulRC0/O4UzzwrOY3boVQkhiEv2h9eIj0uJU70YjBDYhySsArofuHZZ7xNltz
	4Dpk2EzMi8/ADtEiisK6fO8yZW7SLi0CeWTROH4LAZkW2vlTAUUvnfBzNhHHkpaHdqriM5CM5Xc
	d5Mbp9ibcmnc2JojQ8/9acQocX2LKtC0GSyA==
X-Received: by 2002:a17:90b:3ccf:b0:399:ea1:5a82 with SMTP id 98e67ed59e1d1-39b26101277mr6747599a91.3.1788519131264;
        Fri, 04 Sep 2026 03:52:11 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39b260deb53sm1234066a91.4.2026.09.04.03.52.10
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Sep 2026 03:52:11 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ce8a76df2dso15991865ad.2
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 03:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788519130; x=1789123930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4T8JhJl+n0cUcmlbairws+PCdmkJbE8LYyhZ18WIdqw=;
        b=KEZ3OCHJgsdO8DoRgYA0ZsLgUs4Kx22nxeJmcQPdYckPuecm92FRlHZ8mXY7PMXarg
         fer0gp8euIgc5cixgl2XDF+dy6DbUD5BPD1X3966kJ/oL/qmre4d+/6Y4zOGnlAIYLJN
         lnLqcDI5wd/4rkSNwReqzUnQrEoU4X3bspatc=
X-Forwarded-Encrypted: i=1; AKwUvBzCLiPCyhYzQZgAsLXgplkqBP9WO9H76X03Akby90xN1cwymeEHcTC6ZCV4vjYIE0aM3ioR80pIlckV@vger.kernel.org
X-Received: by 2002:a17:903:1a8c:b0:2d8:d4d1:313d with SMTP id d9443c01a7336-2db1267bc0emr77507265ad.20.1788519129670;
        Fri, 04 Sep 2026 03:52:09 -0700 (PDT)
X-Received: by 2002:a17:903:1a8c:b0:2d8:d4d1:313d with SMTP id d9443c01a7336-2db1267bc0emr77506395ad.20.1788519129223;
        Fri, 04 Sep 2026 03:52:09 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534d0asm6171170eec.8.2026.09.04.03.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:52:08 -0700 (PDT)
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
	Saswati Das <saswati.das@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>
Subject: [PATCH 01/15] bnge: Add infrastructure support for RoCE MPC channels
Date: Fri,  4 Sep 2026 03:43:09 -0700
Message-ID: <20260904104328.763768-2-siva.kallam@broadcom.com>
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

From: Saswati Das <saswati.das@broadcom.com>

Add the initial L2 driver plumbing for RoCE MPC (PRIMATE channel)
support:

- Plumb BAR1 through to the RoCE auxiliary device info, alongside the
  existing BAR0, so the RoCE driver can reach the doorbell BAR.

This will be used by follow-on patches to issue RoCE commands over the
MPC channels to the firmware.

Signed-off-by: Saswati Das <saswati.das@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Dharmender Garg <dharmender.garg@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnge/bnge_auxr.c | 1 +
 drivers/net/ethernet/broadcom/bnge/bnge_auxr.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
index 0955b488b6fe..87ae40eab592 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.c
@@ -181,6 +181,7 @@ static void bnge_set_auxr_dev_info(struct bnge_auxr_dev *auxr_dev,
 	auxr_dev->pf_port_id = bd->pf.port_id;
 	auxr_dev->en_state = bd->state;
 	auxr_dev->bar0 = bd->bar0;
+	auxr_dev->bar1 = bd->bar1;
 }
 
 void bnge_rdma_aux_device_add(struct bnge_dev *bd)
diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.h b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.h
index 6c5c15ef2b0a..13cb9289f5b8 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_auxr.h
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_auxr.h
@@ -46,6 +46,7 @@ struct bnge_auxr_dev {
 	struct net_device	*net;
 	struct pci_dev		*pdev;
 	void __iomem		*bar0;
+	void __iomem		*bar1;
 
 	struct bnge_msix_info	msix_info[BNGE_MAX_ROCE_MSIX];
 
-- 
2.43.5

