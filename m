Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC613BD22B
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482328; cv=none; b=qb28gK8Amz8ptzYC6MiFvxUO9vRZmfyu+WzezuFahB4yGcV3AjS7tKICwhvZC07jrII4WBHoJ/Me1bQLCQ1tx0EJWg0us34aXSLEudh+QA+Epsrov0oKDYhdAN4ljMmj98AVm5RWgOtIFOSNuiaJ4/aV+GVMJrjBGCQKDVa7gfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482328; c=relaxed/simple;
	bh=VWsmDle07RKVuw0okYWyTMeaAzLOeNfj745EDumoJkg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YHn7UphCVxwy5vwO0QS0w+Sgku42h7QHjEKKiuwCsIIYA53jWoJjeErRE+OmQkt8qGK075KpWtX1KoJPORjZ93yjFJpbFS9yRf+KLg5K9uISAmM7ZDAB9NCdpT4Wg3TYVZoB+Jz3J6rCV7MXHo/fORJ+G3Ex1wyJoX5JWF0eF6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cM8yqbZl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cM8yqbZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DDE1F000FF;
	Tue, 15 Sep 2026 14:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482326;
	bh=VWsmDle07RKVuw0okYWyTMeaAzLOeNfj745EDumoJkg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cM8yqbZlhrE3KC3didsHwGMryuVCM+I3lxQn2xQbFW5DZzGQDFA9IZQeUv5Yk26QO
	 1kizrw5IOl9/HgLoVEGhMy/KueMNFyWRlOnYIxD4eJ0P7aZHax+ZGXsOMC7CRiUghT
	 MBIsvytZ5R1LzOmIWIwx331f9ObFcFRLOV1L5JUtG6s+M91//a3eYUXhfQjT0+zw0C
	 M/NRAMk1UfT8isyTNrSeyqUnucbU+33tJeu0FRObvF96mUOzS0suC6BOSPaQ+YXS5p
	 inmpqbajxFtZSD+RnoLWH8VAtCLQu1xFf0fWrcXXOEpeC0QYVHP9sffCJYFk0DqsfW
	 cJr+dFVrRJ1xg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 09/15] RDMA/mlx5: Put resource reference in
 mlx5_ib_wq_event()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-10-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-10-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:25:26 +0000
Message-Id: <20260915142526.81DDE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rsc_event_notifier() acquires a resource reference before dispatching to
> the registered event callback and expects the callback to release it.
> mlx5_ib_wq_event() never called mlx5_core_res_put(), leaking one
> reference per event and preventing WQ destruction from completing.
>=20
> Fixes: 350d0e4c7e4b ("IB/mlx5: Track asynchronous events on a receive wor=
k queue")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D9

