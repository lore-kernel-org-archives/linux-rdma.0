Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8E3408612
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443463; cv=none; b=IQIIXgbGodP5r3Omp/2MpvVQWI/s5A/4liT6eZxP1vlxc802L348EkFK8iVP2nZ6azcqbT/t1pvW2mRwjvCQ6sI2Xq3aLBoUJw/C5aPkFoSRLd8TKia1p9pbvI1EYFrSB3/px/BY1x9IOiUqS33L6HgA/qqMe5wD/wXh6adoskg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443463; c=relaxed/simple;
	bh=Txged/zpT+c/iqH8oMVI5H/2zk+s1bKsGaz82B1L2zU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ot+uOdg4tiU+gBB5KDXAvHz4ZG1WPAWwctLnt88wH96eR1oTKAPwzHLsCQRb4tcGaN+mfAP0oB/V4oAcozDQTERb+1Cbn8SkWgd/OGqX/Iz0feYWMDIP/iKYZd5MfjKRiWt48/fLbtrpWpaRX36pbU/Y9/kOb1tVRvQvMxsVudk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHv5Q1dt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHv5Q1dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DE01F00898;
	Tue, 15 Sep 2026 03:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443461;
	bh=hshEsj1tj2G6NcT1HBoBWrt+sZZzQNmPA9iSMcefQxw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aHv5Q1dtLv7f3lANRngL6r5pkhkIIbhjkifZM2FU02gRwZfC0MDA5IUH/rgpHeW89
	 khllL/64EB4WAqZSFQsb5uhC0AlTCPnzHX5+1CB8s6g9LitPok6GeiJ+EsCcKHph/I
	 3KS3JC275VtuR5MzNSwxOB3k95qgWJyRDvzqAqRDZL+Xf+rjpB9+DGabEh7LQak5i1
	 1Ze0ssbFwWOWRBH6aIwUP3NZ+Jlq0mct0NxwjqYCysETFLRaKa5aL3Ros+887kcA2s
	 ZOyAevA/IKI1NQES+p09B4k6wRnoQpkbowcjm5NFOO/FU1JPRpkBiiprCMljePjN2p
	 ddevxnfaytkjg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 12/13] net/rds: drop rds_conn_count in favor
 of t_conn_count
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-13-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-13-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:40 +0000
Message-Id: <20260915033740.E6DE01F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The previous patch gave each transport its own connection count in
> t_conn_count, incremented and decremented at exactly the points where
> the global rds_conn_count is.  That leaves rds_conn_count with a
> single remaining consumer: the seed of the per-path workqueue names
> in __rds_conn_create().
>=20
> Switch the name seed to t_conn_count, as UEK does, and remove
> rds_conn_count.  The numbering becomes per-transport instead of
> global, so connections of different transports can now receive the
> same seed; workqueue names carry no uniqueness requirement, and the
> seed was already reused as the count rose and fell.  Removing the
> counter also removes the rds_conn_lock round-trip that
> rds_conn_destroy_fini() took solely to decrement it, leaving the
> free path lock-free.
>=20
> Based on the Oracle UEK commit "net/rds: Each RDS transport
> should keep its own connection count".
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D12

