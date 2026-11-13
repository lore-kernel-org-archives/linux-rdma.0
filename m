Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794596940;
	b=tUARPwqFkvlyyXojzuy3Uf/gpgAElJe9hW4xxSY8HwIzimFFFsZK5BvC/LrTjSKIeLk+
	 cc/jcbgsDjaH/cgF2BBVZpZ3m1V9vgOZOjUrXonM2l63UcUhBpd/CvHn5VXK3yVgfkOS9
	 pdg6lwd889xqcjGrN7HjiKfmwBK6iczAYgKrQnoBVyE6Ax9InpzkMS0HrxLhSfX1vG5nw
	 QFSP1xdrYGCD3L9SA1dz44Bc6Nj74rCRSuJvP6EFpMN7RhcN7hvluI2MNRB0M7PPAxWVs
	 9rb77Vu/g5ze34WVkOrprqr+mae5GAhzHjyaf+vVLTvy59l4Vw5UFU5HtgUJzApBsqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794596940;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=wMGf9TKkw2dAolbYMMRxX3h85UEtf4o2yarI4oY4daU=;
	b=IF85EoO0rEVrVJ/oiwp9iCNxt7ZYLoI0u8PFQO4FawaUTf8z3IIaJ4nLOo5ie7B5yXtf
	 d7eLm5Ca4UN9/zw/Sa+OYoZpwu/x/h6r9Tb8ez6HIPzxTNRhh6RGR+L5/dUJOiQvwhqz3
	 R8Gns1a58P5r617VNWfGWiPMGD2XXG2ZxwfE26aw/R063RdKJaZuCNp7DolXwJrOYrlew
	 ivhe1mAjxu/x3hbhdf25OK+Kd8SnaPVWQeuMBEIcU1mDt9okDZaDJX67YUyaenSsyWU8v
	 lMO2/Z6Lyg4ufIqN8KvDlJM8vIIUALzsDuwUL9TGp34WInReCejBdhf+rFlyGnSr7lQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=nOONlcMC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB37606A883
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 19:08:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BB37606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=nOONlcMC
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6ADIwWnU437810
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 11:08:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=wMGf9TKkw2d
	AolbYMMRxX3h85UEtf4o2yarI4oY4daU=; b=nOONlcMC8i4eL5z9MdkEXEZlwOx
	Vrvx+jYuO0AU7xRzGRrS3LpEi73YXmUwnlC/dOM+wJ1ODaYOk7bl6zGXh9sfmJfw
	MKNO6Sg6FOBmO6fyVJijB2yweyStubRKYP+YC5sRD+08HFJSgTDbMn2V2e8elqHY
	cir6/wisuzYvGcarXU8Wim98GEnpbLytImhbK0UaDptgWMMAdVa2EzVnCL0Fdt4P
	C8CwU6njpzc16OA1dki1A/QVsYaa2fr1OOoMTrn0yofhzM7HL6RF2Wow7f2tRuaJ
	2PYNcqU0vefF9VfhQZZYt3fhB3NxmITWzERS0MJE8hSc3pgEiPS+lD+uMlQ==
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by m0001303.ppops.net (PPS) with ESMTPS id 4hwh7ngs3x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 11:08:58 -0800 (PST)
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a1f03f2e8aso12090845e9.1
        for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 11:08:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794596937; cv=none;
        d=google.com; s=arc-20260327;
        b=FxiKJgNuyDj/65cCFM+B6O0OEK8VKp01BoXJz4G+xAoA3QDFfaXSnBP6bSQmdtQLJa
         Br9Nt4u17Lw7x+8ZUP1jndbaFo/5sewl/fVsBZwJcyFisAW0iqobgRxWdR2ymUCdlcQ2
         JtOEfn1scgiebA7C12NYS4vRqMcUH3nUplasxgZeWS+Qw5IuvQla1/p2c+Xk8TV96n2b
         KdF6BjKkBJ7wZXr0WgC2BZs9le7au79eke0SFLSN4l6qTbK9p6SweGDRcWE9UbRXQf+R
         jdr4se6CtUPg6FOAjDWMYiw9rf37nbbMC0+BJX8y3KuEZC1+Yl6Dm5MUBC/bBt0X23EF
         kMvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=wMGf9TKkw2dAolbYMMRxX3h85UEtf4o2yarI4oY4daU=;
        fh=sa4y+oQ9/VIc/SqiO1O0d433tP+tauy87gPP/HY9FQs=;
        b=bgeB9cMgfWYE1wvcT9LzERQTn0/J+yrIoo0PBMNgB8CJ0as2cu8juwZWX9htaUZzvb
         qpBPDYE353u1ccoW8M2sRH66lHmkZK3f4TOg6bo+FpR0QOrZlbrZPoaxB91IDNirHmej
         5SuHNIjEd+NtkDpyiM8vLVvi9mD4Q0yxnj2Qk1Bl0naGCaVgNgdi+yiuicOMcimwylZ8
         iI9XenTwKWlwoThPA3Y9KuQbzPtmggFvS4KRnuwjHt6cYhngi2A+YG9F1NgDK66XGcuf
         1zxW0bRfNoB6n91KEd4Dkp9w1nf+/jhb+zMz10KDjgM9OLtijhlc+EIJB2bwONyWLAvM
         EAZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596937; x=1795201737;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wMGf9TKkw2dAolbYMMRxX3h85UEtf4o2yarI4oY4daU=;
        b=FjsC1SmkhoAgQ46Rb0FSE99AvyqvSkAxVVqjlBUPFqn3s7P2/9iY0WyBZDzJHzBH8o
         TcJnYmpkd58xgc7bqIMxVaG52APqvpwUOceywdMKOlKzQHhehumRYHHVhcW74MSyBZmd
         VQezmQO9+21uD9A2J1tR4QjUDbklIEjrZhfOiZtFvpiMJsGq5eWCQgyovGRcPfloIswf
         KBbn5F7dqPytOzlOisYun0DkNkvsaT1XL4gwCKluOGL2UgAiM2BjE9fazcSgxcEYKdSo
         oqNEpLveW7lYBPhvBK5FkN1FIQYSAiBD6yyWSHBlZzUTApg2tze4RY4WoIsa5uZrWFkV
         kYPg==
X-Forwarded-Encrypted: i=1; AL+hErGQS7LjSHo/1gQ9TIJq100VEHGN7hz8ufuH7bQHMCXdn5CBYLr2E5WozfnlPOEFbKfOh2mWSb6tm+68@vger.kernel.org
X-Gm-Message-State: APuU4Z8pnwWTd7/ImrJBscRkAcrS1rAdqCXcSHdpMGTcCs+SZC44lKGm
	Tjs34tXzdoYD3qYAQlX2GGAfwb8y6CQG3EdNAZ9TNhWqMkLlnwXsPiH0uYTJv7536r+8cjsVhOy
	lOkrrz1TQjcmd7sPMsdX/ExBza+gCyTZa7SxKmZklmz6RcSP0ek0jp/SVgb+xUj2JcxI3NHBl9U
	tPlxrfumbPhJeGH4ipkgXHUxpZfmdqzl9Pua0q
X-Gm-Gg: AYBFou2jBBegYCbgDapTkNz+xqrZuaAKvoL6m39IEB/Mz8h5SV3WBgiOywxckRTpjM0
	ILUIGNXd7nytDBpKeyLMZG7SOX/R1QDCI+kEh4u+R4URbocY7crb4dwWnYdFYzo3XG346z3ps7V
	PtDl5ZqckaUSz8nRFW22Y5II9ou5p0XPE6BOAOfcc2yI28YBuKNnLkfO+xdrP8Hqliiv6InDdIh
	bswdE2572nBLz57UyiFJ/73WOc4qufdNjch
X-Received: by 2002:a05:600c:c172:b0:4bb:5f07:10d3 with SMTP id 5b1f17b1804b1-4bb5f071385mr25701165e9.21.1794596937137;
        Fri, 13 Nov 2026 11:08:57 -0800 (PST)
X-Received: by 2002:a05:600c:c172:b0:4bb:5f07:10d3 with SMTP id
 5b1f17b1804b1-4bb5f071385mr25700845e9.21.1794596936812; Fri, 13 Nov 2026
 11:08:56 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-1-toddfreed@meta.com> <CAM0EoMnPM54re5-WKyWgwyoz0cn1uGT6=E96OBG2-4m7M+kx7g@mail.gmail.com>
 <CAM0EoMmrRrmPdXPKyiQgEHQSb=mq3uYfNc69hEKw+Rw1EQAzmw@mail.gmail.com>
In-Reply-To: <CAM0EoMmrRrmPdXPKyiQgEHQSb=mq3uYfNc69hEKw+Rw1EQAzmw@mail.gmail.com>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Fri, 13 Nov 2026 11:08:44 -0800
X-Gm-Features: AclHuK-U0ThzUJNaBNSfjppeRsNnyfVDY_cTKL9afgrilY3k6R5ZNeb33jtLtAI
Message-ID: <CADh2yMyJ7Fgtv2BAyNpKFkBC6YRC=Z7kOHSiBcH6kTqcriWL4A@mail.gmail.com>
Subject: Re: [PATCH net-next v1 00/15] psp: introduce socket-less associations
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Donald Hunter <donald.hunter@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-rdma@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
        Paolo Abeni <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA3NiBTYWx0ZWRfX03ZTmee2kE6v
 GrUxETk3QDTTbNv9CFLP5Zqn47v8Af96/XW6nNw9nljL4KuKldoK6pY1YewwkvrwJlJVHq4EUUH
 GsnA6/XtOXQb0H/LfjWOaHlWCHoTT9Y=
X-Proofpoint-GUID: YuumL0VJvIOZYrDQ5vu-JTDreNaYxy3o
X-Proofpoint-ORIG-GUID: YuumL0VJvIOZYrDQ5vu-JTDreNaYxy3o
X-Authority-Analysis: v=2.4 cv=R46WitRX c=1 sm=1 tr=0 ts=6af7604a cx=c_pps
 a=Ech0Gv1thIkdqUNjVc2Ehg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22
 a=c92rfblmAAAA:8 a=VabnemYjAAAA:8 a=V8I_lJ-4SMfPdcaXHV4A:9 a=QEXdDO2ut3YA:10
 a=GvGzcOZaWPEFPQC_NcjD:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA3NiBTYWx0ZWRfX1T5YNtYFIqKX
 riDst+PFaCvO8jV1eNvHk4iZ7K/+ohb183Z9ttvk3cOEnpck7immdLDdq02J2JWCwIEX5olpeQT
 bOB28LRH85A6rq7AtHX+KY5iJfllPGT20bw4Wmlh56zvkK5ZDFf0v+jooZLWnjIpegwq+oOAFmo
 rljkvjypehHqJR6kbcDdb4lQf1BVukFMkTU9oprj07Yj3AZUZ3NbrmOjv0nqEhfuA3pAgO9sMkD
 coaD3sOvqwwtSfZ9vQ7wC2RiHvtfHtg5GYU8P/AVodkx49GmJP3BjMUwdohhvQhG9elziNjt2nP
 EJNJa1b2qA+fJZYFl18v0tP/gnezinHZiq/UVL6uBie45W6rRII0N0ZR+hVso+lkQ+BU3vkSymZ
 bOpdyGniI1Atv3Zxx0NuFTvPZwFDwVeOSJYaQYSt/Irhw33aOh+wySCuvaX/KRnLQ9Aamp0fpyF
 8YYPHyC53NU7BBGKzcA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-13_06,2026-11-11_03,2025-10-01_01

> My bad - only one of the sashikos (gemini) responded. I suggest you
> wait for the second one. I think it watches this gemini sashiko and
> tries to come up with more clever findings.

Ok, I will wait for that before posting v2. What is the best way to know
if that has happened? This posting is from 3 days ago so I would have
expected all the sashiko reviews to be complete by now. Let me know
if I should adjust my expectation.

I think this is the right place to look

https://sashiko.dev/#/patchset/20261111005533.6436-1-toddfreed%40meta.com

-Todd
