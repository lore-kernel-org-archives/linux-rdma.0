Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794311411;
	b=WJvKr9irwnqMd0dhF+/FPy496+egWJEPQV+f8LPmqesd3J0HkzxZ2atRKjcNTk8RvyDI
	 taxqRTCpYassXJQatbhQl0659cWgolTkJthxkqyXGhXgGZSH+hZshciuX1k5eylG1hd1q
	 YKY2kuAgzr8tglGvTZvuwFBabUqpFbjl6WVtEhpaUfKFt4eS9JLcI53Wu6kP4yOcBKju7
	 D3qcVFKn9J8eAe5jYTvkgo5ZjiYsrmed/Wat2XDlODUg3TUDI6oSMMMmvnaQx6lZm5+j5
	 NzxEOmLUR4R5COrfDgJWrc3o5GKxN1n07c0h3k9jE4kvaE2khaKqsCnza0iHioWYRHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311411;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LgpMLGK4ekiWa0ZilHci518owhM9vuRHW3NwSiXi8Vo=;
	b=rO+gnTuWpjGLphRqFSUzzAKxI9q8aFfsT0Cvce/2Ltf00lBZRqf1PJZ+VgrtU8fDAesZ
	 G/Eid2vm2rPaPiEACWZLUcJjS26QhUT1a9+bWUKW5i3K4zT9iwT6iiUbae+PKGPFvaS4L
	 wZueHnnKDll3mIVDM0duiYOZpSjE7lwCX2XmWW92cUdj7Q1kVkaKtY2rgePRv9cs5UXeO
	 F/ltNeO4RIVQGCmqP+W3+wMqxlQ2K3KURyXcto7FXUOPt8OLCC0idDKEjBG0ZaM60mRjS
	 z++9i68LEEGXIrlboN/bbYvMlV6YSGuLmNRqod8yiud5HDk+yKgTC/iF8iVd7+7SGDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMnpfN14;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36704606A9A5
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 11:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMnpfN14
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A552B1F008BD;
	Tue, 10 Nov 2026 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794311410;
	bh=LgpMLGK4ekiWa0ZilHci518owhM9vuRHW3NwSiXi8Vo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LMnpfN14fuZzr9WmkViBuKRzixd82M70pwobc6FG6jWea5Mvz7uoWh6ENx2lXuCVP
	 zmT9KTatw4WpZ/Xt3IYbkc7V2U8jhAKRBAeIBYViBxnoG1xCX6DiXcKLZHOFbxxnsS
	 7/OtuCzDlHoX0scLmzi+SJOu3bF35s6ainIQhRKVJx9qZ0joUIC+ve5J9KyhNsV6gi
	 1vlnA4DE4gyiwcnS2tjDf9t/PU1H05+VxVgpYasE8rrDdngKMU5EuAi4jzCcyRA3jY
	 uGPXU0TTIgEjefIg3Tuz4d3nBYrzyApsJkRS8RPuq1VHhWaqfvcKhjUNY//Z9+AR8F
	 9vubykJk+HN7g==
Message-ID: <sashiko-outbox-206953@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC net-next 1/7] net/mlx5e: kTLS, Hold a dropped skb until
 its posted WQEs complete
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109114734.2087878-2-tariqt@nvidia.com>
References: <20261109114734.2087878-1-tariqt@nvidia.com>
 <20261109114734.2087878-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 11:50:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> mlx5e_ktls_del_tx() releases a TX connection's TIS and DEK with no
> completion tracking: the DEK is destroyed, and the TIS is returned to
> the recycling pool, right away. This relies on the socket lifetime:
> tls_dev_del() is called only once the socket is destructed, i.e. after
> sk_wmem_alloc drained, so every skb of the connection was completed,
> and with it every WQE posted ahead of it on the same SQ; or from
> tls_device_down(), after the channels were closed.
>=20
> This does not cover the error path: an skb can be dropped after
> parameter or DUMP WQEs were posted on its behalf, in the kTLS TX
> handling, or when DMA mapping for its SEND fails. These WQEs request
> no completion of their own and hold no socket memory, so freeing the
> skb can let the socket be destructed while they are pending. The TIS
> can then be handed to another connection, and the DEK destroyed,
> before they execute.
> [ ... ]
> drops released none early.
>=20
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Link: https://lore.kernel.org/netdev/20261022181751.1349984-1-rjethwani@p=
urestorage.com/
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109114734.2087=
878-1-tariqt@nvidia.com?part=3D1

