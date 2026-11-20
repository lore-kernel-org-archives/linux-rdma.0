Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795195464;
	b=UoM/e+kUYHpyY6sYXheZbVD4fYgCWDjGf4u1OzcYSs4sQ2/emDbIm3Kr3Bm7Z2SeHG6x
	 ixNV+csy0aU8TEYfYR2xVEfmqeBXeM0lB6PCSUomlYLtSjawMM7NKd8AfiHHmWjK3dxJs
	 oSlo64KNWNg3IpNLI1MToL7RbIfbUJKnDukrAlNEahbF+wZ3c3AJ8D5wPj2EvzccorC7y
	 nXgp2ON7KYCcycwfIMPkVpWPplVfSI/JsKgVg2VMBCTA9DxjGNL9A1y1lpPa20kxpDMzy
	 1uOkVVaxJPRbKsi/Y/VsINITrpIZk/ICN8eDGqRxdfj+ahKJ4VwGePI9w7JNwK3b1ng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195464;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version;
	bh=6NFMKm4Yb/EeljsK3MyT7gHKFnJ9GueDkr4QoDZuyMs=;
	b=xd75AMeXQHfvfLUR8Cxwi+HMisrnd2nMv88AMVdc1ridfmm1fRahgTKJagQ2YDgZ4rVS
	 PeewIcfLxVroTMbux8afTNa/I/FJ41/95LV1hdsKJsMaW64qpHAgWVxwk07gZo7cF6qGL
	 LPJp4SKQJi15nDxBEONwoaeXfeaUKYb7BxfPu81eQ8iAOC5HCT+dL5LhJepAzrLF6Du3Y
	 fpcQhnwbB6XYv1arXbzVEV+WcOZy3y5WIMnXPSvbxWzu/S8kNfra0uxXiwKQj+RWB8ORc
	 1wh0+Q0tenZLOkWu9eOEliC//u0cbG90HO3R/6fP47IAA20SohzjoE+SCHvj/g3l9bQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=TGOhdYA6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B71606A337
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 17:24:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0B71606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=TGOhdYA6
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKH9e5O1581165
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 09:24:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=6NFMKm4Yb/E
	eljsK3MyT7gHKFnJ9GueDkr4QoDZuyMs=; b=TGOhdYA62fn8n4BD/9TP8WBEWve
	Sx+7gr7K0vuT+XGt3vpcITfLWxgoo58oy8cN1z+8aR46XRmYfffQpZ2AYmqv3vjD
	C7SvuJq3M1zfcHJaNzAIFd2mHkqH6xyQ323zJqoyig76G8cGJ/i0Y0cVgH0WIQSv
	s4jvumLFpB0GpZssk/o9KEBlfPl69e9MwfrCIMZlJHJYXs/ic2VSNiUBFoA1HiqZ
	2zDPa+JTtOne0YMwq9R/9LPf/9Fjfq1YCWl5xAoy5teWK0rjcA9kjbQNJW0HdTWJ
	TqxnEPGOFIMwTH7MnMlN+k366/mTOhzRqaSGB+bhPHlg1EpyBGMRyNvUyEg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j2tc2r52g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 09:24:23 -0800 (PST)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b3fc6a0083so1297067a91.0
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 09:24:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795195462; cv=none;
        d=google.com; s=arc-20260327;
        b=LePeUoB7vMj++EGX4MyN4pLGeMxMc0ejdHr87ZXfiM0KHjMyz6pneiRIlC9ihDpN1Y
         T2Zo9D3zz5Z3rPTGKCi6e1GmJCFzsklvY08ZEcSmuzKW+3xpkuW1rd6aBDJOsBqEuVpA
         k3HTipAZeYOPmeUlRh0wJWNMEHMF/jPH1huct+o67ni58HA+4t5ki42SDBJswfoRiTFt
         V3Tg1Z02cYtjYTnQxkvyUhB+zC0GDCqj5hPE8ME5YCsdqz4k5eTjLINEG8qufThAt6XO
         RjwSzbgCSbgM+A8FQjUXLuax3HiUbHxs5gOjEePz+wspMCaNOWyBBqTYIENDMBVv+ve7
         doGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=6NFMKm4Yb/EeljsK3MyT7gHKFnJ9GueDkr4QoDZuyMs=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=PnPFxrmpfJaMXgPoWR2nWwn2yj0UBzuUEt00kcmNkPQamynhzieo1HB+2AuzVbI/GU
         masrk5XN4eka/ATMx/zs6vK5syllUeCpJ4McbgRbQ+VqLIHPi30460GBE1Afqu02ZdgO
         P9QD978i7gpF8RlHbc7AEXxOLAPTFg4dsJN9ebZGDZx8zx+hQPJyQCsTuw4c4iq2JCoI
         toKFcWULyIip0E+3ZUA0BgveoRTn00HXY0YFjTfT9KhqAVQ/MkiYWFS/pFUtF7vH61Uq
         dO45cTnCGV304kOB+VnO9aGqvhJgeKJIvKITvadwUzGbJ88ViLX0S+9zigg+P69++0U9
         WI0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795195462; x=1795800262;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6NFMKm4Yb/EeljsK3MyT7gHKFnJ9GueDkr4QoDZuyMs=;
        b=VfzrzlpnJLtSNZrNBdc0pdOFQK3qV4u6xplT1VzYXzjI8Q/awQrlg2BrqbSdRXhobb
         z27mmgCjEgkBXmV1W727KfCmwt/CAAWlFd5jp9Rxx67NHB7nFy5GoEXdSQ6gA6vjZs6h
         /V1MNL0ywqv4luTEbzqW9Chmypt70FNJdt5z71cOdvNxAA+hpsUGyTKqq4p8G1GWaRzF
         asHlrwq6mE2tLthSN7CmzLCqhezuki6U2oOw0XE/LJuunodiRI+VWGghwHZkiDgrXKP9
         EEwaIvACaosqY/OKf6ZveAfPfxGrUZMRVVmHS4BNqn6rlGGlDghbmlB4j+t+wAL/LZ72
         ZRHQ==
X-Gm-Message-State: APuU4Z9sQg7eddbNANq/W4a+IlisLL7YxkXbJKD2qG6kr3/fF3N7p+EV
	yC6hlhyBCLt4bDXs3OmIY2U8zfS+J67ZQ+XATv1yUiDwya82GSPNP+wq68NNMQ8qXhJXI9Wpiec
	pufONRAQ3j920lcWDaj18yJ8XJoElXkve551u6X/bA40ZT6Ez3ybqx4Hz+CBetkQGskaqLIF7kv
	UnIDV/XecQakkLGd3ByfT8rl+kkNn2J0Ca23Dl3VmL210J0PE=
X-Gm-Gg: AZFdTZevfEKiPwy3yw3yab6kCRY+2ejbd8I7SFzb3oOK9ueq73uUpTOj2g+OL8xpCoh
	+l/IE8+7SHSkGYCuB7vom/x8qYRml11tXAd1v17Ypnc/KbfEVjc5T6SFpwZt1ASJtCAwrzU2B2G
	Gw+4Xeq0zVjfX0xFxILhC4zXd7e4bZyMrSPl4kB6A3qt0YJuZjLdwA3YL60phKjsaeHFNNDoK0N
	okanSHXdiZ4d3RFtfcB4HUzgSsKvrD3
X-Received: by 2002:a17:90b:224e:b0:3b4:22d:e066 with SMTP id 98e67ed59e1d1-3b41c7d6061mr3466645a91.5.1795195462130;
        Fri, 20 Nov 2026 09:24:22 -0800 (PST)
X-Received: by 2002:a17:90b:224e:b0:3b4:22d:e066 with SMTP id
 98e67ed59e1d1-3b41c7d6061mr3466626a91.5.1795195461659; Fri, 20 Nov 2026
 09:24:21 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119013103.1092559-1-toddfreed@meta.com> <20261119013103.1092559-6-toddfreed@meta.com>
 <sashiko-outbox-224312@kernel.org>
In-Reply-To: <sashiko-outbox-224312@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Fri, 20 Nov 2026 09:24:10 -0800
X-Gm-Features: AclHuK8M1lhzRbuuHmkqHDKPgh53wz_ndGWByADosNoypzx4IbYIadsZhadwjq8
Message-ID: <CADh2yMz9qKhfin-6R398WTGH6Xi5r-9r12TGf+HO2jsasVkqKQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 05/12] net: add METADATA_PSP dst to carry a
 psp association on an skb
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Authority-Analysis: v=2.4 cv=L8aI0OT8 c=1 sm=1 tr=0 ts=6b008247 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_1IyUuN4QrATX339ibzo:22
 a=7a1JM2k2UpYnRVFoQv4A:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA2OSBTYWx0ZWRfX2TgAPBvJLwnH
 xAGxGx+zgUT3wcXCBmdbi4JP4+rQqgAK3x3cpWhiU5b1Ubsl1l+MScrINzOXHscB9RJiJ81mqZZ
 YROtE2llYV1Qu57EasAMEfAdt2NJ2KwtZWTM82n7NPGQQF0piDsEfNVZSgDo42wJvoV8ahMDdhF
 6Aqi7pL9PkVrjTyoH576bxbCqYzQXcl7XRhnf1W244qseoSmUDGm5Pe9VugeWn4JuFeIGvLB17a
 ZXWU2L4SV/OeQ/JW1Ij1lYMhy82fHmogGKfhOHAOytMmgA6n6m0gYmnCxs3iVEhrZOG7B2TWCwQ
 eETl+sKczw16LYiGPzW2zE30wCmDYmyE4X1kozclxKo/DWA2rLJcsoNrIqYhAnq6VDI0jN5CS5y
 1lWjAGF+1ljmExxII7tjvJbeFYveh3fIJXC+baRr4/eOMjp9jmbL5ktaPviW6fi6fHbcEuEHN5s
 BALZOJ4vPty8b/OIDrw==
X-Proofpoint-ORIG-GUID: mIj1KdfU9IFTEJQ9e_MpeFAD-L6hX5FR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA2OSBTYWx0ZWRfXwfLRWvbcGz5q
 Nky7at8kXufsipwKKJr/rFA7ZxYgSfEDuMf+Rk4STl7sJ8EOeYJPA399oGAwpxR0DTeR/ZS3ZUu
 iPwctRv8cG/8LJgLGjHm3q1rRFwOKLE=
X-Proofpoint-GUID: mIj1KdfU9IFTEJQ9e_MpeFAD-L6hX5FR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01

> [Severity: High]
> Does sk_validate_xmit_skb() drop all METADATA_PSP packets sent by a
> TCP_TIME_WAIT socket when CONFIG_INET_PSP is enabled?
>
> When any TCP socket enters TCP_TIME_WAIT, inet_twsk_alloc() calls
> psp_twsk_init(), which unconditionally sets tw->tw_validate_xmit_skb even
> when the socket has no PSP association:

Since posting, this has been fixed upstream,

  82290fab668c (psp: only give time-wait sockets of PSP connections a validator)

-Todd
