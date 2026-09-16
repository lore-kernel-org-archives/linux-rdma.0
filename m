Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4174EE864
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 11:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789557656; cv=none; b=k63c7eyoUDV9RPPVNhCwXsz6Fjg0/7TY0H3PPG0XJ1S0GFkePtO8WEY/qXkvKB9PpjIKEtz89m3/39oecemj/BVoFgUh2nsGsf3mUZuLqxbNHHdI3B8jMqTJIS3tYODyZTsejCMkEynfz3HKZCLxvRU0M8/Vm5K87s9QEcfKkko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789557656; c=relaxed/simple;
	bh=lCyRVhPClkIjRQWBic3oS1IYODGJ+SWGIJauaf2SvzA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VRy33sdsRVJGONV1smgauKkI0leOEb/ILkHjR8Z4kWlDgZxc1mnBZh6ip4YH9tlWctjHdGoZ/fceaQMAvvlBmh+f930EyMxaRTGtQWNOCvACstPOxeqkJ0E4s9J9UvN8EgruK67hQBs0TaVK2RZ+nSOs85YZL2hl27//OhSuV2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dANyD3cG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dANyD3cG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980181F00893;
	Wed, 16 Sep 2026 11:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789557628;
	bh=lCyRVhPClkIjRQWBic3oS1IYODGJ+SWGIJauaf2SvzA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dANyD3cGxeqaFnOQ9gTIIo/QwK4c3LV1vZI5DE8psI8G0/lMPGheN/BfLLQNEwGdb
	 FtcS7baG6K4ax4svMmszre/HGa9ExwzZURa3dh1JpWsqsbHTj9O6DCY5wUB8j1hOxH
	 hr9ms/LtL4eKCOUX1YEPyxoxh8pJWg1IkYljZWuyTfdb8lxhBt/gpme7lW+HlfAuFg
	 C+GdpX1P/zla8rJkbFpwC+BUFbS20A8tEQisr8N9XevF6K/To0/+lobwD342pE+Uye
	 pV0DkeuVdSYMKo48EbwWJ4ARtImnV1hQHBkZwO6Gfm/vhdrh76jaQmYO7SMBgZ29BS
	 O5B/Mq9u7LGNA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/6] net/mlx5: HWS, Return meaningful error
 code in hws_send_wqe_fw
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915111912.3926585-2-tariqt@nvidia.com>
References: <20260915111912.3926585-1-tariqt@nvidia.com>
 <20260915111912.3926585-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 11:20:28 +0000
Message-Id: <20260916112028.980181F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>=20
> Returning '-1' is non-idiomatic in kernel code.
> Use a meaningful error code instead.
>=20
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915111912.3926=
585-1-tariqt@nvidia.com?part=3D1

