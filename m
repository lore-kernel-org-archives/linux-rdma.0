Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794884508;
	b=osqkIlXP9Erm1ZuipdSnXAt1+9oPTFReSheKlQ/d/I2qH6tWjDNoZXjPSxQwt2urb68+
	 WhS2XMtmz2Bsuho7S5wgoWFVYWDGfqkzn+8Vbxf1HbJ1MtdtBNdhelTj7tvvSNCCX9bFp
	 f2Us52e4jLhQ9UvcZmlFVEr76CzW6/pDiZyggyXL3WTcJrz/b6VItTeL/rEDQ2r36fDwX
	 gk5UxS9LYt7+pBpqSUt5q39W8mlcDOFbhHEAjYthCsXF2VxdK0mMzTO/cOQrvdGosiYQ2
	 3p8AHNrktaCCPqPfc3CwlqSIOz7rJVcIsi4gEme14CUNPrIcpADVZFe/0Z+06w1GINQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794884508;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jXAykFlTjw10HuvOwMLw3fL0YkHKBn5qyBXPqoe3tLQ=;
	b=B37GUAMqzovXT4WhPE0OuB4Lx9Y5tLfEdL6IZ5PWGawYMjH817LvnIUbaORTZ1sxqDtf
	 eGKcDochxO/ZaCsFctArsyAK+SpHD2I4BqFxqQA4Pl+LKdVLI1THlNFutdSyjaE8Ore9X
	 53YWGUhVT9S09jWcB4Y/V0HOD38l4o3xRoWKl6G4kkqkvdC0wt2u09mDV5jNUPNoC8fKg
	 CKs8A+ZHCPalYmlQonSQIJ4XHLXps5nkOcppEX2YxDwmiKn98O5E+w7stke9yLmIGD3hJ
	 VuHAozqbqE7fU1vsESAFUeMJdKcch+5j15VyepYyZO+zwGJddS6LbV5fMw4eFGdPfUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BqGQdNbN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C3C606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 03:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BqGQdNbN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F051F000C4;
	Tue, 17 Nov 2026 03:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794884507;
	bh=jXAykFlTjw10HuvOwMLw3fL0YkHKBn5qyBXPqoe3tLQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BqGQdNbNNbsuf/IsSEbE7S5Q7B6GxYtQM+VLpEpEi9yFw6Tt0MMt6ePGH55Co1pku
	 TaiB1VDOAbFbuLfa0me5aXqPz3I86vuWvMwR5QXMUOUoL968jzbzoY/9sb+7gBZjd9
	 Vzj9KxuGSW6xEyhXyLJiZIMwBzYRu5E4FJQisClCT9rz3BOCRuIgGzV+MFdBrtgUKH
	 lzIPzaDOpZ4lf/NyTzl/7LSTROepV51y0p5TByyJ8br6dWTpw4uwBnZi9pio+37ox2
	 lqwsQcvVhqRaIhh0ZVrXz3QAKCAcKsHDUdVZcxaL93gPBGeUr8tk2lIzcHacxNzYEc
	 VhiJZicGlRvpQ==
Message-ID: <sashiko-outbox-218110@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6.y] RDMA/erdma: Use IRQ-safe XArray helpers for QP
 and CQ tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cheng Xu" <chengyou@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117022839.23186-1-chengyou@linux.alibaba.com>
References: <20261117022839.23186-1-chengyou@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 03:01:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> [ Upstream commit 00baeade709fb66da647e8327e8398bb532e30f7 ]
>=20
> Locked QP and CQ lookups from EQ interrupts can deadlock with
> create-path XArray updates. If an interrupt arrives while the create
> path holds the plain xa_lock, the lookup spins forever trying to
> acquire the same lock.
>=20
> Use IRQ-safe XArray helpers for all QP and CQ create-path updates,
> including the GSI QP store and error paths. Initialize both arrays with
> XA_FLAGS_LOCK_IRQ so sleeping allocations preserve interrupt state.
>=20
> [ The GSI QP create path is not present in 6.6.y, so omit that hunk. ]
>=20
> Fixes: 98df2aee1459 ("RDMA/erdma: Hold CQ references when processing EQ e=
vents")
> Fixes: a52eeff32024 ("RDMA/erdma: Hold QP references for AE and CM proces=
sing")
> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>
> Link: https://patch.msgid.link/20260828030344.88021-1-chengyou@linux.alib=
aba.com
> Signed-off-by: Leon Romanovsky <leon@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117022839.2318=
6-1-chengyou@linux.alibaba.com?part=3D1

