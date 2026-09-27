Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71552E612E
	for <linux-rdma@vger.kernel.org>; Sun, 27 Sep 2026 06:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790491046; cv=none; b=LTwBLw/f48FGt5Nf34S7g/xghsa69bXBjyG7VNOaZfoXfTtGeQ4fNC4phAdinDTErVFL8DBvo7TkWm/thkG6rwROtNRxe45UXp52nJ/YAiSPY1U0uhcdjWRVUMBb2FXLE6F97UshXEh2gsMYWB1jc3IxktwLTuAcKOya3xudAss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790491046; c=relaxed/simple;
	bh=xOemB3x8SIlbUHLpnOXsCYCUFsg0QO1NKQ6n9K3fdPw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qrOw43RL4n22SSHtX5YL0xbEb1R4tquqMct77XdSvOMLBGg3A1b7gNyaBenkNE6E9lZp0qBAMTJNwvS1yaZlFb6iyuTDETWmRldBggp4Dv6jTk0hYc+YobOWT69/Wo/39SuE3GFW2Ii/5ZVgyZPysveoWeY/q6gi7sOZlkU8s9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZ8zxubC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZ8zxubC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340951F00893;
	Sun, 27 Sep 2026 06:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790491045;
	bh=xOemB3x8SIlbUHLpnOXsCYCUFsg0QO1NKQ6n9K3fdPw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IZ8zxubCgDQIJ4wFRgauIljXELVPWRbRlizbTKgVSUOF7c5vy3hvlibF9zLvLnOJK
	 JsNd0FeTpDvYflJQ59kF96BO4cCg+uTwt31bqkTb8rF3COR6byVXNHOaaSc5ftrF7F
	 nMitEIHOw0x92LaocfoX19IYexRZNcD4vTzqx1jDJRWHXT0b2HBKtZr7Hje/hpWX17
	 GXGetEjt8H2LXwXIKZM4dQotS8EPX3y12mupGywf6r+nGp5ili9mYDNWXL20w4AJwZ
	 e4pM28dfWGUdJKwZcul8LSxN7Q/kIJEZz/MassjSxIl20NYuqUsV57Yb7i2RQjQuPZ
	 7sqompgejXbwA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 2/2] net/rds: log the port a listener
 actually bound
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927063058.170273-3-achender@kernel.org>
References: <20260927063058.170273-1-achender@kernel.org>
 <20260927063058.170273-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 06:37:24 +0000
Message-Id: <20260927063725.340951F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_rdma_listen_init_common() reports every listener as being on
> RDS_PORT, but only the IPv4 caller binds that port; the IPv6 listener
> is bound to RDS_CM_PORT, as rds_rdma_listen_init() explains, and its
> debug line has claimed 18634 instead of 16385 since it was added.
>=20
> Print the port from the address the helper just bound.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927063058.1702=
73-1-achender@kernel.org?part=3D2

