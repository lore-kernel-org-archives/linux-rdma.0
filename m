Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5896A4A5C47
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 11:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472876; cv=none; b=GkC49acAkp/FM2vB9RRREGAWVDT7i5a88ylNbN8favqOCW+JUC6c+FX88U8w4gg16zL4MVkUcA2e8gWh0UkAkmSxveIkTQMENW559f7VgvbkURguC2q93Fp5P7x69+dxbizHsmq9+A71U6y9suCroHbYjiBJKU6uk89Zg3+H6zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472876; c=relaxed/simple;
	bh=Tak2mMDirXoofCbMz9k3GCT9TF34VnZ/fjp6EJ1lk30=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G7TeMY+GLDrTANkCOVfO5DYf2TOVOPOq5Jg9hA8qiHIoQXshVZe5I4ShSmkVjEq7STX/WwNVWjIheY+LjbmUh+HVzwL9KTqIkdO0kI9VtuTBqqxquvB/nr+5UD4zCu0OnbWhWjALJe0GvWdjRQ/R0m20U929uLVh0H99dcUFAmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S45RmS29; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S45RmS29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2981F000FF;
	Tue, 15 Sep 2026 11:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472875;
	bh=Tak2mMDirXoofCbMz9k3GCT9TF34VnZ/fjp6EJ1lk30=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S45RmS29Bhe0146FMFlrAwlC6EYe8JeMc4ZeO68L8QRUF4dczeMPNRLYmnMSmwrPg
	 gA87jaaacG7J81YHt7MrfOQpQ55kY7g1S6CSluQZpQCGwLOgwBEKpKPu0YO88RY0mw
	 9USrUT3hGS8S0xKGBE321MhpVJtxMUcj1lJycPC1OfB6hmDhZpOffvcqVsk5OkJp9p
	 w6NZWMyJIlBtSAlhvAFC36GhACGT9gr/vj+rhMYPFuWz/NINgTGLaMnPZQSVOo7Gm2
	 qxIENhIWy6vuoU81elcm0fMx62efp9aJcdVZSWUEuLUG4G6uEMdQfwpVzpfX86dvnk
	 T0BLLhANC195A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net V3 1/3] net/mlx5: devcom, Base component size on
 linked devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915113459.3934760-2-tariqt@nvidia.com>
References: <20260915113459.3934760-1-tariqt@nvidia.com>
 <20260915113459.3934760-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 11:47:54 +0000
Message-Id: <20260915114754.CF2981F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_devcom_comp_get_size() returns the component's kref count. That
> kref is bumped in mlx5_devcom_register_component() under comp_list_lock,
> before the comp_dev is linked onto comp_dev_list_head under comp->sem.
> The event broadcast (mlx5_devcom_locked_send_event()) walks that list.
>=20
> Hence, a caller can read the expected size, but send_event won't be sent
> to all peers. In the SD group registration path, this lets a member
> broadcast its role-election event over an incomplete list, electing a
> primary that never completes the group, is never marked ready, and
> leaves the group with a stale primary.
>=20
> Track the number of linked comp_devs in a dedicated counter, maintained
> under comp->sem together with the list add/remove, and return it from
> mlx5_devcom_comp_get_size().
>=20
> Fixes: 9bb1ac80738a ("net/mlx5: devcom, Add component size getter")
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915113459.3934=
760-1-tariqt@nvidia.com?part=3D1

