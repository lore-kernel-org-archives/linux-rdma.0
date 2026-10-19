Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.76.27.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792440755;
	b=5QPWc56URe4Bz2gh014TJPWM+BqC2SqZG8JsZKfvpmGFAExNaVweQWT/mnVWZ966mXvj
	 wrJzHtRvqFy7xZRSZGK6plVOfxuTr9qoKTQnxvRReLSqT7fBVJj7i0u+1khgJxYPJMzGn
	 9Zc7BbL52pBF63jdFVquZP2jfyHnJgrWqMNOUd5B2JRM6blYLJSs93YghCObRdbcnnzme
	 BfB4+ypxKJCPomTPNvZvEglZAA/mITu01H7aTU9Y0E5k3FosT8Z+G6MrSkuqctVr8NHkY
	 2SFRDYIl8Qiqn/n5cSpoJe823E+yZcQwjZTdvZYNzZ8fZR/A/5yp6MeKGpkfBVwus3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792440755;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=ITKID4j8TgDVznTDt1fwfhzQj8gSfNUjv1loj3KnXbU=;
	b=IY5A7ILRkQMW9KTHkhzP8UsaTo2+JGwz/XL0gu/Q7G6nl4eqa3nZpVQka/Cd/XPm2vkJ
	 d+OExvdvuk55OGVNWtbCkj7+o+9+qMMU+QHzaKyxXga4RW1SqapxxwWQ8qbiiCBm2Bn0q
	 WPrzzYqRW9OZQBLJEwPqkBi9Bpqvzg6NW7zWNlS9CdXfujyUhC4F+f7SaN3TIHz/E6DFe
	 7+oqPSJSy8Hr0DpqTi/zyNNZbdMn/tHpT9vHPKGGmdoUhiE4Br4g885kAcfh4rSoJDx9N
	 XvEqo+lCVkB+pZB4sRUXwtptuXiOnbGT2jUx24JouHyvVKhJ24bFsdDmu1T0cu2IB3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=andrei-z.com;
	spf=pass smtp.mailfrom=andrei-z.com;
	dkim=pass header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b="fcoT5/MX";
	arc=none smtp.remote-ip=82.76.27.144
Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF26606A31B;
	Mon, 19 Oct 2026 20:12:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCF26606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=fcoT5/MX
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id D991975B4;
	Mon, 19 Oct 2026 23:12:26 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=ITKID4j8TgDVznTDt1fw
	fhzQj8gSfNUjv1loj3KnXbU=; b=fcoT5/MX6d/UCCPfWG+cVebnYEbR2anMKwdC
	Q8ISp3JlwyWb2gwdWCXmdo+kUd2dtF42jBk4JLZupYso4WJCsCZeSQkWs4WpqQ2v
	od/KvvV72k1P+3fV1ILymDZ7FOT8itWtin6EwP6mOxsHqXRKT/UfkvvgDQ/y/zj1
	+BNnCB/8S3AP1bDOd7C5bcswlbpCUFwDdH8E647rQR3GSAI2nqd7YEZxOKdUJHBl
	qR2m97ohVGf1MZLAKq6j4FEHURnbawhpv18p5FhUszjQa2TpWhZ8+FLsx11nlOsn
	+lqfBbrTH27GGLC1uMY296efjCj0ywvMMOAncfb+Fc/Z3sSvPw==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 9D7E6765C;
	Mon, 19 Oct 2026 23:12:26 +0300 (EEST)
Received: from [10.89.11.73] (10.57.8.14) by VTJ-MX.corp.irix.systems
 (2a02:2f04:1:9c24::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 19 Oct
 2026 23:12:25 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@ziepe.ca>, Sagi
 Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>, "Md. Haris
 Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/3] RDMA/srp: Post command IUs inline
Date: Mon, 19 Oct 2026 23:12:25 +0300
Message-ID: <20261019231225.386811-1-me@andrei-z.com>
In-Reply-To: <20261018100501.GA41539@unreal>
References: <20261015125118.2966247-1-me@andrei-z.com>
 <20261015125118.2966247-3-me@andrei-z.com>
 <fa01c872-9d1d-4b60-b994-08ba86a5ebaa@acm.org>
 <20261015212227.3338582-1-me@andrei-z.com>
 <20261018100501.GA41539@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

On Sun, Oct 18, 2026, Leon Romanovsky wrote:
> As for your question, we need to hear from someone in the ULP community
> that this series is important to them.

Fair enough. I will leave the series unless someone using iSER, SRP
or RNBD says the latency matters to them.

