Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794955619;
	b=TVQjOdPAsOTjemTmHMAqUStv0uj40ir6OOqV2akWIKhfqWtQWEs0nPhx6BY3/R7nRkje
	 v42NrTmkuYrExy8Ddo4vvJWwxKyC2J9Ubo+zRGsMvzSRfcHqPqwFeLPz7XVlPpI9MuxSv
	 WKonVfEU1+9W0Xmpwm2+qWnuZ6PXmLqQdtReiyOt9iYxrh3dVgKCPs1gUBEUZ2TC1QGfu
	 jDIIjHqh2e3MGiBovJS2pwb4PkT4ajdvne23N0MVNJeW0sSnsHsSY98MjxXXU2LJbkBwt
	 odIvKEwv19hJAVhldia0UUY1/asQfiSmqquxII+RYmqDuAlAVGwOswLahk+uAJndnkQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794955619;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=KSC81XL1+EQpdKzjuyxfAuAaB+et2a6UKZ6CLWHqjqw=;
	b=w73n0hRdAfUi22tr0eZWORDp3pRpdVXIKd5USvjQQNHfz9ysjDiSI82rFRwSAij+jH64
	 p/LliNDh0GRe3zHLSa/vbsI6DfDUNQpV9T3EK+Jog3SN+sEOe3HvNkxcmoOB5WCXo0eQ6
	 fZ+3UeJavpPddxACa3dXBFIRRghv3khQomDNZQDKvzXXaZGRHsgKTTSmnqlxZUtBfrrd9
	 13Vp2JnAZfmpm98qXeXumLk9WGKI9eKjlJDy1r1we7VB2ut9TZctwZqDJo55cdJHxZt3e
	 z5h7YXuM99wIZwqkLv1UCtIMOBIpu+VAvK+JwOYoKhF+VXz8VaGNgrDuJkrD9DFvbMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=OpD+6PDM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C02606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 22:46:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44C02606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=OpD+6PDM
Received: from pps.filterd (m0528009.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AHMfexW2298500
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:46:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=KSC81XL1+EQ
	pdKzjuyxfAuAaB+et2a6UKZ6CLWHqjqw=; b=OpD+6PDMlyRVIQ4gUsxd1pQRiiY
	2xNljoVElEeEhFUiOG5Uk44VLPG4O4uXpXj0+j4jeDetx+c0P8e+noxSYq2lCh5W
	KHejIzt/I4UdTJmzw+Fg/nSj7cB1QTMx/l3bO+xrP+TSeATVVrDxWTZVHibCW5U+
	hjOQG+u9uC1e2kybz2OaCsXrkrsDWl9/U/SGRqGmJY0vG7rKiLXndtlvel7lQl55
	sdjYVggRIUMT42oLfV5wteJXfkuV+1P3ib3Fp4ylW8JJJGpvlzjjnP6mzY9S0HdJ
	AQ9e8xf/1KwJnz4XcYTaX6HmGdSH8UZ30qmpl1eTP9PIAKGbfG22H6j3L9Q==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu5r3dk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:46:58 -0800 (PST)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b17b31c3beso226839a91.2
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 14:46:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794955617; cv=none;
        d=google.com; s=arc-20260327;
        b=GYmX+KpwhQYPSoSI3wbqLioOOP35AUUmX8331ddk7cRW8AJUs3kIazvipv3cvaPGE0
         UVFduD9KrzN9zP+aCY9fe4ikdpqRrrdVFFj9x0RfhjE067xhBj1PyNjVI/o5gNHVuniZ
         NTPKd1OE8eHfESXRjY5X240UHT59bL1yEENK3dbekTwNRdCNUsJ1taQ6wiLNHFEQZ3g7
         cHfyeAfrd0T5OVXi8HFarVWVRA/beX8pKhM5nR2PIi9Is+07ZwrcuY9OLvgdLRC8y6ZD
         QiEAqdSQCGz+lLoh0rqGh4bfHE311GpNlFpiACeL0OTNa6DIrr1cXwi0bPFDsaXdYke/
         xXpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=KSC81XL1+EQpdKzjuyxfAuAaB+et2a6UKZ6CLWHqjqw=;
        fh=zR4uiuMNPjZ2yqhE0we6613VcLdBPJQOlYgJ8EWjjqs=;
        b=VbiDN9LDuHF6bljqbSGINFnpKRBLpImc1KNhg4SAGq4tj+RseZ8Wmf59NozoJ+pkUe
         uka995HiVxLPkeF8zxTQ//pELB/1wzKrkebKpHKPT1IxRrLs4I2ACX1iPRnkLKYYa0kP
         JeH7hlh1uCmgLqQVZjuS4FD47MoMQK65dwXqvRUKcwB+ExtGv0JpORVtoTZ/cBY5c0IA
         +C48RBSjSLIqnHVjA62mtXr1AYdkfpTIvG3JSDZ7+ekkp4+XBqLC9Rhq26uyJT6GMHLU
         4WjmR+JOs3kaCx0S8j/z59zYatP331uoV2Eby1PFrQmmhs2XkAbP2dw0b1AHatwVzsPx
         HzhA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794955617; x=1795560417;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KSC81XL1+EQpdKzjuyxfAuAaB+et2a6UKZ6CLWHqjqw=;
        b=y21X83gCvgbrcBKQDatHchQZg71o/nkYRLmGAjorv9+gPqx3Yp6HgiJx8X3yremYdg
         CMxrhCZ9Kp1dxcnq7q4gj5GRRjljlNkaJe3J7ZFE8DhNEpwWxQlgpwQyv4HEX6y54fgR
         j10ayHiXUgs4vO6CHlBVz6iQ301fLMoMwc0sxMAZ6G6IfvJroHgByNu7+DNMw+Cv45II
         Jmnd78LVfbDO5X1hiIRVgLvmb/NEBY/mXZunijI2eX0q8TprwtGlo6UdnQq60v3YovXH
         GbyujZHtGIYXHY8vxD8bZXJNVqK1I9MnBIBWhk+nnc7tk5fv/veV+o3dEDbmwSIsXM0z
         d38w==
X-Forwarded-Encrypted: i=1; AL+hErEKGdirwwaN0PCDGogJ+Sv5rhhbS9/7mjQUqEpnOMMbFhqCU8Na+XBjK12/Z/y1w4NRoJG1KoDTp+VT@vger.kernel.org
X-Gm-Message-State: APuU4Z/Y09k4/IGIta1ov4H9WbVfTHca1pSYfh2l/v4xN/qpgMdVsZss
	ZDdwROIga6jBy1XB4FpwLPbOkL0+GnI04N6iXFKMh/cFHWYEZubYGXY1qdeZkFm0wgzlh85X4wy
	GCjmAk5ZFbphyvSaNqilANxaLQ9mortXlfo60Ucd1paKlYlqe6hyDecGheGBvu37BYdLc0p+oAS
	VahYawcgbiYZCddR0JTuuk3o0y3Pill7z69LgI
X-Gm-Gg: AZFdTZeUhXKCYHhw2PgxNavQFb/mMuLU0Jz7yJoUElmhuj2b34AxTvLToQxjpJ8eftR
	bphBMnYt8iGSvmaZFm7sDMqaJ1jow5Fxc1qdU+mO2WtTnJHiDh8dDAY5Atp4TPiNqU/msNM11Sp
	J2J1tOtQpjApHlBtbYaslfVI8Sd0dMFt3zHlbXpwNtHelxDqRflx5ixQh75Am9+DUvCjdWnZXHd
	MSDoNNgsPgBlh33+csKas7Igzaim6MXToNNvma/aOEYmh6RAZs=
X-Received: by 2002:a17:90b:2fc8:b0:3b3:c3b9:7de6 with SMTP id 98e67ed59e1d1-3b3d07a212dmr710203a91.13.1794955617405;
        Tue, 17 Nov 2026 14:46:57 -0800 (PST)
X-Received: by 2002:a17:90b:2fc8:b0:3b3:c3b9:7de6 with SMTP id
 98e67ed59e1d1-3b3d07a212dmr710167a91.13.1794955616819; Tue, 17 Nov 2026
 14:46:56 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-10-toddfreed@meta.com> <179471270451.2199510.14795764193886368841@kernel.org>
In-Reply-To: <179471270451.2199510.14795764193886368841@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Tue, 17 Nov 2026 14:46:45 -0800
X-Gm-Features: AclHuK_60Rb9y_3QFrgeQGfRKqUkPpfoiUhcDbbJP8UTYE_KV9Woof2OdSMKaMY
Message-ID: <CADh2yMwGN64zEVedBhYbMDcsyPjSJ90tyPz7evJ6x7B9pAk3TQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 09/15] net/sched: add act_psp for psp
 transport mode
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA5MCBTYWx0ZWRfX9V9yhJV1OAL3
 a0GuzinAzudh4UbTlPy01rUNqVvGfqMUmJALSjvgAcGTQi5YcSApz9+1y6lXyqee3uXeV8mGFZI
 YpEzGS8fOssBav4AmEMxMszCHIzxd/WkkUWz3OQmWSzf1IGgykRt1x0ia7qToTn5TxM4b4yYwjC
 /cvjUCVrH+vjEhFIf4dihUIv6ZYMaN/yP/3jOWKVaKOTrc5yhH3hv55gFf8FExXg9Np84s67eU0
 LAhNqrzKWARunGe8q31bvuxySPQTX13ta1YQN5A15qgdWN4xw2NqKDWWQPrEIaRkFGY1GpXQKYH
 U7PX+D+E2+RtZG47tY7r01ZBcYb+m197UfMws+o5lSUeLtd6maFh50bmU3UL2lYpmXNoxx4gOsQ
 LEfdN41eZ0rhao/YHQHArg5tE+OIggf2DaRt3V6MCdzNEJnTgofHLYf8tMZxEXXSFw9K3c02hFL
 YbDj1GkUrF9ie+A7Ddg==
X-Proofpoint-GUID: L4cfP1w8sT7lchT8VEoo7u5kIbI0y-h6
X-Proofpoint-ORIG-GUID: L4cfP1w8sT7lchT8VEoo7u5kIbI0y-h6
X-Authority-Analysis: v=2.4 cv=dbgVTnXe c=1 sm=1 tr=0 ts=6afcd962 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=U_y8lYiYyhHBU5rMqhb2:22
 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=DHOIGP5XwAi4GC-hQCcA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDA5MCBTYWx0ZWRfX0srk7vSQpMKc
 j5cmiTQFAR09AOmtWySIbyxwd4JCBb2fuY590c4zbNR9VLKhpKB7DIQsJq5De9IiXRPqqrbC4Uh
 GkAc9gx8iDk3kX2+rMQjAeYFdVdjxtg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-17_05,2026-11-16_01,2025-10-01_01

> [Severity: Medium]
> Can the METADATA_PSP dst and skb->decrypted get separated after this
> point?
>
> The commit message relies on skb->decrypted as the backstop: "on egress,
> encap sets skb->decrypted, so that sk_validate_xmit_skb() drops the packet
> if it loses the METADATA_PSP dst on the way". The egress to ingress guards
> in mirred and bpf also check only the decrypted bit:
>
> One path where this happens, on a non-PSP netdev's clsact egress:
>
>   act_ct (defrag, sets tc_skb_cb(skb)->mru)
>   -> psp encap (the reassembled packet is not a fragment, so it is accepted)
>   -> mirred egress redirect to the PSP netdev
>
> tcf_dev_queue_xmit()
>   sch_frag_xmit_hook()
>     sch_fragment()
>       ip_do_fragment(net, skb->sk, skb, sch_frag_xmit)
>
> sch_frag_xmit() then puts the original dst back on each fragment:
>
>         __skb_dst_copy(skb, data->dst);
>
> As a result, every fragment carries the association but has
> decrypted == 0.

The fragment path is handled by "net: don't fragment decrypted skbs" in the
net series,

https://lore.kernel.org/netdev/20261117203137.804424-4-toddfreed@meta.com

This causes the skbs to simply be dropped instead of being fragmented.

> Would it make sense to do one or more of the following?
>
> - propagate decrypted in ip_copy_metadata() and ip6_copy_metadata()

Conceptually it makes sense. But because of the fix above, that would be
dead code. Furthermore, they still couldn't be sent. skbs which are to be
encrypted on tx (ktls, psp) need the L4 header, and non-initial fragments
do not have it.

> - also test skb_psp_md() in the mirred/bpf guards and in the cleartext
>   backstop
>
> - have decap refuse packets that carry a METADATA_PSP dst

In both cases, these guards would be dead code.There's no way for these
to happen once the fragment path is closed.

-Todd
