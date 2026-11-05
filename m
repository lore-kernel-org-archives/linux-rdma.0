Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793917265;
	b=U1vhNhijDY+FHq02mtrrsRTLkG/NCv/tVMG5WC/oiNdtC8/X/8nsVDpFIFgux9vLdj+A
	 d86miJkzajaGCG4JigseXEGuomLroQNdwFuf6KEzKA62mWIthZMtbLFqmupXr7lUc2CHN
	 0uEvAcp/2qrImERunBv+3ldVgUB5uKf0pDQ/+QE4laQ5iDJmka71rEbgNin0s6jIKOqFo
	 xu22t71iiRRH+WGL/WoY1uzpkl47UK5Oq7hyWxLo5Fz5czvbGhvmqgom23bSFOd1WHJs6
	 CbnjzJfv5OCGNORc9eTARC9ka2UcmpsAVW2cLj41IHNmx9RTgLmtRSxbUidnSQiGuPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917265;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=bZjDWOUD0tAJxtZMll1Q64xr0BqB/ZpzoZmoV9J+vc0=;
	b=GDQH4vZ+2SaeKAc7gSRxGzuFZwCzaQ+QyIxWJ745bu1s6m7BRpDbg7q3PeFZ186ih+w3
	 ZJqtOnXCRBQ+tZ0fqlSJwyGHPUWTM6jga0lK50P83Pnx0aXrx6EyNxUX3TI6rxbpHwE64
	 bjZxjWwTLIENjoKSF28RjxZOSTCf4tuxW4l0j9+vaLnjLFyw3lBMgvvn6mp7bPVV1ObTq
	 uF1iyZe9VzwScwxNnZl+WJONpjxky9nWT2N/7z8wrHNxZfU6UYCho3dY34fcjozGAzpWo
	 I43OvfxmlyndOi8GwhvNBxkS7U6HohFV47k3ZNryUfeMq9y4kKWiSKQH5OURquPExKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tTmCPrmV;
	arc=none smtp.remote-ip=74.125.229.7
Received: from mail-dy2-f7.google.com (mail-dy2-f7.google.com [74.125.229.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBC1606A33B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 22:21:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBBC1606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tTmCPrmV
Received: by mail-dy2-f7.google.com with SMTP id 5a478bee46e88-36c9b5c6faaso5868eec.0
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 14:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793917264; x=1794522064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bZjDWOUD0tAJxtZMll1Q64xr0BqB/ZpzoZmoV9J+vc0=;
        b=tTmCPrmVRUAllLERaiIgEGzgA/3GcfFM2ivaSUFN58HhzdGttxq7aMEdu5wFU88DN3
         BGADzbE+V/rwCP47nlsBPiPbimmbqXpsm0MTO8By3xg3KpXoEoJg/xdT0VlsAlDt1Qws
         XBiuk012JlHh4nvmFh9c91uBbDK3j/UegZ3ClICJVHL+CXJJZhjeWkC20o45Z6amYY7z
         nX+4m+6F9NRf2a/BOP4r7rY3hLk2InUAbIHtQrptWriCeAuG1hD3EmLPQ5n/AzeXrwZE
         86vRSdPo2JBAI0tzU8eJWVzWY5nCMyI+JmMTbfHCkbdmBgZJIqVl2SVZdWy0kwxDGHPq
         +gVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793917264; x=1794522064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bZjDWOUD0tAJxtZMll1Q64xr0BqB/ZpzoZmoV9J+vc0=;
        b=p6EbsUyyiQ7R6V9EWhKqVJLE5GSRxM0qLsC0cF++5kHYr/mocZMxzl4FQF2Das1Od7
         YRd6AJ64yqstITY6PQBDMfEKSNafKTGAHyQ/eaLruZSDtB3VzDF8WQxvKMX+DicrwMAK
         CvNsTTcaY/Iotf4O6MJpwtXySaswlKfGB+txNj8v2/X8nFnlmIrmJMcknJcdBxIFqUV1
         PgInepc2oX4TqYiLGMdY4S/BnXHM9pfGUvB/Wp5F+akIxRaUjSVKiBNjNw/oJEZ0sZzE
         HjlAVZVIsvkX0G0LB2nL8Z7oyeiWNJgs5041PMz2fLHtZtWm655eDvF5GPASul0zH6i4
         9h3g==
X-Forwarded-Encrypted: i=1; AKwUvBw70JY/hiu5GetsUimjHtIeS4325/tVM1nERJz0a56GZ62oBYedKOo3hfaISKprqHfqBJAiL4XRs4Sa@vger.kernel.org
X-Gm-Message-State: APuU4Z89qZrPp0ZT/0g6zpFKK5RVQObxcFqT3PczwJPjbksZIhegCSgt
	+4J6fUn3lSy4Dk6pwRCWKxCmxBpf9xVeTxUWv8ILtRq7Vy4Fqj2I4ykb
X-Gm-Gg: AYBFou1T1FIEIgHH1YQZthEVYwNYBz9kGZpz6nOwsfADXPF2D/jUbeG05HNOWaB18Q6
	7vI18wl7XZf3FDq7tFPwH3PJwmWa1BvFBJMK84ooEPr0hye7nNCQxHn0JnzBAkx51uT1oE870si
	jn3kbQPw9YXJJgpiV6QGPn+QrnMWA0W/PWP/EUZD+o55fWuPokeMF9GuOJFeupzuuzJA/+cHdzy
	ynu16S4dJqkZCUE2/G7/a7SreaOauQDVTKZFArRAopcP0/REkF0WUzfQARYb8infvK1rrMXKHJN
	mJh8AQKCZtEN6r4cmk5bFxNc5ABNp++Ko5RC9c6m3szaXIFcPCXDe1o/rlrJ+Hth6L3QUN7xrRk
	2bki6vw4TQcmvAU9YBz9DDrrQP5P7c8xXK8J7iNmf6UAXWzDCQ3d4mmEtPYb3kIf2r/pYtOe9VN
	ZOfc/HRBloFPr4MGFBdN3NlnQ5c3yrjtxuU7ii3K/HHFzHVPFSN8X/3zU8AoXPxIQ9JtqDvKSP1
	cfvpCoyUwScl+exnc05lSF2s0VqZU/AWcvqMM8v/YjkyKinoQMxMZCyHV4vqlvCRAJGfdNHhQcj
	jgCEKi6/UK74q7wWbhp02mc=
X-Received: by 2002:a05:7300:f586:b0:36e:2b8b:a09e with SMTP id 5a478bee46e88-36f76c1875amr631599eec.34.1793917263769;
        Thu, 05 Nov 2026 14:21:03 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:42::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa9aea414sm47741eec.16.2026.11.05.14.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:21:03 -0800 (PST)
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
Subject: [PATCH net-next v3 3/9] net: devmem: use niov_shift in net_devmem_get_niov_at()
Date: Thu,  5 Nov 2026 14:20:52 -0800
Message-ID: <20261105222058.944293-4-sdf@fomichev.me>
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

TX bindings use PAGE_SIZE net_iovs, and the TX lookup hard-codes it.
Derive the index and offset from binding->niov_shift instead, so TX
bindings can use larger net_iovs. No functional change, TX bindings are
still created with PAGE_SHIFT.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 net/core/devmem.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/devmem.c b/net/core/devmem.c
index 32fafbfa1359..6339f221bc82 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -455,13 +455,15 @@ struct net_iov *
 net_devmem_get_niov_at(struct net_devmem_dmabuf_binding *binding,
 		       size_t virt_addr, size_t *off, size_t *size)
 {
+	size_t niov_size = 1UL << binding->niov_shift;
+
 	if (virt_addr >= binding->dmabuf->size)
 		return NULL;
 
-	*off = virt_addr % PAGE_SIZE;
-	*size = PAGE_SIZE - *off;
+	*off = virt_addr & (niov_size - 1);
+	*size = niov_size - *off;
 
-	return binding->tx_vec[virt_addr / PAGE_SIZE];
+	return binding->tx_vec[virt_addr >> binding->niov_shift];
 }
 
 /*** "Dmabuf devmem memory provider" ***/
-- 
2.53.0-Meta

