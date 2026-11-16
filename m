Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794870031;
	b=eJ7s1p7c77b4qUcpTAQgBTZXaTOIiTxvQz6vWwSN/QtFl3/qRT7h5odhbRDv+eJmZsOo
	 oH4a2/qnBhSUlHcuyWQeW3YHYUXDjINlcZZWEh65STA1ZdxtNPGTPNSi0u0H7cqsxYBpe
	 toulpwKocf4g0e53IrPdtxAAwVhAnz7t5xkuGMuseqn0kWi7KVGWn+JrIr2IJDzQ76p5N
	 Z17rz4lQYxhqLQk9O525TJaxObZAYDLsQIkbc0vWndLWIbpWqdvrFrRwq1jqQSx6G3R2M
	 p3CZgCi4J86OOGBhcF2blf9dLmafiVEKktrhp8Cf48JkStsmSeWlHWObLbzm5vDePag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870031;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=BCHVgfl79qsgOh8V2QC+/phw3otd9S0rQogMC77mTS4=;
	b=Y/7XPUlNPQBWyKGcTGwfAidObvjzFscuOPrDPV23re2yMv4owpcY9zZBsjx12HB0gI4H
	 95rzz4gfmgJlBa68A7mqa7jWlzMWHlMn92LW8VIWcQ84h6NNUSrz8fZ7xjqrIWXRySUkx
	 rYq74ZBNEYgbW73oBs0V8zogb+6As85XSRkGH6px8SrNPsd5wRlE1ZzMqXQINmbsun4l2
	 jiyHHyftDQSuS/lleb+W6U3AjoeG4iSzGVLroDIDBQ2dD7Llnw18VGXj8tYPPKXR5r5pY
	 wbL2dYvgmKbbbZ7i0+Zt8HK7KwGEd7UMlxMsxrnh5sBCd4jSczimK6qRWXL8jAc6tmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=bqSqU6yF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550F3606A329
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 23:00:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 550F3606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=bqSqU6yF
Received: from pps.filterd (m0528006.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGM2Hfj2324162
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 15:00:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=BCHVgfl79qs
	gOh8V2QC+/phw3otd9S0rQogMC77mTS4=; b=bqSqU6yF6qU3K0lBCnujplBnoj6
	Qk04NCwjHPY89A0kUMgZtt+BMSnHZZMbjJQjUfXSzYh5Rl2q6WmEZGiohyprZ/uK
	0Kqe7TUQiVFp6yOTrdaSP049p3IvIPaw7y+dJL7qKbHtdYYUSqQmeTFpAB8X+3f+
	ET32GeE3PKZduCdi6ipMtFApojz8LlJYmXdq4PzaYQuCXxVbRdGTC88PNbebbR9S
	b9GjBWYtvzkNTkjsDZ+lSj12/5ZbOh0dwt9I0ENG3loyFGBqOnytPf5rM0td7IZu
	iME6ei8GOC9CAZDOvKPUffcdZVdcE2zIxNWapMTB+2v4zIUjWcdL9vCjSOA==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hy95pa5ft-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 15:00:29 -0800 (PST)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8b7cc3f8a4aso2505542b3a.3
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 15:00:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794870028; cv=none;
        d=google.com; s=arc-20260327;
        b=itPUPCbEjLav1siLul7a+yQVxpW6CSS3rq1NIt2uNJbBqQ3PCIl7KMnx+AIcor1ltI
         kikuaDyUFoD1B3k63EiE6vw6VTWkpeJUJ02tXYs4vVWExwO/WSCRhK+VzDfaQF/lGgwF
         7GG3OEvmIm8bJmiieztvw0FJrpi6Xyq6mz86wDKmsLfrg8AbV8mZ4IWvtmJY4KDBBIJK
         1+p7PaVW/x3SHSjfG+uJ2br4qieWc3CIfSxxyDF1vf4UyrKar1DvChyYVS9br9UIVoSM
         CzYEpXoKG2nN9EYPLFvU5xx2D9IaoX3CZ/656iRr5Eo0hVBaP5uf6osUzhDGBBqYbIE+
         +ISw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=BCHVgfl79qsgOh8V2QC+/phw3otd9S0rQogMC77mTS4=;
        fh=xyM8kJLVZKxzSU+2izcLNzE1c6FuYHQinGM5Dl21DEE=;
        b=muZHxen4oooQFiSZTvIcAlb6XusoDPLGhFJ2NJEnBOjX85dOwmesJBCqIBP5c1ACmE
         p63e1w3I+Ha0iwvRPmjoj+pfekVRgxpPVjZv7fZ8n7ZgrysvVSMF6Z+H2Wpfqhz8bp+f
         JwrX8yADQ+mmLYV1eAR59LC/DyiFr0zDfRV/MLbF9RG15bK3nG19vIRtO8/Xgxt/jzQX
         mv6Iug0uuvwoBAqqy6vBgQPSas3up/nhhMYusrGwm0fxsCJfy61e5kCtT4xmGbfHkx/x
         Y4ACSJ9lBu2n8sFWq0x4GqYZXIm0KsITivNBDSYdbAXsdLqvtJSpvnkd+CQRCZ0wMQyg
         gNkQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870028; x=1795474828;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BCHVgfl79qsgOh8V2QC+/phw3otd9S0rQogMC77mTS4=;
        b=pQ8vz6LifiQeWr+GjByrM7ylqBgzgGlohSfZuiCIh0j3jqoc40Iz3zfUXPbIE6hCXi
         uP20PWe/YGnqBu/YeKV3TG6r/QLgGXja/GvHgkOpQNr7txyEWXobE7ablpVmNfxtc4Hh
         h6csf/LL748HOfCjCvQWSqGhVWLRMBmPECCcDScdkRc/VR2NW/vuMdW2nq0WFkOLE4Tj
         1znM1DKVYXA5wiG6VaUnySIEPAcfRoV/023Xek+FHhrNGR3EE6eHftHvZM6vUaqI4eJL
         a9aLr/YiKgPvDfeEl57nhK11cqEr45MsKKAjy98cH0fO+XHIG4t+rQEmMkO8xplKVhFs
         ImFg==
X-Forwarded-Encrypted: i=1; AL+hErEO8Ed+kPpw/TDVHIQ4vfaoCXBTYtv/ws5Q0VrIxMYZMdXF5P7NOaadQhIPJxoy6qIB3kCfGEHMcNNt@vger.kernel.org
X-Gm-Message-State: APuU4Z+LcSA7gA28YaxLJ+IjxzxHdQozns3Ue3sonhx+C6CsScMx1lcD
	deqrGlngckBSJLdGfEeRfuBaxDiQCmM/fhwaC1P04kphIrulFuovAWJNCAZWdqu8GnXc3JC1j7K
	DWmwFlwOk+YgfZ0f5NdX/vRu/nzUIipFLvZ2i9CJdg0B4xbW181zkgGduA2eyF0uBl4Mip/QzZa
	wW6icCmCG875qj5bWojshScc+crfmtPZCZ/IUM
X-Gm-Gg: AYBFou27OqQwMGid8atPIXXkJcNMLOANUfnOQN+gzEtWzfKEuWfmv6+0mQYFM0ZBEnT
	map4FwjXOifuEv6vvObPE6BkecUB3KxmzSQ64P09s/j2nXzg8VNdK8qCYcM18/4AzuhAa6KFmeE
	bwFpKRg4f7Op3EDr8qbDi5BXwn3ukr93/hBEHbnY/wjHQiUsPF7Y3jLJ8d5jLtZBu/ZqXc3jh6f
	BAGGQvWf3WR49nRafEFwOpwV6GEhO7rAEwikEWNjl5HTww4qqc=
X-Received: by 2002:a05:6a00:2d1e:b0:881:be70:4490 with SMTP id d2e1a72fcca58-8beb6193d24mr11011935b3a.28.1794870028047;
        Mon, 16 Nov 2026 15:00:28 -0800 (PST)
X-Received: by 2002:a05:6a00:2d1e:b0:881:be70:4490 with SMTP id
 d2e1a72fcca58-8beb6193d24mr11011901b3a.28.1794870027525; Mon, 16 Nov 2026
 15:00:27 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111001831.3710881-5-toddfreed@meta.com> <179472727079.2199510.11728930190494845454@kernel.org>
In-Reply-To: <179472727079.2199510.11728930190494845454@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Mon, 16 Nov 2026 15:00:15 -0800
X-Gm-Features: AclHuK8U0c5vpo9LrE-LUBEl9Mos_YCScdKBQ9e4Pj3NM_Kna-AkoWmo3RzMn5g
Message-ID: <CADh2yMz==oX8OMx+dqNXort+h4vUFF6LHLWmaZJMTzoW0f+Jvw@mail.gmail.com>
Subject: Re: [PATCH net v5 4/8] ipv4: icmp: don't quote decrypted payload in
 icmp errors
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
        bjorn@kernel.org, borisp@nvidia.com, cratiu@nvidia.com,
        daniel.zahka@gmail.com, dsahern@kernel.org, dtatulea@nvidia.com,
        edumazet@kernel.org, idosch@nvidia.com, kuba@kernel.org,
        john.fastabend@gmail.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-rdma@vger.kernel.org, mbloch@nvidia.com, pabeni@redhat.com,
        raeds@nvidia.com, rrameshbabu@nvidia.com, sd@queasysnail.net,
        saeedm@nvidia.com, shuah@kernel.org, horms@kernel.org,
        tariqt@nvidia.com, weiwan@google.com, willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA5MSBTYWx0ZWRfX/35vgZyVQtle
 HQIr9oq94mKRDQQhad3v8t4H8Bxlnn/Mc1DcDV+lQMXLIGZ8cmlByu8Zs72XRQevK6wMino9cQB
 17JdvBcQVjqGm/WIbV5Mij639B7trKOsAn8UbcqV7xOHO9UBoh5nrmTKImRxBORlPEmJzcpzj40
 d/AxQXUVmzDUv0R1ILA7RjSv3sXz3fplcl10mIbOvYlKAWI6lLLvbA4fW981Nl83IyEApwNA93Y
 VpmwUtTJNFHs79iDWTxt2fG/GNzxeFOutYhiPTW8cJXGOtnmaly+hYO9Vg0gOXr3D8FskObWQlA
 ngQBpW2NVnzJGC5P6PHdjkchVfvtyMgrIH8Nv8N+OG5KeQMXbhbfAprPfFwF9kj0Sawf513mpc+
 eGB0hVHqBOUJi4kvScfU18HRdxTFtQ+R8VAqkhNMheuqqK6oRtlTXHRQ+GS8owL+9YJPXnnyc47
 VUlTD3rT9NyazSdl4QQ==
X-Proofpoint-GUID: KL2r-SgApjdtkh77tI2N3Jx4LV-v1FpP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA5MSBTYWx0ZWRfX5yAD6L1csX5B
 LL7JtF/OxQE3U8A0wp5aru74kR7HlRZMfoejzAUSHJNlmrmfRK6yjiuWp0OmZDsm4dLb6QT1fCe
 QomROOMXiKY7rS6YOaM2vICVa6fMk/w=
X-Authority-Analysis: v=2.4 cv=Yuea1IYX c=1 sm=1 tr=0 ts=6afb8b0d cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=kkcUborcUVj0H7zxAXTl:22
 a=voM4FWlXAAAA:8 a=-ThzyT3jwNi3vWZZJl0A:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-ORIG-GUID: KL2r-SgApjdtkh77tI2N3Jx4LV-v1FpP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_06,2026-11-16_01,2025-10-01_01

> [Severity: High]
> Does this check cover every reject path the commit message names? The
> commit message says:
>
>     a reject rule (iptables REJECT, nft reject) sends its icmp error with
>     icmp_send(), through nf_send_unreach(). so now, a received packet which
>     the device decrypted, and which hits a reject rule in the INPUT or
>     FORWARD chain, is now dropped without a reply, like a drop rule.
>
> That is true for iptables REJECT and for the nft ip and inet families.
> The nft netdev and bridge families are different. They build their own
> ICMP error and never reach __icmp_send():

This is true and I will improve the commit message in v6 to explain
this more clearly.

> Should the check also go into nf_reject_skb_v4_unreach() and
> nf_reject_skb_v6_unreach(), or into their callers?

These paths are covered by the netfilter-next series "netfilter: don't
send decrypted skbs in clear text"

https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=533037

-Todd
