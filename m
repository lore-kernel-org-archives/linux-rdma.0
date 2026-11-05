Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793869869;
	b=DzydO+QTreS80jK5k2Fu5eFGa76FUzu0fMurzg0AaoEmhArIgysPF9KUdvf7JamNL9Y0
	 /GMtzJvba1SjuHIDPatwjWLBVpTUVP8nRGkxHmk7tQ7bmMdTbDoaNFMfoL48Or1l4PK27
	 LEITFCCnU60QHVq36tXdqApHcLRWRrSpufkGcz08NA35cC+zS3PPMsvQc9qFAKdhJOeIT
	 qSueuHNuMjbUZXC2P8P/eVBEbxq7AoiqcdYJGY2t1VLIohkTLeZKz0mDWvPy9UuqcXZw/
	 fFPGymutpfR0KfBB2Tg1aUEFTvqETnXhk8AzM9Eod91Qli76R2+CPBpeScMWipBmyhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793869869;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=A1RrU/JNgR1RP4YNG6owTJ8LvQxop52hPUkVC/V8M0k=;
	b=FO1VRcUsC9xask04SsBT8jtEwchseSrwV/WlyTotHGUMPf6LQtSdctAaTAn4+pD61jwV
	 KKLkA1Cmd0HkhebX/+m2/64yq7JvU9frSNbNFdgTPRqxXJgP/QeJhbkT41pV3Cn4n/w/9
	 i4HA9SWx7c56/WFMiEkychaZw6dkJQQmNDLYqCCoCpxohk3nSCKSxx8mg8P8SpZxmtvc3
	 d09+ZwG+N41JTxAaPCvdeAR9fd9MNaAWj6WVm5TBUqICCUoRTPYzTsLT10mVzjaaFu8hR
	 xzmilMd5hp2c59+nN08dqLqR3/ZkHzf+g9mjtgu2jZtIdUohTnEr/oOXIBASFM3OP8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=bIL7KRz+;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BC4606A328
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 09:11:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63BC4606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=bIL7KRz+
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so205762a91.1
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 01:11:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793869869; x=1794474669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A1RrU/JNgR1RP4YNG6owTJ8LvQxop52hPUkVC/V8M0k=;
        b=thN/63wrTsgkuVykxmoWznR6z+KReY0cl4h84AhCObOWe3o+PGQKGykToqdSF+ThTX
         kdpGaJpPu5an64IzYXRdYJnyOSV9LI8oRAREDGNdhFF0+7KhK61mJKw7Q/8Pi8FVMJM1
         pCp6unlcQHfa1wDgkzVxQh4JeVV31okFh7v9+eT1oBvd/LjFdkYh4yMoBU+116e+5Vaa
         onmkYjd37A0JMRGoJOnuTcA1KzX75nd4+11RR0151lnwFxB+wmtMZAdoym6Iw7plHtjQ
         dwBbNh3hRR7RAmFgSZMnsTkyB/fyDgHtCHQ6TxefHZaZCwNfuqoDPA6+viOroESootYI
         rTsg==
X-Forwarded-Encrypted: i=1; AKwUvBwaHDyFE7oT7izYbs5Px8DGOEFHUh0Zikkl1JDvQ5cYuX3+rBVUunJ5QIC4EZUg6C4pGGCFVHQjtQx4@vger.kernel.org
X-Gm-Message-State: APuU4Z+JUwNys0wh9QCgcy2fPC7YQtGO1zYahEdBuYhOLAEPaY9QBGCJ
	xGrN4R3KThEBzQrELB6xcg+f/b47sXhLo0fCdruFg26B9tDhWiIt3RcNDLeYgRdrODtF0XqKGx4
	GhL0X8VUv/IHbbHDkxD9KnEVXWUWvyIFY1yBMimeteVK07xzwJOVncMSh3AH1H7pXZ8rVyCiFlu
	q3j8hd4rhhnzLu3EPfk7S6ime+E+mx/NDOuQrnPR2mseRt+Bpap+3MibQ8qEu/zhvOVRCMNvS/g
	JuY/4nQHSomo4Q=
X-Gm-Gg: AYBFou3jeHpXQgdfo/ofuMoyi+jM7XUyQxPShgwfMHz0W5oxomRx+yBfwnFkcLsD3c5
	8+naQBHW8tPQEJylp/22vBkO5Sq5rEmQRft8WcoveQvRpHQAwWIwNkZpRZuy3fuvyfzKs17NHbt
	n2QAeHoujqEymrUfQyHy0Y8dQe3UqKX7z+zka3ltxLZi7g8wtoVbg113FAWuikVyFt+JxI6puxo
	S6oGwKvLsuvnSuX3a4ExWynhxpEaEf2HmeZnpOIbyPmSIMaSYjuZX2ifhnw0PxY8bnuE+x5WEHc
	pDvVyDrFkvJG26fV4h3i/Ba+FQt6rWOsbhcYqS+WUZSByEptnlHXPr0pe4r1luzFNGNO9iQk98m
	J7U/4HF3kHrx2vYNj2QkoMMEE7KAJX9MiO2rr6JfjnTbWsBSpMC4NRzAaBE5jXq2Bt9g9qJR1ps
	7yTjHfKMxrm/w7SIQzaSPGNRL83RV7n4a26A==
X-Received: by 2002:a17:90b:52c7:b0:3b0:ae41:2711 with SMTP id 98e67ed59e1d1-3b0ae412932mr1875330a91.24.1793869868747;
        Thu, 05 Nov 2026 01:11:08 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b09919c5b4sm1465231a91.3.2026.11.05.01.11.08
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:11:08 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91ea0c20af3so647976d6.3
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 01:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793869867; x=1794474667; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A1RrU/JNgR1RP4YNG6owTJ8LvQxop52hPUkVC/V8M0k=;
        b=bIL7KRz+CB5zZaQn3SPpePiCiGHLm5Cz9j6doZR37jEFXPbkuuG9VFxK2SsMtdQnZ7
         HadsXDW2vpMpwo4+6AC/Lqc7orADi+NnQh2q+tiRUdsEtSogjvdRQkI1qsrJ2/4Mc6O0
         ONZFbQ/dfZkoRrtFdgrigd7+WP+/rBimadE88=
X-Forwarded-Encrypted: i=1; AKwUvBw6o68lGPX1AYRppgyvwCIftgpnNJJeKjsm59R+RCucu/7WWvXsQaaEcP0raKm86HBwcpo5A8Bed2/N@vger.kernel.org
X-Received: by 2002:a05:622a:2e87:b0:545:32db:e551 with SMTP id d75a77b69052e-54532eb38e8mr196110211cf.75.1793869867285;
        Thu, 05 Nov 2026 01:11:07 -0800 (PST)
X-Received: by 2002:a05:622a:2e87:b0:545:32db:e551 with SMTP id d75a77b69052e-54532eb38e8mr196110111cf.75.1793869866807;
        Thu, 05 Nov 2026 01:11:06 -0800 (PST)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b100af507sm47298591cf.6.2026.11.05.01.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 01:11:06 -0800 (PST)
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
	vikas.gupta@broadcom.com,
	ajit.khaparde@broadcom.com,
	dharmender.garg@broadcom.com,
	sachin.holla@broadcom.com,
	Saswati Das <saswati.das@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [net-next v3 1/3] bnge: Pass BAR1 doorbell mapping to RoCE auxiliary device
Date: Thu,  5 Nov 2026 01:01:52 -0800
Message-ID: <20261105090154.1293846-2-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20261105090154.1293846-1-siva.kallam@broadcom.com>
References: <20261105090154.1293846-1-siva.kallam@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Saswati Das <saswati.das@broadcom.com>

Pass the L2 driver's BAR1 doorbell mapping to struct bnge_auxr_dev
alongside the existing BAR0 mapping.

This exposes the doorbell aperture base to the RoCE auxiliary device
so that the RDMA driver can access doorbell registers when configuring
firmware communication channels.

Signed-off-by: Saswati Das <saswati.das@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
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

