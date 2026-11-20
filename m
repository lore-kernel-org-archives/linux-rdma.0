Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795195088;
	b=HBVSDLBI4bzbbJXU4Y7PuLb58VmuIVYo2eNRCXc/ncrgC/4rU7ktRxAdOu7y6h2rh/YG
	 B90ZmttgeYTPc6Xkk8X4c3FMvLh5/i7g7M1nIdvpdTRmQfGEd1xp69TohRTuHhS7kts7L
	 aOEPQXxWbAj3tXM04C8g8udHXrqyS1arAKXBhGv5UmMN6CRvorGg5fmwHJxTndjctxkeO
	 sh8YX7B4cwHTjk1y7C14WMYPhzkgPmrgqdK5UnTsbgV1wd6AB6JIMN2hcSNM7ZWJK+HRK
	 44uwKxXIIcm+QRNzu/FV1bm1uRjzC02/rmFuW1LdOemiGvRnTEB5VB9YwoLJ3XJPWKw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795195088;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version;
	bh=wjfu+1o0XY41QpFEK0UkLoGoO9C3f79CMyE3qI8pCWQ=;
	b=Gt/enHKzZjq11hvZDXJHyVirtdBndtd4H2G7KIOELZ2JBWNyAE2O3RA+aunFLAmx8IFH
	 mkS0GeHyZ670YXEbncc44w21fKDxc1JAWMB5/2GSJj2UuKpn0g6E0F6vsNj0onqPhxWKC
	 uUOPtt6+Ao1kgmgbWZbqvqFlx16Erv5cpcQ7kW1lk5E34e106Un2YH670OT6FkOA+zPkU
	 aV3L/mq3ijn18MzFUayzFZ0GQyr7TLa7JJ0urd1FcyYJP5ZPlbEmrlwQbwn+UUkKPTPjH
	 OtK9Y+96o4SfRJIH3EJClw5K5jK6EvLp9XVcdO8ASpuyBqvATDeotBGE/iLxXW8SpXw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=HvFsqWth;
	arc=pass header.oldest-pass=0 smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BD160A260D
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 17:18:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63BD160A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=HvFsqWth
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AKH7tgF2299509
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 09:17:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=wjfu+1o0XY4
	1QpFEK0UkLoGoO9C3f79CMyE3qI8pCWQ=; b=HvFsqWthOwr5IFXRc/Tsjs2JhU2
	waqs9ZKQnjldht7nZxu9zYt3XhDvdDhpIYEfiGJJJrEARGhYqP4wrclpQ6/0EBg3
	lRul39UgevRZgaQs0bGKuvsQi0xfHdWI42hfp2dMFO4+23ry2xekopDamDQ+QHRO
	mXXtwTWmKRWeGnr/fcfD6YmZLWD9v7sb3z+OTz4taeyADWFoc5O08MrAVa+2lhfG
	EBi8+Aae6qA7wuabHWw2J1neVqtl3Unw9VQ1tfsa9cHkvdngACKt/gZSf3Yp+tsQ
	oC4H3peNvc4jyK4lcsQdMFqAsEQWukxa8zbJe+Y9Ra7kS18gy32bPs7JW4w==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j2tb7034v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 09:17:59 -0800 (PST)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cd5ca3840c5so1294622a12.2
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 09:17:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795195079; cv=none;
        d=google.com; s=arc-20260327;
        b=h+f3q9ca/5J0YXAB95BDcxQlrAWFCrxkfjpDyA0piydxPkeshoYHKi0buuiZHpjgPh
         emN/3wv228ZpO7jfu379q1VfHMzKrxWoadH3dH6oupf+lAnrHv5FTC3+yayOezr60tW1
         LEeD83Jec56VSz6vFzmaWxPZXQhGmbtd8c1hZQ2EuBCZJIoeJ6X3Vs0w8XU9UzELUALY
         O0mkyU57F7SKuOhVUsLOk5n5lAJRCfoM9hlyrVqNyZm/CWaZG/mIjokVFoQD+loWCSPw
         IqgrBAX1FssaVXybB7qHPWzOG/DgNOPRyRR0aXOJATYt71e4JhnaAdj24cHbiq9qLvDC
         b8HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=wjfu+1o0XY41QpFEK0UkLoGoO9C3f79CMyE3qI8pCWQ=;
        fh=VvZV9znE9ZnAcwazEw/T2GK/656nPiNNnEtWdFnVRQE=;
        b=E6G+Wwk6NUJWx2OcwD2wjzOa8zONEgcmS+JOx4w8SNtGArUp/z2JQj760gjAsdrcqp
         KqKfBJTWtG/lIiyEH6acGLAoGKNf7j76EKF3XOCoraTTh91a+LPqjIwStsAkd0Drk9oq
         KMjN6V9UBo849H3f42JoIoMMTaHNSW8ZAVC5AxR0A1k2DLSwdlv0NDY5FXavWvaF3Fvd
         0KsmSLtDp3S544N8zXZdQ5Bl2tpqrihOHfdZxDNgLkY+vm6Y3q3c5/aNRp4ttcd9/cB+
         dItF5YQSfP1eykG0h3O3ADxUPgtpnYPq+/Dw9En3SbYBbVfZ97RvlQURNu5coq6srC3j
         9Ngg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795195079; x=1795799879;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wjfu+1o0XY41QpFEK0UkLoGoO9C3f79CMyE3qI8pCWQ=;
        b=arptVfJyMlIAfbfen+x86PtqEVCykmzke4YEAp3iunMv7N0GAqq2flj7c0oErf8EFv
         NUDaAI5xNB8nIiRE8TwmGhOnxkB91sMLk+5g/Lbei1rg7Q51nWCgC94w/W+46BlGKhXu
         eGSWn6GuopdWOWJBljbrdd/ZdDWSEn6XkaUB23X6BEMPnh0senfOAxoyc235eFIPrZXx
         fhEk2nrN45eJFJvUuiMHpkIWu2LObYF6uaPUYOc+aKOaRT4Cbkjog/SLmP1568TKvOXq
         73wjWn+CaSjPirgixDk/n+RPPK2TZ5s1fwmzOS9/jn+SjL7VKCyv4IACsVNOI1FBGYT/
         gbTA==
X-Forwarded-Encrypted: i=1; AL+hErG1lom95FUbEH8vO1xhZtdNuquYZtqM2QEF4FYlLtP78gA7dLvSkA67x1HT8AFP3Gh3lbwFY7eUg2WZ@vger.kernel.org
X-Gm-Message-State: APuU4Z9MY5F2l3oqRy2l9Qzp0OcHT2SdaSl132MytdDMkjemqELkuyrD
	flwtEKeZNRFFarAbxG4phl1edMGBMt6F+VU1YmI9IkKm7u//zc1Bey/VLCeDT+DaS4WoRFaHSlY
	/8SrFRZ6as2CzaV8uG1GPvuwp/DBq4Q+b0ZpH8A/3HyKTJkvpz9qPtpf5JyTTiZhZedZN5heRZv
	Vd0ZwLn1dohnXXiSwq9E/eS3aCxW8+an7WSxuO
X-Gm-Gg: AYBFou3GpI6WceUrvWp0GUKVGqFddjFG5Hi6yL4W6rhkHE0Cyax1plkKHZ8eYo0m1aw
	O+XBeiMIUy6z3CrVE1u+KsfTq4po/5E+guQJ/hjTP5Dfe1AqiEQwevGY49XKWZ6pKkH1g1e26Ej
	+UN8a1OCvDaOCXf6nXnpFNLEaOpBZwYjpAUZoFs+Gncmdb1WA3nk1QvUL0KymOEAyxqOloaf5Oe
	WUH9MlDvy84IlzvdwVg2JFWdiOLIsfk
X-Received: by 2002:a05:6a20:9f86:b0:3eb:39fd:bacc with SMTP id adf61e73a8af0-4014d360ed8mr3745377637.50.1795195078608;
        Fri, 20 Nov 2026 09:17:58 -0800 (PST)
X-Received: by 2002:a05:6a20:9f86:b0:3eb:39fd:bacc with SMTP id
 adf61e73a8af0-4014d360ed8mr3745344637.50.1795195078192; Fri, 20 Nov 2026
 09:17:58 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117203137.804424-1-toddfreed@meta.com> <20261117203137.804424-9-toddfreed@meta.com>
 <906302b6-facd-43c4-872f-ae40bc59714a@nvidia.com>
In-Reply-To: <906302b6-facd-43c4-872f-ae40bc59714a@nvidia.com>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Fri, 20 Nov 2026 09:17:47 -0800
X-Gm-Features: AclHuK-LgS6otYIsEJ3X0_WptWHRTeRKrRZOhEbdUdT3ro_BhN8Q7OlgsXmfnZs
Message-ID: <CADh2yMzLDMEOupGJwS8=3JbN-g4LR3ZapyBNaJx3chNT4_6pDw@mail.gmail.com>
Subject: Re: [PATCH net v6 8/8] net/mlx5e: psp: tso: replace only the length
 in checksum seed
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDA2NyBTYWx0ZWRfX1RVzLeqHi8cp
 z2z5gtAwhVW0E2rGPgJi6rO+PIcJkLPkVVSOboRI3xlV6IExCeYMCzcnr4a5otxTXCdLJNl5z4X
 SEKwdnSKSkKbm1kqMlVU1vWz2mR7/pE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDA2NyBTYWx0ZWRfXzO9cYVv8YHSQ
 W3/fTYFtS7r83ttD1AMYRMYKXf5fqqm0CNT48M+yI0dBCQd6zXSUPNr375KPMg31EvLn1/kn/Ix
 80xG4LKb6hjSe9DpUFgYGfLyWPE+MIM3ZbFQ2ZH+R1L8vLQGQMZmRGbfz8BzLgqKxIAoNcSp+rq
 Jgn/HxxwzB/401UM9sp3Cfk6MPLvX70z7/FV+sOFboE4Pj4SA68AgC6XZQILnRfvaK+2xXmWjte
 VZY3dCfI939Z9nn5yxSur/sNqJ+KgE0hXS6I7Qa463ewcxtxh6sBu2CwH8eT8nCWZZoNT7CN6Re
 ahQ22TVFt8wSa3eG+dq8ryUPAQIm6HtXJRScEySBEqVirRBNjJr76vnt24T/WEFmwmNwx0IMEcG
 fqRUUH13CD0rKBab/s1f8PvmkXb6a5fMQ7cY+UFtQwHT+F0/tIlYgvFjT3LhoJaJkZwLeViSH35
 9FpLPpbB2CHNIi1M2zw==
X-Proofpoint-ORIG-GUID: PHPRzDf79G1acX2TuqTv9ohwhj1moMsc
X-Authority-Analysis: v=2.4 cv=A/v5rKWG c=1 sm=1 tr=0 ts=6b0080c7 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=03ozwUkBphtHgyqjj1sw:22
 a=OFRVtpLxHUNKrmO6MooA:9 a=QEXdDO2ut3YA:10 a=QYH75iMubAgA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: PHPRzDf79G1acX2TuqTv9ohwhj1moMsc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_05,2026-11-19_01,2025-10-01_01

> > in these cases every segment of the tso packet to go out with a bad tcp
> > checksum
> What did you mean with "to go out" here? Goes out? Or is a verb missing?

Sorry about that. Here is the updated phrasing.

    In these cases every segment of the TSO packet goes out with a bad TCP
    checksum.

I'm not sure whether I should re-post if the only changes are grammar
improvements in the commit message. But, if it does get reposted, that is
how it will be worded.

-Todd
