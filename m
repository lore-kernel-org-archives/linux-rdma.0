Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795204027;
	b=13Bvn/YDh+/o2WC6DPKf53849hYd02VS1iOkTpvXj4zsv/KMJQM7lkz0XfMyD6MUd2rX
	 mxjsasE0PAkb92z+TGPHb7/T7HG5SAcp5Hfz1rVBGzQRxi6+BPgwrEsi0icCr35BT+Uz/
	 M6rdJl9zaD73NSfZjvOS6FiDtnGuqtlV1RnU2BNSOb3hziSpEWmX7IjbEaw0il+lcVwgV
	 SI/yQn33rjritUm885z12Xx/5na8hxkU1ELYRD+IPQ0j+A62j/m7DAQzftQswJs/Gmnq1
	 2RzI1Dkfjw6EvQpOssiRFNmSldfNkbtFyEe2IQYMXAndKSlZFCL1mTQ8MGLOWEdl/4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795204027;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=e3Qd9lqm2GC/AOlq/ZfGyfDObtCF7sAVb8g/8PBrXLg=;
	b=11VZz6biJCjT7iqF/nKRocQlCXMw3iMP6F9T3NRWHZCUPGGuj8qeXBEYPTVzCaZjDzew
	 Z5kJKIpq3MOvOnNqYL66eix60AWp7DdsVbpAKTD/f3PE6eHgyl1+MEMB+QloYhth0t4yQ
	 zX75MnqPanhd+LHOTPO0w7CSKiJVvC4hVekgLjm57sGBAD+IfeaAEubxxa6K8H0zhxyH1
	 YMWF7cst3L5tZspexta8UywONcdUkPO0N9tWpY1J+Nd9wvbUa6NTP6yjx0hvoqSpFNMpN
	 qse7ZewvyPo0dZcnVxZQjptVnFdHzZPu9MrdXEoqHdUBqgz9v3R5PmgLaYcSKcP2y9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=KL3UKyQo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F680606A6D5
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 19:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F680606A6D5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=KL3UKyQo
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKHAcup2337661
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 11:47:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=e3Qd9lqm2GC
	/AOlq/ZfGyfDObtCF7sAVb8g/8PBrXLg=; b=KL3UKyQoqii+kkrGYbCRZSD8MHP
	GtjcWco/7NUJeizS/IWfrU6Ai4xuki5tbigAvmjURYL3vI2iLh59Sx1Xl4OG7XTq
	UuAZc20U+ulo2cIofMX6kMJcU6wdEfPsasvr4Nz87v1PFyrIgxJEebAHfXeZeSu5
	h8uquqHSk6wecActWDiVHT9JiCLm4fUIVMCYzNHjpzi5MPWEY3Bvw0yarlzXqjx7
	3ztOKhrct85Vg2TdB8UawAP5k7kVtLeRRhBH0f3J3gI4S1wBv8GWv8JnsHOHHdhe
	hw9PC2oKCorK4l+4lCC5cYERk3Rhofleas0ha8XgIyr9O4OolKIefwc7BsA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j2tcjs95v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 11:47:04 -0800 (PST)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8b69b8c6dd5so1463784b3a.3
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 11:47:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795204024; cv=none;
        d=google.com; s=arc-20260327;
        b=R2qZXaCPHs5/PSELWFyS+ISDk40TRF+lkJQnU5Eh1hw3rPTqMIpIyxZg+j729eQVoz
         JMlh/jpHZ8sAbv9aB6boJqyWwPmjl2dLpbAC1y93yo7mPsoNkoU2fa3jhr4um79QX2Go
         xtH+ah72JDG2f3GT7PooouZyRYmX07BZffL0GDa1937wB2YbeKHUG5pIFxg1TM/MBFRM
         jf1O2Oai+UZtbdeX9GTWihDzcEQ3WVLYr1PQk/GDtJM1hsxUI1VfaMkJORAsfrGjDvHC
         HpA4iZqFYPIlKxg9T0tw+Kg23ROGzHzY23f0Ol+hx0FMr7+IfHfnHXqaZ4kep5d6Ys9Y
         Jlnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=e3Qd9lqm2GC/AOlq/ZfGyfDObtCF7sAVb8g/8PBrXLg=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=jGgPihdxvZ6vGXCFafkN41xEJefKRON/Bp56f0Z5XlfREamDEMLKJ010QJ7oDiaGN6
         GgKbxXV/EeBlmFmqcYPHYAFnfhgxcqfZpMI9xvPlstC0BFa+NoGqkYQNmMc9X9MAnOCn
         OPAr8jORuiQiBr3pRxQ48t3dJBBPYEZUDgqoyKIasxA0Zd39SfB774yAp4HIAqaNWhKh
         XYmx0XCii0l5iMqSgylKy86QI7KNFm0vakcoEpdnct7cyxVJ/qjrrroGjmzsY3ZovS67
         JycO+3ac3N4zHEg9n8nMbH/da0zy8vJ13O32nQARifBEBV/gHgji2QThnWToKpws6UVA
         +elQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795204024; x=1795808824;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=e3Qd9lqm2GC/AOlq/ZfGyfDObtCF7sAVb8g/8PBrXLg=;
        b=BpLRkSpT+fC/kWS5nlLREfFrjthjpPKcavxYN4zTjDwx3ZjgltVUWGX1b3ccftp2Kq
         CEJiod84uvUBvX03y4xWGLmrvZZzsxvdkHSKVqm1HTGuPILXIDxQC0jrVRmYOLvUWVBG
         WRTQosw+0Kc1+qqniYkXP9AHogNrUymtPrTjIjNvMtxwGmwMBug2qFSCaNefDV1Qpg9d
         1x8Xt+P8DC0ZuMkHgsfD78RMXf9AP5Iy0+df4SMT+xyEwdaPkiavgZ0o1HCYlcWB+ubQ
         ucbVJeqWZmkH2PSlJ2VsC3WZktEE49Ss4sEeikenUjzO9z8ccpJ/kZVPcrktqtNTzEwY
         PaaQ==
X-Gm-Message-State: APuU4Z8TJpsZL3AGJRuQpIiW5L7rjRTayBFWRFDOpqxy7WgaWH9+5dN4
	l/cSrezxGotwjwp3nE9wKeUmm8LBMtL6bOMWkPeGToytmMELTEBVRRy0AFso57UOGyRW6cbna9F
	nRAbsrbvblNZ4ECQV2vCRrC11ld76e3gpwElv8vW95wLsHbqA96VofE45RVuUG6XJpvZThhJsXl
	503BlV9JNptgrSjkFB30SXcv4AvZFQd4CWzfPhNmTnPjBTupk=
X-Gm-Gg: AYBFou1CAgkfwS7c+T15m81cjggg8EcFXmC8HPf4md2014ytwfjUdAp63FTJWTUc353
	5WorbnZLjq8+/hYd723BtbbwVzoHAzApnGgU9vfqWNlrgEopg5Q0xnMEOABybz4Vd50+BnRDq6I
	aSx06UdFhkB7r/sbtCxBcqfG6Q+NHrwE0WgTagtqLGYwnNhHzDVJee/5Vn66sOzIQI75hMiXMaz
	VW+MPQGGQcduIL0sKchpCLOYdKPD5JH
X-Received: by 2002:a05:6a21:4d14:b0:3e1:d75e:651e with SMTP id adf61e73a8af0-4014b65da72mr4526399637.16.1795204024090;
        Fri, 20 Nov 2026 11:47:04 -0800 (PST)
X-Received: by 2002:a05:6a21:4d14:b0:3e1:d75e:651e with SMTP id
 adf61e73a8af0-4014b65da72mr4526384637.16.1795204023576; Fri, 20 Nov 2026
 11:47:03 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119013103.1092559-1-toddfreed@meta.com> <20261119013103.1092559-3-toddfreed@meta.com>
 <sashiko-outbox-224309@kernel.org>
In-Reply-To: <sashiko-outbox-224309@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Fri, 20 Nov 2026 11:46:51 -0800
X-Gm-Features: AclHuK8FGaO9Aw2ev57MNRSL6FQOQNTk1bJDiyMnIg82e246BtElLrxY20MX0KI
Message-ID: <CADh2yMxTi1zr5UT2sEYCnRTk5PJ+Uvtqujfg9AhZp8c5mo8G1Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 02/12] psp: take the psp nexthdr from the
 packet on encap
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-GUID: 1xyTAxCFMgWdVOhJe9lGwqMoMDs5p3yL
X-Proofpoint-ORIG-GUID: 1xyTAxCFMgWdVOhJe9lGwqMoMDs5p3yL
X-Authority-Analysis: v=2.4 cv=JYcpPkKV c=1 sm=1 tr=0 ts=6b00a3b8 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22
 a=575YS4XHc6AQ9hrrRVEA:9 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA3OCBTYWx0ZWRfX4V8XElNYPgC6
 lIQNuw+zcQPzVHAKMfqHOlalYghym3caFe/9iP5LBbQlxckRLB+XJuj9Gvf7Luyoq9viPm1Cria
 jAUHwZHK7umtiksDxZg9FRjtSHpv82vV3KeOBP8gh9EmTwCBhPpuPLY9bas5DpXSMccGaAw64CK
 eUjwkR0Z9d9F3MVPUIplrd8+LsY1OgNX3XwKOIXF6UmznKx/181LS/Sl8HGrtA4/8cqg73p+Eaz
 Cv8hwFZGiWNBlyKiW1PzHnWEjYNdDL0xlGHeHFv6qxHwYb848VW7lywwwzC6gPXt3epxwr6okEM
 Tvw5oseE8pBaYRkiWGkdi6jxZ9IgHHA8pSRIWKqAf/kVfOSalrAtYbIL41zh3DMN5pB5nHZredm
 uakzBZRuL8FZiJPh0l/UzuYUpO9PkCrTzXbdNXq1W6M5hXQ/bCg26AH1yxE25yis/LUXArH3K5a
 52T9GlTA2KNCVBwlFJw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA3OCBTYWx0ZWRfXxS1UHDtD/uRb
 TKK+NfAsEXZ04z5dVZhrgq6T7k3IhBFwSvXySWlqApG5fgY+yiz/02H3+mmrTN9j3KhMT+lFTRf
 ZE1LoE3iAlIWiMLi6vwI3EEI1lyiySI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01

> [Severity: Medium]
> Can clearing NETIF_F_CSUM_MASK or NETIF_F_GSO_MASK on a tunneled GSO skb
> (skb->encapsulation == 1) cause software GSO to strip skb->encapsulation
> before psp_dev_encap_ok() checks it?
>
> ...
>
> When those segments reach mlx5e_psp_handle_tx_skb() ->
> psp_dev_encapsulate(), psp_dev_encap_ok() sees seg->encapsulation == 0
> and skb_network_header_len(seg) == ip_hdrlen(seg), so it encapsulates
> the tunnel packet with nexthdr = IPPROTO_GRE instead of rejecting it.
> mlx5e_psp_set_swp() then leaves eseg->swp_inner_l4_offset as 0 because
> skb->inner_ipproto is IPPROTO_GRE, while
> mlx5e_psp_txwqe_build_eseg_csum() still sets
> MLX5_ETH_WQE_L4_INNER_CSUM for the CHECKSUM_PARTIAL segment, producing
> corrupted frames or device TX syndromes.

I reproduced this on ConnectX-7 with a GRE netdev (with csum) dev-assoc'd to
the PSP device, a TCP socket routed over the GRE netdev, and rx-assoc and
tx-assoc to activate PSP on the socket.

It does not produce corrupted frames, but the GRE checksum is left unfilled,
which would be an Rx drop if this path were otherwise working.

It's not otherwise working though. In upstream, psp_write_headers() writes
psph->nexthdr = IPPROTO_TCP, so the GRE payload is misidentified as TCP. And
with the net fix "psp: don't encapsulate ipv6 packets with extension headers",
only packets whose L4 protocol is TCP are sent.

This patch relaxes that check to permit other next headers, but adds other
exclusions: fragments, and skbs whose inner headers are already set up for
offload (skb->encapsulation). The latter drops the non-GSO packets of this
flow; software GSO clears it on the segments, which is how they got through.

Anyway, this demonstrates another exclusion is needed, and I will add a check
like this in v3:

          /* Devices complete only a TCP or UDP checksum behind the PSP header.
           * Software GSO of a tunnel with an outer checksum, e.g. GRE, leaves
           * the segments here with encapsulation cleared and CHECKSUM_PARTIAL
           * at the tunnel header.
           */
          if (skb->ip_summed == CHECKSUM_PARTIAL &&
              nexthdr != IPPROTO_TCP && nexthdr != IPPROTO_UDP)
                  return false;

-Todd
