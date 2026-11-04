Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793752770;
	b=q7Fdv9c2X/YmTMu7h28n3sojLYoYbdKyWxaMPe/5z4MZcp0cIyA13JuQ2+y7rZ3jDHUt
	 SvqzvBGSr1OOiSLFSQUFuZOlbOBrBBUJS0nLMkih38THZ3jnEAR0o+f0VDRfgsiXa2WN+
	 CRjD3E5MF0+AJFMkovCW2wpa8zn/hfTUAPwQEv3DW4WISIiHUE+WdwuwRSPyBDAseZho2
	 /+Jgye4XJWkbMjtLP37W5N8CO97fkyCr7yx3Kawz4obgoxismu0eq4IQn6e7y8qSQG1jU
	 oiGN7+neR/gtFL1o1tJSAciIOhSfqyHat2xDZLrMzBueViHmZBmci013sQT9BRgwS/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793752770;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Content-Type:Date:Message-Id:From:To:Cc:Subject:In-Reply-To:
	 References:Content-Transfer-Encoding:MIME-Version;
	bh=lQ2xOzxsF+CEtv2Z632brvuKrWBZQypDKsxmzWa1C5s=;
	b=pfTSSAeS/Eq4i3MoZSXh3ja1vugcupcrFKcSEUTW8MAKBhejPDNRR4/v4qkwVFVIW0+S
	 EPGGQcQP84Eghhre90QDXk77zl7R4mYGCUxVJHnavi/xi8vzXTHmf//6Tg1J8NIsvGfhl
	 aCzhx7UsV9lXdSaGtupqeKidGXs5Gu0Z+g7V4MnNEQq6UolNsTILI804ERrktVKSO04Kn
	 hjrNZLBd0W21m8nu8a7NpUY1tqgJCgOcKaOhMN+YEWzlUR3ub075pzJ/bx7HyHLVzkxVk
	 /zeO/Itx+mY7ZcZs9V5DixpzFqXK0XX/iRtFUSioFWgeGHBlrUBCYi5tBmLrefTvbBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hr+JzZTf;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACE9606A328
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 00:39:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1ACE9606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hr+JzZTf
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e8246b13cbso967525ad.2
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 16:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793752769; x=1794357569; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lQ2xOzxsF+CEtv2Z632brvuKrWBZQypDKsxmzWa1C5s=;
        b=hr+JzZTfML76aUBPRMSo/3TW8wG01zPPhuL/+lyor+y27KaG7K0wNq1h4XbItsLlae
         9aQFRKvZAF64WmcAU2FaEbMNIk3lag9vklnCV1nNbvazHFxJvS86TiagPTxFNZsiE0Xs
         vmuzGeSSudENZM5KFICQTPzdSCrbJ9JQ10LroE06YTO1PjeHV/Dey+drr3CWhXurH1oh
         /BkuNs0yz8eGrh5zbvxZUepb3LrXz0S3lsC414wKo84s+rmkO8uiO1APW2AtNOlMixgt
         ht6OtwB6e0WNLNDXQ1ZF55RHYIVaS/nYeFn69hB3sXqqBm+PAgLA4S4QokHq0OhiU7Ro
         6fUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793752769; x=1794357569;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lQ2xOzxsF+CEtv2Z632brvuKrWBZQypDKsxmzWa1C5s=;
        b=cTFas6JGkRcdy4kApLrkUYlMxWetGSS41OxJl1C7YOSSGeB2zMBKrXUROM3D2S7tPW
         iAYE0FR5sAte9zCCIaURR3qfm2VVHKSYTK4lgXD3wopvrpK/q4DBljTZuUT0dmF/b8qW
         BFWAdYZ42VzC2qVm7QnJLwbtZv5foTv9GaDsex/qx5bQQAaYl51r2U4PX+/LcmdeuMRg
         dfuLHU6zIaemPP9VyQRMiUSm+lVV2UcQg0SaNmdAFbJlGsrGQvV4TT2IpOe6GcdFmqWC
         TmYfWw41HSd0FjBFgVi8gLIrZZmwTZadVTfpxCc4eGdbZVWSV4gqQq3YjlmaYqtx8y7r
         AnyA==
X-Forwarded-Encrypted: i=1; AKwUvBzH79bmMLicDd6q57kvyqnclclib0vn84cmfQXGCjcBVSz52FnDW87XUb/9ioJrhCNKSBMHlr/QLNkH@vger.kernel.org
X-Gm-Message-State: APuU4Z+QcUYBaQxYzJ5kt6t2p+GjLJ2ZxOr1EtM3b4Eh9IbUm1CJz7F8
	Z9SUQ9Q5LPJbrGPzJz1gpkeBSu1EmxW3ipmYvB3bYPL/47xuOEUNr6w9
X-Gm-Gg: AYBFou2zX6MSxykvB4IVgGyZ1JQJK4Vb4OsETXZxuUVmItD9MZZJRZLGR/5WldDVl1f
	vJ7g9ec7xJ/Vvim/bQRhsIXTiJdk8VmKgUjab9Hj+DIaeXKpzH0WEwItfGMT47NfBw+7AzCkeZS
	1gWREHGFgHSuvDIIN/ugTMdrr+Ma10386gqWyiSC+dFenTlBArDQ3oeHfqPmr2Icn/zc5XwMAx8
	BU804+65k7WnvYRsMbgfDudH+jkobPbCF8FTEtrPZuYTLSr7PImzDThxw7L+zuaaXDkEyPNXyjo
	9v8IOrIQy4qkprbiNjRkziMWJkPDwiQOQUQmkBLnxG6+9+zfPha0bDxPJhb/RelHMf/8/wdiYW4
	KQLilhiTZgs9vVZEZ5YVnoaskuBzffSCa+gR+XT5YinzAj4J15PYbbSIZL2QfSfnUXMhS564FuE
	InLykyWbMbESIOV8MJkUNo0znGe38nAxujlnafKW6wNvA1U/ZNDNiIFrKoOu4PUwKXeAMOAdg42
	acj0V8pWkK6Ixi1R2JC+Va0yXobJTEvZoOo+awcI1KRhxlmvN245rg5nlDz6kykDAeLRipOUglx
	QZB16jTJgxifnTA5ih/v7AqEH404UWC/I6boVKbr7//oQmR0+57eVB4DW1Z+YEXd9F1LvRe4yUB
	BUpC82hwBUDszZtzW1HTkLY52HeaTGHCTQa3I0OEOmmURLwNdcggIAfM=
X-Received: by 2002:a17:903:2306:b0:2e9:628d:e9c1 with SMTP id d9443c01a7336-2eb364b0c7emr143562815ad.26.1793752769163;
        Tue, 03 Nov 2026 16:39:29 -0800 (PST)
Received: from localhost ([153.61.198.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed090f7313sm510055ad.45.2026.11.03.16.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 16:39:28 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Nov 2026 00:39:27 +0000
Message-Id: <DMM0ADCEGAAB.2RFNF1ZI5TGWK@gmail.com>
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Antonio Quartulli" <antonio@openvpn.net>, <netdev@vger.kernel.org>
Cc: <saeedm@nvidia.com>, <leon@kernel.org>, <tariqt@nvidia.com>,
 <mbloch@nvidia.com>, <dtatulea@nvidia.com>, <cratiu@nvidia.com>,
 <andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
 <kuba@kernel.org>, <pabeni@redhat.com>, <daniel@iogearbox.net>,
 <hawk@kernel.org>, <john.fastabend@gmail.com>, <sdf@fomichev.me>,
 <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Antonio Quartulli" <antonio@mandelbit.com>
Subject: Re: [PATCH net-next] net/mlx5e: Prefetch packets of upcoming CQEs
 in the linear MPWQE path
In-Reply-To: <20261103235823.536706-1-antonio@openvpn.net>
References: <20261103235823.536706-1-antonio@openvpn.net>
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, Nov 03, 2026 at 03:58 PM Antonio Quartulli <antonio@openvpn.net> wrote:
> While processing a CQE, look at the CQE MLX5E_RX_PREFETCH_DIST (4) entries
> ahead and, if it is completed, prefetch its packet headers, skb_shared_info
> and page. Also prefetch the CQE twice as far ahead.
>
> Looking ahead requires uncompressed CQEs, so this is enabled only for
> linear striding RQs without CQE compression.

can we prefetch 4 strides ahead without the CQE, like gve_rx() ?
In linear mode a packet takes one stride and HW fills the strides in order.
mlx5e_alloc_rx_mpwqe() allocates all pages of the WQE.
So mlx5e_skb_from_cqe_mpwrq_linear() can compute the address of the packet
4 strides ahead from head_offset and page_idx.

  per packet                 the patch     4 strides ahead
  -------------------------  ------------  ------------------
  CQE reads                  2             1
  dma_rmb()                  2             1
  mlx5e_get_mpw_info()       2             1
  headers, page              prefetch      prefetch
  skb_shared_info            prefetch      no, needs cqe_bcnt
  next CQEs                  prefetch      no
  first 4 strides of a WQE   prefetch      no
  stride is not filled yet   no prefetch   wasted prefetch
  CQE compression            not covered   covered

Then no need for MLX5E_RQ_STATE_PREFETCH_NEXT and mlx5_cqwq_get_cqe_ctr().

Something like this (not even compile tested):

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 22fea47..31d5bc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2094,6 +2094,29 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 	return skb;
 }

+#define MLX5E_RX_PREFETCH_DIST	4
+
+/* A packet takes one stride of a linear MPWQE. The address of the packet
+ * MLX5E_RX_PREFETCH_DIST strides ahead is known without its CQE.
+ */
+static void mlx5e_mpwrq_linear_prefetch(struct mlx5e_rq *rq,
+					struct mlx5e_mpw_info *wi,
+					u32 head_offset, u32 page_idx)
+{
+	struct mlx5e_frag_page *frag_page;
+
+	head_offset += MLX5E_RX_PREFETCH_DIST << rq->mpwqe.log_stride_sz;
+	page_idx += head_offset >> rq->mpwqe.page_shift;
+	if (page_idx >= rq->mpwqe.pages_per_wqe)
+		return;
+
+	head_offset &= BIT(rq->mpwqe.page_shift) - 1;
+	frag_page = &wi->alloc_units.frag_pages[page_idx];
+	prefetch(netmem_to_page(frag_page->netmem));
+	net_prefetch(netmem_address(frag_page->netmem) + head_offset +
+		     rq->buff.headroom);
+}
+
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 				struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
@@ -2114,6 +2137,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL;
 	}

+	mlx5e_mpwrq_linear_prefetch(rq, wi, head_offset, page_idx);
+
 	va             = netmem_address(frag_page->netmem) + head_offset;
 	data           = va + rx_headroom;
 	frag_size      = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);

> - With XDP, skb_shared_info is not prefetched. XDP_DROP rate, low-rate
>   traffic and multiple queues were not measured.

Pls add XDP_DROP and XDP_TX numbers.
