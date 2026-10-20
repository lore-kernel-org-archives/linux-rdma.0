Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.76.27.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792499991;
	b=QfZk4+NL4krFoAjR/uBCOnNy7avlPN2E4KCZpdGHk90c30JN8e6K6R+T0zHKPzPPbelO
	 eN0wxIGDxB9GZSebekDogevlEmkeeoFobyNr17yKiPFZx2OrLi/nrgcYanZTYdrnHq4jy
	 WuP+MgLDJxggnfVcA3de43nwxt54frqSabYq6gT/83ouTOF24L2+RxN0h58TupmmhQRBz
	 p6Bxz5PU7UZuAHQTP/qM+bFPBzYP7YLmbf1Pl2S5l6PSTqYT8NJIORmh+VWilcY70T9PL
	 zUf2lfbUXsPKnCJ8hoab/++IXNZSr9c4Ueb265GreyRx0U0PEgCaWirr0GDX4gd25sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792499991;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=99Rn/UZ1H9MbzGEXcXS/NYd0KredJZ+AqYa9UlDNkl4=;
	b=rAB3nyOP6/SXM/HTjIUX5xj3oxteEfcqIUezbZHny03KXhlV9nggNab+/2jsKJnbCiVT
	 DP+52EOm331A8nucDegJkn24ZkrfDn7Rr4qXy5kKzsyjNTAdh1rjt8JPy+9dde6RimIn5
	 D/caHPYmgpJJnIltj83jQR+ONCfO6tcUNja4rppw3YpkQnL613ZmR09z4MwSwBpTH/ch6
	 k8US/loLAXLRlGr7x93dx16f75KFnCRMJIKm9bIkL+nYYNkEbKkieRRhZv3sFyBXVC+fY
	 QisdmEvqU69Pu8JSxmZG8FDtTQFm3qxH5UFkews9bKt3Mef/sKX0goBOKE5un0vUH2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=andrei-z.com;
	spf=pass smtp.mailfrom=andrei-z.com;
	dkim=pass header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=Jur1rxuw;
	arc=none smtp.remote-ip=82.76.27.144
Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F76606A31E;
	Tue, 20 Oct 2026 12:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78F76606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=andrei-z.com header.i=@andrei-z.com header.a=rsa-sha256 header.s=sig1 header.b=Jur1rxuw
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 8221013CE8;
	Tue, 20 Oct 2026 15:39:47 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=99Rn/UZ1H9MbzGEXcXS/
	NYd0KredJZ+AqYa9UlDNkl4=; b=Jur1rxuw7ZoSUr5QzCGDJtcmybHMgFIclklY
	47BolaC3w5bG3R7PL4hw3tPaUlTwrTOI0w6kPwvmwRGIbFUg2v7yMGY4QKjBejiB
	6b7rEbpja4wLd6cmddx1ItNnnJCVRLZdwd0xWT6HpyhPoHkaQUgJ+NvlhRcqOvY5
	3ams9kW3EgV5nbFPhjX4nwQ5pnLAMXOJtynu9Q3NUbJXvY7ICngblMHu7Sm9dH31
	c9RfFiNny0eNuq3puzSTu6Q9hhGcqJssG/6JDYWGZgRsdLFsDgDVxLQGhGKyuM4e
	GELmwSXkSJ59TMfFLpBpmGxZkQHT/9qz5Gxa86w8xSEPU3h0gg==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 0885513D28;
	Tue, 20 Oct 2026 15:39:47 +0300 (EEST)
Received: from [10.89.11.73] (10.57.8.14) by VTJ-MX.corp.irix.systems
 (2a02:2f04:1:9c24::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 20 Oct
 2026 15:39:46 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Sagi
 Grimberg <sagi@grimberg.me>, Max Gurtovoy <mgurtovoy@nvidia.com>, Bart Van
 Assche <bvanassche@acm.org>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 3/3] RDMA/rtrs: Post client read requests inline
Date: Tue, 20 Oct 2026 15:39:38 +0300
Message-ID: <20261020153938.1445837-1-me@andrei-z.com>
In-Reply-To: <CAMGffE=qjNDYdwx1PYgK1K87A4NhJ=cuR+kkUhdYH81gSGb-nQ@mail.gmail.com>
References: <20261015125118.2966247-1-me@andrei-z.com>
 <20261015125118.2966247-4-me@andrei-z.com>
 <CAMGffE=qjNDYdwx1PYgK1K87A4NhJ=cuR+kkUhdYH81gSGb-nQ@mail.gmail.com>
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

On Tue, Oct 20, 2026, Jinpu Wang wrote:
> The change looks fine to me, and I did some testing on it. However,
> the data doesn't seem to show any clear performance gain from posting
> inline requests.

Thanks for testing it.

That matches what I measured. The gain only showed with one I/O in
flight against a memory-backed device (4 KB random reads to null_blk,
ConnectX-6 Dx over RoCE): fio's mean completion latency went from 20.1
to 19.7 us, under 2 %, and it took 15 paired rounds to resolve. With
more I/O in flight or a real drive it would be lost in the noise.

As I wrote to Leon, I'll leave the series unless someone finds that
latency matters to them.

