Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793716357;
	b=Y8S0lKIb6yj98v7f1T3BGj2nvVl6PzuKxfY12TY4RyfHnjjxHjMa/HpfUxZUjlDzOpjS
	 V5YB4FUmf3aNITU2o7NOfKRG2W3RqVejIbQ+O53M51tUY7lrpwPLxSIVQETKLqDRaGV/d
	 ncq4xjy0ptn8Uqi8QhDghxOVyi5rbhgYDKIPxo/11oeVlqzrt9a4on+rHdQu4nfhuslsK
	 ysbXuhKRDjgDurWuzeAxs86YvHwn14KvglNXIOvZ3TS9LJjfJitZXY8A9KzFbXMh/l4jE
	 wyFAlrh0/9Gy7EPI7KonMp0iq/qhTQOVpY8MIl7+0GCuRJNcTm1DFfpS/ZVD7Tihi4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793716357;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Uqfwo9P88X6pj0sksJAuwFI9bcTQaxy52r8EZAPUt3M=;
	b=VM/F1MedEBafnQAD6JlEYlq5+1+ODqBytr2ajtE6rmapjQmMLlSb8xHvZh32JfV7SoW/
	 SeLlwCvN55jbQ6rjbuZ7L+8LdVKXha2vz4uLh4lIC3UgSXkBfrz0FdFveY7rVtj5r/Y0P
	 IdURcucbCkfSIHi6IyXk3AJwC6xsqDlbyxT+mpFB87RlDmSlgNvy65HvVbXIK+kM+ewTX
	 tyWIb4lvegHrUf8ymto6poiA6Yxt1YPLWzI7QeEE4pXERI+85F5FiVOcOD3b+W1FFXNin
	 /TKYzIdcJI/QoKo5d72VSjonrrXw0vobpgFwW/ZYzsyN/xLJW/tyfRdvHrrVXu+hhFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WlKSJ284;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082B0606A32C
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 14:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WlKSJ284
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882371F000C1;
	Tue,  3 Nov 2026 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793716356;
	bh=Uqfwo9P88X6pj0sksJAuwFI9bcTQaxy52r8EZAPUt3M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WlKSJ284wctXVXMw5ZYrgy+MLsvJc8lBVP6b9q+g6MCTQODPQrg3M/g+y9PuBhagQ
	 V8ssdV470eFsEcK7l8WL6LgE0xNV41X5ZTH5Cq0vLgjCwBMLc1ATKkd6Kfkuwqq/6t
	 ixRBA2WchnYR3AZw8GvjxKmU043nEswnItSyCw0owTV/DBJon/A2LqvovLLmlE3Mch
	 pJZz02UrTgWh2Y1fFl/KntihV28QwP8b3nUY1we4xoJsF4gCb1WCA+y7xodmz1seAZ
	 bLiJGV8d7/MhEeQIJxxPXYO1dskA/rsXma4Yl9SQF+oEvcwLX1eCQCMABBxtAebHSE
	 1l4jSLGDXXHOw==
Message-ID: <sashiko-outbox-195453@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Fix DevX umem page size truncation
 for pages >= 4G
Reply-To: sashiko-reviews@lists.linux.dev
To: 0z5a <dezhen.lu@student.uni-tuebingen.de>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103142709.66179-1-dezhen.lu@student.uni-tuebingen.de>
References: <20261103142709.66179-1-dezhen.lu@student.uni-tuebingen.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:32:36 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
>=20
> devx_umem_find_best_pgsize() computes the page size in an unsigned long
> but returns it as unsigned int, and devx_umem_reg_cmd_alloc() stores it
> in an unsigned int. When the DMA mapping of the umem is contiguous and
> aligned to 4 GiB or more, and the umem length is a multiple of that
> size, ib_umem_find_best_pgoff() selects a page size >=3D 2^32. Since the
> value is a power of two, the truncation turns it into 0 and the
> registration fails with -EINVAL.
>=20
> The umem log_page_size field is 5 bits wide on top of
> MLX5_ADAPTER_PAGE_SHIFT, so the command can encode these page sizes.
>=20
> Seen on two GH200 nodes (ConnectX-7, firmware 32.38.3056 and
> 32.43.1014) with a dma-buf exported from cudaMalloc memory: registering
> [ ... ]
> GH200 nodes described above.
>=20
> Fixes: 7610ab57de56 ("RDMA/mlx5: Allow larger pages in DevX umem")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103142709.6617=
9-1-dezhen.lu@student.uni-tuebingen.de?part=3D1

