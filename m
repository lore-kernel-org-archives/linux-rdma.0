Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794953838;
	b=plkh2fjWyEdzAQ8cRlHsDsoLIBBzbzIwXqtk1fz981lci2ms0bRf+y+HsVmOWDic4y5j
	 0TrelLiqmneF/JgZ9J8hNkTePc97pNCLOgcJaZUbEaoAiZj4u/2HKwA8qyTuAkVW9ecoh
	 GDODyCR0LbbZoT37nBI0kMvHAS5kl5NC7dXLkqwjF92qG7jN7ZwHFUwVBItO+0gxy5F+t
	 Mk6JELujrKCRByQ+VsRT07PhaPogO8WU4xuAswu+H93SNc2MMkR8xCrg6OmSTAy1IIiqr
	 S/hvGkm5KSVY/aqJ1OdRGVlSUZr6sHaJFAsLNkXe+gM71q2QGWfFi4N5rxzkrT3WrMw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794953838;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=naIMYO16Tb2J0b8QTmQ8uSWyAJ0zbIqQUrNZeGUwwtw=;
	b=xRs8DQLuwjle/Z0EG+/dOnxplOdxkZKm6AadnzaOZX4MvDALnE//MbzwUhuvBi+45jtT
	 CVuLG8BrYpHXjuw0xrFNELt1aRNM1t1zpAELDnLqzJOwIkZ6B8nJG7eUjCzLimEpMCbYO
	 Nax/u/6mlNBPBRmX6VXYrMQ9viIu9HA0/0aM1q0bwEZKi+OC9lOaeYorD0mN/Iz8L/Va1
	 mVNwTOqJ7B2dCYmH18pQ/Rh25JC0gif6f6W65Wgi/x1X7ppky7pVN+G+r/PMZb7jzhtjY
	 Ct3D3Ma3nrq54Kwx3YfU4dWL9Ifi/RFwDV0jGn2hXKqeFc3UPUPTb3qtUcacx99SVMQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=EvkMrAlm;
	arc=fail smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46741606A337
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 22:17:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46741606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=EvkMrAlm
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AHM1tYD104850
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:17:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=naIMYO16Tb2
	J0b8QTmQ8uSWyAJ0zbIqQUrNZeGUwwtw=; b=EvkMrAlmrDK8ub69Xg7pAjpcfhg
	bZmfLUAoEXVsHI582DX2XvH/l6wGABdG9omOSqhVscA/IEoGuPA0CuKpLQIwkQrd
	hBEyFCYOGEXtjyA8x3b0g3YTHTx/sHwE+cQmDTvaKvteMtyAtX6dmBfQkCozkLZf
	p22cxMmQsz7yD32uSvOi3HsnxIikFWp62dCypEtCz6SeWEqW8jjr10TkF5/Z4PeJ
	/8L+8tNnAtQ73AhwuAwiHeC+vacHLSuhs6/KyihzjSuZu88a3UB0O+P7RJ2pM+Pq
	VMyvbB/nLDYMAxlh+5ivYxFI1VuB1MRuJ0Byb/cV3VEMNBGlBCxo+Gavfxw==
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	by m0089730.ppops.net (PPS) with ESMTPS id 4j0p7y686h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:17:17 -0800 (PST)
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4a68703d177so61077f8f.2
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:17:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794953836; cv=none;
        d=google.com; s=arc-20260327;
        b=Xt1cu/H9/8fgX/tDEK7e71spbbeGm7Eb076T52E4OrqHVny/UybIf+iKVrpI5InS1t
         CBTd3zyhC9ZDTY3YakWUfzS4rSDNgEcyUZ952CGeccH2t5+Dqo2dpM/P0ng7Oh9Av1M0
         ddLzExN+EecDpBTzpJipIjivhQ9JPqa4iWokFtR7UfhyyWKhmzKAbnBMs6UwX1FMlnJF
         ypf3wCLC4DLkjxgP2LJ1l+R/RN9GF+53uTYGRezhBoG3R4q27jJWIzSuIWsh854QVpqw
         ViKVakKhfqr+4zzXpj2D/telqoY12HdgfGu1b55n+cxC6IwLhD4F+2OJrSGsztQeScxS
         UiWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=naIMYO16Tb2J0b8QTmQ8uSWyAJ0zbIqQUrNZeGUwwtw=;
        fh=pi//1imfeTnoJiDzqdI4cxbO/6+5GLhnUFM7pA8Sr1I=;
        b=Mzq0SRR9IpbrKWBTFyR02gcwVZ4AfVUL489dbiqKT9HK2y1dayK3IqBsyzQ8ei6cG9
         h0MZ3e0GJhMGmzcBq7VW5uVLIA6O2LE+2tz/yIhCmcMk561pe3jicopwJ28/RqgNJGja
         dG3OIfffgkjsligtKsKGHs54Rq8ITKfBFCfnsGDLe3JHxB1hccLuUP8x1ZwvprzH3VNw
         WjmXJdpASjgJVS5dfybS1R3op8NRzJhyow8UitXXbBAKYLow+Og7o3KteHUjJW7WtBJg
         1SVCYoiFNQ0a6dFZBeM4yIfFHna/YTXNbG6eEqGzVuexgl5UPtdtXjaRFaxSfuQGJ2ME
         XjBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794953836; x=1795558636;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=naIMYO16Tb2J0b8QTmQ8uSWyAJ0zbIqQUrNZeGUwwtw=;
        b=e4A1z4NKeKSJpIaOF+lcpMtkrdU7DTM1kLJJimGUEnCVm20QHWvTaBkV2ySwl98zhP
         V3oAUkgoQjRPtor1tdXSe3EsFT5b5YFe9ZXndau+lR4CJiFJ5/CuWGROeJYvp6CMv8VX
         kOpC5lrNx6FVNSLvWy07uPPO/o9GKL3Uuy6jro5yhdR0TFxkss0axR7nSn5I/UtiA6Ip
         tG10B+MTHo9CMuS1GG/5PpS6nD4yZ2EKsfMDsJIOPrR0a+YomhzOFgOfhN006ZOJnsOU
         AFVdJJrCYY2yunqt44E9s1JkphtKFA5qp4U5WWmJX2T2dfe9DF9yzdT9VpqDKhyZMbx4
         +iKQ==
X-Forwarded-Encrypted: i=1; AL+hErFwZ9k2KSj4ERDtzlOa8bhcspadSdaNG/K8t6Qmv97XiBOqIuAGeSgBX9bKjXyh2AvGx/dBP6rG5/C8@vger.kernel.org
X-Gm-Message-State: APuU4Z8TkIiZqHhTAUaJ/o4IUKWbcfsMbpoiLMRz6hxzPOlWAffaNGg6
	594wt5Ma6PEndgf7XvgPW2f2XkEd4RS42InOlVyrQoayiRhBgudbR5LomnijsVf6QaL4k3oM6lK
	VFUIqHh+XEBOVR0j7Ofv4cI7UoTH041QPqcyp4iUK067NiOctDDUAPV/mnvplhK8yUZqGRWV0Np
	Xz4L+Vk9TLIAQ0R3Y0rJbgXnhiL7iIG5IFixvE
X-Gm-Gg: AZFdTZd0oXtHzAEQDSZ76dJrDcYYt2IM9AKMz4IzANp7RMP6Yaq5bfAeIWGmHcP9Rx8
	Zi6HtAc8BluSSWdUZX0LNe3MIXFfzSGeOA8iYyW24OgOzCr39nNX25rszwC+beGP1FTEKnFO+0B
	I+kfS6vlvNgadGe7DA3KxMuhi5/Uuz0OfYIcPFet5EjcBNCu9vxnyR481zsL5BYwAh9jWD5VXBK
	ebUH1WVmoEvIebFNfKnj0QKBmKVhj12zhkB7908vmrPgWeNNpQ=
X-Received: by 2002:a05:6000:603:b0:48e:5eac:7e48 with SMTP id ffacd0b85a97d-4a63d2cf7f1mr1645594f8f.22.1794953836018;
        Tue, 17 Nov 2026 14:17:16 -0800 (PST)
X-Received: by 2002:a05:6000:603:b0:48e:5eac:7e48 with SMTP id
 ffacd0b85a97d-4a63d2cf7f1mr1645531f8f.22.1794953835465; Tue, 17 Nov 2026
 14:17:15 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-3-toddfreed@meta.com> <179471269307.2199510.1215468778950936295@kernel.org>
In-Reply-To: <179471269307.2199510.1215468778950936295@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Tue, 17 Nov 2026 14:17:02 -0800
X-Gm-Features: Aa3M54r5Hu3045uljd3xO655IC2ADA2xeFtOm9g-Da5bBZKD676NvfeHASL2RN4
Message-ID: <CADh2yMznmWWJsh4ArEhrm2n9fG8i7o3u-kjLrvs_dwsBPiFvtw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 02/15] psp: take the psp nexthdr from the
 packet on encap
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
        bjorn@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        daniel.zahka@gmail.com, donald.hunter@gmail.com, edumazet@kernel.org,
        kuba@kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        john.fastabend@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-rdma@vger.kernel.org, martin.lau@linux.dev, pabeni@redhat.com,
        saeedm@nvidia.com, horms@kernel.org, tariqt@nvidia.com,
        weiwan@google.com, willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA4OCBTYWx0ZWRfX0xeUPNIczJQG
 wdwi9Z5fvT0D40DhfbQoiGDBuHuLSnHGbcS1l05oykHljeU8wRoncAeZHjypQcWfgM8doSFf19r
 aDCWg3NCkkK7OX7/6UVp/DRnQiSDRUUMDOq4UlBi9UfjiWx53vjngiY8RDC6xU0z8NIoLrToAr5
 bmpPjK4m6dcag7KPhOh72zKOX6TOez34K34SRwjZyFqEb5wd2eiin7eFUuhemYIFtRelm1dPjzR
 7xIMdi8vU5fY4NVxT3DZM4WrwswXmoVEqpyHTew7UuWm1WADKqTrXQyZLefsfTAo+RG/Tr3o3rD
 dN4UfdqqsFLpCNZ8zntOm0OTIyEHudjKYTiHHjszzmBinP8dm0HpMzTNT3Z51OlgFTIYNPTCHWp
 Ku/REfppOiVdN041udUQ0R2sn3MsdLiqhQ3osGsX4XB023ci8vNleEMUNb6dmhIlLYV5r62e0Cw
 CmZGwktVxKj9EcTKvIQ==
X-Authority-Analysis: v=2.4 cv=bJyDs/+Z c=1 sm=1 tr=0 ts=6afcd26d cx=c_pps
 a=CsXZvLRfiTx/ye2xXAwb9g==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=855S8uPTkML1Oy45N9_h:22
 a=-eSvoOO0VIkvbIxHXOgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: mc64OLzmP2zAUgnb4JMjkgAr03gFyLNU
X-Proofpoint-ORIG-GUID: mc64OLzmP2zAUgnb4JMjkgAr03gFyLNU
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA4OCBTYWx0ZWRfX1kMNvQIgi9/k
 axpsZJ6Riw7mvyxt0PS4uYMH29QE1OVhen48RDg0wd4uBdSpd2vKiBRGicgHd2r/HpkC3qBzuVE
 2U7Tq4Fu+Uia0VAsfGPr0FAlFuMF4g4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_04,2026-11-16_01,2025-10-01_01

> [Severity: Medium]
>
> psp_dev_encapsulate() now accepts non-TCP packets. Is the outer UDP
> source port selection in psp_write_headers() still correct when skb->sk
> is a UDP socket?
>
> ...
>
> Should the sk->sk_hash path be limited to TCP sockets, with other sockets
> falling back to udp_flow_src_port()?

Yep. v2 will only use sk_hash for TCP.

pw-bot: cr

-Todd
