Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794404813;
	b=oJUMW9/zcGkogIKERv4XwQ75CxCMk32DDdI1wri+EUauy1+qOQLf8xJQSwwkyx4l7IdK
	 2nXfRCywya5rswBVCpxWZPkJSqxQ605x46z54nX0H8fiVellqxf+E8jVpBNlQ26T4qqxc
	 7J4yK3vYWNQuPGAN/EBIurHMCqDI7qm+T4UdGWq5Pq3MRX7JlPalTMbLMDQaHUHdyYGyM
	 u4Wp7hrTgEuhz9kBMMQ7/zgSj4KfqUyWMskMnV8gBSzc/HXNW1x/SNKHyUiMszIr7j4Ib
	 g4mn5BAbQlFT8CxWuL1vva/1xszUiIDbsxmKWLlppx4yKIUzyKprcn9axPqclTRtH4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794404813;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=G65tLZDJZus3Efs7spyS/ndDM47CHh0UPhDMWzucVAk=;
	b=34/TDzNifbEzDaJEQezZGv6LPSQjzWQ1yJlhULE71JBOwEegbrQ4C48II3luCvYp4J74
	 bB2OoEyFxFAQCtvAx6G0zDhR7ibPxuLCUbjp+VnHI7y9OaiQ6VH8ViDeVfh6U6dnHnxu4
	 T4L+C0apntC8kaj+38fEhwSpKkyM8jcfrGfWCGkFj6i8hnj9GPWLAf6DOvjVyFNvSK/MG
	 qW6AJ0A1UxdoF+Nn4HztZHCfmSNc3GcysrG6bW4Ml8HMQLlxJtHaIp/TJVgaC/piepQxa
	 Qiz04kfJ1rCwgBX06Hib+X03/de1hchygOr9SIR5Mv88ktzMwIEHcbI0ARpWsdCtsGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDriaFQA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721A5606A888
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDriaFQA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317281F00A06;
	Wed, 11 Nov 2026 13:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794404813;
	bh=G65tLZDJZus3Efs7spyS/ndDM47CHh0UPhDMWzucVAk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iDriaFQA8MUZqr/JBLneBs/MG4w8vpe/QGi3hzQs4ZrxYaXAlrObn28s+y7W77xc3
	 5q8PoqLENxKJqbC5j01BjylefYsJ4JIT2P0HegEPwRGp98UPehtrenbD7AQ/bPZ55x
	 4DM78rTFRKiNUPuo9zkDqJS6zXRDuZeh68ZDT37nc1oadRhzV5MA3vnSATwPlq+hW1
	 /+Tj1KCy5QQT4j1ThPPzWIsSWtt1//OWyRD+FMuCogq5yZIS+G1IXXRomf0oOAzzkn
	 Xc7AsXSitKLCcyUL8SMPVemGlD66/NyMMBfqjFpsuwD8Ji56/MrnXJ+SYoqw6f5jhg
	 xD/s1CDpuN0EA==
Message-ID: <sashiko-outbox-209099@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 14/24] RDMA/mlx5: Keep the UMR QP failed
 once a forged CQE is detected
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261110134320.34408-15-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
 <20261110134320.34408-15-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:46:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In adversarial mode MLX5_UMR_STATE_ERR is a final state: the poller sets
> it when it rejects a forged CQE, after which hardware polling is stopped,
> and it stops mlx5r_umr_post_send_wait() from posting again.
>=20
> mlx5r_umr_recover() runs concurrently with that and moves the state with
> plain stores: it enters RECOVER from whatever state the path is in and
> ends with an unconditional ACTIVE. An ERR set while a recovery is in
> flight is therefore overwritten, which opens the UMR path again for a
> NIC that was just caught lying, with its poller already stopped.
>=20
> In adversarial mode move the state with cmpxchg() in recovery, ACTIVE to
> RECOVER on entry and RECOVER to ACTIVE at the end. If ERR was set in the
> meantime the transition leaves it in place and recovery returns
> -EFAULT. Outside adversarial mode the transitions are unchanged.
>=20
> This keeps new UMRs away from the NIC until the forced health recovery
> moves the device to MLX5_DEVICE_STATE_INTERNAL_ERROR, after which posts
> fail with -EIO anyway.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110134320.3440=
8-1-yishaih@nvidia.com?part=3D14

