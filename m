Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AA14A1E12
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 11:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789557665; cv=none; b=d1V7yJa2BIC03+0zILJJDEGasz1rk6M2HNRQ4AzdbWjIgTia5nT2qRhxvNWTnGCJt/CNlquu4mEaAejxq1pmwXohafblSEe5g0wpoIXeRcF2w0RBvYyFVmHo4EGuIdn7s61CUwBx3BUq+d9j+2Z3gHzzFU8wI3ZZjiwRGnQbA+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789557665; c=relaxed/simple;
	bh=sJKosASc5fzF/FBxrmDAJSwFc0/O9UptP/t4CO6XH+Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GLdFqbXBKvbdaa/oBehA54DImLT/XFx3oVD8bLcdj5GD4U4aN4sL94Mhzu8EKQ1W7vSRmoGn41EYsSgZPXjXLI5P8tGYVnVVHUW9EZOzBM0Rv2xvFsTX88wtTXYZoxYiQBGIcXUG9KHGxGUv0fj1Yu1FmctfCr4qKRfOhwVx/r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GiW+p/f8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiW+p/f8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394901F0089C;
	Wed, 16 Sep 2026 11:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789557632;
	bh=sJKosASc5fzF/FBxrmDAJSwFc0/O9UptP/t4CO6XH+Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GiW+p/f8pcFibWxW4Pi6NUSkIh55cyOBfWBmitIO6nIajDiSi0yjcLufQa0rCoyzs
	 eEetQGGuQYoWEq4C3Drh8M8OGMjI5g2Wv8U1JttQg7Ko6KT5HqJqZsNMOUmzWg6TMF
	 p5W5C0cpR+H1/IWcCA80PyVaoSVJH7aoGuPE6gN6wx2yHd7d89m67RTqY4cgVisKan
	 8I3h3v0mB4Tum4UJWLEmw9WuSTQdJdptvw7jT+WPIuPzfM2sLTLuXzIYvjISzsu+u8
	 SXG3rnJzb0YxuD8a1E1VsQ6KalSEMs/LH+C/85rV1s/sQJ4pEGiTjxPNg6/PmCbOP2
	 gcuusElnqKElA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 6/6] net/mlx5: HWS, Remove unneeded WRITE_ONCE
 in post send
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915111912.3926585-7-tariqt@nvidia.com>
References: <20260915111912.3926585-1-tariqt@nvidia.com>
 <20260915111912.3926585-7-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 11:20:31 +0000
Message-Id: <20260916112032.394901F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
>=20
> Remove the unneeded WRITE_ONCE, for two reasons:
> a) This write is erroneous - it just writes to a local variable
> and doesn't have any effect.
> b) This code originated from another place (copy-paste bug),
> where there was actually a CQ polling right after this line,
> and the WRITE_ONCE was writing to another place.
>=20
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915111912.3926=
585-1-tariqt@nvidia.com?part=3D6

