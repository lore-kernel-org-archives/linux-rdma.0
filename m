Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.229.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793917275;
	b=WG4I9o/op1lj84vf8RDbxkJaCfs3UsVnSNHe+Rt+Q//FAybl3MldfLQLxeyaywngIXWV
	 H2rAQmiI3vJvLxm5I+gB0I8816uVHzqybVlxjEpmUoODUaH+BlSgUPhc+gkmJl4Sz8t6m
	 nVFeQCTp/eds7ASavLykJqnvNkVurm2YkCjLzcr/5fDlBR3SoQdVakXOzoN1Zik+hlRFw
	 spOWT/+tlpeyLkAyoAKoa89H4sjsPMMXXSeN74pPOoa/u1yneHOVsEIVOjsZDXzOUqbqZ
	 wnTSeNKcP5pQapmA6aDQUpzRXR9n61KGhhi5mUqa30UvcHjqyFa3aFq903C//8VqMMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793917275;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ppas129PwuUiw2Xw8Lcjz7A3XE0ezJjL976wMeb8fos=;
	b=NjU8tB1XtxMycI+BRgGVY4ddulU1/oTsoOMD5gJhx8HT85aAMNTDjG44a2P6kAznPh70
	 qE/Bb7bj/JsDz9oA6gr0MJQqiK665O/tq8zkwYZn0zE0N6Ak4Z94HlESuseJS49GagNsF
	 uI/L1kGMyV00migRkdnd/iNtskktkrjbFzIyo3GCeM3WeXOefvEgE9Kjt4TgiWWeOBOoc
	 6CmrxJJPnYY74Hg6BUlvJ13JhvZ+TWaor+G+JDXpCdYPyc7I7CWbfuv2yLravG+mTo8GI
	 BH/lVopoBIKqvjN5tdBvOOObv70CPxvmJ9rS7tXJ8Svu7ohau+NMNwp8RrJPhYzKfaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ei07+fDw;
	arc=none smtp.remote-ip=74.125.229.8
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E29E606D81E
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 22:21:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E29E606D81E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ei07+fDw
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a6ce64b95so619eec.1
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 14:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793917262; x=1794522062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ppas129PwuUiw2Xw8Lcjz7A3XE0ezJjL976wMeb8fos=;
        b=ei07+fDwVksjzCrwDH10oAlXvu/ahqITqWe8qoe1bC7FXoipcduGF83vODfy+8RG4b
         DbJWVQXwdB8brnziFnLnjzrcg9QWK4kPPYyKAZ55quymum6L0ksay1Ps7FWvjzzcqX6y
         iPpt9MF0fN3iMWibQtwcW8leLr/v9+sxjVep6so4TwLRDz/waR4liSB62fLaVAULBsxB
         vBS2pJJ88SsioL4u5X+jvRzJJaX6RUJXayEyJt6FRrYKh+tUjeZ/AoxNcxveEWC7KdWS
         xoK/Oz1eVOUEi5dzMcZ/k51F48eIQEgec2XnG++AmLK0zNN6LcPEuHcRO877EwUyaikp
         Z71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793917262; x=1794522062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ppas129PwuUiw2Xw8Lcjz7A3XE0ezJjL976wMeb8fos=;
        b=Fk83SU2Ceg4OlG7DDabvXFPq1WcwWsJ/CLBZ2qXSzXPPTi8sYf5TrDQHgJCuGp+Y8m
         uvLOoRwKjZeX40wmb0sbKGczD3XO6yfh+ThKqYUb5jhpqLMeiOqND0eWacz5JEXxsJpD
         K4pPVSBwKkscdg3yZdGKR4sz3HlAINhgk+TVSHuxKLaVdrIOI/vuRNpjWI/fB40WtfUo
         zptdVM3zkhJwwL+Yf1CClDSI/6Qr4ibrQ1utlvENx24Av8w5zzRiwI9b2/cuMIabnAQH
         zFHWGMEl7cigTYxSRLKgvexEfzOSS40fF1lbchfWcFha6WkB/KIOmKTXL27yJpX38QUg
         fKdA==
X-Forwarded-Encrypted: i=1; AKwUvBzBk2b11lHBUdZ+ow95SosJD6PA2wLUGSCHnGNJdUT6OmfEJx2GN2BiFqeLTpgZ5nucYyDoVflHYY+M@vger.kernel.org
X-Gm-Message-State: APuU4Z8WOr7bmEbU6/5agQ2umasgTX8ggC3o2nQGGpSQsFDbrmRsOiwz
	MNOWDxPLcpgdRQ/tZo6FoEFERw40X7ETCb9sJLrbzvv+iGggbBtnNbw7
X-Gm-Gg: AYBFou0oETiCIVkH8cD3s8Hhmq+X+yLE4kVA208ZDKIB6QJhey+8Ix/XlCEJI/G3TJr
	OhlpZo6j31qb9UocsKaeZ74mwzyAhD0+U4RejpF34K9RbMj8gVNMZs6THBnxnRjwR8WRBwsgUG6
	K/x2f+dkFqyB67ei5ajWf1qV0xQblQWP44xSzIfFTkXFczllVChmUPPPvtrOEaY1bBTIr57sdkQ
	envLYvhV6ClXFMtk2YjYiniXmNMWGc+aBqzCNgkSlu7bzj3ireHwai74XRsN8S7aoDf+34+qdQl
	QyU/KHLrvgQDCfh64VOKZBWwe2lHqFRkjepQ9Kjulst6cZipPUxs17MY9RqWmT6NvKTbc2UirC1
	A1heMA3cgYPDqQrsUlQ5GKEc26gxq/9XMIDoIbdKPq8a3UNppvLdNmQJ1BQYHzKoamyGNda624o
	biGCq9L3vQ6Qgte+XgqgKP1D9lBaEuaQIi+RDUI/mFIAZJ5qvvibUy7EUB6KvZ1yLWu0uxbN7LY
	rPfcaCXs52R+nRMdsLb/cn/9ksNV912Yn6sNnaGsQEPN7D0qfxkVrp8dQMnbJGISfFKMO8KoBCg
	I29+uHNy0dfnHxi4G2QZP406O7JwaeQQpM6DMZ7Es8T9
X-Received: by 2002:a05:7301:1808:b0:36e:f2f2:37fa with SMTP id 5a478bee46e88-36f75443f3emr684024eec.8.1793917262361;
        Thu, 05 Nov 2026 14:21:02 -0800 (PST)
Received: from localhost ([2a03:2880:9ff:61::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa8e3a718sm39021eec.4.2026.11.05.14.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 14:21:01 -0800 (PST)
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
Subject: [PATCH net-next v3 2/9] net: devmem: charge the frag length to TX skb truesize
Date: Thu,  5 Nov 2026 14:20:51 -0800
Message-ID: <20261105222058.944293-3-sdf@fomichev.me>
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

Devmem TX charges each frag the net_iov size, PAGE_SIZE today:
zerocopy_fill_skb_from_devmem() adds PAGE_SIZE to skb->truesize per
frag and __zerocopy_sg_from_iter() charges it to sk_wmem_queued. TCP
uncharges in bytes as acked data is trimmed from the skb
(tcp_trim_head()) and uncharges the rest when the skb is freed. A frag
shorter than a page leaves the difference charged until then, which is
small with PAGE_SIZE net_iovs.

TX net_iovs are about to grow up to 2MB, while frags stay bounded by
the skb and many frags share a net_iov. Charging the net_iov size would
charge up to 2MB per frag: a 64KB skb with two frags would charge 4MB
and fill the default 4MB send buffer on its own.

Charge the frag length instead, which also matches what TCP uncharges.

Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
---
 net/core/datagram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index ecc30a6f8302..489d92fe6dae 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -737,7 +737,7 @@ zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
 
 		netmem_inc_ref(net_iov_to_netmem(niov));
 		skb_add_rx_frag_netmem(skb, i, net_iov_to_netmem(niov), off,
-				       size, PAGE_SIZE);
+				       size, size);
 		iov_iter_advance(from, size);
 		length -= size;
 		i++;
-- 
2.53.0-Meta

