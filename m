Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865D12D5937
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 17:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787073764; cv=none; b=VFRpZwOwYsSIwRUCe4vPRspoOjWKvNMav03ScmfP4uOFbjfhPnOSa6GGpBaPNYhtxs4Bw4F7hIGDwVTCENXoFwqMMA8Xb1RnXIJOA+tYPLTXB3YmloTDK7mqXQ6TAKXb2KVPFT5Ek1o2hKu9rYdgfkZGYiS/1riyFmAUAZgn+a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787073764; c=relaxed/simple;
	bh=5H3EQ0QLOVKmjzVTzb7F/SzHLCB2HD4fukmL026jYpI=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References; b=Miv0bEuZ/9p4t1rcMSgTX01u3p/rGHB/g0WBnrxsWoOCDEewAD9MNRaOcDsHpEUXlV1j3mbQEkcSNKIEUkgLd1K2x8oS69QEPtAD8ZbgYhzAJhGtFb676a1CeHUfYAib4loIgO+UCTA5TwQIc6deQLOln3Rc9M+FeWwhtMc+bsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ga/t6H3c; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ga/t6H3c"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cedda2ce6fso445045ad.1
        for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 10:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787073763; x=1787678563; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :content-transfer-encoding:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5H3EQ0QLOVKmjzVTzb7F/SzHLCB2HD4fukmL026jYpI=;
        b=Ga/t6H3cLvs+cyWgskq60VVFgNSeCXzaVOGBJgZa4CYVu3uDP95FnnnHm08fctDlIO
         ACRnOyFz4A4/ywhXR97D0dC4qoXR3yej7UHFoi5/OcxwVNXXZ0fU4mrFz4UqYJypTLlr
         9FYJSRpvFsGgolFNx8vIK+cPSnCLRlpQqdUzB/HB8hr/QmXp/PYkm07lF7+pI6AwujCR
         nehXlpRW1iMrxJ7NtSXpYy3M+LnExG8zzd793+b0VEBIxvLHErrbp25VOl6OxA+a4IQh
         LMVr8uA3mawZHjX715JYcO2dL3aDaEV+CYHmAzDHtKNWEoPDzOuTHNCi7gAXE57nbl8J
         CHfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787073763; x=1787678563;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :content-transfer-encoding:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5H3EQ0QLOVKmjzVTzb7F/SzHLCB2HD4fukmL026jYpI=;
        b=IWJek8CMK1FDjAaaCxgXD6NAjQCHeTJjmDZEwK96ztc/sszUP+aYcmLvcact4Iw6GY
         lB4df04nUcBOMJNbHJWDY0WRsGcD+dN1H++yEeQglOIM3oTCEFsZpiZ8pFp/yIcxVBnM
         6eYXPesF72BTfEkdYJln7xefI3Eqo3Yv8g1pvsju8EZAqueBur6A+7aVx3XlH1BnZCNP
         i4B+vkS3QH9Ia2PWKiqNFQGP/wS95CoGMyM5+liICsT9zpD+9suOIsdGYQ4UnDkwLMvY
         QJ8eNuHtOfTdwqpBGdyxF+W2ScqBJp2/Ul6xZh+NdIvB+9vCJoJLbXytLLLtqPCRJNbV
         loQg==
X-Forwarded-Encrypted: i=1; AHgh+Rp+YK29Aij2Jw3qLjixrTmHB/gdG/SmOm/A/i73F9j656G5b/wDyjAg2LufyDCWZPZHJ/d/HuxXHzzn@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5hklNJx6glCKzhZ97WI6HdxU22QhDALVANxB8Ut1Fog+vAC3Q
	h3pNV+BG/1GocNPfqNYDU2m/vi0spPcd73I5LS31WUbOZ7w5ZmSKnMIYvWYYOEreBLso8Bz0
X-Gm-Gg: AR+sD13jFVT2FDBY+XexgvUh8lb9rLdDZCcCbEC3VsXxTqOHQ3B36vvR+HB588DzG6k
	d1eCtjH1aiSNFhb5zR9Rjc/8ZocsAKAu7271V1dLpZJKHNV+HF1jPsskUJhmUB0hFagk7L/IjXp
	nSf+3NLFiqcJBSbEGZOO41kEUCs31WBKgEuodSAcuP9Y42zqUt69WICIAU69RTeB1yg1Rjk57NA
	2ML49/maRd1QV8gI3UCyTyj/zwm80+5ULvJpOzSzUhnjmk6hkzIbzTrtY+oKetCMNII3LvruEwl
	YTacD9ysd+WjmXOZHdpcLxr4nrh9JUNRlDc0laLTw9oUOM5dwwxnOBsue77IjLBjQ4p0lvspMK2
	42xCoVueaTnnZfP6aerACS8WAt84v4efz/u1C3VHe6ReTTjXZ9AUPzelmYXw4aNb9WD7A02grKs
	J5fo5xe13FrPl8GZI+QKJ2gIndjHMNNb+XSYH9LMpRBrnc0Mr3LYU7jPRL5fCZYDElcvr3P5RdZ
	HIR9MM0opyI2PZW0R33XbVqnIhGAkk629PBipMB++05UH9EVh7C2HxnJZbuZJ8v5e66PHxrrqQW
	jeTFb6t98Tss1ZnwtPk=
X-Received: by 2002:a17:903:1b48:b0:2cc:864b:539 with SMTP id d9443c01a7336-2d5c4f20383mr156967635ad.6.1787073762556;
        Tue, 18 Aug 2026 10:22:42 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([240a:4282:4801:1b98:2558:3176:8229:fc85])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1ecb1c1sm18179215ad.66.2026.08.18.10.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:22:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
From: Liu Zhenlong <dragonliu2018@gmail.com>
To: Md. Haris Iqbal <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/rtrs-clt: use find_next_zero_bit() for permit allocation
Date: Wed, 19 Aug 2026 01:22:36 +0800
Message-ID: <178707375643.34993.16303244908977680572@gmail.com>
In-Reply-To: <20260818163513.53875-1-dragonliu2018@gmail.com>
References: <20260816165935.90523-1-dragonliu2018@gmail.com> <20260818163513.53875-1-dragonliu2018@gmail.com>

SGkgSmFjaywKClRoYW5rcyBmb3IgdGhlIHJldmlldy4gU2luY2UgSSBvbWl0dGVkIHRoZSBjaGFu
Z2Vsb2cgaW4gdjI6IHRoZSBvbmx5CmNoYW5nZSBmcm9tIHYxIGlzIGEgc2ltcGxpZmllZCBjb21t
aXQgbWVzc2FnZTsgY29kZSB1bmNoYW5nZWQsIHlvdXIKUmV2aWV3ZWQtYnkgY2FycmllZC4KCkJl
c3QsClpoZW5sb25nCg==
