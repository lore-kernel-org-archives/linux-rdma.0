Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795029316;
	b=BukKRpQ2V+I+TE4WUTWn27N9vGg5TeiRUkmlimC4Ecx2RJeOKIXCQ6S5a2MdfMmiRYTc
	 /dJWUMx4rKREc8MhbkGBuIr5hIxTDo/t4CbnT9LMSkVvXNKgzBA8u5xXuMKox2vYZpN4I
	 G6QTDyVXIQKRSMeQw74mP761Mrh03hqH6uoU1bXxU199iUL91Mrrr51EUZJ5L4YrBvmhJ
	 FiaxF9DwX0F7UV2puSshblGE8tR76u05FimqTM/EqlpV90b8Ce8/ff59NlnK48yTV9wBO
	 2p6iN2Yi0Tjhu4+xBwGFlvAKLHuYTs9oPVZAYLP1e36aEEDLLiQjsx6sDk5NARUShEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029316;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=+xA+qBnR4DhGTpzy0NbqbmSwtcknsJxtpzKOLUxHJh8=;
	b=I2cTaIhW+15JuutI+Neupg3MFlpo8PVhQ2PW6W58Zu1zcYD23jEcaITe4IqW8lDu7B6R
	 dxH3W0zGzLRTaOiPwUcp5C2wbtTndU7sNcecGcn7UaLyND2ETTwUCP0mmwkulezO6Ak6Q
	 ZxBCcCmhefmAm+YILwA77zdON/NO/wS4f3xumbQIS4c5Inwo3/+W9haoS6D/178C44NnW
	 SpQShdtAhbAELPU990JrSGg9j/+jIEaZz6BfbBkUzGNCNtJkX60E36G3ezTTzbFq97Qtv
	 BofnVTcYYM2yeNpy+FBxmQ6PFe8glhKUh8MFkkFSDA+Tiwm2SbxKjsr8BVp5Hm1Tb3Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=CI0coo5M;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41000606A334
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 19:15:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41000606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=CI0coo5M
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIHGJuP154243
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:15:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=+xA+qBnR4Dh
	GTpzy0NbqbmSwtcknsJxtpzKOLUxHJh8=; b=CI0coo5MCl6PeMetoQwNQwkRIbu
	JiJgmxit9cRt2nDJWrdAARftxPhoMHNyIVJskaAed9S2yJwVu7Ra0ZkweQuyB5yF
	guA6b+B7Ror/Ay/Qt7H0gVuOq2ynwudmNifTkBxQAYnk71ts4xr1AaSkk4W+eOa8
	idyTtCCV0m4sS5SbBYGeYAKxD77vl1xiK52a0aXDUovzXZHhLZIrtRdrfVhCe76Q
	12cyZpAXp16EprTl+WZPucOgkRXsuml9kXyb/gOq3sIF+GsDHZrnxqsx5q2OGKk9
	Lta3g/1SFu0Ht7eUlEGwKj9v2nyojzUDtpEBFE/6gMcWgBLoOUalALEMPcw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu808a1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:15:15 -0800 (PST)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8b7cc3f8a4aso1026461b3a.3
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:15:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795029314; cv=none;
        d=google.com; s=arc-20260327;
        b=LM2hZGxsyNzhXc6738JIJGNuGtTRjRCoUVljXJXU+zOcQquibPRvklIWSdx/b8C8xT
         KE3wmmRK1XsZg5jRIKFU4QXjiKsidvwnKSogTYCxuRHLDcmIsqiGkZ0MUDq6BVFwQJ67
         306himYN4ue4F57UQeXffI9upcWzNYpjIzIDyIfgcfzQGy4q6zIyA/AIJJ5UL2MR5fo7
         GXPG6JNFX0/8kVARbvT4Vj6gcTKAOEkDBSNpDaKwJcQ+oZQ+Q1Jl5HNvtmqtc182G+CS
         84jSa4TxJU6UQ3uZa2ugMk/UfWsVO6Th+JvanFD5R0DxGUXmIcA15VJQMvndg2bQjnp+
         qbDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=+xA+qBnR4DhGTpzy0NbqbmSwtcknsJxtpzKOLUxHJh8=;
        fh=xkc+HWZXCznach4agIJmuFj6F57q+ukwxEDw7+ZRkMA=;
        b=dPtNaAGqbfnMyCri6x10ePogOEn76FF8HomjRDw4AIp9o6DW32B/Np9856jgIMyGZx
         0LjhLQVBkAEFiDJM964Z1IRsgwi8uvvIs0Ac7LelDXla8XULKMdmovXHv4gYdRootSMA
         qiz8kdYCQtCrO7f1SFSGwl00y8r+cMWT6V595n8PtCVi+n73MC2+dA6wvxudl79fcsqh
         RRSA0GaIfVb2vnkSSCqTfz/Uo6d6BxJnTOWOUF4IrfexKl2mODHCukPcdgl5mnbXUg5D
         YbnIX0QiVsWD8GTS/+7S5rPcY0nl/KcFFZUQIZ5KHVSgSbKu1fN12UeXMo+2KdeKj0V8
         SsyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795029314; x=1795634114;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+xA+qBnR4DhGTpzy0NbqbmSwtcknsJxtpzKOLUxHJh8=;
        b=bDZUCtqFF6/ovwYTsyeItwGdL0E4ky7Qb7oPjIuvvwJA8gZwEFffx+9/IJmRlUtn4B
         QCWnOvxsJLSFeH9I9ydFTnqFAYNjoo1AUuDA9xj93ErfiQlSb6LtSKxzakKto5W8UjWm
         5kb0JH0n9WKd+8s/0ZY88szXjjDmSMazghSgUbbjmO9ix2rB+/8zUexV1X4TO8YfuhiV
         47hB6fTd8l7O87of9hp6ICFwH+Y+uGjKZZnMK09Lm+ySUSdEYMljkCXhoIAZN5ouHc1N
         zPnqm3u3hQlEk0ew7Jcccv/t4FUY8g4MUzAeSAvbaEmGPZsjACSu/f685qphs/GY8I8W
         KitA==
X-Forwarded-Encrypted: i=1; AL+hErEqxs4+ZE8TR4VM+weA1ReqpItpde65P2vP5PsrO3USPl1Hkq/5Ril1yuvrq4JWhtlijNJ2/7uwsVVs@vger.kernel.org
X-Gm-Message-State: APuU4Z/PYSzuhReAdKvd51Rs5EvCJ0ARJ99SsoJ+ke1Eh/T6pKehlAhz
	7hyFpTEvnUpEKFihjx5Papm4WuteVv3MGLLYKA+eHXiXG71qlP0mzvifVgfDXg7/Qe7cW0BMWfs
	0wzEKUjhkLkQwXnbMYZhBF2TQsMJmgcdXh4TTdK27t4BRdh+fO+cuIXCgEeBuDxe+UwvbwFk46/
	sfux8YZX5GoAal4SPVr48RJSMrAs7YAaIDG7ZX
X-Gm-Gg: AYBFou3Rm0IcbnorNyB1ElsjQBrQZdqs4vGy6Aadk6qGbPXS7F4eTVlgV+LVSB5vBUr
	1ZXopw16JqRwhkJuKk9eyrzwRlfMuBIgyfoHWEKDbtlXq7aJ6DOvVrl5Wu+HDejLZx70hRXV0Ra
	olLQDvsk4PeuBzv5kGcB9n5Cn0oMXEU2B1KHbkga2kWUMeI/w62UTS0D3R4u0OwkTDJ6EiBOJvq
	67UU5mFfDy1bEXqKEivrm9qUsQFzhiU
X-Received: by 2002:a05:6a00:32c7:b0:880:e4a7:b1aa with SMTP id d2e1a72fcca58-8c5d46deeffmr3344619b3a.55.1795029313737;
        Wed, 18 Nov 2026 11:15:13 -0800 (PST)
X-Received: by 2002:a05:6a00:32c7:b0:880:e4a7:b1aa with SMTP id
 d2e1a72fcca58-8c5d46deeffmr3344573b3a.55.1795029313133; Wed, 18 Nov 2026
 11:15:13 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-1-toddfreed@meta.com> <20261111005533.6436-8-toddfreed@meta.com>
 <ea8a18e0-12cc-48e0-903e-325a8ece5a0f@iogearbox.net> <CADh2yMxffQ3cywT3aNg3SkVfog5CFnUSp34F1esyun-xUBVa9g@mail.gmail.com>
 <4d271539-b2f5-4fb9-a4dd-32becd02ce5e@iogearbox.net>
In-Reply-To: <4d271539-b2f5-4fb9-a4dd-32becd02ce5e@iogearbox.net>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Wed, 18 Nov 2026 11:15:02 -0800
X-Gm-Features: AclHuK-4R9Nf7O3FLY7hrUyXB1KdmwvUFFQk3aRrICEDQQcjmr2v5AAMDg1nX5s
Message-ID: <CADh2yMyo1VCNKC58oJiOLJ2NtGqAFQfxLY3iNbP5mtQhaFsR0g@mail.gmail.com>
Subject: Re: [PATCH net-next v1 07/15] bpf: don't redirect decrypted skbs from
 egress to ingress
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        bpf@vger.kernel.org, Daniel Zahka <daniel.zahka@gmail.com>,
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
X-Proofpoint-ORIG-GUID: 3pmjaJCOun-G9WeZn_lBewyYVX-YVucK
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDA3NSBTYWx0ZWRfX1HAy0OhfaltT
 3ujnSw5pRGExUUW6Uv5QSQbeDob4GRb+nAh3w3JyBRr+0/be4UioO0App6/xUSpSe+oSDXsddCK
 48XDQyqadVBfx2R0s10PiuImtuVb+NY=
X-Proofpoint-GUID: 3pmjaJCOun-G9WeZn_lBewyYVX-YVucK
X-Authority-Analysis: v=2.4 cv=MvDHeGae c=1 sm=1 tr=0 ts=6afdf943 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=xtH7KyWI9dI7BmFOsl-x:22
 a=DIuMb9_t4Eg30DVr1XQA:9 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDA3NSBTYWx0ZWRfX6GyFVmtOkXHP
 pa+KSpp9KZKFesM9/a9nAC0X2vnOBqn4IPsYpcJQjmWP0dJ1Zx3vZygvU+bJ59aR0gEoOnDnoi0
 6XbHvlA/fMMjZUntkZXJRHHK1amcZkWcaXtVOIRNf0oXd17rwova499gJgUE4K6kqlBr9yHREaY
 JgQhNQPtjpvRySRdYx4EzRVkcWc19Uv5HFgbPtMfb+QS+Q8fTwO3BNpZBu0qB5Xe4bP+Ym3Q5vy
 LUoGLKi8/eW0Gd0ILHlyPsOjeXRxTjaWMP1QG441EG+zokSelsFtMNhvqH1gVTKAJJ7B3G46R3G
 4/aSm64KaA6pmYu5hOYwU+I5QxbeZSX0HnSTxZwNPefQcOu6VHxN6F6e05MY1K4boqBqMXWfPJl
 Uil0k4S5U6LUtiuY9nospt0RDX7byX6wrEhtbFGe0exn2GGw1rqDU4Zsrmme77QEnCjikHhP1yD
 xWauaY8YeApUCTDqNwQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_05,2026-11-16_01,2025-10-01_01

> But why under skb_do_redirect? I meant just here:
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 532405988fd9..ba112111de22 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2471,6 +2471,8 @@ BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
>
>          if (unlikely(flags & (~(BPF_F_INGRESS) | BPF_F_REDIRECT_INTERNAL)))
>                  return -EINVAL;
> +       if (...cond...)
> +               return -EOPNOTSUPP;

Yep we are on the same page for this one.

>          /* BPF test infra's convert___skb_to_skb() can create type-less
>           * GSO packets. gso_features_check() will detect this as a bad
> @@ -2563,6 +2565,8 @@ BPF_CALL_2(bpf_redirect, u32, ifindex, u64, flags)
>          if (unlikely(!bpf_net_ctx_get() ||
>                       (flags & (~(BPF_F_INGRESS) | BPF_F_REDIRECT_INTERNAL))))
>                  return TC_ACT_SHOT;
> +       if (...cond...)
> +               return TC_ACT_SHOT;

bpf_redirect() does not see the skb, so it can't check skb->decrypted.
After the program has returned TC_ACT_REDIRECT and
skb_do_redirect() is called, is the earliest point at which the policy
can be enforced.

-Todd
