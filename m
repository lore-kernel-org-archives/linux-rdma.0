Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794444717;
	b=iQ0EGjRzKqMgoze1KvnuZ/kL2T9VgXcMyeSJtLsCh0SArkKYtRQmKECfw2DVjrriLoaM
	 Lvp1wx7XV3rHxSgfjMmchQlD6o6ZplVaXjSgixUH8cKcCnF29WqWj5zt4U+/CqanQQUhb
	 0wgq2z0unTk0+qPR0wOj6r56LVV8ZTg3j0rMW+RMHPaV8LdaqbORf6bnoAGKIXC+CYHk9
	 vFgziLmtMLYkRSvo/tiXZ3oQZ2Ie5eI/VZFWSrE8keLTeytqMR/frqnNfM5fTUwXgReZa
	 l/mItrjP8ox94lkfOfJSQwOwgupZf0CqKXLfnuaP2NG+Vkkl5blU58Q3P5biqNCb8/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794444717;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=COvz1LYfsfnPEz5Rqox0HEgHvMOUnAt/U2EOg+WNlZU=;
	b=dHmiEVa22/IHFy2FoB9xjf9KcDKVdk7KqtqeGwqdoI/r1pK78zBUQo8GmqE+kUeb2UAc
	 QTnPDnCD/fkyJfXJ3zFuXQvwY8TlrzhrbD9T6yjZPg7BEsuF9QoTwhf5DL+9QrnSseVeY
	 A/XdCkm+LGs7WIVs6jw9gjRq33tuGnwjkw/Lja8vIuYr2oM3iFMCtt0zAHvDrr46IZmJe
	 kUs+WWblcD1O5FBghOPlljMJTCMoGUcT0zhsoiLLjfp4Zb18fDUIQd3gPHB8RWh6QO9Vv
	 KrccQlf8kci2yL8rvKLMzvGh4YFQEA6vGrWoGpyC50i+X7iHFfqXGwcqdPtE42/+5gA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b="M9reJI/S";
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4285D606A326
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:51:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4285D606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=M9reJI/S
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC032xs762728
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 16:51:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=COvz1LYfsfn
	PEz5Rqox0HEgHvMOUnAt/U2EOg+WNlZU=; b=M9reJI/SbRv3KTUBSw1H39UYEB+
	5lytBhF7hV4YQaPVXjAXypBnalL48KDk1A1rPKkW4JS7QlVjoHRcEgxDsnA3DkFA
	V060Ck2jnCyXydM8YqDn8C+78ia42U3pbptfzsZlVy9Q4snVD20ijYvY83yoTAm8
	ocCd0aFLyIXSlQmjSjI4EMdJy/wmj2AUKlRJZxWjN0PrKyVpD34ID8GoMpx8amwx
	sUFDPaIZYs7/+VMoJ2ms1f1pJNJM2ePMvINLR5wuKhj4NwbcNnaqKiw3F04xD0Hl
	fQXX3j31JGidEqXUi2+1MYP8OtMbJoF6w9Rm0iCvm3rpqRXC98O03u3+rog==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hvbxch32u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 16:51:56 -0800 (PST)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3aed37745bcso249914a91.1
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 16:51:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794444715; cv=none;
        d=google.com; s=arc-20260327;
        b=pVaLlmKQNljM2uF1uf6yc1hD4dsBISpF4EK/vIqWXf2RR86s69svzJaP30IEh8HjlJ
         GmbhRt0EVYRkL8Vf1LkMKcF6Lo48ShjRo+0G2scoUQZhTfjSfpjoEtvlrsKey0eC37bM
         ClGy4Rl3E7Ph2woWvDKiXooQshL3DaaycZR/dUwpn2BpfoRsIwYwKTPUzy5SGT61VYQI
         JnYdx6Y8Q5O5M2d9IvCvarYN9hJkYxJOeMUC+OZIj14VjtD3YwvBCGW6Mn3PybOOBDMs
         nefp7BlisW2SOl7puItiVF12lePIZ6mB1SNLvUIUSTzIT3bzhKNe0F1OXQAF5lVdulNm
         dBnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=COvz1LYfsfnPEz5Rqox0HEgHvMOUnAt/U2EOg+WNlZU=;
        fh=m5l/EB+Dh2Yv5FpoHbvG6xD2WP23r4i+AvChUYGRTHY=;
        b=Q3iMfFgLBdcy1CfvBwZU4M6qiTZodPvoVDoNt6Ju1D92krogiaaoQwExnLXP9yIeBo
         MCZoAAj9i7MlZKdxpV4tQexgvcBsCLvyyV+LsHLCcARPbkfhkbDDzXV4dJuhAlQXg0gr
         vvH7wOTgxSrYWeeUZmOeAVwolIUrPr63A1QAWeyyRL9V2oV/VCxrX0BVv+AdR8rSfF9q
         yBtHIyw8gJrKorBI7Hu9RX+qvPaKX+Wxr5rlN1MFcAXrRVg4/HyBm436VjvYVNgrF03l
         xJMwW+NnBHQiidPV3BdMV1Q6NkKSpKbtsIWcWqsG8lriUQWUKFAS0vVpAXC18tuPwlA9
         StWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794444715; x=1795049515;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=COvz1LYfsfnPEz5Rqox0HEgHvMOUnAt/U2EOg+WNlZU=;
        b=nXgf/J9stAHj+Bw7NKTNg1GpAyvAr3hndkYkTyngdYo2LRAXKelv+RdQeNLN7k0ncY
         YTeHMWJc3PppQU3iNVfCcer48RUVJqm0nM7hciWFtqG1xvLKzuIuklCSLugiZDHtViHC
         URezxsAdRZcphW4Xgx31/kG9y2nfFgSEiDNr53i27sUMEnw0pxNeFVUYqz+frD+j/NHe
         CnFl8bLrliRVomrqgNswVDSB4ZEgyBBToXQv2TntNv4bMpWoOW/ZWp81FWqIMHMdEaGy
         ElNeL0Y4Mf7e8A28MQXK1TSkzBjiFVM0SoSnu8Xkt3zYEKZCvRlWNsklJVypBxsxEv79
         g7tw==
X-Forwarded-Encrypted: i=1; AL+hErFd/M3MXBclL6tGkOQp9uWiBbWI69yG2KCwU+b0sz1nS0M2DGFhMdVdxcRxumDZno7opE/iL3n6ClpY@vger.kernel.org
X-Gm-Message-State: APuU4Z/VTYYlZTtSgVoc3oxu7Sz0r0UcZG2WEGUq2zbaYFxmH+L0QaBi
	fRx1y+qLe+S/Cp6/SmXXdsq+S81us1DPU7x1aTkPprP4JTtKiCsXcU7mhu7M1j8xmc9YWEOR8Ir
	I81rJlKf+zPM+HcUna0VvqGlT6JvH91JLkaXiTFJAt7sWneehkrxVAIlY5WBrHI6ObwES0d5LmV
	sItsb2gWR/DePeH54mivBfpltuzGzGV2PGhCBj
X-Gm-Gg: AYBFou19WGtn/wZRE9SyDcFgVCH9UvUI+RlL2jqf950zKvyDGINqFx/po+lMmzrjFBb
	jIXcznX3Hrmx5JjMzY7wppBWD46xWFoMHPRBKyA0MNrz+jDHBJNJBvyiHI0Uqowg2IBqICWwayV
	GnTLjnbbSUN5fy7C8L7KLf+ke9MOzHpZaf5xfeXQ/YM0srsvUxK/6bs9rBDXSxummi5LyTODTwb
	adxffKCesJlkq+LK/DzCvxqWxFQMw4Z
X-Received: by 2002:a17:90a:8c8e:b0:3ab:d26b:c2df with SMTP id 98e67ed59e1d1-3b197cadcdamr475953a91.27.1794444715021;
        Wed, 11 Nov 2026 16:51:55 -0800 (PST)
X-Received: by 2002:a17:90a:8c8e:b0:3ab:d26b:c2df with SMTP id
 98e67ed59e1d1-3b197cadcdamr475937a91.27.1794444714456; Wed, 11 Nov 2026
 16:51:54 -0800 (PST)
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
Date: Wed, 11 Nov 2026 16:51:43 -0800
X-Gm-Features: AclHuK_TCwMOAV1WvAw9HnkDUPDvVUUNIB0-FrcHVRqyh165RWlzsz9oCiRdiUI
Message-ID: <CADh2yMzdD3FSJSAY2+vJYADwRg704Ndqwz2DhAC3nhmyZe85jQ@mail.gmail.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAwMyBTYWx0ZWRfX9OMXVWkwCHs5
 1evyeOy8aFfDaUsR8r1NHWsvlWk/xYoeQ6cg+O2J0ascwptHncltS3jrc4Ho8INBylqYpjQQk/p
 ir9qp9eHiLd/OCaVXphU8TV7Afn8KySeAMJVWyRLql+EQSPxmDoPNxsryW6a2dAqeihdU1g4id6
 ijvjxJQucOtd/FdDBsOfZnVkamFOvwYbxPP9zYyn8SQNs9eiN1VxN9AU0NUHQvVmsmHszXcDck3
 y/dHVOfb63egTUNGyEPnp3nixe5foRbi+t1EOgVkxR0fphx2f8mlmgHlaA7GH5ePbm35j0f25Ir
 kifgtkMKypBFr/OlX4UDGiQQL+nnFkM7xEJKjrTNj5vS9mpA4iMpRxBgNkPDDvb4z/Y+2X4F8LQ
 0GGAGDuo7Ph3WO/ZJvFsFBbYM6JTXaOYXcdlxCj6SCj2vofIgYS/1qfX3A4mOBDkUlw4vssc/P7
 SlzsQWwwvBL1XFVw63g==
X-Proofpoint-ORIG-GUID: 9DPviHFdhll5LTz_9-ETmE-JnF34dkP6
X-Proofpoint-GUID: 9DPviHFdhll5LTz_9-ETmE-JnF34dkP6
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAwMyBTYWx0ZWRfX4hKVpnTta9gj
 h+nwVcGBIgcdqxvceJJlTHZ3KLmawD7dOK2+/6SS3K7ZBUrKVeYSCR8XiOO1FTZsm11SCSou3Ag
 LbLzBu48o6N7iy811N74emaQlKn4Hvs=
X-Authority-Analysis: v=2.4 cv=ZdKIpcVA c=1 sm=1 tr=0 ts=6af50dac cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22
 a=EaETVqjJsHDKXBk3jaYA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_06,2026-11-11_03,2025-10-01_01

> I think the design could be improved by not reusing struct psp_assoc for
> the socketless rx spi accounting, and by not placing the socketless tx
> assoc on the active, prev, and stale lists next to the socket
> associations. I'll try to comment inline to give you a better idea of
> what I'm talking about.

Sounds good, I will do this.

> I would create a separate list for the socketless tx assocs, so that
> SADB handles can be flushed on psp_dev_unregister(). Then you can just
> leave this function untouched, because invalidating the generation is
> only for __psp_sk_rx_policy_check(), which isn't used by the socketless
> rx assocs.

This sounds good as well.

-Todd
