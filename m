Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911800;
	b=YVz0aNqP/+zA4r/a+QwpJLOzxMMdXBAOWozTnRNbWz53OzIV1as3LP+3fYwkg1nq/tKY
	 Zg96cH0nDLb44ebS3Em2+MpZ3SqYgqnYfYYlRpnRSxcgn66FgcvOwzh6dEjU7HGD4NnBP
	 hZeUvZubead0oY+J8YsfHDQIU4novLe0ZqtEBA75lgaAbdXFnDrmhlJlzVOi98LKDuwEi
	 TOX/7B8WMuHrnPKCIj4ynKWwnPGClmxppC4zot00SS0hXCKddlcATp5G1Xr80UKp9koDg
	 Mfrd69mj09lttf+A00QZTfTvly6cV0yoBODoVN1SGFdMqWGKAaMTROx6/26lOf2YRgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911800;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=llvtJrixVXB3/mfmOvMmzDZzmdIbKYy8H4v4oeSAtFg=;
	b=skOrzz8sh54xALshdiU82STfoMwNXAlYfNOmLiRxr9XSKwfNI8N4KlY13qWNrn0Lvdfu
	 UevQ/9u9oqayHWXl6OBC+VwafERLLdWCUejk/fWTkvTNYP7vTdiXMbs5wfzHsj3Jf+ILU
	 A5BvR80eGpHatXmS7MuN/qKVMgu3VYG1OSnfx7874JDilP7VZlpbAnLusOLbytuNP8+Xu
	 mACo1VtH6eudXmERYQcBFsVKYGMWTBg43HHbQeJ8fRJU/Ymik4xuXss4QZcdWL0yM3zlS
	 qNDYcfewLyPcb2KAH7xjTbpWszhPnALOOqa5alKB7TvcT18T/t7tab/Rdu/96M5VJ1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKJo6naq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EC0606A887
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKJo6naq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2D71F000C4;
	Tue, 17 Nov 2026 10:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911799;
	bh=llvtJrixVXB3/mfmOvMmzDZzmdIbKYy8H4v4oeSAtFg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bKJo6naqiyGvV/RpOPaOLN/Gw7rozGF1vb0SlI+urEa03kLgmH6yfbeLfatoAzTnv
	 C8XMWUqrYg+uo1vx3yJKfVPu5UIHH1dQcWFFf5wVKUyGnczgactVFQPmfY4a1pq58t
	 9dpvT6iU+jl3pZ9BbNoKe3EuO3kyYentPCYUkdBygZKQNdOxkUsirzdP1amAAM49eJ
	 evRA9QioETrP3MM1Rlvkc31AsRbmpeWhqiO1VV6AAror1almFJOs33VmXn2RVdmwFB
	 lAK5/BIOq6ZdZucyt21kP/Bg9GVTzegsz3dW/NPKvzFHXA6FmTCi5gxUYUPQDnUbP6
	 i7kTjza8pApEg==
Message-ID: <sashiko-outbox-218629@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next V2 01/10] net/mlx5: Distinguish VFs/SFs in the
 SW system image GUID for LAG grouping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116103010.1129666-2-tariqt@nvidia.com>
References: <20261116103010.1129666-1-tariqt@nvidia.com>
 <20261116103010.1129666-2-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 10:36:39 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Shay Drory <shayd@nvidia.com>
>=20
> mlx5_query_nic_sw_system_image_guid() builds the key used to group
> devices that may form a LAG. A PF and its VFs/SFs share the same FW
> system image GUID, so without a discriminator a VF/SF that can join a
> virt LAG would be grouped with its PF.
>=20
> Appending bare discriminator bytes at conditional offsets is not enough:
> distinct capability sets can collapse to the same key (a PF ending in a
> load_balance byte of 0x01 vs a VF whose marker is 0x01). Give each
> discriminator a fixed position instead, and add the VF and SF as such
> fields. Trailing zero fields are trimmed, so keys of devices that set
> none of the new fields are unchanged.
>=20
> Set the VF/SF markers only when mlx5_virt_lag_is_supported(). The same
> key also backs mlx5_same_hw_devs(), so a VF/SF that cannot join a virt
> LAG keeps its current key and is still identified as the same HW as its
> PF.
>=20
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116103010.1129=
666-1-tariqt@nvidia.com?part=3D1

