Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794421450;
	b=iVT3PB9jVghMEPYWZjVVg6/yta0DNBqhOxCjkP4nrxUirYnHCGqK4xa7m+wYeSvlE7PH
	 2gw14W5ZXeEsvAps6zcRSkB7aIqtOqlo0/U7N4yOQuSJOIh6tidQwUFq+0ZHPdo1kYsXm
	 y10T3j3DniVgxMu0+c582Kjb6jrZByArh7mtWDAEoTvtqEhTM+9oPU/X9/Tdd85+gumOE
	 lKYF7zzFPfjZCFaL4M9qo+JqfsE5efgHiCcPZPY7aYuN7pCgdCBkVWaidcd8VKFewXzG5
	 jHIDQeTNCSIKz+MbLPjnDpd20qWU1w6MWKhoo/Ob9Rre1fbycRh7p3x1KWbudeqLH5g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794421450;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=aMG9NSIoryJ6ZmHzBOTcIKDBni97i5hfecL1FAmnbM4=;
	b=Vbi9g4VcIMeRoQLIe/Wc+RlBSLJz+LZvBeV4nilzrDHOPXsnawHuQuD8hwWPPo148Rk5
	 P1btxyBg/uNrebJd6qLu714r+9YyYsu9srD4xYTeRDm3LXZmBZpFrGGEQkLqp4pA4pC3C
	 hSHHjDYry1MwodLrFOJ8mEhN4QKyDTUxs0UNvOjuIPn5sSBBHG6U1qWlMEMu0DmQ4TY23
	 sry9Olb1fyLfeMl59zMoJ8//8YWm89MJ6FMj4kjBAp+QiTgYu7kpuXz11DGnd9TYN/Lzc
	 Bs83mX7GDI8mFzznwWJqICuody0Rsl5Y1k049y75OsZJuCyuE1MLSbbTl6/Pw3PstkA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=isns6Mqh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D8B606A887
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 18:24:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01D8B606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=isns6Mqh
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHtMR94161036
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 10:24:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=aMG9NSIoryJ
	6ZmHzBOTcIKDBni97i5hfecL1FAmnbM4=; b=isns6MqhLK2gICBmvsfmHDefPrM
	fcse+kjR+dgFtXbRypDtqotW1Yl02H8zLF60ugJCdMKKjv2bgp3/FfDVbtAj0qPL
	nMdiMIQxDW/X1fu1xFPQrqO7h+9kKGnsak6+fIA8XRHkd2ZnZxPL61j+PZEgibEy
	nBb5hifSwAd17cHCObGIGWr6WQCyzXxmQufY6UHIk7KcX4LXVPfTsiACYBolCFv2
	uZsIapcgbM6aipiYch9uLbCT+xrDb7WMyVR20uj/cvl1DYR6dMROu6AKFq/+SWeu
	7vwmmqM2W1TLALIA4l+/gOuarfulif/2FeT4KQUkwmvzHlyXdH6HmkOe6Mg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hvbxcegvd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 10:24:08 -0800 (PST)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b175a69ab8so2093590a91.1
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 10:24:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794421448; cv=none;
        d=google.com; s=arc-20260327;
        b=rYcDt9j1gJPtX8rysTaOQX0VDfeHj0Mk9UWehjy4fnasUEtf+D2Qp4Q4ug7WmWOxDW
         x6CtQCuBqP7+RP7/aWr9b1J75ljJBhxsFi4mMwV/OCmRUTU2eABxHCHbpZo8gZKDA8No
         WKm8zWID6bzAEiphQ6qIE4GPpQXC98/IEHm042UTy00k7fDbR1Hk+JiPipj67PpTRR2P
         FTsXT5Y5QveUHzuO+9Kfr2ow9QmlKoAB2VqYzIs20aN3nZhDtMfy3J1CGjuGl9fMSy3I
         MTpFg/ry5oAsPs46NK1LsdEaIwXBQTXeyty93HKjb7ZqaPW7NGf87YQa0HRye3UT1Tak
         rU4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=aMG9NSIoryJ6ZmHzBOTcIKDBni97i5hfecL1FAmnbM4=;
        fh=OryKfNmImUCYdiA7YfzXtq+JR6c36UaEvcah7chExt4=;
        b=Tltvcm0TdAYO5NeNKtnEOcqasqO69NunQkrFdHCs/RO00sXXu8c54WUaVagyKQ+ERq
         J5teNvUweSAe8PEM8dhnMuYT638j1QKufePXgRAgRmL2B28syupi5iAU1hIBzpmXyMBp
         aTsOHMVP99vSxjjZq7SYLaDM7epFBsuOku5OHfiOBEXzg7kXXO3cyGZvHTqvMF/wM/6q
         hoCHoc5Q++Yz6vzg8MKOgperlVq+00hLCr4479MSqkeMI6v6d34MlSC3udtKs1h/1Lc7
         8Jkzdbbp6xlB5s5DkOAcmzRQOUNIjAjJCw9JXPz3vLP7yH/kA7CmRi8JIa58yu/70mxz
         GKCw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794421448; x=1795026248;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aMG9NSIoryJ6ZmHzBOTcIKDBni97i5hfecL1FAmnbM4=;
        b=W/v07Dwj7oayTpWZIwj46IHSGPxbCBQc1uHSZsqy5tk4Urtn7v6wOXHFyGcNimL0j0
         zgyAm5Imheh+F+oLlcFgVV1vqcnDL76h95ET87sfkPMk3zutzoCkxb8HYoIpPZhPLViV
         3BM48VfFHTrIKN1txPsDyEjcZI5OFFGdrd8zv+VSyVbiWe2L8mzAUPueZqvL9TWJh39W
         +9gFbeFtBRUqai3wxMxnOpucS4GmHgZ1Ze34Rlse1Z2kUq7u6K2707i7TETFSV0MRmL5
         5Lqd4EruWuSIjpOCIKXInhG844doyf+UaZPXh3dqYW9c8+fDpes4Tg4kdE6AChydfnQk
         Dfng==
X-Forwarded-Encrypted: i=1; AL+hErHsP5iZPPpsdS3ualwPaJjAbncNc2jDOgwal9xN8Cs2VmLId7/KxJ4n/UtpR84zfWBz1Tl1g/X/dHwn@vger.kernel.org
X-Gm-Message-State: APuU4Z9aaWoyYaOXGR8tmNZy6kux2jO9pCyG61Putf4ytsfzSNHr+v8N
	2WQ55sTBqmU2R+e4JTjamBcyyWFNadIAw/h5vTa/Hhph6VqOf4aOp9iSTmyw0ft9e7GYbfwuCFN
	yQD2eG8ulGI5QXjamkhm8RLxbXefOBoswhuO8BNYAiP2bz9wesD3b6v6322QbV6m4aW3EMi35tO
	BZhaqfOrHPOWPglZmgGS1cXcNNlrd0sbTpHktL
X-Gm-Gg: AYBFou3/NAqviTN3qgtaDvfxiyQ6DxEHfmKXXPapMHC7cGKpJ2lkhaAZim0Hz11VSPj
	ARluzSmfNOqHqHQqhQISdtzhHZ/gbSkpDlaXvZnenovRjzYBW5jhvsy5CH1PrcbunouVfIkRenf
	uk/uid5LHo5EW+84QG7qmMmoBIvUuNrPf8QJQZ28yLKVr53PpQaITvwBkBfK0JWwgXXhDSQglvK
	K260MjuqgRi2huDlkGvDlkJyA3Uqy/+
X-Received: by 2002:a17:90b:2f83:b0:3ab:884b:65a8 with SMTP id 98e67ed59e1d1-3b182eda7efmr3257435a91.26.1794421447563;
        Wed, 11 Nov 2026 10:24:07 -0800 (PST)
X-Received: by 2002:a17:90b:2f83:b0:3ab:884b:65a8 with SMTP id
 98e67ed59e1d1-3b182eda7efmr3257421a91.26.1794421447127; Wed, 11 Nov 2026
 10:24:07 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-1-toddfreed@meta.com> <20261111005533.6436-5-toddfreed@meta.com>
 <DMSJB8MZZCXK.MCEBRZQDAM5Q@gmail.com>
In-Reply-To: <DMSJB8MZZCXK.MCEBRZQDAM5Q@gmail.com>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Wed, 11 Nov 2026 10:23:56 -0800
X-Gm-Features: AclHuK8_olqmA7fXTYgEAj2-H4kgkwQj_X0uL-xyG8nZrZvhci79BGaB7ila0uo
Message-ID: <CADh2yMx8MPjcH7Bpj72rNNd_tT=6uSC5Ow9JyGjTMjFgs499Pw@mail.gmail.com>
Subject: Re: [PATCH net-next v1 04/15] psp: add support for socket-less psp associations
To: Daniel Zahka <daniel.zahka@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Donald Hunter <donald.hunter@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-rdma@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
        Paolo Abeni <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MyBTYWx0ZWRfXzxgbdKTCrjq/
 wzU/DzsoVa9mOm7uXxlXicxctMYbiVYsmDwVmX05nC9NLXqvuFy/PGtUGmFOJpqLGSML8JTQxYt
 VLXvqzqe/XGooq4kaQ82x7Ku9SGwxIvzJFH8kcw3+Lvea7qhRu0T7cSZKYm6h9WcA3WXemJ7tAQ
 a7rFqkFbUlbazksjbG3d75c4rHRGuv1RoWQrvBQaXJ/6DKkR5ZTFae+7aofze7psLkdeZvCGvkL
 FqyyHNh3frZvLgpQAojjmoMdCuDSwZkRF/uUCST4bjc92iUWxAgOeqcdU/POuT130IrJgdj0a0B
 zPt3Ix46le2Cysu6oXj6m4vrsOlE25bexX/xxos4Fz7W49YHruYTNCQ4TRrZeI2fai7zqAJPNlt
 uUXVhlTTSOBQziRDXuHTmQu8vfcqDNatqXSzS4T/iDHNBIfD18egmDwhx1tAuvN9KCoQlmWcmx7
 IfucGIBL45w9EnPHSPQ==
X-Proofpoint-ORIG-GUID: 4zs45keHautBuJBccz5J4ghA1twh3wOG
X-Proofpoint-GUID: 4zs45keHautBuJBccz5J4ghA1twh3wOG
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MyBTYWx0ZWRfXz3TofS7tAzq3
 VwYyh7a7/2SKI9uM3oUevtoBNYOFDsymMpn9rcAwnsaQoKDb/FODwAgtQKlYWW2oLNPgRcGC6lj
 WJO5J3uPnbqGzG+W4/zl5LBChCnk8fY=
X-Authority-Analysis: v=2.4 cv=ZdKIpcVA c=1 sm=1 tr=0 ts=6af4b2c8 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22
 a=-xR6GoDS8vL2zpuMsZwA:9 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_04,2026-11-11_03,2025-10-01_01

> I'm not sure the kernel actually needs any bookkeeping at all for these
> generic rx spi allocations. You could probably just pass the spi, dev
> id, key, and probably rotation count (as a device key generation of
> sorts) to the user without creating a kernel object. For socket
> psp_assocs, the rx state is consulted on the datapath before queueing to
> the socket. For tx state in all psp_assocs, there is the possibility
> that an SADB handle needs to be cleaned up. Neither of those apply here
> or in the rest of the series as I understand it.
>
> I figure the tc ingress rule can just take the spi and dev id by value
> rather than needing a reference to an object that we create here.

That is how it works in this series. The tc psp decap rule (ingress) does not
make reference to an rx assoc ; instead, it should have flower matches on
psp_spi, psp_ver, and psp_dev. That effectively ties it to packets from just
one rx assoc.

So why keep track of rx assoc objects at all? Two considerations.

1/ don't accept packets that correspond to a stale association. That is, even
if the device decrypted the packet, it should be dropped if the device key
which minted the assoc's SPI is two rotations behind. For psp socket offload
that is enforced in __psp_sk_rx_policy_check() with the pas->generation
check.

The spec permits SPIs to be reused immediately after two rotations. So the
device could decrypt a packet with a SPI that is more than two rotations old
in that case, or if a previous packet is being replayed, for example.

2/ hardware offload. the solution to #1 should be able to be fully offloaded
to the device. psp tunnel mode will be hw offload only, and is implemented
in the eswitch with connect-x.

We could add a psp_gen flower match to replicate the pas->generation
check, but the device has no access to the pas and can't offload that.

Keeping track of the rx assoc means that the kernel can take action on the
"this assoc is now stale" event. Possibly by enumerating the tc rules and
either deleting them, or marking them stale for userspace to reap.

-Todd
