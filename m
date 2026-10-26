Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793052356;
	b=zuqr0lN21PhUmpVWFtcZhp+wg+AQP2i3pwATX56g63w9MWKtnC4EBaiXWlHPXlUsoPju
	 PBo6TmpqvCkGrG9vLETmvByUJhkcPwHkL9CXDsMiCp1zFxjiewMd8WuRmxv2o+m8/5dCW
	 k/xKxY4ZG+u8vkUJXNax2BSx8tZarhaRju527BZP12ANFFd0+nf06IOe4us39k0b8l7vB
	 AWSx9AHU24uI5RUInb49cA7ia8tZ+iHDmiqru7YfVtWvSgWvu+gs+7jD3Y7duq3h8Asa7
	 ciR2D6JoU0DjUN7FC3GlK93h37/N9P3fE6brwztNHe5zfdVEYn+Voky6EQeDGIGC75w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793052356;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=z4nQTtfOhd8q9VhT0x4dUvhNJ9D8OtV16AyYym6/9DQ=;
	b=vQL34QHJg98jdXXFjRBnleJFm12nVbnqJ27KhumwXvl16sf1bYENbjS3TjZAsZ342HHZ
	 0pnvncY1DTXYxJ/dmSE+tXx3p7VP8CWD0nxUkvWaMIGIFJSgLkq+hyUvm394fQ0M4SHut
	 2HoLYYIuWnyo3DYZyM6xt/JlkzM+nfDCdQ+8dyLuj5r8FDR8Re9nfdtpNLPW0cWvWzkNs
	 cHinx9N5pRD7ms0CP26Yrd2c12vDpQLAwj9+faD4T3RDXUO89OMlE0u70oIbX+nWR4BWl
	 aWetmrym7otC0oW1h+T942eISLxexE2AACARBfFDjzb5VA7EAkK65eAyfl6UgGl+LiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=hlKqV8Du;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED57F606A31D
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 22:05:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED57F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=hlKqV8Du
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QImntf610045
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 15:05:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=z4nQTtfOhd8
	q9VhT0x4dUvhNJ9D8OtV16AyYym6/9DQ=; b=hlKqV8Dur4ZzUuKxTjP7YrMiIjt
	3ZsOzN/DdqCpY/o56SvMkVq3ZXuz+GA7bcM+/aPPz6SpoviGFTl/4hrkVTfjX05H
	0GT7EGWQj2EE0PEccBWYxiw+GhKrlLLc7J9afMut2vpHBX+bQM6qRxkTR5zRkbmX
	oSa5qK3hwZ9vkghNACrjtWY57rxM2wrBkf1P9KEau/9GkUYQ3XheuKXBd0gfttSu
	UqqqEN99t56wc+KwSZdPn/fNIq003oaGTjLV+M2+SjYPlgkNzqrgh9aTe+EnkyOZ
	1DqwCxNs9C1AFXQUxT8UomRIhtnGM9OfFoCNlDgfBKJ//xeeR05pvvDZU2A==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hgtg6n2k4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 15:05:54 -0700 (PDT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ea71803effso36275255ad.3
        for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 15:05:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793052354; cv=none;
        d=google.com; s=arc-20260327;
        b=rvgtNqdOBMhDZXTUbMQ1Y9Wuvp046q4uUZDKeObkzdXMpwHmJ7hJBFDY6nZMJ0dcWp
         2KdZrZNYE6axQnf1AC88u19BWjGgTVUTjmeqmytn+4Wfp4ual3dt/2aOqoqYO3RLo66y
         pPvFF47jKR4W/o0FYXauSV7V8AAp1Vp72ZVpwF0EtWylbR8kGiKSHXTfYU+aVVuae2F4
         3iixJZpTcrWMugUedhCCW00Rx7LHHaeY7FLak/RTnouOQX1BWLVM/IKBXFd5BBk8awC2
         VjeE69VhAEcaTd8kIesulBqUKP38jPWRqcajjNs8yL01jssrAh8L8v950C4ZOlSnVoys
         TxrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=z4nQTtfOhd8q9VhT0x4dUvhNJ9D8OtV16AyYym6/9DQ=;
        fh=3zv14n2TSiy7/VtrVhM5OdOeXQgVyBZ0XDwVdhPDjIw=;
        b=epfLZCSTlBSF7PgfzI9OcFdMNgCyBfUWMeacIS0i8QK/j+9rYYCvARam7PNcRujGAp
         2cnu5pbaExjLdYwY8ghv2O6GtMyvgq81EgSpPBWjqnNhtrT1DQOQyUta4NxIIHdp8ra6
         xqe3t6qPbD6jX5odqFf2da6M/AsCBmHCi7U85FdQhn4gewh5FqQKSXOUSvdWyG/romwR
         M3pD1Mr/YMkncC8+9HGtC+CT1F+gbv2CKVJ1aML7rbVeG8QAbBVbdOC5tzr/iH72mUQv
         XtckJ86lXUAPwLdQxGoBxeBz69aiImxv1Ms/htKd8DlqWjfWpOVjFA3hZprcPPAZVZ5s
         tqnw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052354; x=1793657154;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=z4nQTtfOhd8q9VhT0x4dUvhNJ9D8OtV16AyYym6/9DQ=;
        b=yZvkN/UcPYqPqMP0WU2NOmScbXrgmKVbVzb9nCisePCJFRBK7U9TLFf4/9szFYQNyc
         63b2NxBWdSNUe8jfcQBrUFMMPoDHXdy3xitLPRKc+I0ED/9HOgGw+/CfOHa0Gnx5wQUu
         X3TtSI2MAi0mqiVJyhXXyljv12x/JbiIG0NauikI2sm39WuG3JxRQD4JapCKTsRbGGi9
         n8Ho9xKswugW0IPODNxdWU3gGhhu1d+w3LI+43I+qdHPxHQamMs8zcv4vPUG7F/crhGA
         zjVTCFzO2KDY7928XvT6884a1n/cy1/rhY9GsLxNGAzCw1c9HdYf0WEPJAbU7L6koFqG
         8nEQ==
X-Forwarded-Encrypted: i=1; AKwUvBySWQs/SJrNCdkNrEqMOSLisyNMANSrODz+paBBWKztKsE+4aqDYu6efId9eZph6qo3CrgECN84LE3b@vger.kernel.org
X-Gm-Message-State: AFq9FYL/tJR5JX1uZhBCpeKSxItzeCvUmD6UASwekfE92GqzhD/ROisI
	44CigEHRzgAKe+PVTy18T2tn1Rc9pDq/g1HGx1WCpvyu8/3hF4OKr8KkZaX9u9ykgf5z49fP7xn
	euF3K4PGW3dpcfTtLQlqgXR0gl7nPQnqFCZCVvlYxfn+/Oo3IzulNhF+5dpmgNkHp90eUyQaqNR
	BhocBae/KkVFABlzJDwhDAjbiroyPCGcaAsIHa
X-Gm-Gg: AYBFou1MN+27onIbSc8bDSGxXU7o1OUBgw0VtD7QXRKCuAnjNCBdejy5va3DRIcbCIS
	kW2tJWwrSFkMe3gyEEzUq9Tf1w+icwlH/Nn6f19Df37HPCP1fuAB/MB1Tb3tDjrRfBRFPBvgPDi
	vfewZdXBdPbWGnT87X8VT4eaIP5oc9vcVz0aG+UZ0p2ne9s/KIthi4k/aB5uRlvc2nJS/Ud8TI6
	zlWTn+BaqX1TX5xBc6mjtF3NTAFxAefJyBFSglom0zzJFyECjI=
X-Received: by 2002:a17:903:fa8:b0:2e8:3d48:4d80 with SMTP id d9443c01a7336-2ea9c695516mr62602235ad.45.1793052353854;
        Mon, 26 Oct 2026 15:05:53 -0700 (PDT)
X-Received: by 2002:a17:903:fa8:b0:2e8:3d48:4d80 with SMTP id
 d9443c01a7336-2ea9c695516mr62601855ad.45.1793052353322; Mon, 26 Oct 2026
 15:05:53 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023234640.1459291-3-toddfreed@meta.com> <179288570143.3134.8925369868949382653@kernel.org>
In-Reply-To: <179288570143.3134.8925369868949382653@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Mon, 26 Oct 2026 15:05:42 -0700
X-Gm-Features: AclHuK8vmHsUIvz0IY0SMdSvsvG63AqCObkQ1uaVFzRtYuR6y8WvmQn7TcpGKDc
Message-ID: <CADh2yMyYS-PWP4912En9D6B9up6Kz-hnCthNkWot+e7N8-q7ZA@mail.gmail.com>
Subject: Re: [PATCH net v3 2/4] psp: support ipv6 extension headers in
 psp_dev_rcv() decap
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, borisp@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, daniel.zahka@gmail.com,
        willemdebruijn.kernel@gmail.com, horms@kernel.org, shuah@kernel.org,
        cratiu@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bjorn@kernel.org, dtatulea@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-GUID: bFquEQhky9qr-HW1xQFlgcfCJJ3Fw5gg
X-Proofpoint-ORIG-GUID: bFquEQhky9qr-HW1xQFlgcfCJJ3Fw5gg
X-Authority-Analysis: v=2.4 cv=OJqyTiaB c=1 sm=1 tr=0 ts=6adfcec2 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=wpfVPzegXHpEFt3DAXn9:22
 a=Pwd9bqppP3xQxChDgmkA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA4NyBTYWx0ZWRfX021NvaNYjS/x
 jABs83y0NMLcUCeH60W9Oj+a6JF8Z+C1j6nCTkcis8576RFjcfwmqBZ1gyw8PtvgYMhB3SnWbIP
 iDk8cGBLHQ3UzADohJNkt6RpbR0dJMWb1Mg97MfFf3VcmxHcO13w9Y0PkR/45s1+CzVqFGZvzrt
 1E/tkuk45zEjHvub/tyeUdXZ6ODWs3nLwALEzwMb4l2VH8DvC95fuZapaYlhZjo8B5wwZnfCQMp
 lv1M25Tn8AomTQtR5CCSr8GEKmBmq5XkDC26jN8ShJogbTwAW+Z4sIkM3g//4Q84d1U9NuCezqm
 oUbjf0cnTt/FikU3cOOHnEPFOz5mMD/W6kSw7JSshbJSaE5gOTilJndbH8KwkgA1zya7Q9lYRfk
 d9vNKsby8+rSodhdKGnkmnorTruIGnZQcB81HBGmb1KaCwdXOXiKkP58s8CBmpz/Ysd1OebmqVJ
 MQQJlFvYp8SLGOGcuJg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA4NyBTYWx0ZWRfX7ttLTKDMymkS
 14QPhR4nxIWkKqzCFYu0gfxWMYonem23+2aXyd6NpE1c+bgdAlYKlSKPr1uyZGTnDqcEok/ZEmM
 XIYcX0v37W+zDUEIRUnUPGabqa5PT1M=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_04,2026-10-21_02,2025-10-01_01

> [Severity: High]
>
> The PSP ICV doesn't cover the outer IPv6 header or its extension headers.
> An on-path attacker could take a captured PSP packet, insert one of these
> headers, and set saddr to an address they control. This assumes the
> device authenticates such packets, which this patch's premise implies.
>
> Several of those handlers reply with an ICMPv6 error that quotes the
> packet. With default sysctls, this happens for an unrecognized routing
> header type (type 0, for example) with segments_left != 0:
>
> Before this patch, all of these packets were dropped at the is_udp check.
> Forwarding the decrypted skb itself looks blocked by
> sk_validate_xmit_skb() ("unencrypted skb with no associated socket -
> dropping"). That leaves the ICMP error path as the open channel.

Agree with this finding.

Ok, this puts me back in mind of the approach in v0 of this series ; just drop
packets with extension headers. Actual support for extension headers can be
done separately from this fix.

pw-bot: cr

-Todd
