Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794378586;
	b=comI9uzE6baDgYeLUW0VW2xFudqX0RwP7j/qBpwDKHOscRd96f/3yj0b9cJOyzbPv5ND
	 RgoCOjcBqtH/3S3ZkYW0r6DEUR7lebw0kFVdEaP7LtL9+DR75R/HrsjutHWiKJkmGVkku
	 hDQzZvPgDhPlx+8k1ZjKWvVT+N+uy9ewNl/GDAmK4YBij3SmLHQeZM4rSt9mf7gX3MEY4
	 UvUy6UExLIpAvlVSDwUm9gwGNeFtnfbZaFGYT/XEeuXLWy9fmsgCbs1W7VAM42pYeRiu3
	 DAohJvb6awHjP0dRRmqr0gMefnfhZ9pb4l0ynz5jsEqQ/tH9keqMYKHwVASF6aLB2UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794378586;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=982skjmQWlVWeCR0dvMpkvy4QcIduHPcJMkY3lSuKFM=;
	b=iujpmG4VJujZg9FcuqXtxQdgNFVfZveDPKbbzyCxm1SqnVs3p0aSELd1+LHvqEHq7b3u
	 kKyWuiqYh2iyWHdnW7/VhSopL/eClY9xNv3s33yxF2gRgcpCmzCfLu8xJsgBkAj6Rtxgn
	 tmHCAL6F9NXRUOTaGxuKle1wMS1UM5dPy/FqJ8/BG0OfkzZBnFGwPG3P83QTf25/GOQax
	 4HNLfWJ71tulkOBjlL0IyrQ5DOGgZ/zgOYDSBA7dvtwi8BFjs9aqyKugYJ+tY2Dc0vu46
	 BgBvL/+1erMTYrs/Cc8bdyku4ciOrc8yW1REgKF0wwF0qedtpz4fkFzP/t8s/BYaPvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rcGrU7AJ;
	arc=none smtp.remote-ip=209.85.210.169
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE3D606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 06:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DE3D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rcGrU7AJ
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8b5c3288e6cso1240909b3a.3
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 22:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794378585; x=1794983385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=982skjmQWlVWeCR0dvMpkvy4QcIduHPcJMkY3lSuKFM=;
        b=rcGrU7AJZ3TRwLxUVeh9SZu6G7z3Wc5rpfM3PG1/5MlZKLWZKgUvDi5n/3XZ286nHt
         QXztxMQgJG6fjXgy23xxlv7srj+3uMgioYvgKHhFj4vBlMwfGh0aCS/qinuKzS2Sip4i
         vNMFBtM0c/iaERTORa7SiSECAI+Do/24rzSbAQ9zg0mKPU/WpOXjbrcHFvHX79j8ERVc
         gT66+DBO48fwF40KLU1poVQOsTfHuTEPKmIWohfbMcXNOmGQ79IPgWQpROsMDsEd+ztX
         PrhlumJwpM3pQt3PSOLMQeQ6yimeXzFfJngh8XwVjtn+kyFI/Gfr42g3+T5V/pTdzoBu
         U2vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794378585; x=1794983385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=982skjmQWlVWeCR0dvMpkvy4QcIduHPcJMkY3lSuKFM=;
        b=sF+Jx99urXgq8jEama+ZdBWMD/bR5cQ/EJoDehvH1z3OL2E5Lc6kofHS3nigCGAL6H
         9XXNFhfa2jKdOd45zoJKxAisM+uugh/oAH3EI5QIm8hO2EFsTKrM3jYLq4RLHCyXZ9+V
         RvMvntD9BU8x/cvXNtd4xQei7wWfzDWXetBz8XOaesND/bZsswFgDIPFxjTc/+Lbtzp9
         YNpUyaKILsk9I+e94aKO4Jdz5fzL6TmpbCjiTPLNWhXQDiwlsDePgSmuMdEOhOmgtwWK
         0Szubos5dUijCOi/n4BMaROr8YyZyYXfmWCek1bVQ2+3X2kJqULchSYh4imZgqAFKj11
         9UwQ==
X-Forwarded-Encrypted: i=1; AL+hErHYdUvsvwVWkK6ejM/4J0mDnYeaBohHK6QBw+2AA5KTgI200z/9LXAdqbC4GknxP++sCqoHTvS8aqBx@vger.kernel.org
X-Gm-Message-State: APuU4Z9ePibc0kMnVnNz8K+2gVmEEymYcZEFJrcc4MLOM8YkNQGMWyzy
	e+0WVswcMIh/dQDOOE2RBCKhIrxEJhNg3d8GB6+LV9cmM1YTWgAa5sU9
X-Gm-Gg: AYBFou1FeKfZQ0XQps4jXjobr+RoFatA0BmoRzVAHUBVuhjbS5dd4/Z4xhTbSuTCMRc
	qr6XNELTr8oDL/R8zHuyhXj4K15ujFt0/tBZqRLA2EgJ37hX6IZRpXQIobVfRT64Pylx9omKFRX
	6oxgMKTF7aw2s0bBkeEUMD4i8Gsm/4S5yvwg9cBr+27KO2L1ScidWeD/c0xfQ9NnZtiuZuxpzs7
	dea6rb4T19QtJfbtXU/llllcWQWlkzSqpK3VmDidt6mDQKP25wIYK0idXGzAWzgkiPfd5DzP40B
	Uk41lD+lL2ogzqjUAptMNz1d1jeeInDwnSVCY/qyCKwE+YfbmStLA/bSse5raEcIxZgEW3cZ2UL
	K3vU+ElFRrFGMVt9iq2DaxOCx2seiu/HTAK9qMOWpr7Iv3k691257LBehRt6bZgfrw98zUeNo3v
	6d9b2WmjU+dFlC8A1jXPEjFdNs9OBgrZKHmXbXgpw4vmBl+3hegpu97guj7JLFGHsyF4f0njeYP
	IhLVSSfOdJDgNIMYTrERoUGal65u5DuVCSnQJhXnElmPVKolr7Xj0GPSFESP/kAcZVMpmE/vyuz
	vNPDc6bpF4pIBJXnBFSoxOXXeQq5URAOD6EoPH7SzQ==
X-Received: by 2002:a05:6a00:2343:b0:8a0:3336:4b45 with SMTP id d2e1a72fcca58-8bc1c594810mr1681640b3a.12.1794378584851;
        Tue, 10 Nov 2026 22:29:44 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaae3e25esm1768266b3a.37.2026.11.10.22.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:29:44 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: Re: [PATCH v2] RDMA/srpt: Limit read data transfers to the command length
Date: Wed, 11 Nov 2026 14:28:50 +0800
Message-ID: <20261111062852.1279950-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2e748067-f733-4edc-b71b-540de4bc3d26@acm.org>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <2e748067-f733-4edc-b71b-540de4bc3d26@acm.org>
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

Hi Bart,

> For the second case,
> srpt_get_desc_tbl() should reject SRP_CMD requests for which the sum
> of the direct descriptor lengths does not match the total length in
> the indirect buffer descriptor instead of building RDMA contexts for
> an inconsistent descriptor table.

Agreed. In v3, srpt_get_desc_tbl() sums the direct descriptor lengths in
u64 and rejects a total that differs from idb->len before allocating
RDMA contexts. The existing descriptor-count check is preserved.
I also initialize the command before returning BUSY for a parsing error,
so the response and completion paths have a valid command reference.

> - In srpt_queue_response(), zero the part of the data buffer beyond
>   cmd->data_length, e.g. with sg_zero_buffer(), if the data buffer is
>   larger than cmd->data_length.

I have replaced the WR/SGE modification loop with tail zeroing using
sg_zero_buffer(). v3 saves the original buffer length and clears the
unused tail before posting the existing RDMA transfers. Each separately
mapped SG list is synchronized for device access after zeroing. The work
requests and SGEs returned by the RDMA R/W API are left unchanged.

Thanks for the review and suggestions.

Regards,
liuyong
360 Vulnerability Research Institute
