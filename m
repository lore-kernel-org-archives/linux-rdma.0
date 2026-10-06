Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A7F33939C
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791303839; cv=none; b=AFAcRKOjFzQITUPw8FqBGqV8jk3/XqnquggAraPrqO+wIATwJHyxzSjkyFHF/ks6cQrlSElH9jDtephDA3DlewXrpOZyWc0syFhM0snn8vY3Qs5gLP4JeBmAuSsgQMKIZt9fCNk4Wz9xdHn6vprx1vNE1xd+k3GcUj4l9HRcHRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791303839; c=relaxed/simple;
	bh=VxMNyDoWxVlJ7T0GoD5YGGuBg3vpoeSHQkr1MLBpXfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIcLgHzIGiiHiOxMWRd2tgL97TauZbEYii4sAoGKq/3Wm4S/Witl7DjNphlHKxBqab7r3HWCIFDgTOorFQF+aFHV2MO/B6ibM+bj0D9avUGF1+Em/RoHAo1DVKEdxP9b09tucUXKScRZMR1JHlQZTK4IxLpIHaYwgHN18drRPQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cm6wAsod; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cm6wAsod"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cc1c9879395so420483a12.1
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 09:23:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791303834; x=1791908634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fd78CaQGDmDD1ZFQcb9JSvynsD0IJAgYRm2QVzW7Ldg=;
        b=HyWeIEpVNgUP/BUtSpZlGfh+AlqCKG290aNUpsNXB4YjPnyQwVX7STrHnAjfR9d8Lu
         wVhXlSE64yPGVm5pNNRrPrCziUn+J7s+HxlM/mPAPPvgFOSofYXOuVaFP0MLELlTwNvi
         TAlSSWtGo4TnAWYXYx5OZxS79gUANkdSTiH+md30CNJB5VWw4VR+tgJNIyLsfzhLR69H
         gb3bCdVoNHschFvOaVx+75Wym897nf03RQzl+pu6pkTQ8Fq3c4SWU/IkGwsIEG0sIYQ5
         mpFWjKYXUF/e9yarRgSTf4IzT+L8ZYaanQQ1wULbFZRAPfnOv8hKT9hQW9HGzzmk0UIm
         KimQ==
X-Forwarded-Encrypted: i=1; AKwUvBwgU1wC4B21jaIXNOWuxER6mKL5mpwc/5W+5YPdEN32t5ggnciVYl5D9qJd06bQWxlN+ie5mEjdY7lR@vger.kernel.org
X-Gm-Message-State: AFq9FYJObvYUlbh3hEEIiTXLmod9Xe6wUTSzhF0Ns6PAdHuJL+QnzAiw
	uvorRiQCC12gQoRKBySPgoan2NRhX/PQiA3ixbG1GNFwZUYRQEfjbQp0iwMYSBwjnlIfMgonbml
	D8BgstfdNDdhUsu4adptGjsN+X3x2XdeC2lSz1jkKkHcOGxcopirytamgHLJn9lAkAdruz3qLH6
	LDCxOIzclIjiVvbJT7yOvcCljVOlFPeS5qYQ8+LscDwWgoWe++JE4z2voqZtRWWWSbIAPoClHBm
	ZyddHaB73/q/Sy3qg==
X-Gm-Gg: AYBFou29mI/c0p7Jdggx4gIyyFGMWmfUoKAd8FqgBUStfaHN/2HgU2CgCbKCrmQtGmj
	FGvPlDHkFcJ3tittI5iRFLJ5Gw10Etr1ItxwwQVEItn4Xo5y4FkCZP1Gvixa11dGznStgpXpqOQ
	JRbk8dL+mwbxA8VRFvIzjvhx3FtbR03650fZ2BLHZVgv+MO4OWXpROQ6Xmn/gDR1PQbUG0GgcDW
	/Tbr70plI8fWqmT6hrHB2RYLuR6D196o9mu8a/g7mnjvcM5kT54BNQwE1DehYTo3dJdChexrV1M
	MB+vchdQeLt5lDCcw07pvhy1diGV/PThriqxpsQ3PpmnNWyrMApQvSU2Q4w9ksAu0fe5bCrO4a/
	KJn2a63SZWcKFHNqM3BVFII+aMZX3nZstqhL6ZwQhgvdXLKZPdet4lSt4dEj/G/EqbUSKlG5KiP
	tWfjfR6P//QjNghkUQs77GQVolYRDhZdUDN5O2
X-Received: by 2002:a17:90b:3c09:b0:3a4:c538:49c with SMTP id 98e67ed59e1d1-3a87379b3bcmr1191917a91.50.1791303832399;
        Tue, 06 Oct 2026 09:23:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a898939b02sm46149a91.8.2026.10.06.09.23.52
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 09:23:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5337f26ee19so84932481cf.2
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 09:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791303831; x=1791908631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fd78CaQGDmDD1ZFQcb9JSvynsD0IJAgYRm2QVzW7Ldg=;
        b=cm6wAsod7QzwpvP+UScMzoULxd9+GPD36ZF45anzBL37elGK3nyZS9QYL0dF4D7mqg
         jGkFVv0uO+9iyVsv+HcCxNKBjH1aszrFZmza3Yjo7jRWHisSjhrrLRhJmZlhqBKdDXJ1
         UUEO0AuVQAqX87xn/X1olFL70TBZQ3l22kliQ=
X-Forwarded-Encrypted: i=1; AKwUvBz5IqhqB9wbqUtrDUBtjEtzyvhaKXm/KjKJHqwPw7vXdRUvBL0wWol7T85CZxlK9hQHybnogbc0TPW8@vger.kernel.org
X-Received: by 2002:a05:622a:64a:b0:532:18a0:491a with SMTP id d75a77b69052e-535671b6c03mr33111081cf.60.1791303830309;
        Tue, 06 Oct 2026 09:23:50 -0700 (PDT)
X-Received: by 2002:a05:622a:64a:b0:532:18a0:491a with SMTP id d75a77b69052e-535671b6c03mr33110691cf.60.1791303829742;
        Tue, 06 Oct 2026 09:23:49 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5356b860df8sm9020961cf.14.2026.10.06.09.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 09:23:48 -0700 (PDT)
From: Siva Reddy Kallam <siva.kallam@broadcom.com>
To: leonro@nvidia.com,
	jgg@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: vikas.gupta@broadcom.com,
	ajit.khaparde@broadcom.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Saswati Das <saswati.das@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>
Subject: [net-next v2 1/3] bnge: Add infrastructure support for RoCE MPC channels
Date: Tue,  6 Oct 2026 09:12:54 -0700
Message-ID: <20261006161256.1493672-2-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20261006161256.1493672-1-siva.kallam@broadcom.com>
References: <20261006161256.1493672-1-siva.kallam@broadcom.com>
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

