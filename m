Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795085855;
	b=WSidgroAVaSZJxnv9ifO/9YYspDjaTYTHA0Ejbao++oMSWmlbE7zHHPo8FI67ysclJzB
	 dC+mDQiY/OKWlt6+CiF92odjK/61giODHxV8pBu8r+3GGvz2QudR2t5as9truvUlo7f2z
	 iVHx/mOIIelPD9unlzBuOxF5WULeaseGAvhY1AQubuFzR95y/izxdbFTH5ILd3NXPJxTi
	 1QFOMg7Y72NBJLpCAd9siLtRCWtpAcbGaTCXx+WZT2d4sijYhnEqA2lD5lUViw+DEZLhU
	 XBCrMjHA6UcXDiiYPrcqn9VPiWLvnHoxnx05Cn/DylmhBqNnhyGDpliBmqDNvXInlTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795085855;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6lj1ZS90H9VJapZVfQ7UItzB0FRkdpix0cZWX6LCseQ=;
	b=iThCMfruBa2E6xuE0c+GqATi1TSabaokZpqXxrtotxpyq/hY3O5REcP1aFh4N0w03iNO
	 QXGsOAlmAFD72iRVMOXGtDWqOayuRyvnvR5RyN1aVLz86pZur+qxVdLfu2TKaBCnSKhqz
	 g1kdW8zcF5Q0r9XVCi4lBluIERmocoR6WTN2GNzoJwCh4qZMYh9jCkG9xtHnbcFDC7F85
	 PntqKH4lZCb0l0TZMCUlX5+Yh8cdSt3MlYLb6fxxsdPkB0igE1ZmtJsS76lm3u1KOGJjV
	 jdjZUYOxx53JWCwf56Jf0QYPDSIzbVzBWYHHHxrd6CQ40LyvuvHXZWXyJxAux2e4vgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HmqdnD75;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB954606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 10:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HmqdnD75
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFCC1F000C4;
	Thu, 19 Nov 2026 10:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795085855;
	bh=6lj1ZS90H9VJapZVfQ7UItzB0FRkdpix0cZWX6LCseQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HmqdnD75XY44IPPVgtRkAPOxoU8FnxP2Ay9PdwzpaJQ1pkoxmlu9zqRyokcThm6wN
	 D+hgtxAb2Q0WbCPL2QhgVr71Pw+VANxoWN+gxQDbwj9VwizgaAifLPCid8WxBP4qGE
	 uITGr/HQWS55DKCadkpbPfFyhEb+93+HTW7IopPDEkptgbtrDjemPbqyJWSvOx0riY
	 8OSK6Fy+RCllaV7J/c7SOSkyzldRWcDart08uYIZXUrkdre3BRloVsxDryhvTPM+nO
	 6Kio7oqu+ynH4cL8pFagaI1HsZCdTyB1PcYwTqx9zW/1MX8Bfp8UcMKypdb5PT7Wbu
	 YZ+oDY6KolnjQ==
Message-ID: <sashiko-outbox-222994@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V3 1/2] net/mlx5e: Batch NAPI RCU grace periods
 on channel close
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119103935.2190627-2-tariqt@nvidia.com>
References: <20261119103935.2190627-1-tariqt@nvidia.com>
 <20261119103935.2190627-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 10:57:34 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Carolina Jubran <cjubran@nvidia.com>
>=20
> Channel close currently invokes synchronize_net() repeatedly while
> tearing down each channel. RQ, ICOSQ, TX SQ and NAPI teardown each
> require a grace period, causing the number of waits to scale with the
> number of channels. TX SQ teardown adds a wait for each traffic class,
> while XDP and QoS can add further calls.
>=20
> Batch these waits across all channels. Split channel deactivate and
> close into pre_sync and post_sync phases. First clear the ENABLED state
> on all queues, then wait for a single grace period before continuing
> with the teardown. Once NAPI is disabled on all channels, wait for one
> more grace period, as the poll may still arm the CQs after
> napi_complete_done().
>=20
> Similarly, close the queues and unlink all NAPI instances with
> __netif_napi_del_locked(), issue one synchronize_net() after all of
> them have been unlinked, and only then free the channels.
>=20
> Keep the existing per object synchronize_net() calls for single queue
> paths. Drop the one in mlx5e_close_xdpsq(), as its callers already
> wait for a grace period or run before NAPI is enabled.
>=20
> 248 channels, rcu_normal=3D1, ip link set eth2 down:
> Before: 11.837s
> After:   0.817s (~14.5x faster)
>=20
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119103935.2190=
627-1-tariqt@nvidia.com?part=3D1

