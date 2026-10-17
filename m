Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0872E5B2A
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 19:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792266343; cv=none; b=Q5S9y2dWPgAeBOPN0laxl4zHjJhJCF8MQCA72cDiBEyYKz/bIF8HS+4+EFYWQse/Amx/qun8Vp0ycD2C4nVjsh+Z7RxtM47J/mCHnzF6lxVp0pW9HNbQDX1/cy+tk+Xh6F0/5vhRVCzdWp6yvmBWX2ypVRRCLarHqOVlGMWTU4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792266343; c=relaxed/simple;
	bh=TcUUiw0rU0Bx3l+UQkZ/JRXy6ZX89mpYsEq2yH85Pns=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Tnv9Ib266SdKmfIGBSNoZalPWOzm34UjX8wKDPO1SACW/R/0L1UaG7Wx6N8v5+1/U8qNE8P3rsQ9pNs7RAVEEYrhmBQgOvqF7KZXHzL1NKrP+N9+j8pQd/4R598aXOXRX+urivj4f1+u5LCNjwZVjOlEA6NQJqMsh8N+vXj32Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAkqVEWH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAkqVEWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A91C1F000C4;
	Sat, 17 Oct 2026 19:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792266341;
	bh=TcUUiw0rU0Bx3l+UQkZ/JRXy6ZX89mpYsEq2yH85Pns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VAkqVEWHKzKuZLuKq8uKIcLnJOLz5Tw71RyddPJ4G+VkjcUdHAS8eGSY4TDj0iUGR
	 9YWXZ8MX6Nm9VJMoSWQ3vnWNPuH3IgRtteimiiPV6Yyoglow16/dBaygM+JVVeHeoL
	 EBmVbShRu2XyIlWPRPySm4bx8U0kkXak4vwQeKmfw/GHa2astx3pBsky1Dhc6ZD2Pp
	 gZF4W0dY3+chNFrk1+v2LQ21nALekrbQo8KssYLUcLtTynlp+mVooDJn6HmI/uN+Lo
	 7KXSmBmp+JYNjqr6jMdDtdScKF6e1G7zY4Cwq0M1EHpHTAyqPFMbQ/vjE/J1LLuOh4
	 1JIgTPAWvxhKg==
Message-ID: <sashiko-outbox-175790@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] net/mlx5: Use generic power management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vaibhav Gupta" <vaibhavgupta40@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017194104.2684-1-vaibhavgupta40@gmail.com>
References: <20261017194104.2684-1-vaibhavgupta40@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 19:45:40 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Switch to the generic power management and remove the usage of legacy
> (pci_driver) hooks.
>=20
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017194104.2684=
-1-vaibhavgupta40@gmail.com?part=3D1

