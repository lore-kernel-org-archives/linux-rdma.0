Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8221E4A3F03
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 15:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486995; cv=none; b=pKlpsv51MVG2FsDhViIZHyVEon8+Ccfw4sh4TsBphDTF7y0LOad8KczZ5BxZAX7yyEX5gK6uky3Ky2/Z1Rvq4tcU2Nfl5JCJFxehOjU22w6iSCoWsdnUuBzXMX4mkOsolFfsaqXR6tL3o5jB/fkDDbZ18OwBwfT3tG4GSVjXMh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486995; c=relaxed/simple;
	bh=uPclshAJwXHcVEzP6lVgxWj0XtHhxbV+qlP7/9MsRjE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kWwKWSwfEY2CFH6+wcETeJgZSEhm8HOHz6xfwV7BIwQpo6JdYBWh6ztNjZ7F8CpsraqC799r/tfb05XAcUqQP30mXjX05QrSmxmlPJySd+uYtIxRD7u4xxM2BL8BYSjB4fRIodT6b7TzSrfG41aeVX6GQM980m0GaI+3duU5PoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnxL96qM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnxL96qM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB521F00893;
	Tue, 15 Sep 2026 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789486994;
	bh=XFm6F+vwIkjmFo1ZJr5t9KeeSiF8r8dIKaR7qkTxvJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nnxL96qMpOUaHz4gG66dHJHPY1+G/7/sgZPG7ySJzwF5qKjaSBEBMGKGBO53aUI+o
	 Zr9hcn6Cu7Olqg8pPHcbNz0UoDBmnFuQUz+c4+F9ZCdeRKWBrhoT3ImLM6f27cnRYN
	 NqAKxMQmpDZ2Fc0OF3lksAbo5h2ckKr/cRaqgOgXgtkTDWkQJnfdwXmgvxScDTJilj
	 n3mqUSzvQW1aE9LK2lsUVg4iQROhKueSwVaq93ctoyTFaRt/kF70s1NcaaT+mKOstb
	 tUG1pF4xT4NjLxbAZJiDBgYSXYQ+ysjsZJXCkPcpLXHdmPD45X8vLTQbEzSdd0wL18
	 XITBNp6gy6wpg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 1/4] RDMA/mlx5: Use unsigned comparison in the
 CQ cleanup loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Edward Srouji" <edwards@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915-fix-cq-cleanup-v1-1-e991944cf898@nvidia.com>
References: <20260915-fix-cq-cleanup-v1-0-e991944cf898@nvidia.com>
 <20260915-fix-cq-cleanup-v1-1-e991944cf898@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 15:43:13 +0000
Message-Id: <20260915154314.2CB521F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yishai Hadas <yishaih@nvidia.com>
>=20
> __mlx5_ib_cq_clean() sweeps the CQ backwards from the producer index
> down to the consumer index:
>=20
>   while ((int) --prod_index - (int) cq->mcq.cons_index >=3D 0)
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
anup-v1-0-e991944cf898@nvidia.com?part=3D1

