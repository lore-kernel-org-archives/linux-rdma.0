Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6384A5EB9;
	Sat, 10 Oct 2026 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791643330; cv=none; b=sWbFEQAPtmgmWlf2bjl9TLQo9T2BffwTMGS3o6MR45R0JPZSW0nYq00z0OIq2bNgBkgzMs5+WtPYLVnIlpIkk3pG08oEGslWHPFCrBTlbxJOvrI0EHXKs/cGHPBxcXpLxqf4iW8b5w82MSCwYjUZGOcSbv19s9G+lfKxVog8M3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791643330; c=relaxed/simple;
	bh=5wg2EBwmLITfL44I49h67OkCyj2koEuv5Lh7LBjx7zk=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=oC9wN4L5ut+Mz4uoM9MSSgnYvu7PrxQ6S/KAbdJHiqDKvM39IIDXT2iZEjqf5SX9gApAgGEdRJ1BjR2SBhDta+CRXBS5mc2shUnHJJVLvdDz1Sx03HTMEFqgqrQxcP9l8+74aVJ/TZPAYZIsDZ9VcCCHOfxQ/Qbmoq/Qxa2bufU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TsbwA34a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TsbwA34a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50C11F00893;
	Sat, 10 Oct 2026 14:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791643329;
	bh=5wg2EBwmLITfL44I49h67OkCyj2koEuv5Lh7LBjx7zk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TsbwA34aRixYo8/kF7VaCnZCyXJCQxo5p4PCuhqzDb/judlNObPWMNi6FGYe7vE02
	 KxyECMvQX3TxUkRslo6Q2y992pyTfYTQ2438KUyKHkQAcbOaloL2Zv8sjsta3y5CbC
	 b/FGV5MA7NHCNG7esYSPJjK3LU9xuUBa7usyRWaU2/g1f52LZe2DOHNyJBtm+nkI07
	 wOQHqRBoEbMMWLBNFTRpDDD7Mbdf+uaLNKmi69jRoDaeNrOfxg8ZN6l8p+XT1gI0RJ
	 iI6CDenW3VbOlzZpYFCfBNFJTdEUTvIEgbP3TWRhw5O8NEnk7ODTETzWeEpsYXhbro
	 kR36ZAd3wXORw==
Message-ID: <sashiko-outbox-166663@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 11/13] net: mana: keep a user-configured RSS
 table across a queue rebuild
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <c55b41e6ee099a5c49d68a167b91b0810435c291.1790795005.git.weh@linux.microsoft.com>
References: <cover.1790795005.git.weh@linux.microsoft.com>
 <c55b41e6ee099a5c49d68a167b91b0810435c291.1790795005.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 10 Oct 2026 14:42:08 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Preserve a user RSS table whenever all entries fit the requested queue
> count. Regenerate driver defaults. On growth, a retained user table does
> not steer RSS traffic to the added queues until the user updates it.
>=20
> Report table loss only after successful queue-set publication. The
> non-swap allocation path still replaces invalid tables silently because
> its callers do not consistently hold the notification's netdev lock.
>=20
> Require RTNL for RSS setters to serialize them with reset/resume rebuilds.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790795005.gi=
t.weh@linux.microsoft.com?part=3D11

