Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.135
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793917262;
	b=nYKHEsMvDHxx/IW8aMgyAS5ecuzdh9HnmOP4Z8KzIhvU5nvvwIjJjubVapyTgqXiDinh
	 K/C4TNg51uaEMfzFkkByw4zu69PcdTJnhgWxRCtEpjXxbkr2XJVJ9hnIq2g/txLsir5SL
	 MPH0Iov5OyzjyLiUNxv4J4YCINH93VxfkY3rA9eh6aX0gh0gQRzTPRtlWA6rg8/vCnRdn
	 rvq2tqV0rpsgJAFJRvH3hyCIcA5ivsq7JCAcgdaNhFqctnFVdaoVsI8rzs8Qd2v20pF/t
	 NB8p2/Ey9cC27IKUz1jVsbFaBXUHCCWvOpHk5pICp26wHn+C9wpox3OGkgM6tzu7Tww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917262;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=BAX35U8nNHwzvrvZe/2+mPjA18tDD45pOn0BmV7GNC0=;
	b=5MeDdWeuCa2RA7NSVzzPU6QjnSgC1Sf1rIHv9YdzwvpTHk0D3xeVQ3Etg3RVKMVDY3B7
	 iTe7fKvaDo3oFhWGEUty/dy6gC/H0wtqLJuHmagAFQYyJlniBVLBO5d2jdsTOawsdkTKz
	 TDVT3y6oji5FmKirpbJAZmXj3SpabCyzVB5DS3/n19koQmgCxW/mEEmo7vl8S+EST6PYt
	 XqEnWqLwoqltjXimc3y46+RlJiimuTK1HvRXaSTH7kydllS9yvDgNBdsommXFRBOa6dGX
	 VbRLW2oFQC80Ee/Zd0CyQQ+RD/SSr/oW+s+X7LtB5n4c7CCqdhmT3gUIfTV01faaeyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e+KzCRPw;
	arc=none smtp.remote-ip=74.125.229.135
Received: from mail-dl2-f7.google.com (mail-dl2-f7.google.com [74.125.229.135])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23963606A33E
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 22:21:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23963606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e+KzCRPw
Received: by mail-dl2-f7.google.com with SMTP id a92af1059eb24-139b659a45eso19641c88.1
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 14:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793917261; x=1794522061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BAX35U8nNHwzvrvZe/2+mPjA18tDD45pOn0BmV7GNC0=;
        b=e+KzCRPwGRMk1BKNG+tsQfz+EP0W1rS4Z26bw7m+52ZDtQj2tRPd8kF2bk/cIbpAng
         oGqnOFDZLoU/JqjgFICwTFI1ou/Nv3AnHlnTGRyo8K7mbaGg9wvwossPFQhXfa6VqkZG
         8UlgrnKuX+60euKUPpM1cQwbJLyxunEH1kaU6zYvGzoKEGDA6PTH/YT2PGCENTQkLofL
         OBryTBIZs6DNLJSHweKDiqBC+plTqFqp2ifPBhB6qvV7AQdDT9oB2lBU9Z2XDQouFnAM
         3YZYRzJTaJWSxCbyV0BBHUU02ueo+SWcZesSKmd1c94t74F6KEoYeVRccSoDXKRF3F45
         lnlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793917261; x=1794522061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BAX35U8nNHwzvrvZe/2+mPjA18tDD45pOn0BmV7GNC0=;
        b=soh+jN/aOfya0LikbCyFwrrK4pDPr51+QryHAd31Oq5In/L5jYoLPeaFY0oRoH7wLE
         rHZZDz9SnPIxfxIzr152rm7rrrwWbFnlu900GtGApFG4pwNKmvTvrKH3krCWWTSnNGT4
         6ME1eZs/sP74geEYgN2ycvoVrzMq6lbne2NiEDWnCUvg0oimbMp8cHEZgdXt2Fu2TKIe
         AcZpt2HqJi/31ur+1nD6jBm8NJSEaFEZZntd2/5xrwuNUjzzHG6kpJ68uXJWDjMhmwTO
         IfcguLM2MMTGtCUrd/xQ5fZtYG/6gTVpkFkhI2bmLrXJDXxPqn7JzW/jjjhelglm6EmV
         wr+w==
X-Forwarded-Encrypted: i=1; AKwUvBwyuTpFW/jO8QuFh6pSXTuNaeobvWa88XMKvOM0jQsSGcfGBrPX4Zgi/Etf72oYNYP9Uf7OJ1QTctm3@vger.kernel.org
X-Gm-Message-State: APuU4Z8dEHgrKHhnTMcMvCMpU1KzW2fzP0aqmyfjyjWYpPs8Kp0qzH9W
	TUNRULRLUwlQEGlifUQvjQH2tbKoNwC7X5y8ox7XI588kAfsAR2emV0n
X-Gm-Gg: AYBFou1Caug77obZ+761bvL5AbgxLa+zaWqO9XpkF0p2kZRN4eoYqtxDmdM+mreJSje
	rltRzlY+e34igkW1KVWLMz5gK0zcPUpUcPMa8SwIm5/qGsOF+yhHDJlk7vZmA5HjqJHf+OgwXL7
	n+lEQQ65dTqh2QBIyliwXfS3zNF0bDK0lIqGlDmVNAS5eV685LfLefopL0YaA6A4a9Br81jfpIh
	4x1++7lo2hueTVlhXnZza2uGYq2juc92UzGHIN/003Q6E1HsXIgWmIHGHSMMI5urySiP4O+eqk1
	NgOvDV1OW4YydqfvjAp1NdOLlUV3AzLIHlrfV495Gjp2dUb0oEUxTMFxDT46UDg58vq8qf+Ltgy
	alwtFv91sozKiodsro4NRgcrjdDy7ZKforsJFRENQWVQPv0VmXcnizWpa0U9aFdwCPVrc8wZU9R
	eyu1JlA9jNddYywOnn1nTDxpdDRjVL+HQyvwYgsCPd4Vk//yh/xLlGslQY9HlLXicR8OGfIygMw
	Eck6x2jIUx2gvyO+DROl4lugSm+zA+s6RD29Njb7EZQo9DtJUQ9Uo/Lyq0hMnZUvvprLh5zbdNq
	VwsOaSYR6wgorttjuIkjRTt5uUSfoxOVq78P74UVPwOO
X-Received: by 2002:a05:701b:4346:b0:18d:9eec:e0be with SMTP id a92af1059eb24-1b25d286bafmr512275c88.2.1793917261068;
        Thu, 05 Nov 2026 14:21:01 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:68::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245b86fbesm20396895c88.1.2026.11.05.14.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:21:00 -0800 (PST)
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
Subject: [PATCH net-next v3 1/9] bnxt_en: let the stack segment GSO skbs with too many frags
Date: Thu,  5 Nov 2026 14:20:50 -0800
Message-ID: <20261105222058.944293-2-sdf@fomichev.me>
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

With MAX_SKB_FRAGS > TX_MAX_FRAGS, the xmit path linearizes skbs with
more frags than a packet can have BDs. For GSO skbs, linearizing needs a
large allocation, can produce a head which doesn't fit in a BD with BIG
TCP, and always fails for unreadable skbs. Clear the GSO features of
such skbs in ndo_features_check instead, so that the stack segments
them. Non-GSO skbs are still linearized.

Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/all/CANn89i+ps_CozfOyRnKav0_LUmSekJ9ExB5JkDbTAVf_ss_98g@mail.gmail.com/
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 757c7266ce15..e7a4190a8c78 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -14300,6 +14300,11 @@ static netdev_features_t bnxt_features_check(struct sk_buff *skb,
 				skb_shinfo(skb)->gso_size))
 		features &= ~NETIF_F_GSO_MASK;
 
+#if (MAX_SKB_FRAGS > TX_MAX_FRAGS)
+	if (skb_shinfo(skb)->nr_frags > TX_MAX_FRAGS)
+		features &= ~NETIF_F_GSO_MASK;
+#endif
+
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
 		if (!skb->encapsulation)
-- 
2.53.0-Meta

