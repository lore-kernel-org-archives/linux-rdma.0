Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ADD4AE8BF
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789487078; cv=none; b=jCvNEhplwpS8NU5Tg1XsfU7Ajq4R9v9F50n+sHibsoKZh2turI9kAGzhZ/rwdbhAKcyg5jAjLH7yXdf5owKn5IVQ8m+/jm5h4uBS7BYsBEceVK2EtlVeJDpVU8JPhbpHewe/ewkyvNzK/xrnqZ8Gd8JC8IYbkIrd6fRPpcDB4Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789487078; c=relaxed/simple;
	bh=M/dm0YVtuV3n5DLAnO4/+jVWJZAgE4h6H4wTknz1m6c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j/Y4ySB5wyoBOauOVb0bPtq9AQAgmJUR3wipSe/MkmRPYxcw+d2o6CvVl2vnwuVekCpv0c7XkNBxpyr3S1Xa6fHquDBw89jVRAraHygggsuPQDnPL9u5jhz9jfpJ9JsGiJbpbepe5k3dEeDssgK8Z+J3p51ZbKE1NKry7wmxv9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hK373Fnb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hK373Fnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303811F000FF;
	Tue, 15 Sep 2026 15:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789487077;
	bh=3SgrApRckmlV/11lP3A0D0mTVIUEVEuWW1S7Rq/Q43I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hK373Fnb04yAz8HFdUa7EPgwJ8CTxLvsXcECPmiElzfSHkmxPa5mjpWGFJULKySeI
	 zzUrLN3FrPyziQ7cigqr0snO4qxF21NVGAtSUJ0P7PtlwpJrATZAektqS4E1nXoG2/
	 nacsaJqPOeiU2NpT7Hlm8XrvEZbcFtMk+kYaYjHSHcBd+0USytKxUQisbfA8STuAuw
	 PKChw4ql+MMEoNWK7r+fVgjMAsRBwh29rqTWT4aPI3JWLn3ahJJNkQ6eHMqicmqZYm
	 Y/tN4Wo/k4z5nBz+0le3iVU8TzyWzHjIh6Krtrd+OgUucOoWL6TOFXCVAF/XKHQYY6
	 4cSRHj/AYfh9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 4/4] RDMA/hns: Use unsigned comparison in the
 CQ cleanup loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915-fix-cq-cleanup-v1-4-e991944cf898@nvidia.com>
References: <20260915-fix-cq-cleanup-v1-0-e991944cf898@nvidia.com>
 <20260915-fix-cq-cleanup-v1-4-e991944cf898@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 15:44:36 +0000
Message-Id: <20260915154437.303811F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yishai Hadas <yishaih@nvidia.com>
>=20
> __hns_roce_v2_cq_clean() sweeps the CQ backwards from the producer
> index down to the consumer index:
>=20
>   while ((int) --prod_index - (int) hr_cq->cons_index >=3D 0)
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
> of whether either counter has wrapped, because the loop no longer
> compares magnitudes at all.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Edward Srouji <edwards@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-fix-cq-cle=
anup-v1-0-e991944cf898@nvidia.com?part=3D4

