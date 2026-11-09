Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794212818;
	b=q4TnEQsCgAVOZrlJ24MaN8Sh0tUm3yxhcSOu3iW3ZGQK31kHC7MFXOxAw8V9vzh23tn3
	 8wCXxx5k0NaNJmGIxBVy+s3UIBRDksG6tneTx1oR/fHjNQYmnWdHdWkEADTAiXxii/jx5
	 ilj/9+qQsdE/Fjn8O8rF04TsMAs6B5YU2aSIstvhRRZAuja7JECnqAzGIaGnq0LoxZeoZ
	 hNIMIBnNpxbOvAWAiJ5Kee4VJyfaNoepgdqGer6QXu0q+ZSkVIr9RX5Vg7v+HGPKvz7un
	 mkt8ulzvtFXQNTmjSLE0sxb3Dx26ng+F31zx0xsrXIbHFoWv+7LLZiC21WZh8iv/OWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212818;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4cr3ATtMvw5rNis87z0n4tAzR96GGE9ZQkQcvQIpiIo=;
	b=tq30p5bMKOiD70asIGRm9LVOICtVWNVJJ9aKuBcw+N1QJ1eiX9DHv2QylcN9bJVcEYtY
	 rN6CIV8W0LNPURhUfqWKVgGmx/4F8GCSrpOq0MIGkJaWZxW5qOAJ1R0iK75j6u3ip3A5y
	 sX8iIF6W4cRAAIH6UxPtbcgqG+/yc6BQ1qzl3SI7b0EV5vnOFD0kT18EpENs3pt356XJo
	 wriJ/RwQArbMuAUgWB+Zqp7HnB6bUFYMizd6oYz1b9Of6vdfUpM9nnnniIxinIR8/Cfzg
	 efSWmu3wJJHsDSVglX6OBep0qIYD4HXtyiNkoqq5hpSflv86o4hDNSWcQ6+HiCU72JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FStTy+e+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CAC606A326
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 08:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FStTy+e+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4561F008A2;
	Mon,  9 Nov 2026 08:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794212817;
	bh=4cr3ATtMvw5rNis87z0n4tAzR96GGE9ZQkQcvQIpiIo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=FStTy+e+0AKNKEiTPuBJ3pFUaPYWVkwC/fC1E+nr3kD2Ibnm8yuwT2h87bsvCc0D4
	 Jza0jZHMjgZ47ccMSXqPo48oI6mK9vaVydaKY177DtE6mu4mkRlf7Yq6c7ksF6OcQS
	 WdXD0LvAA0nnlRHW9FxoePxCCkvP4qu4RQxQ66h9qqdRyz3U9jzxR0ij8YzOPcc4d+
	 c6Bnyxb952iCfIR9nGlofEoMy6uh/r66npL4tZiHBLuSh8VFZy69pzVh2iwE28SoU6
	 6FyK8/GX0p/uhinPWPNChgzsa0CZwvm8AuIQy/Jr6KyBxshKMHi4/zsT125Hbs1BFR
	 pXv6nPrhQ+PSQ==
Message-ID: <sashiko-outbox-204586@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next 3/3] RDMA/efa: Add Completion Actions support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ilia Kolominsky" <ikolomin@amazon.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261109081349.27316-4-ikolomin@amazon.com>
References: <20261109081349.27316-1-ikolomin@amazon.com>
 <20261109081349.27316-4-ikolomin@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 08:26:57 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Completion actions are device-side effects triggered by work requests:
> when a work request completes, locally or at the remote side, the device
> performs the action, so completions can be observed without polling a
> completion queue.
>=20
> Implement the control path. A memory completion action object pins a
> user buffer (VA or dmabuf) on a protection domain and yields the action
> id that work requests carry; on each completion the device modifies
> mem_modify_size bytes (1, 2 or 4) of that buffer with the operand the
> work request supplies. The buffer must be physically contiguous. The
> device also returns an action handle, which the driver keeps for the
> destroy command.
>=20
> The object is an EFA ioctl object, exposed only when the device reports
> the actions capability. It holds a reference on its protection domain,
> so deallocating the PD while the action exists fails with EBUSY. QP
> creation accepts a WQE feature block configuration - an enablement
> bitmap and the offset of the action descriptor within the WQE -
> determined by the user space provider, which owns the WQE layout, and
> passed through to the device. The device capability, the maximum number
> of memory completion actions and the supported work request types are
> reported through query device.
>=20
> Reviewed-by: Michael Margolin <mrgolin@amazon.com>
> Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
> Signed-off-by: Ilia Kolominsky <ikolomin@amazon.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109081349.2731=
6-1-ikolomin@amazon.com?part=3D3

