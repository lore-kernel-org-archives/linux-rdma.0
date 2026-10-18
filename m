Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B62623B638
	for <linux-rdma@vger.kernel.org>; Sun, 18 Oct 2026 02:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792290335; cv=none; b=Q20Sx7XizQxhuZvAtJ5BP1mVDiLjAciOt7dsWxdADpymkguyy1tT1oFeLWJc197hGjCKoLlCIetJCfczUTE9asYtKetKpvP+bszhsObEFrlepYkQ470R1C+k+OZEZAIhqaOTugQriVHLoPCVEn7BiwvnNNlqMezgIGy3aiiv0ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792290335; c=relaxed/simple;
	bh=cOWgL4Y5aOSoL3opS9VqD9bwE2Ik8UunaS8+RLwbmv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+YWWe7y+jYBNiiLG6ffAqMBFYD7/ki6FeZ1hxq0RGFUZIfRStr1XENylWuFafBEyULq7EZ80QjRGxMCYpq2PulMa4izt9wjPzsZVVZdHKY7qpwZ6PDaKCvx3cULru77u02blCJotTRpSbYTI69JGMPU6YiI5adm0xX8CJe/PDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=sJbwSk21; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="sJbwSk21"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b1cc392d8bso1130835a12.1
        for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 19:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792290332; x=1792895132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cOWgL4Y5aOSoL3opS9VqD9bwE2Ik8UunaS8+RLwbmv0=;
        b=sJbwSk2180ZFZkpasPbMUs+VnMuDmisi/Ml/uMIqWgJu+Wy2c8tk0IPP8f1gNewA+9
         7j4qFEMLErx/AMNezdDNt1ya079p74pP1J2G07FVj4DcMBu3XwhRcP/KVRuQY9N/X8zI
         g3QUPlvDmAud0UDDID/3PKF3hyiMlNaFURBHy6HaQCah7yvngWZbyE8FWAZOz2EIZ6im
         4Ztw1lG2LyAbP/lJW1CMRQa/j1l0sWkuM+ufTN7wTzXQoxvLfe7no1E6s+oAoor7hb48
         dwwcD7adG3cEge0Ghw7bGupo+mxFmjjgLJHC5r5QdV9kGaSUvM0u0sObg0arJdHDXXcD
         VfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792290332; x=1792895132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cOWgL4Y5aOSoL3opS9VqD9bwE2Ik8UunaS8+RLwbmv0=;
        b=CYGIw8+PkGmH2Xrs9345TG56y+g/UTnT+clyR00CdTDTR0kYslseRQLGs7qwh49q2p
         twYMgem+uBV8gsD4/L0sxbPYD/f1+UND1Flkg6kk4ahpYHMcz1EdECSR8zsSu/FTN5a2
         81km92czVmvbicp8LNeMAU8zYueEYPBAbxJcG1mgUSbUGex2wolyXeMHIUf6PWa7ZUsY
         NY77JeWSLAVgPa/WsiA0a/XIDWjcYbFn967bB+18Iw5qCxPBid4umi2vhvsd4PkT+eEN
         we5gq5Kxe17TwDZKBWIkcRXXzJ2D0R9hb6zbx9vcLIps77qMrpVPFGYUL62yrdfbtKz3
         z5xQ==
X-Forwarded-Encrypted: i=1; AKwUvBwr3WW/uwinfDJYQ3AFuziSkApOi0yWT0P/vmfIX7j3ihnjw7FQ8Nnjv2GS9yFm2U2IGfmplW9xXsXu@vger.kernel.org
X-Gm-Message-State: AFq9FYLX1vtV1r84khPvSxi+LuZQtS5rVDXn2evgq166OI+Sq4yFTIkT
	BQGg3fBIFJ65D3dQVsXeig9npFzOU6jtIHk0IIzYF20Axpbd5jFl/uUAIelYGFkopQ==
X-Gm-Gg: AYBFou0gDwjugXg0N8A4RFX5PbdX3QKm6o44UYoH9Tqjx/saV0Jk/HK7RteHWJwX7e+
	pTsiV59NsEQmYRDSnzMd7u5bfzJowgb+8R1KQFl9LLyTL1t3ukDFicOo0aZ1J1Vqu8pHsqCUzWI
	OEsgHmeDeySfU8I2eiMCjUsakA+QD1TYSuaPDC9Tj+2dFk0jOmt5u1Iwxv3Twl63JdWtwcEKDLa
	TZp0YDrD/5wn5ANlnwYn8QjHynttegJ3TWkeiJKzKLH5PgxXl2XA/GKkUEibkk3fsnznD7lwU5I
	2A9K6BaBwzE/9l6b286SdEZCaXG8oxZjYI+s3v0sRuubPlT5yKbaO7zBFoUFL84h6creK1aq5+8
	hcfmqcr3TvWEb6a6wYoy7eLcuEjrbGs/mQZfzJWKTz1GKgnv55uacftMOFx0nHt6yACfIxhaqzb
	8F9J8Z4VUz5SVv0M/reO6Uj2JZgFvLSG51AkFkPnvuFx9li/uItQ6wnVeAQMKRYC0gI+KGD4h5i
	hID5H4ZNdGbls7z066lXKnK2BxTuehI6718ZpGSgsaLieECRDE2ekT9rg4WpL25lJWcO1VBVkzr
	EDXwypzTHGYSfKRXf/6rQuYBECk9ZGkd92HnG9ysc/zIdgazeB00AuqL11Slb3cP8iebDEpVkXK
	CrXsgEEnXD7svjXObE1vjoh0Q1zDBGmLNKS2lMoIMUep0gz3aDlVX1qNJXD0+QcrAXUjE2MAfri
	nditru/QIUo7uiyKuQihP9S1HCUXS1EGFGT4Asb7akuAq8aqeNvW+2W38hxpJ8WA==
X-Received: by 2002:a17:907:e849:b0:c40:4320:de2c with SMTP id a640c23a62f3a-c419e73e2a1mr277700866b.15.1792290331870;
        Sat, 17 Oct 2026 19:25:31 -0700 (PDT)
Received: from Desktop.fritz.box (p200300f247429d100000000000000a27.dip0.t-ipconnect.de. [2003:f2:4742:9d10::a27])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40913c4c5dsm222994366b.39.2026.10.17.19.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 19:25:30 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jianbol@nvidia.com
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 1/3] net/mlx5e: Ignore FLOW_ACTION_PRIORITY on flowtable offload
Date: Sun, 18 Oct 2026 04:25:27 +0200
Message-ID: <20261018022527.4065122-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAC1t37K0tEMzxmRhLeHnH-TPx61pZmCHt0xxTJ5Wq2Wxvzv8Jw@mail.gmail.com>
References: <CAC1t37K0tEMzxmRhLeHnH-TPx61pZmCHt0xxTJ5Wq2Wxvzv8Jw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jianbo,

v4 is ready with your Reviewed-by on 1/3, the rename to
skbedit_prio.c and the consequence line. Pablo asked to handle one
series at a time, so I will post it once the fdb roaming series is
merged.

Thanks,
Julius
