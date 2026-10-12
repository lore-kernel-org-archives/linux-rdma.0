Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F26F37F316;
	Mon, 12 Oct 2026 13:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812024; cv=none; b=nw7SVFclI/Pll8QpWZsVhXLyD4Ht/HBGqMDBudczrGiRym6+DL9i/msLB0Rgvn+XvQuahB39bJthtwqv2c99wVOhM/jC7w+B2Tb3wG6cNUPO5PmrqFd6fhpx852KZ5Bqe6w0l6Ql0L4B7b3GpiP6BOzyGDVUzzhyQVaBvcS2S4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812024; c=relaxed/simple;
	bh=IlSM9mkmSx1Ak5BviubszKwQkE00W3/z9yfTwhIx4rg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=slb8ySC82K+PRxzefPDthr0XrVt40e8UD6/7SIRHuVhMIgt/e4m+MAXenFJBDQWNayjFQ6PbtafNF+xUNP0d1io3+V7irUMqYUHvNRjtSIhcELt0po4NOYa4JocJjmmh5WbYb1Tis4DNpZzIzgjONm6vErSN76GhzZ8ze5d2VUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHy5n/AQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHy5n/AQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BAE1F0089F;
	Mon, 12 Oct 2026 13:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791812023;
	bh=0QmKnMq+RXFZVtvvaJPOM9YOwdXjmkpcUwPjDPGfEZg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QHy5n/AQdGbF384IZjyPdoGJNxT3f0GF3Q2TRhCpEDzHkk5ZiFli7ieMFAYTPIGFn
	 7JBMfaHnSJsu1Lqd39RgA6MJDn4QzoG/oOf4Qi30ON3hEnQin3G8CgT/CLRYdPu04u
	 ZtHhtgl+VQlpK1vapjN9JslZiIBhXnnnhII+zn134/QgpotoNf9k3RhlrMT+Y8/zas
	 Le14tdN1fJQDeBU8Bi/jhf/w8uE5ewrrx35qOYy4GoPZapTGQ53bSvy2nJ+3U+XPxb
	 5bgGi5onvyoPVxxYc8PVFu0/TwtsVQJ+ZKtxAVhstJDK08Vtv/m6vvJ4BX5XWs/Jub
	 KAXxN68WqwYSA==
Message-ID: <sashiko-outbox-168188@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 1/2] net/mlx5e: Batch NAPI RCU grace periods on
 channel close
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: bpf@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261011133212.807979-2-tariqt@nvidia.com>
References: <20261011133212.807979-1-tariqt@nvidia.com>
 <20261011133212.807979-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:33:42 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

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
> with the teardown.
>=20
> Similarly, unlink all NAPI instances with
> __netif_napi_del_locked(), issue one synchronize_net() after all of
> them have been unlinked, and only then free the channels.
>=20
> Keep the existing per object synchronize_net() calls for single queue
> paths.
>=20
> 248 channels, rcu_normal=3D1, ip link set eth2 down:
> Before: 10.183s
> After:   0.715s (~14x faster)
>=20
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011133212.8079=
79-1-tariqt@nvidia.com?part=3D1

