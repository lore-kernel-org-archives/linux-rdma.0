Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792585746;
	b=Chz9aI+pH9Bghb3ntHmP8OIUNEACJS8kjtM5fRLAq6WJ9RWudb4yar0XYW4LJSpybCY3
	 VLKr3diyXDg1SrUjq6kIEY5Jh+GqFntgCxBuFQD1Pa6tSMA6dznA5Kzsctq6noy1C4Onp
	 RVQqExpY1Nrk+8no2FUYy2ALeI1YoaO+nxIM+uIKqNiEQvHhjqRPv0Y/uFmU1CqqZEWg0
	 kM1y7VuIe6MWs2pAJZtAWyJFRFCpVcK0rC1X/Fzx1xojHh4bXVb2ndWIqqYfBR3JveMvq
	 L2YnapO+Qh+EmBWhvQqqncGPAvHCB/X2CDpQU3+jctS5LNi0auFSnchCeHDodt7ZSlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792585746;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hvNchxuWyiUftznxY+pFSEJ6UnSMOCHnq4csSPwR/pE=;
	b=MxUXHMD0VPZvStYcEyx+P5T6k1XxDK2a7Rbr0ypMpIOQS2a2DU819A1c5JmIQpBfSQkz
	 A+wVhdNvTIE4du6mr1ChUe1g0WULw2R7+7Z+PJH0cqnnjsb6VOQ0iChaagOvqIKyk/3Yb
	 18JRyknTZp6Swqt+U/ikZpyeDkL63Fx9WDX8P4IX95I8vZ1ssYa9vHkA1aSu1mNV2ZWSQ
	 E0whCwkkU98TQuxJsqgSVsh9MrxQ2uQxu2ngH3uEnfB7LZjm56XEfYcU0dGa3EWaBeLUH
	 lvUXhDd+itSueWh9MOMvtjywfV8Dk9rFqgl3LbVBoKx3zSViTe4sONCs6YuJhmk3yZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WB53QLCB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01694606A324
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 12:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WB53QLCB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898DC1F000C4;
	Wed, 21 Oct 2026 12:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792585745;
	bh=hvNchxuWyiUftznxY+pFSEJ6UnSMOCHnq4csSPwR/pE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WB53QLCBD18DL3EGmBwvshm2spXfLWXbVrz9COVc3FRFj+7kiKXbDaWQMfCjbeN2N
	 3OetOuaSQjAvo0hh2q5+YJjPJlRehdK9XBlI0rUSCJAvB77a1tAywLKczpbIZ+V2mn
	 VZga7Qa4GAhu7H8f8PCtjxAE9W7YXJok3qU1I8K+U44oz8DmOb2H6GrXmqh43QoTLA
	 UViNq6wAxYUcm/l2k2uTrLMoY+EXOo9d9Q2Q8MzAbBo8E5jUtgyMmKf4eR8hRkY3sO
	 ufDhWulj615mlUhpe8eNWSe+hP7zTdpYkO8zXIF0GrT5hbrqYLH80Z4v9E18Mmy2xt
	 DyznxbHsrSbow==
Message-ID: <sashiko-outbox-180252@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5: Bridge, fix bogus MDB offload errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261021122115.3737284-1-tariqt@nvidia.com>
References: <20261021122115.3737284-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 12:29:04 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Gal Pressman <gal@nvidia.com>
>=20
> MDB add operations are queued on the switchdev deferred queue
> (SWITCHDEV_F_DEFER), while vlan object deletions are handled
> synchronously.
> A 'bridge vlan del' can overtake an MDB add that is still queued, and
> the vlan is already gone by the time the driver is called.
>=20
> The two operations are independent in practice: in my test, the MDB add
> is triggered by assigning the VF an IPv6 address (hence joining a
> solicited-node multicast group), while another process deletes the vlan
> from its representor.
>=20
> Racing 'bridge mdb add' against concurrent 'bridge vlan del' could
> result in:
> [ ... ]
>=20
> Fixes: 70f0302b3f20 ("net/mlx5: Bridge, implement mdb offload")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021122115.3737=
284-1-tariqt@nvidia.com?part=3D1

