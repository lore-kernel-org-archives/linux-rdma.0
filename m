Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793902187;
	b=KEU3JbmQECdusr6oPw6O8NaZysN1SEYscQ4pJGQXsO7T2LLO+wxzIPDfWn29Pt0oVFde
	 w9WoM9Tiwq/r7xFeV/fHiGPqfk+NKZMmSc8UfzTx3SO16aU6oUqZJ9ZfDCxb02nQZNHFz
	 fShHMgVXl9TjCigD8Ft2+zd5Q5KNYKwzh9FL/UgRbBbAaM76Xj6BtqlrxwSftHJvITpGQ
	 IEubolD9p3lLkXY7gnAXy4UGqqvjuhJX9XELKLrv5/FCRNkJYym4zgnzNpgumhjbAYF7m
	 Ic0aAuoDltQGtbNqCGytUuaDUqshDXFk/c+XwzNwZviXrWbk8pDAMnp+jlvQt0SBIhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902187;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gXkEqn8xq6wexbDZGfAq0XrvqICSMsa+eeDHqXpJoRc=;
	b=USQCI9EowMpomjMagJKhfksB9Lr/aMegFq6xHbicoOf4xKr0LmTjCP/S3AFBWW7/MR9N
	 Vdbpa2tHsyCDu805reds1RdVcbz6RrLKWjYo0Fg1wdymggBlue13J5vq+L8nStFrwahzD
	 NWHX2tXjniikqPNwJevBM9x8lyKQZ0oumQHT/wy2wpfBlrjs2fuK3X3rrgrQoN4vug4Lx
	 VdTuML0VulWT2rsTLsZITeshNvgl+QG+Ojd/81NoVTWEmymivK1mKDcWDhRaZfT320xJs
	 U1DcqLaLLnUDKd9W0keo9s3EMFgZPCZjOJeDiSmipOjPgYXIDBFUDQ5fbSb0Dy+3fiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GWXRUEbh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7415606D80E
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 18:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GWXRUEbh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587921F01802;
	Thu,  5 Nov 2026 18:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902186;
	bh=gXkEqn8xq6wexbDZGfAq0XrvqICSMsa+eeDHqXpJoRc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GWXRUEbhvVGybmNjeCMY1aKu0ui3h37pLtzZBBwNomevOkTAu/A/0bHid7Eoocug2
	 bj+hu9J1T3/Q+UvdsI+g/+7ueCDVBqqg2ykaM+MtKg+Y4TeuVmGz+cHMM/SDYPx7Aj
	 lr+Wv1cwe79FBEUXYUu2hgw5dA5FRYqMbloKNIEzMMKNv8qbq4f57nf+pTZsahbgOP
	 THfET7DgSSsFeDfsoCc2+0HTKEhcVuPk6BQ3MJ8DRosb+lfzeUDHh2wwX4K2aVdA4c
	 ztRxElH7qC7L4+deRxVz4INH2T0XsaIAcvQFnMWt7pnrUHzpGbU3WPhZiNmMGURfAz
	 VLfAGp/TK2KCw==
Message-ID: <sashiko-outbox-199698@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v9 4/9] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105175928.1326682-5-kotaranov@linux.microsoft.com>
References: <20261105175928.1326682-1-kotaranov@linux.microsoft.com>
 <20261105175928.1326682-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:09:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Update mana_ib_modify_qp_state() to support RC QPs. Initialize the
> packet, message, and frame counters for use by work requests.
>=20
> Arm the requester receive queue at the initial PSN so that a CQE is
> generated when the specified PSN is acknowledged, indicating send
> completions.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105175928.1326=
682-1-kotaranov@linux.microsoft.com?part=3D4

