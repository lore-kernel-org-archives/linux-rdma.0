Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794690308;
	b=nO4IT6Z74PDeV8W0YcbQywdBBFo+yGi6eokII0p1rhdfk/IehoqJk37emiajWWS+oJ3J
	 9SRTE0SjfYP7rzg7K1Qc6/n9Nj7t8QtneXml/HnKVicuMoyvvM3nKHy+S4CTy0+GidZwy
	 c4NVkuxEiI1eeMuOnqhL2RFFOJciMZkOz4mPyKmH9SCBRbZcbILrgdC5uYSuDZmdDGeim
	 SET4yziLONt6bMNXMSyp6Nj+2FDi8DsPAscfCSEqCAuW9CCT4p/TWA/+az+d4dKLur0su
	 RvZttt4CqzE0361GolRnqcjdCwPJyc+VM3sLsSQAzZ8vLxRDXH/2aoFWaUEoxl0NfrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794690308;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S6r9JliYuLkU6bNVnsHUex3XuU8S/UM2soCRpJowQjE=;
	b=nesXI2OEWeWa/h1h5xuvd0sdkkWj/u5OdjmqReQ8i571WxxDCcvKhDpVekTFXD8M12Ry
	 nHgzpuFs2xcF8kWY5zo4+QKUOgwEA2ULpP7PHVPi8GQ0Raq/okaOImTIc27G4/3khh62/
	 5vj2FbykYA3lG3QOC82PI+FUv1ymfaZQPTqM2vNabUqNcLfvIzz+wXyxNbIMnZWEX5fpc
	 dWojMpMmMy7dcTcY+x+qPHAnHXumx8PVoCWZwri+kxl03Ysc/axC+c84wNt5yfUQzgSm7
	 lrK0UJziVWctmuVwg60tMe+Nwz+8RXyRc7PIcYQeltFPE8LCtMJkFW7/sWeQafYw3kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=Fb5v+9t5;
	arc=none smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA47606A330
	for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 21:05:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AA47606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=Fb5v+9t5
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b587591414so2858254a12.0
        for <linux-rdma@vger.kernel.org>; Sat, 14 Nov 2026 13:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1794690307; x=1795295107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S6r9JliYuLkU6bNVnsHUex3XuU8S/UM2soCRpJowQjE=;
        b=Fb5v+9t5HQpH99lBDL6eSyXCd561d6T4RIG3tul3obk+hV+lLvqwx2E/a53VBrruzj
         C7QdCNRUNH/J3utrvpe2c/geGqZ5Sl8S8ROXMNSnD6HIxac1Ng+Ry9w9h6KKx9WqPGRk
         nL5/soLI9m/NrOZQjEKC8IeWYL9z0hSTP62ueEx8glDPxYjodiB5UKN/us3YZ/pjLuiy
         jR7DawCFm/DODgpczCGYTo42aYB6PExJBlNnAUTnFQ1VK90sXBu/fB3nC7A4lv4SEGbL
         FCfXgTsCZXAhHYy7HOtrxslAD9W2+jbfWDGJdsvIuv9xo7so5tZou4C9uFbhXQelwj4a
         ryLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794690307; x=1795295107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S6r9JliYuLkU6bNVnsHUex3XuU8S/UM2soCRpJowQjE=;
        b=bmfqDMpFYxHBQvqBlCGONB8yYfEk7ENSITKlzKrocJr/qnlxviysJ51rka02u/lWPN
         yVEdPpcdkEIyyD3+GeHM4dz8XZjLe7CZ3y9NNwThRADsyEckA4o5BUxQ6ieFwhN8bXuy
         5YYkpcFQWhY97g7k7PFKCNU1KNkRrelvXxd2fhHNdgGoHaUhGOr3Vu0Bu1uqpKh5i7Md
         PYcDUtHUg1dCMvr7lrvdX/gub4eUaT/wydVRur0KDQMyjswzy5hr4MvHE5GY4tmg1Rsx
         NonMlmiLc5d+aARN1m2Skdignaqzpzb7aFVg4Fki7rlGSdYKUnvqqsWIde2LBEjYOyij
         D2+Q==
X-Forwarded-Encrypted: i=1; AL+hErEwxMS9J7eSFpEFh9OUWxo99sAz+v5mMu9HIeQLyq5Y+2MYWijzBzA0my79fuxIIKozwBwZF/H8Y2mU@vger.kernel.org
X-Gm-Message-State: APuU4Z9aVjMcQJtblPtVypSDyraxDcIcwrXAqkJxnQtATzPSbNOOsLj4
	MrNxwwZmpr5oFoh+JwgHHhbXJ2vLKVlfQVTi9oy4y0KiuyNdyqSpCvAza7GGNB8hHQ==
X-Gm-Gg: AYBFou14brSbRleIsuXqxcLIFGATfPxyMxwULD0vUXqmNd8JnykpW/oUr0sPXNpTOWg
	mv3SN1gOUNFa+Gc7ybMn9fKGHhES4qYFukFMRoTgzp7NQORVP/jDgY1KH0q92N/DMYkJOhO+hdK
	d6Hx5jC0MMh1qhr1ngIfeYHlKuIIx4uqX/0jlynzn51i1T8iPGJuNJt5DwGCMRWd2JHLwuAtb1d
	yzXkoIRyigKJ7Qg2aJ3M50NZIeNSr6i6qWkhQc/G0o36/Ss6E/NPy+DLqcE2xtRRPgoB7QA+Wws
	OzLu9qlA9un43SCcCZ6+DciqKRBmHx1yUENu/Sqa/b5auasxY48QuSUURH4LBEdYZbrCyxDawUS
	Y7wiqo2qzQgPX+wBlUMtO4w8ns0lgvTAytrHoQ4cR6f3C6ebXnEtd2pDIdYpGYUISQ4tZ3+yKNF
	F7tmlckILPFBgsIJCPj2AEOiwMlHKc2iJATx+euaIOe+K2LbdU2gGf0+9ZaL+5NwczZK6Bj+5LV
	JheYbyXhqXZEm2LQGINxWnZUj+OpaKdc9mdMi+mxoNqGue78lc9j9siJxmmLj4fu8QXhsjR5xZH
	wvGPJui1AFmUBasuz5H6QbZsXq/lOHcd5Rdc2x5dbkDU2zU/SPW7cQ7JgZMnwzsRUttasb9+pif
	2Bt/tK56lwUbHHCkjo/iUyVjH/Is1OEx74Kcwp6VYPvI1HWrvw8wT5Q7E/V93HM8JUHzvbJ5ZDl
	NZP3iX1uFQ1p4XyvBLxCoxL2ImyNxy9fcbVv/tkrL9PnY5SsCfi9DbQ04P1mZ6Ejr4mCq9oygR3
	rFDcI046E/MMK9Eemf6+I5TRBUh1CvlmtG/+XPSS3IvqxYGUYbipTjS4GYBYOFDOiVf5E88pXza
	UqusjoiabCCb0BVeXSFYGOMC
X-Received: by 2002:a05:6402:42c7:b0:6b7:eda4:e136 with SMTP id 4fb4d7f45d1cf-6b7eda4e281mr1321653a12.41.1794690306618;
        Sat, 14 Nov 2026 13:05:06 -0800 (PST)
Received: from Desktop.fritz.box ([185.181.130.189])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c2361280sm2705836a12.10.2026.11.14.13.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 13:05:05 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netdev-bot+sinfo@kernel.org
Cc: netdev@vger.kernel.org,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	dsahern@kernel.org,
	idosch@nvidia.com,
	ncardwell@google.com,
	kuniyu@google.com,
	richardbgobert@gmail.com,
	willemb@google.com,
	ecree.xilinx@gmail.com,
	linux-net-drivers@amd.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	alexei.starovoitov@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	martin.lau@linux.dev,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	shuah@kernel.org,
	bpf@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] net: keep the TCP fixed-ID flags on the header they describe
Date: Sat, 14 Nov 2026 22:05:02 +0100
Message-ID: <20261114210502.787195-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <179468119953.2168702.10813567320493574993@kernel.org>
References: <cover.1794139176.git.julius@bairaktaris.de> <179468119953.2168702.10813567320493574993@kernel.org>
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

On Sat, 14 Nov 2026 18:33:19 +0000, netdev-bot+sinfo@kernel.org wrote:
> - How the issue was discovered, e.g. hit in production, hit during
>   development, syzbot report, manual code inspection, LLM or static
>   analysis tool scan.

Reported by the hosted Sashiko AI review of v2 2/3 of my "ipmr: forward
GSO multicast packets" series:
https://lore.kernel.org/netdev/179182559332.434549.18294510093742639467@kernel.org/
I then reproduced it with the selftest in patch 2: on net, 6 of its 18
cases fail in 2 of 2 runs.

Julius
