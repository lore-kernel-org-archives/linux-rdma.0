Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795683468;
	b=oeeDSrjIa2QyHuZT2W9yrTKDQWFylTC1uJoepIux8ye/mamcEs9ATg0FAFXmoFf3CLMg
	 QgUtfIG2kk7goM5lljin7Hxo1YXHBuBHCvEqkRUaBqdYvr4kLI5gZ1DvRItXyT56jTI4I
	 DTqYsjKHyqiNXqm/xOD2c5wa6bnHhsfgXxgWY7jkVaaE4/BqCZAbO/sLZaP1oXPv5pyiB
	 /+0xnkluWChyhrPmqjaR+GLvqyZVpmR4RnZO23oKILCpmNMiAsv6vIlyMFNjOr2SZneoh
	 kCmLz8LO+LJv9Y7k3qisrVEfQbBfZJfZGap7N0H5O+vIKhBESWsS221KH3ENk35gASA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795683468;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=Fp76IfrtGXp9iGSL34GKoWvUFdDeaiiKfiG9zopH8+4=;
	b=mOhMOGQ43qZZxztVqlTsvQTs5eC4GmQIuJSCvWeBbR4N0e9J5R/s33ywa4Payu5suXfR
	 b+NFG2B2siYHxyyVAaFYvTwzjYC2Cxqf0miDs48WhGfAH7odrAaIcH2QNnt+M1F2PX6Ym
	 QW1Lic0PIpgNTlLdT8aQWGO18ucsFo+XGum5b3H4UnveS0J5ilzK8ezPz4c1h9FJFcjiI
	 lrRhMssy2L6hMEM0eQgSMbZ9/x6pofFhLpxhZuObIomoKosj+HuTmv2VVg3hp32OXEf9u
	 FHcKW700gvHfnmiWTYhZJiFQireib/3F1LFUakxvnXwQSU9zojLODWQ2Cp6k2oNSrPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EQ6Sm4ZD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FC0606A31E;
	Thu, 26 Nov 2026 08:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EQ6Sm4ZD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CED81F000C0;
	Thu, 26 Nov 2026 08:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795683467;
	bh=Fp76IfrtGXp9iGSL34GKoWvUFdDeaiiKfiG9zopH8+4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=EQ6Sm4ZDhz1hnAVpCqc1rw5tlY/ffU+k+Ec0sCxGoj7RgVZ8jMz+E0Qyul7aHvUeY
	 UpoEIjTh8rK9st5e4XCgKZqO7VR9p3wiXs4iXMg3EDnnnsSZ2HiQkfGmcd2Yza9oO7
	 zSNuWxGLVMwLfjugzIqHE94nObTnvkviD6KXp08JQ//ZZMnMnREEc2M8bRRGkLR2l3
	 4lH3ACSkNL5LHZUAUScleolym+7n9kJcwN3CYkUimataKc/7Yb13UROu+Zci1DKGZE
	 YPmnRGQMukNKcuzVxonFebUOsIQu0NAKtr81ZqXF/yUTKE/qXZUu+REa1CodY/egol
	 qhho7zIW33LmA==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, 
 Andrew Stellman <astellman@stellman-greene.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261122170551.19582-1-astellman@stellman-greene.com>
References: <20261122170551.19582-1-astellman@stellman-greene.com>
Subject: Re: [PATCH rdma-next v2] RDMA/rxe: Require a responder resource
 for FLUSH
Message-Id: <179568346521.1251294.15806808601670027765.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 03:57:45 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 22 Nov 2026 12:05:51 -0500, Andrew Stellman wrote:
> process_flush() keeps its state in a responder resource from
> rxe_prepare_res(), as READ and ATOMIC requests do. check_resource()
> refuses those requests when max_dest_rd_atomic is 0, but it does not
> check FLUSH. With max_dest_rd_atomic 0, qp->resp.resources is
> ZERO_SIZE_PTR, and rxe_prepare_res() writes through it in
> free_rd_atomic_resource().
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: Require a responder resource for FLUSH
      https://git.kernel.org/rdma/rdma/c/3a4881d7bedff9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

