Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8752548A2BC
	for <linux-rdma@vger.kernel.org>; Thu, 24 Sep 2026 10:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246503; cv=none; b=im/GmIQtNNupXQDIowhGQx9q3Hw3AoBi4zkIIR7ovp1L5jI6efh+tLSvNbMCYA1rkCsLukK9lNA0a340CXmDz1lOtNwwdnahG5bKCDedy5KNLKJ9+6RQ/xC81rgNFJwMQz3lboZBf0kzGYlQyNEjESzN6IMW0PYsUOmbr3hQbcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246503; c=relaxed/simple;
	bh=7gCzEjI+P70bLDkpraEIW9fekbIUcOptuI6C6jHQAEM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ig/t84km+1EUd2KrFUK64VEjWPRvIp589oulvKeYdA7ULasoCgpdTkMw7LcaObKW7gUtuSun0p0p3MslpURLYn9wLT/JlJAAeM2sDgN1xsFBGg4LZbwfdsj/uQFxCV7dsv+UHMaWutXHkCfxk1xByoMpHNSfNeeCH9BMWdheZmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YyiDoy07; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YyiDoy07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1601F0089B;
	Thu, 24 Sep 2026 10:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790246501;
	bh=uwHY9iJtEqwHaGZYy16w+Ca9Ei/D4I0vrNK6gf8HVVs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YyiDoy0769Dtxbp4v/gYQSiInT/KXMobctdW1qv9ZsdvrML6IR3kCOpOfVqmGEj5c
	 w40AXTacUh0qfcDWOsRaKFiGsSCFcKhWl2bFT9BtJJOUzDMXb583Sognv7Hh8Gv6U5
	 Oa7j/Keb9FP+OPK6AujSj9NNzU0o8zIwzJDfnFgARl4BtDhB2T5ia8vLuDx+xOuz4J
	 QEZJ3MdEEKnJ5FzuCh9PAauwAOiUBvAm6ZBWbBG0Eshmt7SNjeYPFdT3zXq3CNZhAy
	 f92z5xglOadjGitWMf2xD7jUNxaCcWyGKHqOq6WDsWtN9jwccMMe0e4l89tpDQ0Z0W
	 yoL1BMqYap3rA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 01/13] net/mlx5e: Assign a random MAC to any
 netdev with a zero MAC address
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923103830.1183-2-tariqt@nvidia.com>
References: <20260923103830.1183-1-tariqt@nvidia.com>
 <20260923103830.1183-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:41:40 +0000
Message-Id: <20260924104141.3A1601F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5e_set_netdev_dev_addr() falls back to a random MAC only when the
> queried address is all-zeros AND the device is not a vport group
> manager.  A vport group manager that comes up with a zero MAC is
> therefore left with an invalid all-zero address.
>=20
> The vport_group_manager exception is unnecessary: a zero MAC is always
> invalid, regardless of device type. Drop the condition and assign a
> random MAC whenever the queried address is zero, so every netdev comes
> up with a valid address.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923103830.1183=
-1-tariqt@nvidia.com?part=3D1

