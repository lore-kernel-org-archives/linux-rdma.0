Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794863843;
	b=JmFCkDpUUJ20ZKzYD5998+t667UFBQMD2k+A0uZUCDafZxrpDhYgjU/Um2oWTIJ6qdpN
	 aw3Hxdbh9uKRhGWaCYv44eRiFBRlazNodnAjsxSLS14hGDJdrnvmx5KyBAcPiaL0KnD6o
	 H1oG2ZiNdojNZlbxt7bnivF+ifEBVtPqxmv5JmGl3fJswCoRVUUlXppsbNpTGbfN2w2Q/
	 6VQpshNl303VQ3KKryhbBEqI9v9hpIUDf2llJjfaxo2fdh8wZ2RyKxs6KztRWoxZJ/PjZ
	 SQn+ReEacrs5bCQgd+qdFgucWhRauUcF35CN9Mi4TPyUhbrNCNAOOPlPXIMFy2I75AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794863843;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CqLEYnceGNAlOn9ojiHOxB8R9hCy/zEk9e1kTnHJ6Sw=;
	b=N5azZIyNeumBzyGHfB/Gns+it+Y+0OaQsCFQkpoWGzAfCCiIADXt5fyy5mjOtEWUphq7
	 x7Ai0Bm6sCrZwZFRtPhBImrLJG186LGG0zlmLzzbPUXNDbZh9LtMA91ZFd47n02kzpwYP
	 8t7UdVYEhYUm+nWrgFR0OIorPsDkL8M6swOIazAwkNqYHeftoTPtSMtUoqbYWvuKHW9aq
	 k5LT4NprEAJVq0H8NiY5SzngMR73gDM5yeV1zu5/nX62jQJTNczaa89ckRqXHd89F3Izd
	 MCrL8tsnA7Oo0h3K53+mfxUxU3YWbsA0Tv3UrUe/Jjj0g3WAwe2QvWaOxRgld3vIehA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lber9kX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2459C606A884
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 21:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lber9kX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3DF1F000C6;
	Mon, 16 Nov 2026 21:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794863842;
	bh=CqLEYnceGNAlOn9ojiHOxB8R9hCy/zEk9e1kTnHJ6Sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lber9kX6sSV6xT4GSVOf/5di0oMy1PTi9kLM3szcTpMVam5XFS0jz0JS8BMPFxytE
	 BPHh4/E+dpY5016tjsAhVACqqRlfc+H7lxCayp/SYTGEmNUpSrCFj+IPIYo1bycXQY
	 p4IIcfEgkL6JHfVeB0aurumtTzbkp/O8VD0SbG6Gr7swGw1l1vtdrckHhfrl1HcvBj
	 tNiYdRfSLQXEFPdaxl9cDUzXc/9eL1LGW6hYrenZGR0pkRlkdH+WKiRW9WBCWlr4lO
	 XcnyJzZ8HHPhAUaAHoLbFPSms6D6OIQEVbQt4ZX1GG57nI/inNS0BWwRb3mEmyt/gL
	 eenV3S3/JeJ6g==
Message-ID: <sashiko-outbox-217696@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net/mlx5: E-Switch, Size FDB peer groups for
 asymmetric peers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116210917.1297111-1-tariqt@nvidia.com>
References: <20261116210917.1297111-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 21:17:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Uri Dar <udar@nvidia.com>
>=20
> The slow path FDB send-to-vport and peer-miss groups are sized from the
> local eswitch total_vports, assuming every eswitch that may pair has the
> same number of vports. Per-PF VF configuration (e.g. PF_NUM_OF_VF set
> differently per port) breaks that assumption: the larger peer installs
> rules sized by its own total_vports into the smaller peer's groups,
> which cannot hold them, so pairing fails.
>=20
> In SW and HW steering the flow table is unbounded (max_fte is INT_MAX)
> and flow groups are backed by dynamically grown matchers, so size the
> peer dependent groups to the architectural vport maximum. FW steering,
> whose table is bounded by log_max_ft_size, keeps the current sizing.
>=20
> Signed-off-by: Uri Dar <udar@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116210917.1297=
111-1-tariqt@nvidia.com?part=3D1

