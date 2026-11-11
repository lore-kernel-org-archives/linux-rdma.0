Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794400548;
	b=OKwVLyusytDazCfMQXAcjpPfFJ/khBq9Ycvx770VkVubqV52xievGB0zjldhRjSw6rAB
	 DKYdLWsUhtdcbQtJ7Wt3RulweFsxeUcZxQpXlmkTBt2OhvBdePPO1DkbkDjd7cdRKu9Fj
	 u3KLDHn7bkTNOyjBGXptHzQUGjXefIiAv9jJcOUcVIqqsB+H5PMn1So9Dj2o0UbjPcfPf
	 7VL/jQ9WzvOZph5AdVmrWpP+7jIWG4YuU+Q6V4G5pTN8+66Vm6Htkitjcj6mBrznC5rw3
	 RwcSh/uezogLWEznBSz6Xrgxfr8sssOz66Z3Zs4RZ9njCWZwJz3T1xQgoaasRWqa9Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794400548;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IxNsntBSGGy4qw3Axq+wbaXuWdDpWyx4Q8eXAATlKWM=;
	b=VOx6e7wq24YyZB/qoAOnkPJjPeZ+l/9HARVjO5uN7AnHd/ivRjROQ7LjrW6deWUd2OZV
	 JY+86wNv6FJkWKm7B4KiwVEBMJfCsDB0EF5WVQCnnxBud0CmAHKKcBWJRoDCBXjRd8xwk
	 jbGZWMN8zwYwNOtZsfUIQeQ0wko/YH1Znul4ZqtPK9JshvlFhRySXzB6Rked92x0VJriO
	 8WrgSROXGAoIbsxo4tvb7Cqi94WAA3aoI/6ocZAj1iG+ksHVnU6Hi8fCsH/MBYnNxCU/9
	 JeXPbD6Ww9o/9QjdnbfnQdMrAOzMEMRNdfb1bLQEa51aGAf/WUjGiG/8z1+cNgCf8Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MzmEbX8C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E97606A33C
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 12:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MzmEbX8C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7FE1F00A0C;
	Wed, 11 Nov 2026 12:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794400548;
	bh=IxNsntBSGGy4qw3Axq+wbaXuWdDpWyx4Q8eXAATlKWM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MzmEbX8CFopDJZhHHvDkK0JHXtxhI0uyE3kPTwTOTKdMoBdtbOu1vFd2A/ACyVrFi
	 LmVaHeLeHqziTzTU0GY44U1BaKYjs9yMvxEtG35+fvFWvFy4bP50slM9v0jaHUonC1
	 p9RBnCw/SUlNsnaQldlryhNLL3m0phUHyjpb3rYEpGpHQ5qkXF3COFI9q6AtGUpptc
	 zbpqGCqHh4yfvK/0wgrqbxgt4TXdieoqlsQQR/akTrozvwlyTrlkefzZBNuRu6FROM
	 Q569axdFMKbeS/w7+h9ZjQcXqgtfwXVkkO0JqT7qJGQLRnm0m8vZN4XF4ahsSAzLVi
	 JxdXF/2g3xYdQ==
Message-ID: <sashiko-outbox-208985@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/hfi1: Fix potential leaks in IPoIB TX queue
 initialization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <liguangshuo@mail.sdu.edu.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111-e5624093d6-rdma-hfi1@mail.sdu.edu.cn>
References: <20261111-e5624093d6-rdma-hfi1@mail.sdu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 12:35:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When an SDMA header allocation fails, rollback skips the current TX
> queue. Its ring and already allocated headers are leaked. Free the
> partially initialized ring before unwinding the completed queues.
>=20
> This issue was found by our static analysis tool under development.
>=20
> Fixes: c874ad879c2f ("IB/hifi1: add a null check of kzalloc_node in hfi1_=
ipoib_txreq_init")
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-e5624093d6=
-rdma-hfi1@mail.sdu.edu.cn?part=3D1

