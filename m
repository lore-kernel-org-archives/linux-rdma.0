Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793694468;
	b=2sXR3M0KVCYhroPU6X5tiZgtohs/kfA2AIc1MsCqtrQNJbuMnn6EDlzKFsfGjQ9UnhI4
	 hwMIp6sQp4/IbzXktWPxrITrqYWn7Rh42e5Npv0xA1Ol41ojJhUckWbMWtaoQx9Oogxx8
	 tonCSuxJJLo0xgO6Q68MQ2WWICexJJUjC1PX7QrhoEAUxjxLHFJqqRMNAG/he+/oxtUBK
	 /wDVQviwfCQr39zwwXjL8oCutmEASLtecvpP22KiYH2HSu1esbEgjxD5vFpfkZZKUYLv7
	 KvdRjzDIJle5Ep7dDG96IjgP4+MjMLzJoJxGFX1Wf+RkCjemonmOsKS8j/BbSAfXAEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793694468;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ewXD4v4iaVP6VuSXFrugrFTm42o+l8sHcvCB+JMCqUc=;
	b=qmE1vm7jcEgGiWNyRlgTYtI8CMITySXP4/lO0RkPGrvblvepIuQCx8gCX/9cxSAUHMRR
	 F99ntNxWE/mgmAtsDfdYovWWnDY5wt4dEohORolIPXZvWDJK9iKk164x2joUgnYpaS6HA
	 R/c43Hnx5tRrDRH7LKmcUgLoB/BDpmL8Abyvjubf/Nw+vQ598/cfXnufkoOgRiiM3AE/J
	 KLlJ5eC94KRu18t61S0TNlOdipYS8BixjHsV3pzfGpE7plhjYMygilMf/F1zox3a9kUNH
	 pwhUWoADP0Zv+9GVwbZK92JkJ2KBvUDurlr2ZO3YcYO35YHe+t9rAXESJsJ0C8LiwoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gRjtILDo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35AE606A329
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 08:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gRjtILDo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7438D1F000C1;
	Tue,  3 Nov 2026 08:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694467;
	bh=ewXD4v4iaVP6VuSXFrugrFTm42o+l8sHcvCB+JMCqUc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gRjtILDodu6ICLu/DxZd+1wOxbr55gGSvK+QGb1IsX3xM314++YDiLJMvIwNCECFe
	 UyaboHQBO72ZHb0qjlWCJzVqK8Pl0iEPJFH2BY0JB47+s0c3ujh2RT5t6PWUUcufbX
	 K0Abxzb6ef2KT7ih+HcIz/1PUrP1yEyJ4cpVP9VdGsMCEQtD25VaY9ccyOAqxUhfkW
	 eEBL4abAMsb4kayRinLTrCwbl5QizorLfvc6t5qUbHCnZwOJE/Dw91N+/A28onb28y
	 /UG0z9qMywmfVJ3i66nJWU1Nsx/Ya9tbr3fQGZfXyHt98obsrHUoTbReiqMLdRB0tF
	 TBZ1K9nkW6ncA==
Message-ID: <sashiko-outbox-194825@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/hfi1: Free the trap send buffer when no address
 handle is available
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103081915.1147987-1-vulab@iscas.ac.cn>
References: <20261103081915.1147987-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:27:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> send_trap() allocates a MAD send buffer before checking the subnet
> manager address handle. If creating that handle fails, or if the subnet
> manager LID is permissive, it unlocks and returns without submitting or
> freeing the buffer. No send completion can release an unsubmitted MAD.
>=20
> Free the send buffer after releasing the lock on both early returns,
> matching the other failures after ib_create_send_mad().
>=20
> Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103081915.1147=
987-1-vulab@iscas.ac.cn?part=3D1

