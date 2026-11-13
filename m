Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794560256;
	b=BxcJSSKtRjAfQqQ120FGLRE2ygIH61Vf4IdHsN4BaCMFS18i5Z9Wdssr9wILPszx9dXI
	 uMMcE+ATvs0E53Jm6j/X6Khvf01sTUwPW3nvTTfB8Vf6INK4gzdbE2B7TyMUFk4CK++i9
	 rMzmrUkjcl78zA0Qfb4WFuRcySccHy0/gEXyuTDewltD4TnELGFBR0Uu0nTdx7q+11roP
	 TMm0I3my+E09i20XXXBzwe6TEKe3clIO5mdkwdI4XJ3v41+aL9IIhiEjxzVW16qdpA82c
	 ffpj52tzjaYZTypaHqhVo0X2H77/VkPlxNP6i3kRqIMlsfrPH6Se0rRpTkeqJn+pZGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794560256;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hSdT8KKQ2IK2qOjdLYrZE5NeN7KUFYUnZ3mxXy29cRE=;
	b=onA3Y0eyBQCNI/p5F9tlaBO9nopRM5U30w/MunHJS0M2hjx1A6si59DWIQ10aiUry8PR
	 mexYyRTBsSQK0gh8xCQnqAtP2g1GvGI1SCTbjZaaDck+HrT5oeBg7FZsU/2Rg0VpfWS00
	 DSE2wywdHVFC6vsfxsYkxX55Cdctm+l5Gy2ENBkoPnJ87g7oyCvUX0PJi54ffCQeC5958
	 ISir6rsiYCCvngqfm7BleBvx7Sc+Rl2j8mH3A65K95C7ul2Afn6reVEV4ZYLQ/PS5m+QI
	 1GowBI/UPeQ7MiEb1VCUEU2irlDs8jqiEbdKzPoAViaUqgEFAWtgDKS2wBwbcOWO+wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mZX7K+xw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DC1606A333
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 08:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mZX7K+xw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633BE1F000C5;
	Fri, 13 Nov 2026 08:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794560256;
	bh=hSdT8KKQ2IK2qOjdLYrZE5NeN7KUFYUnZ3mxXy29cRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mZX7K+xwQ/U5zx/hqoMFy/knayA4ALIH9/GoOnfSMrCmBW+RMXTawOfd2cpmDllJS
	 EEeKerHVzjxQVF3UAn02IAHrWfv1QzXJNKOy5BQp+YC63mA+jXMJmz4wXSR6Q18wYg
	 jMOZ/sdTDDM+xBuKndTv5LwDPQHRQnXGkE/X4MSwc4tt8BjXo9Bna0due0ysvXMjnp
	 HwsEPwBz8z3RBtM4uxR/T8B9wO0agUeJGCnFAVtPB0Dl/NC+9g0JH7xK/deaS54Lly
	 rX3nTVm16egMfG7Ycw+NeQt99YXvXpbAkpOpxbycQ/WZp+O8LJVFrhx8E9mC9eR+aF
	 9wnl9dl7ztCzw==
Message-ID: <sashiko-outbox-212485@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/3] RDMA/srpt: Prevent uninitialized read buffer
 disclosure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yong Liu" <pkfxxxing@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261113083848.1517595-4-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
 <20261110030809.913063-2-pkfxxxing@gmail.com>
 <20261110052827.963143-1-pkfxxxing@gmail.com>
 <20261111065342.1282709-1-pkfxxxing@gmail.com>
 <20261112094138.1390409-1-pkfxxxing@gmail.com>
 <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
 <20261113083848.1517595-4-pkfxxxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 08:57:36 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> SRPT allocates read buffers and creates RDMA contexts from the initiator's
> descriptors before parsing the CDB. When target core shortens
> cmd->data_length, a backend such as rd_mcp fills only the shorter length,
> but the prebuilt RDMA transfer still sends the full buffer. This can
> disclose stale target kernel memory to a remote initiator with access to
> the LUN.
>=20
> Reject indirect descriptor tables whose direct descriptor lengths do not
> sum to the advertised total, and log the mismatch before allocating RDMA
> contexts. Save the original buffer length and zero the tail beyond
> cmd->data_length through the chained command scatterlist before posting
> RDMA transfers. This applies to both data and control READ commands.
>=20
> The issue was discovered by Qihoo 360's Tulongfeng multi-agent system.
>=20
> Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API=
")
> Cc: stable@vger.kernel.org
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Yong Liu <pkfxxxing@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113083848.1517=
595-1-pkfxxxing@gmail.com?part=3D3

