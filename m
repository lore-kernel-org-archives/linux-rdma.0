Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793917268;
	b=mmOa1tv6u8U+8lODijqGIj5knIlyXZXgtcTrolVvhdP92zSs9ecmSS9ANGeESpglbR3N
	 E55dBl2mdsgIDRStyNksgpAuxaLxVuOpyRSlT23MuI/SHwgvVHGpkYvvmXMudJYBU4uO4
	 28pTmHiiK/RaT6BpFUBfndZdxNWIVcm6Zc/xvGgsaGmdv0u6NBjnbfnMoDTOfV75L4cQF
	 qmHIWLdtwAjx1SyHlVWlMWwHWyRsRKzSKlyrhHBXw7Ow2/w7QTViRqWbD80CIfcKANyKt
	 ZUA8jKp1myOwEW16OBDqRjIRnTRyaBSudgI15q46aYGuwi7/JQjWuCKlNsCGpWeSf9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917268;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Wko9jYbcFlAwe6oX0v98B8vdw+6Ys7oB0hN4NsC1Zvg=;
	b=TqHhee5lPEBAve9RQamwdqOkQsQ5xRg6PPVdKb11CezrlgSZmxoNJsyq4X/WxAYnlaRY
	 q+wPIXudeQZOY1/hQW0cQX/2rNluKbvyWTwYbiV0eeL/ei23MzWQF94K+nZQaBMxXV3Jc
	 Mc9LpNDhLCKzDsEmxJjMHQ+Ug4GVPFu4/GkJ6+8reMk9pvSHXZidMJ4RrRq0uSCXxkrW9
	 g5UHhr8s3W6D79sc3VS4XBhsyUXxkbEO9jQoQ5mmR2taYYuyysbFuZpBmEDGokqUBlWO8
	 lRrDJdOEb+6uq+uWaWw9piWucLdBu2NkfKDlRPBsQyol3831FDvwf4HkdxCaR42flzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tz21y1+Q;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713D1606D822
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 22:21:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 713D1606D822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tz21y1+Q
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-36c9e2dfb29so102eec.1
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 14:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793917267; x=1794522067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wko9jYbcFlAwe6oX0v98B8vdw+6Ys7oB0hN4NsC1Zvg=;
        b=tz21y1+Qew7hl/Wnsu0cT4nQ9LapPqP/EcySc55XzEzSKyvsKJPQqZfz+zYFLEh7Pu
         8g2X3a1E91Jy0F5IKQJ0GKPJdh8Fr66eG4DTrBw6XlKyXkOa/pYZriB8Js1SGkmxLOUy
         IE5lxum48sXc1czWgAt6Q/hnyojkVE9KjN/7aotvbHY04rpX3SRuLsJVi/FcOLYhTuCz
         aQGg121SHDcG9s08QKA2Wq4D568nrjceOo1sPCbasiCsiVNqCIGZDlS62S21v6ypct88
         3guGUj+JrBBCf80e+jdO1jhBvMuBAs3N9PNQUY7GmVHXWnsHC591iuygoJwOC6lFcnyY
         Yc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793917267; x=1794522067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wko9jYbcFlAwe6oX0v98B8vdw+6Ys7oB0hN4NsC1Zvg=;
        b=D5RqO6rBkbHPP3ZqTLhasujc8+VCaYQm2zmW0EovYzP45SbwzFN29h/HoROsvF465Q
         CbBK0FgFajG8gFrTlSgKnwyouKmo9p7U9whuAGFQcvGZlfWMQcfRO6BBvRW0RdcK7xYl
         uFFBs8z4BRfO8syfOFzWio8AsrBg+HEHPY2XBsgmOoUFC9hB8MYqbNsxtI5tjQBY0Uak
         Z8/u7FPsFg59fOIEI8+BaSKx3MAVRn7PzkdyeFx82HanQrQsLWjbct6PYW2RGJ2x7wVU
         N+P1dFROBxJLuMvtbsBgo2MEn4bNvc073SjhyKKVq9S0Ts2XPGkwIEdBxIaVPLBaP1ER
         3Zlg==
X-Forwarded-Encrypted: i=1; AKwUvBw9vv3dM+14HwZ02NMNgq7Nr6RljOYP2nk4vJwg4nqtEMYv1xZUqxp/fbZHdpeK3Y/xYzczJZVI7fOE@vger.kernel.org
X-Gm-Message-State: APuU4Z/+noDRdGv69sL7Fesc86Yc2k/VEP4vpToA7f9Fab120e1NP18J
	rO4K7bqxd772OxWyb5+JpGRH1olR6Ey9fxlf3vSuKT1OBLG8IpF+qBhc
X-Gm-Gg: AYBFou0hmLUbTsiFRatsH0HpB/OJG8sNGYKISLHWjsVmZ1DHh/W7wKAACZeOAnhLyDr
	QjGOjQGcYFVDfCo1tUczl69styCU4SxuMW0mT7W5wT87QBJHwr1oQJxqm68P8NjlM4+vta0ca8V
	8lBniOw42UE5vm0vg02YXFmUdJhATScvxtUMMI1aWVu/b71qw77Uo0SRVTS8ZKN83B/ospwbX/u
	FTy6hBbldKRVS+Hecf6frJcYRLhhlVqQiaNyTwT7mo55+GYrLHSxfEIPQgcn4tGRnXoXyXy0x6E
	S0GzM6gKRZ8XQsVbEb5GyeMqQ0FTGzNKcQyb030UH1iuQ4ggqFf7xTED8HfrWEXMzWXqqbiPbgz
	nqZ4bh7jRdlgfoLbUYBB7r+Tn9lEbF7qf6JbUpeNB8EP/1sVHhIIa1M1fP/h2hzD2dCx/qCCKer
	3oIEj2KPiwlizUrtTXe5psza0O/6bWC6s20F9zfKT5IJREREnFF9L8kOBd+DnHbSfSw+khuXp9Z
	5VKN/e/hni80nnZmJTFV1oh5RVP5CNdrHH1uxA8SqdNmk0Mip26AhJaOsevMNrUnMA7cO0ElNOX
	Yea/rGnlhGMUHEx9xaqHXKA=
X-Received: by 2002:a05:7301:460f:b0:36a:15ba:43ea with SMTP id 5a478bee46e88-36f76d177bdmr646010eec.5.1793917266455;
        Thu, 05 Nov 2026 14:21:06 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:44::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922b205sm39909eec.11.2026.11.05.14.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:21:06 -0800 (PST)
From: Stanislav Fomichev <sdf.kernel@gmail.com>
X-Google-Original-From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	edumazet@kernel.org,
	horms@kernel.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	michael.chan@broadcom.com,
	pavan.chebbi@broadcom.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	alexanderduyck@fb.com,
	kernel-team@meta.com,
	sdf@fomichev.me,
	dimitri.daskalakis1@gmail.com,
	almasrymina@google.com,
	dtatulea@nvidia.com,
	bobbyeshleman@meta.com,
	asml.silence@gmail.com,
	daniel@iogearbox.net,
	razor@blackwall.org,
	leitao@debian.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	leon@kernel.org
Subject: [PATCH net-next v3 5/9] bnxt_en: set the netmem TX frag size limit to 32KB
Date: Thu,  5 Nov 2026 14:20:54 -0800
Message-ID: <20261105222058.944293-6-sdf@fomichev.me>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105222058.944293-1-sdf@fomichev.me>
References: <20261105222058.944293-1-sdf@fomichev.me>
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

The TX BD length field is 16 bits wide. Set the netmem TX frag size
limit to the largest power of 2 which fits, which keeps 4K aligned
frags 4K aligned.

With 4K pages this raises the PAGE_SIZE default. With 64K pages it
lowers it, 64KB frags would otherwise wrap the BD length to 0 with BIG
TCP.

Tested on a 50Gb/s NIC: devmem TX from a 2MB hugepage-backed udmabuf
runs at line rate with 2-3 frags per 64KB skb, none above 32KB.

kperf output (sender side, 1 flow):

  client: == Source <sender>
  client:   Tx 46.358 Gbps (174483046400 bytes in 30110590 usec)
  client:   Rx  0.000 Gbps (0 bytes in 30110590 usec)
  client:   TCP retrans reord rtt rttvar d_ce snd_wnd cwnd
  client:           729   153 599     48    0 13893632 3147
  client:   net CPU 71: usr: 0.03% sys: 0.06% idle:67.62% iow: 0.00% irq: 1.12% sirq:31.14%
  client:   app CPU 72: usr: 0.16% sys: 6.01% idle:90.66% iow: 0.00% irq: 0.83% sirq: 2.32%

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e7a4190a8c78..c8a887facc20 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -17439,6 +17439,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (BNXT_SUPPORTS_QUEUE_API(bp))
 		dev->queue_mgmt_ops = &bnxt_queue_mgmt_ops;
 	dev->netmem_tx = NETMEM_TX_DMA;
+	dev->netmem_tx_max_frag_size = SZ_32K;
 
 	rc = register_netdev(dev);
 	if (rc)
-- 
2.53.0-Meta

