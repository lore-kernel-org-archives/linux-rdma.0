Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D1D3B2FE7
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 15:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486908; cv=none; b=SChWbyVf62+dN6ZLrY3928tVdQCSPCfNvsIMXW6+kUpxAbrT/WDJ4EEfnayQP3qnHiOHKDkVP/AEXbsE5YWFPTVPfqHeNEq0yLq8UWlydegB+qat9ChNfE27Eijk+xQ0o55Pb2DTBvzHChZmUWJFew++UtuaC8b9pnaR/6TCBcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486908; c=relaxed/simple;
	bh=4sKjoIdqaDlvkqRvNScqLZdOks8Rs/tMryaJRaNE15c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mKYoPj63BJd4b6zhUP/WfwSiAh6M4NYU5RrFcyQIzDUQzv9oZG6bUll3fmdZHRw+fedIwC/iF7T+53QnxCf2APlf7eXFdwucBaPQA/X4BNnYkX62nEiEfTJuSl2r9b5/Frh3KJvp+46TNYdQKKcfspUWXqBGi/I7IWoa+6OnqxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bv3DigeJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bv3DigeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C059A1F000FF;
	Tue, 15 Sep 2026 15:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789486905;
	bh=nA7FbxDoht+oWIFmuVedKJF9ghd0/W/+hQF93OfEm3U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bv3DigeJ49VHgTw0taZ7XMSczjz7ZWMeH87c7v4LSY6foz19IWF5OVvARD8zHwhV1
	 YYRUs3V2YTRhPlFPhgT4q4jHMFsA110wNlP0chCe3Jj7H4Yx0r+AhXpQhzdMUgnd9+
	 57p+WixCGPIHnn7mQWL4uPdMkhsf5Wg+kX5JMHTs2kVdMjuJKhWCoSRzQibshTZrRD
	 XaUr3rxwbhb4Br44cid/+lyXa27G/8IIDV/O3os2lqSbmhSXKAV7DqVMoSPvdqK0rz
	 uyA3EF1e6t+3odCT9xPusbtXOfnXxWpsrCSd6VwGfqXjuunIjfNXkTz7BDZ6eK53Jh
	 o8bt0CZ6zaRuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 3/4] RDMA/mthca: Use unsigned comparison in
 the CQ cleanup loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915-fix-cq-cleanup-v1-3-e991944cf898@nvidia.com>
References: <20260915-fix-cq-cleanup-v1-0-e991944cf898@nvidia.com>
 <20260915-fix-cq-cleanup-v1-3-e991944cf898@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 15:41:45 +0000
Message-Id: <20260915154145.C059A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yishai Hadas <yishaih@nvidia.com>
>=20
> mthca_cq_clean() sweeps the CQ backwards from the producer index
> down to the consumer index:
>=20
>   while ((int) --prod_index - (int) cq->cons_index >=3D 0)
>=20
> Both indexes are free running u32 counters, so the comparison has to
> be done modulo 2^32.  Casting each operand to int and subtracting
> does not do that: the subtraction overflows whenever the two indexes
> straddle 2^31, which is undefined behaviour, and a compiler that
> assumes signed overflow cannot occur is free to discard the
> subtraction and fold the expression into a plain signed comparison.
> That comparison is not wraparound safe.
>=20
> [ ... ]
> exactly that many iterations regardless of whether either counter has
> wrapped, because the loop no longer compares magnitudes at all.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-fix-cq-cle=
anup-v1-0-e991944cf898@nvidia.com?part=3D3

