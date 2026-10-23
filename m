Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792759104;
	b=40txfg2e3QrqCOZrciqi7xaA8MNHvEnc+peMtYyhQjvjxV2/LC5EZuXLWPOovpXf7mAZ
	 e/4qzkfOLSv4q+/rWe8NCYpc7UnxCKH+jJ4AqJiR4TpjCL0Pw+XDN4cFuB7ilB797f0uq
	 0sn39sGSmU0jQ7V7ZN7VbbbMpcWknX41ThRBV15pmgWOeXUpq3xzFV9DUbieQSDgrsNS5
	 ZY0ED5VVQA5c5ijTZCTX36avrSFvbNeYnz4izNFosUwiQp8yjakW0uFf/XwIQ/88HAwdD
	 vRwlgjpjsMVVULG0GqLWXYRh5ro3i48VefriLt4b1TfZZ0n5jyREHkjfMLX7Qk7FC9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792759104;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aQoyXZmF9V2YAGxn7VvbyLvza5OAgawWqhaZxwADCZM=;
	b=mPBlfLPuDoWkKGdxq9fIRIjSPG10q8VMy2+B8k0uw5Q23Kv/vna5IUCRQ7FazlEOiVIf
	 oM3Nb+U3q6bcLVc13igTf0lhVc4QV9nTHh18PKVXceTfrJkFyeLKEmY4JfRfLrxTMk1Ab
	 bKyOyolhZ1AH9JPYK5icT70/SVrKrTcBntsoWyllCOclW9HXQPPzgvgc6YIxZ9/A38cl+
	 1oRKpgNi/bX2Z/xhkXR1+kCdxWT/R3uzsd91k9M55cuxCSgIcSjiRDNPeJRxbB9pF716X
	 dMbXvkM5XhkwbnE68f+8RCvCNv3xIpylVLPeInlt1pn7HAUk+25O14d9Xtd5d33HodA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n0Kuu1aN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5ED606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 12:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n0Kuu1aN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361CF1F01825;
	Fri, 23 Oct 2026 12:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792759104;
	bh=aQoyXZmF9V2YAGxn7VvbyLvza5OAgawWqhaZxwADCZM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n0Kuu1aNbiyzaL6UE6+8nb6z9Nuks7Zl1E/XML0h7MIm25vDDzvTIdL1m8AH6ZYX7
	 5jq9yk0dpmODxbGJx9KtRyTRckXy27JEdpSR5CwD98RS0QQnre0E5915BYQct/7OpB
	 0sxHxUZKHtY1dCilBft7Gr3bESp2JktYEtcVYjR4ClVcUgrCu0JUR8CMknkGmmM7kw
	 c473fRxMHwyvrMHgbBmD7fbj3kpJ6nXd308APFptSblK7T80pk5Xy9mSO5Owzvv3zK
	 Q3Q1u/HMHYSTRi4f8prn9f7H2JX/39oAb3h+U0lLE0Q1fcEaMqXNw0S7+0aLwmVXuU
	 lZ1yhme24VQaQ==
Message-ID: <sashiko-outbox-182783@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] rpcrdma: Serialize notification registration with
 device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Xiasong" <lixiasong1@huawei.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261023125033.528835-2-lixiasong1@huawei.com>
References: <20261023125033.528835-1-lixiasong1@huawei.com>
 <20261023125033.528835-2-lixiasong1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 12:38:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rpcrdma_rn_register() checks RPCRDMA_RD_F_REMOVING before publishing the
> notification and taking a reference on the rpcrdma_device. Nothing
> serializes these operations with rpcrdma_remove_one(). Device removal
> can therefore free the private data after the check but before xa_alloc()
> or kref_get(), resulting in a use-after-free. It can also finish its
> notification walk before a new registration is published, leaving the
> removal path waiting for a registrant that was never notified.
>=20
> Use a module-wide mutex to protect the client-data lookup, removal-state
> check, notification publication and reference acquisition against the
> transition to REMOVING. Clear client-data under the same mutex before
> destroying the XArray and freeing the private data, so a later lookup
> cannot return a stale pointer. Keep notification callbacks and completion
> waits outside the critical sections.
>=20
> Fixes: 7e86845a0346 ("rpcrdma: Implement generic device removal")
> Signed-off-by: Li Xiasong <lixiasong1@huawei.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023125033.5288=
35-1-lixiasong1@huawei.com?part=3D1

