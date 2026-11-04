Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793765126;
	b=o8iv8mKuU2cS9y9Si8Hkz5H175E/DsgsklLRRxGlA0zqn/+lRZnPmavy52joxdltjd0R
	 OTFtSV2NFdts1dY/jbGrSntkO6Odi8KqEUZShRVqbZA9d4+JZYO+m0fxsyUe5yG1EZfTT
	 T2G+FysIZ1KYchjOUDnDO6G5eGI/Huj7PqFsmJ2gC9xJPrJKuCgAQHqfMeZETCHw8BWGd
	 3Oly1QUhlivwSC3ikmh67PeixvYAbxVEaEHNLuAETNBtVkUrb8mHXfRM4nguo9m7BIfh5
	 32mHI6Oj9VCXvcMdn9AC0i6k+L1n1w2clfuizEAbFCEmCBdVTWYc1UqjElZvHfvbNlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793765126;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T+j37Bvrvm5b7s/8uMkhPBVmT5+ES/aAdwRW0vQZhyY=;
	b=BNPJvt9RZWicj26u+QHxhEuhr19aEnvtwseFKBoBuMqTdPMiTxibykYKt9QcJiBMTwuw
	 z5n4iKr3OLvmt4BJTELmSzw1yYM+UM8LdN91b1oCpmFDeA3+NOorx71uBDGNYDObkSEEj
	 wmC1UBHAcptLChdb65g5iIdSjOORjkDRtL5NxtViRbQ58evLn5mdmKEo7P5cIV2mYSiC/
	 YJcA1FAlAlJyvvgvKmeiWzlmjiyfIT86j2A6PmEHf7C6RUXYh4ZhNXNPv2MMV2G47RTFF
	 XnNHe35+4wMqRXY/mLI66oXFnoyGnxHa0UvuCI0cWqBmUwq8xqSsBaGXsQ9yOYD30aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lQgCf8Fk;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF02606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 04:05:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DF02606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lQgCf8Fk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ea138a3497so1440645ad.2
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 20:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793765125; x=1794369925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T+j37Bvrvm5b7s/8uMkhPBVmT5+ES/aAdwRW0vQZhyY=;
        b=lQgCf8Fk/W/H1qJuGTKkIbLrlKnXkKqxCXOhS3tV7Eu7U+fVhPo9nb8yLLixdFyQFa
         LPRjYf4ZjsXpIpV4ekdgLGX/T8O3Zyhjf5iK5Fpc4pt10M74Z0INpZ8EZ5VybwsC3YpE
         3Tu4T9YBF8xuYsMtzNfC+j+14EuldYyICkcK2qPSEq96RYY53YaNqgLwJL6BjiSLbDza
         2amGqz1zdXDAOc8/Y6Dtgz+DMNehkJ6zixyw8MsDbYAXMzmYKF3Vp7FLRUuL4/fWKlDk
         zaPcWvxhgXkRPLivzQlWBAKrfU6Q9lC6MJ11Ri9VMSsHQlmSonWg0NfcG3yz+XaSSRUU
         Zdag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793765125; x=1794369925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=T+j37Bvrvm5b7s/8uMkhPBVmT5+ES/aAdwRW0vQZhyY=;
        b=Gy/auFfmoumlkqPxOVYpdw0CBmCXZmWgH0O8zKc3IjXgDURO5s5J/s8OQfse2lUbGt
         XA5e5Fy+LBIv+Fme+sBhMZ6rkRDeQUSeHzq1oODZxJeL9+ssQZMujmgVuetx3O0pxiCY
         qBbraw6CTsSks/HV3ibCQaI9Z4RaLu5xu8XbIQo0pNQL9LHaxo2vBrCNj7X+5AL3nKys
         2uPyl4Bkv7nTzibnobR0P21t8q7NfRdYwvTqf7WHtwK5lUvM8uKxqdOTDAc6cx3njWQf
         SRbhZ3TMs7OVQZZr7Zhdu2ZkrEcD6daPGCJnWQogPMQJlzSs9dK/8ysg17K3oL9dReN0
         hV7g==
X-Forwarded-Encrypted: i=1; AKwUvBwuhRtt1eWYwdcIA99dhbDgYHkWVT5gkO1EZBY5Pr47xZkKbnmrsAcHCH9WC9NBBAyjgcTjw9ZB+34X@vger.kernel.org
X-Gm-Message-State: APuU4Z/vDP4H3GyBA/FgxhLXubyOmdaVhd5zBhLCSoKuEU44EcOgOa8A
	oLG4AEvmkn0UblOtgLPBANKHNGj59a8b/5dqwtPHq0hUCauxkyvbtCq6kLY2TfdNGK4=
X-Gm-Gg: AYBFou1pymJLilEoOdBuIIEJWkp1JkJA1vRiLxYTY6s4D6/uD4NzuIFw5JbuGezflhC
	vxQzXty8O4TxUQXZ2JgJ7EzuvRuHJHsisFA6wPRY5ak2cSghvVIrP825f2LgGl7LsLLCDSXkFBM
	LlhQLyACyd9PYz3B5N4nObgxC+eNnskQvT2aOguKoYcENARy0id3uf7IdDQoH+UT1NRGkpsB3Z6
	LSS3Vt/4TBK4TvkgxuAu/K7CTTB1Kvd2z/B6jN8gt1InZiqtZShFI/5ky9dBXWTDN9UWwLRtPal
	rpDXgnONywE6iYTCw2z0RwR2Z1fljetWuTnb31wX6UHR2Da/u/cdNY9o0E/Iw34ycwpwrBAtbTJ
	hcPpB5JoGP8p1dfYuzQJnYC4xcK9FRIYm7Qw8E8rVBlqSLplb2+8BfunMtgo4hMASZjZes6EHmT
	PyHjNtcf1bpT0JXJQetlJ8Ik09f6ot03F8Fao0U7fa1IPf+odrHiZ0+dVpD6KZVbPuRs17chdN4
	k0QE8/SkPydSTukPZJj4A5jb2ithZksButLyRM3aiRvTg+1L10N7bv+Aloe3uPLYudxIpYIgY6/
	ou6zHn+qdhvtRSDeHDyDmSAX08kYp7ibTEPCcwI6WHnMwSafvdEnF4C7SXv3sPSa18NfGbcQVmj
	gfMNyVT9F1bzwJkVTQWN3yJDih7cbSubBpaHK
X-Received: by 2002:a17:90b:1a85:b0:39e:6a80:dd9d with SMTP id 98e67ed59e1d1-3ae898194acmr12972752a91.36.1793765124818;
        Tue, 03 Nov 2026 20:05:24 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b094d70a60sm873913a91.1.2026.11.03.20.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 20:05:24 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v7 0/6] IB/isert: fix the device removal use-after-free
Date: Wed,  4 Nov 2026 13:05:16 +0900
Message-ID: <20261104040516.1844951-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is superseded by v8, which addresses the two Sashiko
reviews of v7: 3/6 clears cm_id after ib_drain_qp() again, and 5/6
looks the isert_device up by ib_device pointer.

  https://lore.kernel.org/r/20261104040318.1844865-1-yhlee@isslab.korea.ac.kr
