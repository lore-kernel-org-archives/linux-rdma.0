Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793123890;
	b=hRinl6Til32PfX6FQlY2+wkkjuTG67xJH37GzAo0gE5gZMsEVSmF1FrDeY/hSSBVUJmy
	 +uuWDh2/ai9AdnaDEnm8bZ5SANM3nsF47S5uFJkr1DG+Hq3jjlxJOKlZIH847fk35xXBS
	 oV7Z6qmm9h8X30zhyAh2H+UuEtD1eN/0QuoDdOuueqvWdjgAwwQRfqLyw71JkBWz6mQ9L
	 CfyAkp6a0hq7ury3m3QVqq4/44CHAIzF/J0Xcw948rdMAjQgCiFulZ/Dw/YFFckOh4cIm
	 e3sQEtpWKwvhXO7wdVBPzB/EOlKo2Vuzk8NCC8dH/aw9BwCH5kKQSil1ARzwLyj4AIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793123890;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=1SLwWY5nhyzce/BMXQZLOCKP7mE4tnUfLqJlnWOr9C4=;
	b=PlDvBRdr2C4Z9xTkycaM43TrtIz4sX/Q3zlMummCXJjum3pL6kb/rBfMgx7rTUJivSBE
	 Ew/IinGYNUq+E1UAx3hR7coDHV9EV0D8RSCDqFxnbl6OBe119A1jQlOoUJbsNUB7jf4n1
	 hn+OZfh+Gm0QaaLQg5SnF07oF5YFazYhDUpAv781u1v7iGYP7aU6Kbd1VSNdZKHwpHaJ1
	 FxH6FPM2eo48HBnpqQ4smj6pQEMZMX9K7XK/beBOSYI1sLEPfCYoA0RQkKE3Mk2nS6u5k
	 z6RpHbqXIhA7+ce18edEb8cU8Cj82X+0Y1b8lddcXIQ3bvf0g0JCBpDtONxlov2t44A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=IW8i35GR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E34606A31D
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 17:58:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4E34606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=IW8i35GR
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69RGwmCl2624049
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 10:58:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=1SLwWY5nhyz
	ce/BMXQZLOCKP7mE4tnUfLqJlnWOr9C4=; b=IW8i35GRgMONClqZI2OvdI+YMWt
	lbGNBCfDtJu8Dc/fyucXYPugZHQ8NiMKoVfl37wOvnt1jO8E1i0HqT5KdUOLN9KU
	xzv6eowT1GeapoSuHMktOIYQl+bD6u/tUHXJJAypgqr7uU9CvsbXzTB3tIatCvjl
	AbI2ALTb2EZOdpL+elkTE9SsnhiBeI3nFDjzW4x+47l9XFcO9EmlFHXz1rwzWuuF
	SHS2s+lWCD77gihNNzffxu693UkpGq3Dm5Dn/IoV37REIc9nDbKMbLrDuXzSllOx
	48A8MwWWKGoWl+Fv98Z5xBMaIFaxhn8IQLoo6birj4rZq7EZD9LNbaAda/g==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4hhe8hg1rn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 10:58:08 -0700 (PDT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a5971cf7ceso192277b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 10:58:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793123887; cv=none;
        d=google.com; s=arc-20260327;
        b=b6HgWv8HHQA+b1Blj+2CGo2WL9L7RYnloKhL5xzwfo0miK5+Xuypm7w+viV0DMQinZ
         dbkfuKRwVPH4M8uQjztkMAvD1yBGDzTnBL86qOqecz8hAq10+zSXCKUOq0WDvC/bD+DO
         /J2qh8S11y4B5nVcl46pWEy2MFGIxokm2mN8tB86G/0HfCKIITkK+HVggYEh8uKTVGMy
         gH5sX6WfF4rL5lD6xolOHJ6ivCawOHNQ2vyVoKEdkW3UqPf0jrk0jWgoqpBDnxvjsIk9
         qvWYcZmrgQ9qSbKzqiOlykSEGLT4Y8kJdGje0tUMU/8tNZBHmE9beTwzBEDEvu5eTSGz
         3uNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=1SLwWY5nhyzce/BMXQZLOCKP7mE4tnUfLqJlnWOr9C4=;
        fh=GL5tHCgk9SJ/E1Cw5LB2j+3IGF9T2aXyPlXQuDuyIC8=;
        b=axwW4xTPTefSX1tGAU5YgYazFGfhSEqkobLBQxOqMQbmf7gW8nFeTS11/9XP/NRkNi
         O3PzO4Q48fFDM4mjtEeZJv9A2tqaMLP67/9tuwp66Jlhc2ZuORDRc4N87puyRBgRyrdH
         aPIIamkuSVs/fK74r6uH+fpE1Wkhreaxq3jRHLrZbHaPINPvmIIpKiUU+EUL9Lq5PtT1
         AAHdQMYWcDjoDUAxwPryGxUpgzhI+49BeT94/qISeM42Waj1emryf4J6zH7wcDvbmWJ0
         OLV+uoYbxEyRed0pg4/RlFnYo43sJDVUb1MtMWH2FV8h58kYb8NSUxQzDaQnXlyjjLI6
         qpUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793123887; x=1793728687;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1SLwWY5nhyzce/BMXQZLOCKP7mE4tnUfLqJlnWOr9C4=;
        b=RP1wkj+rj2Kx7WFwiBqsBLkW5F6a+Ai2V8OPKojAoPnrrsi1QvryC0os3PmvavlTU0
         C26wCusTFivO/55e2BlPvklp8TiEn4Ubc6mNqucOrCI9pXdUKZIbeWncijVBSa6N5nyo
         LUFMUeGU3OoYpCF3Ec+9A9TZ4PGgj8NdPPPbB6IvcAqYOBEg/iK8iy7BjKvfyy4zMSpf
         Y6DvrYJUed2gN7uqMnIfFrC6OcE3fb41kOvxHjBVBkhmMGYnzusgx+0Sq4tU3UHwFfVU
         iJbxG2II9M6YuxhJGuWxtACNELi+SG2DfRyAY6AcnRyYuaVnBxkAHndMTSvxYBdUEiGK
         bdjw==
X-Forwarded-Encrypted: i=1; AKwUvBwZrUmlridAydXFmdLNT8ggyDN/aNX62XdeG5bpOFlaTTniDd/4SBMGZmaDUE7Cs6PjHLwuckjOPOUj@vger.kernel.org
X-Gm-Message-State: AFq9FYLhwTjCbW4iYOVV/sJI/c4SWUG91VWc0pRwwfLZhg+iCTnc9dqn
	bTMDvw/EYzKyyQ90OLdJ1c30Gd/pFTwrMMz/DDHneSJTjeEnFmM6DoSiR1T6SUdiX+qJ/OipnoV
	LsrcTo4LINX1osMf63GG7wjsascMw/kG0nIhgDygV+vyRufDAu3wfuj9BkBcrZe/R9Bwf99zY2q
	MSB3SFH6sz8Dm+FAo1zQ6AaUFrgzBx4gN0i3S2
X-Gm-Gg: AYBFou3QNvEJPdbGpkPQOJSbt3U0nO6m9V3sUkat+p+3Z+sqcC3/4WBpLKx+6KScm8G
	QZZBZnt7k0tIT0QUVm1sMKXPf7zsKxqiifsZdwVMsSgO68LgZK3yERs7KEcsYuzVEJzeCCAP0tR
	Lv1CaOz7dixPJ0c4irJdPyh6MTJTHib5EZ+Q159f2+ApWbRx0CXgXQkKvDqQqZqDcj7p2PiDwXj
	JSUyJe39gm4Qjy4WNWNTKBzOh6UaGU=
X-Received: by 2002:a05:6a20:7343:b0:3de:505d:d77d with SMTP id adf61e73a8af0-3e90232b771mr13641637.15.1793123887257;
        Tue, 27 Oct 2026 10:58:07 -0700 (PDT)
X-Received: by 2002:a05:6a20:7343:b0:3de:505d:d77d with SMTP id
 adf61e73a8af0-3e90232b771mr13625637.15.1793123886850; Tue, 27 Oct 2026
 10:58:06 -0700 (PDT)
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
 <CADh2yMyYS-PWP4912En9D6B9up6Kz-hnCthNkWot+e7N8-q7ZA@mail.gmail.com> <20261026175805.6d4dcae5@kernel.org>
In-Reply-To: <20261026175805.6d4dcae5@kernel.org>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Tue, 27 Oct 2026 10:57:55 -0700
X-Gm-Features: AclHuK9a9sPXLGBoQ5eEYEDdm6r3iIivGDQdeIyBtpGnfGV8DBsPe7nWqNJ4q-Q
Message-ID: <CADh2yMwtF3DxcD4h3zevCcmy5vn9iK8sYHoPrjoFPH5PHuNkoA@mail.gmail.com>
Subject: Re: [PATCH net v3 2/4] psp: support ipv6 extension headers in
 psp_dev_rcv() decap
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev-bot+sashiko@kernel.org, netdev@vger.kernel.org, borisp@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
        mbloch@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
        edumazet@kernel.org, pabeni@redhat.com, daniel.zahka@gmail.com,
        willemdebruijn.kernel@gmail.com, horms@kernel.org, shuah@kernel.org,
        cratiu@nvidia.com, raeds@nvidia.com, rrameshbabu@nvidia.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bjorn@kernel.org, dtatulea@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-GUID: 9-Gof1QLjJXtut6sjKYok3MMOW4hMX2y
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI3MDA3MSBTYWx0ZWRfX9MnJ14qm+PtR
 PTa9yWBAmNXTYXStKvDoJrcOj1Kgr/plcflRKTsUERJenfo88RhT9uHhfxu4DbXYZeqxHaqdtVI
 YtJOY69ThJTOCNZGsuN8wvHDZRbSjjI=
X-Authority-Analysis: v=2.4 cv=MbD5KJ/f c=1 sm=1 tr=0 ts=6ae0e630 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=jCddH8ec0KUNCymVuxII:22
 a=GCtVsLiEsvdnKASXBLoA:9 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI3MDA3MSBTYWx0ZWRfX5yrHyxEVaFkj
 KKrb9QXAZZtloI3g4clcDzKji0s6YrinqQoaNMf8RrQ6GapoE31Z9qFONX/YBTk6yd+Cpf6yBWk
 A6e/3R4d2Bf49zkwkKVQ3o4Rlw4MDIUfEKysp/cEb6bTEAKplKzD8m9lZ7OUAG2ZfqPazi2Qrtk
 JigxcBSKUNvZPp5xi78wmrb9DvrldxgdbeDIqhNzc6hF1aq0GmRCiGaUg3bft9MJxkaNBPknB6i
 GlLrUiSykWVwYkRLxKDEpSG8QbTi8wcD1aju8KmSHGh2TaQeBItWQs2OifhIvGh0utk9XyhyA2J
 8bJPa7jz9N6jNu+6Arry8IB7wVACuunaNaOAf5rDJcXpQ2iCIyFvl3MLYwHw2+AUSezIW5EAlID
 SXASeWdAQeG/i3DSgizMi08SLvdnwmq3DMx6sW3BsL60hykQnhstYkNwH9rYwvMVsJ57Syjs7VZ
 Ww90JvdJssnY9vy94kQ==
X-Proofpoint-ORIG-GUID: 9-Gof1QLjJXtut6sjKYok3MMOW4hMX2y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-27_04,2026-10-21_02,2025-10-01_01

> BTW I haven't looked closely but is there no existing helper that
> would give you the ability to walk the extension headers?

The closest candidate I could find is ipv6_find_hdr() in net/ipv6/exthdrs_core.c

I don't think it quite works though, because it doesn't return the
location of the
l4 proto nexthdr (only its value). Also, we would still need to traverse the
headers separately in order to implement the reject cases.

There seem to be a quite a few "walk the extension headers" implementations
which seems somewhat justified because they have different stopping
criteria.

-Todd
