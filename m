Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793917269;
	b=v9LW1ReoEYgAjrHjNxX09BocpWaQTblMP7jOxpcp9mwk9rfH8EPEPXgZs1cigs1xJaMq
	 THQJhFCKVlJeB15WX+xnwYt7Up0YbJal7Xkfyba+aE26HSStSPv/cNkB73vZDfzUDB71H
	 P9KiOkJUlMRDKR/CXgtAcyEttm7wmjBsaGw7jmkz3S0gehyeRWmM9HYanwkejHRGzqBNa
	 5EPSkl64grRSv04Qt40ixld5J8hKszJbOXJ/YJnAhdV7gNvrKxFA1Cp2J3dL3rhQ7lZAF
	 r4IuM1p5L5ddMauwN9eH+Ej3KQ38k5L2bZACAW2fsUB+rdKyCAi6tmR3+EcyuhuB2BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917269;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=4db2AlEwBuJ3NhUvd6DttANYOsA8cpC5/Z0gBUqIqT0=;
	b=kxl99qFfAQ7WVj9DNiPpu+mnYAdzKzFMN0dvu3s90E/71EKoFZhJACTGYC0RcAks4AX+
	 GqHMq8OfiLK+Z8bpQW0rdQ1wCdgiyKDIuvR8xUVnzvuX6FReoaicSh/x3VgyxHU5janbS
	 VDuJQA1ShWPpBBi5NPcK3mHALbZPD3WHwgzu/OarseLS2gYbNsqv2ncnTd/Ccgt+hp/Be
	 Y8Ta/r7yCDpA42Jhyf+XNttwFvqG2Oby1Yxw0RQhY5ljubciHBsGOb3rGKFtANosfzz05
	 qB1bALph5CoNlYZpTx1ygOhTks9C+QLdIuRUZhuOzX93+8LSv+JCON/9e9XotyEdKTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZrlqBW95;
	arc=none smtp.remote-ip=74.125.229.135
Received: from mail-dl2-f7.google.com (mail-dl2-f7.google.com [74.125.229.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD53F606D83D
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 22:21:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD53F606D83D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZrlqBW95
Received: by mail-dl2-f7.google.com with SMTP id a92af1059eb24-14345ae29c5so51662c88.1
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 14:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793917268; x=1794522068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4db2AlEwBuJ3NhUvd6DttANYOsA8cpC5/Z0gBUqIqT0=;
        b=ZrlqBW957FVRSJmhWtYT2LZ20iLqM9RUGB7Z0X1CqCOXFP0vE1Q7C6Q2nXJgpBFRq4
         Y0uMg2XCt+yCfud4FgOvOKF0JHJPs0lVYLnGJQ4jcxxF70pQppH8nnLD50s6trUzqKW9
         HGpBPaeom520SaQnpAAKksjsd0wAIXkDsU+aD/KgENAMz/PYFf5jq4jUvqCBiJJpoqLG
         v+bH1XZdZ6WrabNwkAW+3z+BeWR94LS0RIHFvavciURbGe8OriTuxF/R+Rx58PPkE5Js
         VeLlpHVqQwrZGLRVasQ9dARnv4xZUCKPjgg+Sgd9mEmFSk4Osvn6arU4uu75Bok6gbqw
         aZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793917268; x=1794522068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4db2AlEwBuJ3NhUvd6DttANYOsA8cpC5/Z0gBUqIqT0=;
        b=Z7UeUfhB5D5Y3HsyFzqJcFxC0d6xMSZ4ZPYQX044qpk9o3Fami0s40RRGWr3i+eAAq
         mj6kPrcHuF0RjW7vgGabk15PaDnxyAJX9U5PhUVqgS4/zZxtm+EtvRjlRUBk9cHpAQFn
         +ppWolyW8WeoWPxvZWew7AnRNkFFGsn+5QKfeNu+r+dCZkV66/3PwasBw7sdf3wg85IN
         gDM5fOs4GgOQMrgTC4g5XoYAZiRH0yLqthf1WPSFJy/6i71lM6BQ8flfafgyLvSRULaQ
         iuHbDpG009+QqjKsHJKwYJsWg0HRypfw9vkdyOyjogFiSTUnJEkuWqfM+i+E1AQ7Q4dT
         Ggrw==
X-Forwarded-Encrypted: i=1; AKwUvBwwbJDXE9TFjx4vsj0pc9ssDbeq6wOV8D44qPZNZz4hO0xr2ljcAo2EZfq5bb1z+QBPWzQwQ/WTN9Z/@vger.kernel.org
X-Gm-Message-State: APuU4Z9k6feuuIk336VXH76wCcS3AZYaG40WXk6grxYtGzZ3JEv4h0xt
	EP4zElBnC4k4t9ZkQD3BOOTRWEvupLyTANHt8kw7iUm+fIH+hXtpLZe8
X-Gm-Gg: AYBFou1knuZEJp7WC6KYcQvktfzR53wcfkcQrunWQBKiplVXv/2b/G+PIm1UWVin3QW
	1KcPBDAxN1CzWP5b5nI24728gZiNgJcFtR3dFEUdimJrIoxlLUIscV+OyplJeu5dh4GOZbl4S+B
	cCRHL1f0VCSsNleH3ttVmyZYynLfxlViVKXb9Rgd4hbovr7CBZYfwy12Qz8hhLuX81F5e9Kr8S3
	tytdjKl8DuJFcz+Paz5+s25JR6ukWWZAdl2HgINgPjW91XIhFRdR8TRv02Edb8Y4BWN9/JH/fhO
	Ye5ZfxZ8yU3zLK1g5ZPp//WvcrhjkI2XxgWlNzWg51V/j+/3xq5vBAvA5BNUj0wVWItYk8wDLee
	JKrazGIliA6htxn0+YssDXSwmbTs1M++qq5VnPMNjNXDyMaOtvBp66TxgGd+hjusmJDIeuLSh1C
	7Q2Cj/2WMvZWKe9tSSt4QW4tAZjEMXmoyW013U4th8iiIxG5CiVSdEANmWIpwRmcSWbYbyWsGOg
	ruEHEfpxNpKfjKfqMWDTfS+uQ2etL/38az4FKB/F8ZlB0efWuSZthH4Q89CNI+nKPaGt725xRy8
	0oavMFHJUtKvFdYShMVXFzw=
X-Received: by 2002:a05:701b:4590:10b0:149:1feb:6d9d with SMTP id a92af1059eb24-1b25d31efafmr453115c88.19.1793917267847;
        Thu, 05 Nov 2026 14:21:07 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:6a::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm26931436c88.21.2026.11.05.14.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:21:07 -0800 (PST)
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
Subject: [PATCH net-next v3 6/9] eth: fbnic: set the netmem TX frag size limit to 32KB
Date: Thu,  5 Nov 2026 14:20:55 -0800
Message-ID: <20261105222058.944293-7-sdf@fomichev.me>
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

The TX descriptor length field (FBNIC_TWD_LEN_MASK) is 16 bits wide.
Set the netmem TX frag size limit to the largest power of 2 which fits,
like bnxt. With 64K pages this also lowers the PAGE_SIZE default, whose
64KB frags don't fit the length field.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 drivers/net/ethernet/meta/fbnic/fbnic_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
index 8a6703afca38..0a2b66202aec 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_netdev.c
@@ -760,6 +760,7 @@ struct net_device *fbnic_netdev_alloc(struct fbnic_dev *fbd)
 	netdev->stat_ops = &fbnic_stat_ops;
 	netdev->queue_mgmt_ops = &fbnic_queue_mgmt_ops;
 	netdev->netmem_tx = NETMEM_TX_DMA;
+	netdev->netmem_tx_max_frag_size = SZ_32K;
 
 	fbnic_set_ethtool_ops(netdev);
 
-- 
2.53.0-Meta

