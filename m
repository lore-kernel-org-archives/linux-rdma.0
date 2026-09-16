Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003203DD847
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 06:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541664; cv=none; b=VoSpDe+ymlgN+7XpazslUDxVgQxesdibk/xXFCODCGYoFWcJIqmmxUlnMAz5y8c//+zF/fV0U5lIYsFzGSBsioKO+XaOlr5MkjxC/66g7zuxBlzrfqfrnJXE/NH92TV6HzPEWSzKic9zXVxYNKvIpydC3ANFaBT/5hgXlXztZXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541664; c=relaxed/simple;
	bh=L+hzxCsU6HSn3SQFsOGwt9KIqOuFpa6tpHNBhVQ8dBg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kpBgwGgPGZQrlxtI9RBntEiNLoxxoboCAy7CMQFzSjB5+T+/m7JoM6MNX/MvoR70Z2g1l7HAvP4XV9O7YiTju+CG/Ux2S1B0bakCpIOp+QNtmHscGKISeDL1uuFiNd7E9dxrEvNgm6GE/vCIf8tiv1UaUbK/ZukQK+GyaTVmQKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7wuvwR+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7wuvwR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EC01F000FF;
	Wed, 16 Sep 2026 06:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789541662;
	bh=Y7k9EtFwMjrPTUciSrX4P5LhAK0ljrBJmWsROFyzAzo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b7wuvwR+asko9C8oBqVTfgD0JyL0LG2yrADY6eoCUkmYjYC69iGQaD7EKpjXr7oMS
	 WWewgi6lfaEuVgy7ykHt6FKTEcn9JiLmUIu3BB7rqpFaQIkNexGYKjo8bU7UX8oG0u
	 Dgcz9Z2qjPgbJLmIONd+T5uhWQESiemUYy5pmZyPlsX21rg+5SUzVC7NAszkPe3SVm
	 Cja3HxqpgnIxzKnLu9KlO2gH8AfZg0ktA5UzTIuwxQaUKSXOQKb2s6Q3AA6bjW9Ban
	 p3z73nq+279CT6+cmVfa9iAotS4kWWdly+h64/4ee5st9xxufQjThrOZg/Puua8DSj
	 Fmb0Dz5Os+cwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/core: Fix swapped list_add_tail() arguments in
 ib_add_sub_device()
Reply-To: sashiko-reviews@lists.linux.dev
To: lirongqing <lirongqing@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260916064435.2180-1-lirongqing@baidu.com>
References: <20260916064435.2180-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 06:54:21 +0000
Message-Id: <20260916065422.69EC01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Li RongQing <lirongqing@baidu.com>
>=20
> ib_add_sub_device() links a new sub-device into its parent's sub-device
> list with:
>=20
> 	list_add_tail(&parent->subdev_list_head, &sub->subdev_list);
>=20
> list_add_tail(new, head) expects the node to insert as the first
> argument and the list head as the second, so the call above does the
> opposite of what was intended: it treats the parent's list head as the
> new node and the sub-device's node as the list head.
>=20
> Because _ib_alloc_device() initialises subdev_list to a self-referencing
> empty head, the misplaced insertion does not crash, but it corrupts the
> parent->subdev_list_head list.  After adding two or more sub-devices,
> only the last one is reachable through the parent's head, and
> ib_del_sub_device_and_put()'s list_del() on &sub->subdev_list rewrites
> the head pointers, potentially severing earlier sub-devices from the
> chain.  During parent teardown, the reverse iteration over
> subdev_list_head then skips the orphaned sub-devices, so their
> del_sub_dev() callbacks are never invoked and ib_device_put() on the
> parent is never paired, leaking both the HW sub-devices and a refcount.
>=20
> Swap the arguments to match the documented intent: insert the
> sub-device node into the parent's list head.
>=20
> Fixes: bca51197620a ("RDMA/core: Support IB sub device with type "SMI"")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916064435.2180=
-1-lirongqing@baidu.com?part=3D1

