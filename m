Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795463215;
	b=Y7b8T6IUvITIYFB0Q4RWUr3Sria0z18AJLoqmyR8vVhruSCXJWIlgrPSAcdvcM+BoUIg
	 vAMFD5Jxm++2o5NcwiVha6/ZEFgm66tUVptB17QOGYNqhR8XFQ4x++Ifsf0tafh+MGz2U
	 aG1vqCJCcaEb0RlM0Tb5hr3JtgP8geiOK27fjjxEWaamkHz48VLx6pt7NVwOUAGF0e4h3
	 PJW1PAxzj2rqw3zRu4M+1f3hFD+/9LG4UPajRddB5Qoy4YaDQDt1z/bjn3TpDDVt3EdEN
	 XwyF/i3aylEhVnH/g/xbvVKYLe+BHAQxMhjazw47SHyILnocAQzHgTJA6XuDtgGWxmA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795463215;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=68msumE9ER+DmiSRosq40jxym27XxyiCjqWMWovmiXU=;
	b=1QTLLTilQ10P89aaF4kokdaVepnzijEjOCyIUimMjZRGa7BmPCDrq8TG6C5rDD0mVS4T
	 xihyZxCp3B8KkFA3O7VnWvTWI/GXOJWKIcwj5NsXG4s43EwNE2diOh2QtP92H9rK6ZFy0
	 QzxaVU/m+AOXXjXvcuyI0PYKdh3JetyVqUCT7duom+UwzB9xD0QPnBefCrR3+070gvPjx
	 j0YKvo8rCFcJKHU87sfl5EW+A1p04rb20TigJM3Oqnh4zwnlT3uXSMmpstVu/kKxeB88V
	 kRsye0kCQ6v5Gvfv82G+dFo1eHdVKlFkuazTXN0UP6cEsC6a5fvkhmGVo0k0DkupPrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=NxH5C50a;
	arc=fail smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BD5606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 19:46:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55BD5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=NxH5C50a
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANGIXbh2266628
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 11:46:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=68msumE9ER+
	DmiSRosq40jxym27XxyiCjqWMWovmiXU=; b=NxH5C50am/nw4X0MHjqFCQfQQj4
	A2bOT7e7cLabU4X+Sd7THNtQ0jl6lvyPzgQ8aOft1isWuisGo+XJ7aIXM51vLROc
	qpPpnDmrvZlB8yc0yB5YrixgG5RHYMlIFX3nTm0V5JBI7PU/MIOOByEkhJAKUVFE
	xX1gXF3waa+WEhGm7iKHLHJZFkp1lLYYn9mdCJt0+YUM1GX8VUH5jmf31nNw7S/w
	SpQlGDrlIaO9LC8fxFlZXyX7bNpQpgNXsQ+ra+V5OEhX0O0WIXkynG53BtDhqIBb
	CzlqPIM8Xakrj0S2g1MP02M7rJZAtx5Csz52FYEb/yWEZbOe7LdyHCAJxCw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j3874utr4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 11:46:54 -0800 (PST)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ae19907a31so3502262a91.0
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 11:46:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795463214; cv=none;
        d=google.com; s=arc-20260327;
        b=CCMgMsUOSYIFjjy2WuCsVl+EI1vlxISWMgxya9C8SKQ7j0Djb38pwV2lqlMYcwEmu3
         a1i87P5H1m2BebGJxBgRHHG57vWQCXQTZCnsIL9NK0VnQQARWHL3oesvzJwoE7T4nubN
         zgGC1zxLTc0na5yA9HLsE8gm3WdEtPadM5JNsXcwMoZ+TcEy2nH5Jml/QAw6E8ALvK/A
         2J5LFaS1I6sWnjyMjzszD9flDcS1KUObI06EsJRbcKB50Q2zh7Swa9ItmnnzmGxOWfMh
         my6TiUbNjCwCza79pwkRKMQHP4abZGREhOccm07qKazsV6Ik6F5wM3pxUKRBFCiyvGiP
         0YDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=68msumE9ER+DmiSRosq40jxym27XxyiCjqWMWovmiXU=;
        fh=nCyiB7IDwxotJqPtit9RO0C0x5YLnzPIMB+yWRWNd3s=;
        b=E8KTl+F+54R6DA2lNspXbPandS6on7uEoyiBomTv/ePZoP1SCLGtukeJRa7te5pK/r
         2a908RFm2UQ/hXZ2pEUJ3sUbQ9qW/4CsKMvYbqa9F68rz5Iy/CJoTSmdVfwY6abaPVwf
         jdpj3Kq6VWRc+oqWdkDEn0ucKT7wwtuVXtd/OiGQA5RErOD1V72DrUL05E1+Sv4zWCi1
         1O8PQ1Q9jMFrOxgKvCbEkI/e78YIut5Qhjvi1cbo/1WsWDi53AdAJAyU3XY7z9SPfNpP
         PP3qbKW8n47rJtkOKAxpi/XyE7VLihdwb2JsM0WUaCGlgLkWbxMKvoGez7yIz8pK1TWv
         WxVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795463214; x=1796068014;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=68msumE9ER+DmiSRosq40jxym27XxyiCjqWMWovmiXU=;
        b=MZU2mlynJofO+RbRQD7dK2NM4rXjh29sB5kEGvhQ3kpnZfXymYfpSKFhRzqHZ326n+
         kLrueyecx59BRr5hu02EJadA2jrD5PS7xYRjtqwR3nj7H0o2/41Lm4aVRYjLRl+P4X4p
         dD7Qsip50RbdT6sle/5p7wB16S6eBrdsi95xnLq5LtiOHtXRN6EPcqW5iZL9p+MKkU/H
         zpmjghX7OGgolaxLtavcbLxOFH35yFT3Bk/Fohzl9JjR+2hl+tlVzaj52WpLfYZ8VdqM
         /kntSuCKu/Lesf3DvXeTox7SiQ1nyvxb+Q0TNcF4RlLDpomwQYV4CSGg0JOlIlZjPMyO
         kcdA==
X-Forwarded-Encrypted: i=1; AL+hErEPVGnN84VZhlfeaKZQqFOuPqSGIOlqaZiRAhrIKbTPKh0lsZHHyuccHBACZfPwjSXSTRLSxZWAaqWP@vger.kernel.org
X-Gm-Message-State: APuU4Z992sxSemDAwV4b/syClBG4bnUdDBupQxJlNTUECZP5Zg97d0b2
	8ft1tg4CE0kvJU9eCg9Vgdfii9ea/WkP2j2H9h+eY+pjCHGwjOG28Vb12rTiubbpphFr+U/mUYq
	g3m6O0pkLaIFwnjEk0/yHpSxqlZACSyJczAfVExjsPx6BWt0ss3XzuNdNVQl4Jn818+2fpSuKVS
	r465l0XjRzDJ7N2/0PNW9Fj6JBn0p7vQMU8oKe
X-Gm-Gg: AZFdTZclEnRJpsUanR8HyOI92o7kBKzfivEHjZMqaAGfQPBwwBhuCjyDhkhV0BkUs79
	3Uw71xCikoE1r76dhLEaJZmNylHcIiJBXjqpaLtlCy5+ImpYQ0/wMxQqDxd/Y1H/tP/GzJ5UDRl
	ar2AYI6drDILhMeijqcpYCdkacqhiIOwJbuDZFgidWnbbKu41dwzehrOagcq0d7531yh+rBnpWJ
	4v6G/vpVOuly1BtA3T1nbEVKC7NLcwQT84LdRKqyAhO9vpujZc=
X-Received: by 2002:a17:90b:4483:b0:3a4:b509:88bd with SMTP id 98e67ed59e1d1-3b41c7bc7ccmr7276203a91.2.1795463213820;
        Mon, 23 Nov 2026 11:46:53 -0800 (PST)
X-Received: by 2002:a17:90b:4483:b0:3a4:b509:88bd with SMTP id
 98e67ed59e1d1-3b41c7bc7ccmr7276167a91.2.1795463213335; Mon, 23 Nov 2026
 11:46:53 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117203137.804424-6-toddfreed@meta.com> <179529586258.3135.12190616828136497053@kernel.org>
In-Reply-To: <179529586258.3135.12190616828136497053@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Mon, 23 Nov 2026 11:46:40 -0800
X-Gm-Features: Aa3M54qNBs9m9dMGH-6cVdsrK_G87ANBZo0TyGs0hmoTzNiwaEmGoS1Z8U9eLXY
Message-ID: <CADh2yMys__9M11pgtxkMQHuhjvM8DzZr20t7W0aEVNqEmABEnQ@mail.gmail.com>
Subject: Re: [PATCH net v6 5/8] ipv6: icmpv6: don't quote decrypted payload in
 icmpv6 errors
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
        tariqt@nvidia.com, weiwan@google.com, willemdebruijn.kernel@gmail.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-GUID: UPR0D64edlT0CorVs8DnZBvZeic-k0pf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDA3OCBTYWx0ZWRfXz1RJdQVzQH5e
 cnZV3OSz+P7fTHuCIrWwat7oz6f39c5g8XH8US9DbelHEjZ+aaySi88SpwgzMEqa+tvU39TTX3t
 P8G1qv7rBDzldlK8LcbjSI8nqVnpaE6xbmFRRv/+b2qgqC9K4BEscmWCGoaprI9lz8IwbgboQot
 VPN9JpCyKuZZ9+pCp2x8b85x92+xIkjPHpdlOSp0gfNBW5CWVkHcJZg2PjuVtVnTcQTsucTjsl6
 miEwkpn4OnYluiNvdDeoRx+sofkfObLh7WLF9CAKWXwh4vpmx3xe+bQ3/l7Sx+RH6qM4XMdeszO
 uQJ2+au4LZ1bSowyv0twSMF7zl6UwWbVI7Y55/K1e/wsOVm2R+KH+uDvs4P/ZyoN97FvNn53TPK
 8g9lywNPtMQpnl7lvcHqOlEziBNb1EVmCgcMfZv3WNeY/jdMHlom/9l18BpDdXo66abiYe+UVE8
 X2gQZ04mGuGSubNXh7g==
X-Authority-Analysis: v=2.4 cv=KJLPn1Fo c=1 sm=1 tr=0 ts=6b04982e cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=tpM8CJlwf7uhpglF1g9U:22
 a=-7il3XB7buBOucKm-QsA:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDA3OCBTYWx0ZWRfX1Pm/YkpTKo7z
 lSbdS6bjSqfgBgipYEEo/HhSbIJzF7wOiGa0JHkbnpyMSXuxM6IDDWiIc2Ddll+fVwWOTWgY5O8
 1RSyxsRa/WnOqC6fINChRjbZNCkWPAM=
X-Proofpoint-ORIG-GUID: UPR0D64edlT0CorVs8DnZBvZeic-k0pf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_04,2026-11-23_01,2025-10-01_01

> [Severity: High]
> Does this cover the NDISC Redirect sent from ip6_forward()? That path also
> quotes the invoking packet, but it never goes through icmp6_send():
>
> None of these conditions look at skb->decrypted.
>
> With
> forwarding enabled, a PSP packet sent to a non-local IPv6 address would be
> decrypted and then forwarded.
>
> kTLS RX offload can also produce a decrypted skb whose destination is no
> longer local. One example is when the local address is removed while the
> offload is still active.
>
> The !skb_sec_path() condition already keeps redirects from quoting frames
> decapsulated by IPsec.

I reproduced this on CX7, with both psp and ktls offload sockets. It
only affects
ipv6 (or rather, this path is already addressed by patch 4, the icmp fix).

* server enables forwarding (force_forwarding=1)
* client connects to an on-link address using the server as gateway, so
  the server forwards the packet back out and sends a redirect
* the forwarded packet itself is dropped because of skb->decrypted
* the redirect quotes the invoking packet which had been decrypted and
  goes out

I will post a v7 with one additional patch that addresses this.

-Todd

pw-bot: cr
