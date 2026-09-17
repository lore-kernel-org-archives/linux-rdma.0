Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D944BD7B7;
	Thu, 17 Sep 2026 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789689166; cv=none; b=BdKRvqh8LodQoeOyojui8GxT7zy60I/uELjhwE9Taw7KpPf0Te1g/0zTWdb/uv+YAE4bmVTlSFDu18kfzMcuSNwTA4WELXXdd6UB3CZhgEoSPWCAe8b7RwP8SumX0ox9KOrsQf5p1AjUxu78PQTeR6S4zREWEU98gkO0N7pdiHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789689166; c=relaxed/simple;
	bh=nzX39hEwAIwIeB29rsbeMLtoiFtXc0UcwnXu1EUkXx4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YQllLta/iEiyrNkbga2js88exJtjqMeAAli3tt5KrHejyXA9IBY4bI0ORZmNW3gmzlsXnWmng6ONRtkKifMVCpftQwHNEcFW/WgX6nGY5ge829Uqdlts1K73eunAUNPI50lDYWgF/6QRP+WNuRZCFBlf5hwAH/Zg5hioG0P5dSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPeAKpxB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPeAKpxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B301F00893;
	Thu, 17 Sep 2026 23:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789689165;
	bh=nzX39hEwAIwIeB29rsbeMLtoiFtXc0UcwnXu1EUkXx4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IPeAKpxBz2RSVdSxbWlxA9WJVIEXV2LfXem2/7blvaMnROCQo85ytUz9FX4D8KQg4
	 X0rqYoOl43D7BFQ64gD2KR/AplALxl8Too3dmWkhnIzeU2RuH4cs6cfSXid1p694lq
	 GW5+Q9hsboz0vZJ3Shg6pGy799FcFkcHbZ3gkZntZzruUeH2cOVyR9TfAgfUTMh6Al
	 AGzm1SexlDHE6RFdDaC8bVXKz0v4C2bu/pN0YY20V2c1jZotzUktQ8mzvVXnP2b+Ao
	 KOSjYobQk/haddA0VhmP8HuHNMSmj7AB/7lWbWPD8C7cqVNyU1qOrUSCxdlgYUuof4
	 NfSZHy5eyyoTg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/10] vfio: selftests: Add dev_dbg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <7-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
References: <7-v6-8af36cf7b73f+e2-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 23:52:44 +0000
Message-Id: <20260917235245.00B301F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Enable it with a #define DEBUG at the top of the file. Allows leaving
> behind debugging prints that are useful in case future changes are
> required.
>=20
> Assisted-by: Claude:claude-opus-4.6
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v6-8af36cf7b73f+e=
2-mlx5st_jgg@nvidia.com?part=3D7

