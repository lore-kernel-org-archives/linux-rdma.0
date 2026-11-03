Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793676077;
	b=3/vrU+TpL7WyJl4dsLgrEjttzfF3/QxxdY+awXnn09ZwORnaxLL0UzMbkdRsXwcFk4xa
	 eDzGdhXe8WUqe+1on3tKizCef5xK6Hk8fnE780K3ABqHjEIXWoJMt4S5gslx3VHeInOLL
	 fZhD9yJ6LlPXiZbkttEhBjhc8Y7ro7w4vT+Bsm8ZeyA2HJS2lBhr0+BhtvD+IdAy8+/gh
	 5HhcEvXoavtLUwv6NhIV8AhEV7GA3md4BDmxFhL/RNtHK2LKN24XQx5qLZfxxqGdXxIpo
	 lolJp5ARnFQKbW8t4CryF2LWvorev/AIPxlea6RYLZKPfj1Cw/0wkflwG19kjwNup8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793676077;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=vHT8bkkLW/9XxIIDt95V7F9nojsMSnOqrDB92GHmzSY=;
	b=BRtN5SnRUungSS3YHaqHz0opKBBfhiRmrhx0lDE4FliIRBJWfEDshbFUWFEjPkqLKJCf
	 HZItmY2oXaBRyR+E/vKENV7etIWgoUNJV8wZPyZW5DuqMrPcVnJF1Hr0hgopjV96DmJkB
	 GR//UtsLaB6Rnzi4LsTUGNPDz+Opa7CFFo/vZWr20iWxTJvLOUSEzpGH6JMzqEVeydWlW
	 mWiYMSyfezS14+rsEuQMxWHY1P6upn2BqP9HZ4Lrd0HndLq/zwVDUGmNX6hMUEWbN2RX6
	 0thXObew31YmgAcdtzE3LHPw1LBJ27Ao4g/MuvBnQ9vAl2t18B92Nzx967JeRUdL97w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ONJn9Pen;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A54606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 03:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ONJn9Pen
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558BE1F000C1;
	Tue,  3 Nov 2026 03:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793676076;
	bh=vHT8bkkLW/9XxIIDt95V7F9nojsMSnOqrDB92GHmzSY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ONJn9PenuvCjOmlx8kQdVNLdpBzFc7L6OPaJe0AaxdWkMbYC3LB+V18bC1R65Jl8f
	 CBV33a+mrONPPH9gFLaXIuyj43zXRLWbnQTATq2oT9IuuTheUbXFzZnc6wHrNlUdtX
	 FNjgyHQPNoF03vH2Tp0aoNK4TZKKe2eEXEeOHK0fD3ZN9YDwrFcvLSyRAvBjiGykH4
	 ZqggXz0mxBI/tEAV6cFK5oI/Jf6hFaHD4SiIt31anYWa+UEMJkx2zccbh7BtECkYQ9
	 5MWs2t2ufBTXEi3i4vk34Mg7CV5clKeklVFtNC58ofCJKvx6t3YtcKQoVoZIDKw0f3
	 F3qde9NdfTE9Q==
Message-ID: <sashiko-outbox-194507@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] rpcrdma: Pin notifications during removal
 callbacks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Xiasong" <lixiasong1@huawei.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103032758.1302493-3-lixiasong1@huawei.com>
References: <20261103032758.1302493-1-lixiasong1@huawei.com>
 <20261103032758.1302493-3-lixiasong1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 03:21:15 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rpcrdma_remove_one() can race with unregister and invoke a notification
> callback after its owner is freed. XArray RCU does not pin stored objects.
>=20
> Pin notification owners under rpcrdma_device_mutex and serialize
> unregister with the same lock. Also pin client RPC transports. Skip
> owners in final release with kref_get_unless_zero().
>=20
> Invoke rn_done and release references outside the mutex. Track references
> separately so partial acquisition can be unwound without accessing freed
> owners or waiting for XPRT_LOCKED under the device mutex.
>=20
> Fixes: 7e86845a0346 ("rpcrdma: Implement generic device removal")
> Signed-off-by: Li Xiasong <lixiasong1@huawei.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103032758.1302=
493-1-lixiasong1@huawei.com?part=3D2

