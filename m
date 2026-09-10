Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4A63C3F68;
	Thu, 10 Sep 2026 23:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084714; cv=none; b=hwx4Z6V0EDJ+EFgpZcoMqMQkFX+CVTSaFP2qNp0PyQsnUyKlt3moWDbXx6fb414qWCEtp0Lvx3G9FYDg2jv9+SaCDsivDhZbI3duVrtEIzTQRyR6OHSINLNf803ZwTY3tkdOTKhs2WU8IxjcUH3rbbNs1lZOm4Gv8Faa9+vnMxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084714; c=relaxed/simple;
	bh=Ma6/03daESK3YAM4IrgLfRp2+W7JmBXpvLZ6EnDbeXk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iO9f0q1QiGhaWMze6m5j46Pm7EjQ1WCcQRXkZ2EhTxESZ9exPxgIkEkxUxhLN1qkHCjDnP4/nHTHPfe6OAeO+v6JqkHDBb5de0T6dwYhM0TmZcUFf1kriGh7drSSdSVn6X4scHkZrmtyEAgdMEjdGoqS+uTWG1eqfftkfVYQJ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Td0+ajfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Td0+ajfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7941F00893;
	Thu, 10 Sep 2026 23:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084713;
	bh=Dd4gzXUiNwsyKZIsEBOrkG9oPV4nITZ1AcI/Xk/DROI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Td0+ajfWq982AEom9yuzQ6hfbtYpui5JoAX5OEcGDbj+tNpqgwaQcbcwRQeXY5Uzr
	 7/ucFp9E1yNBEtXZf1IX5JzJIwxR7qyCFNprENjfLh7GsdUlnJVk9eUYPwjQDDaWfY
	 JSf41RonpEg9kE5YuJeK6UcToGmwT298rXAZp+6yUDF91rgJCLeo+4gWjDn5AHrzss
	 eFBU8tSlRILWfznsd3AiUwZ5Yyird+tKrugwAHXQepdLH/dIS0FyeoRW2wT5sng7U4
	 n8OAwju4/xwRLGl9AF2IJbFK73cEXVyf3gOPJLkbfGJZ/eRM4h+hGGt05ByEipjlSW
	 NDdf06JL9h09w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/10] vfio: selftests: Add mlx5 driver - data path
 and memcpy ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <9-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References: <9-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 23:58:32 +0000
Message-Id: <20260910235833.1D7941F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Complete the mlx5 driver by adding CQ/QP creation, QP state
> transitions, WQE posting, CQ polling, and the
> memcpy_start/memcpy_wait callbacks. After this patch the driver is
> functional for DMA tests.
>=20
> The data path implements RDMA Write self-loopback via an RC QP with
> force-loopback.  WQEs are posted to a 16-entry send queue with an
> NC doorbell, and completions are polled from a 16-entry CQ.
>=20
> Assisted-by: Claude:claude-opus-4.6
> Acked-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v5-4cacb99249f6+1=
b4-mlx5st_jgg@nvidia.com?part=3D9

