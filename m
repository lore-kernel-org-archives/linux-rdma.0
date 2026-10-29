Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793248544;
	b=5JgHAeS0gn8A5uejUJ47zOLA6fo1ycOay8nS2ij7AvqNi2AtRtj5uAJULHnxp6eD+S2J
	 6/aSnlrzzzcOK06oVvEtiAVq/MPKl+cNGcTEdsO1S0CuLocooilwPGAKvpQ0aiWVHbH04
	 DU3h0/Js0e6+zoHlHPuQG9iho0ZM//RJx45tkBfm9KhLkwHqgyVnLex7+Edrtk9fpKUFU
	 tLewPw+BzQ8tVN7F5Akz+eEUxa8bm1pfhl1L1F4iaZntws3eP1kCoxZfvLfS6z9XB/R+Z
	 Z3ZRwWGtgrqrXHTIss/fRV4lWsrmij8N3VUABUSGWOqTICJxbHIV+lGUbBEk8GqVx4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793248544;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rPfbq1TiAQLFj8h/W1Iup/PEYxyOKhXLMiS3vxWLmVQ=;
	b=44WGSibX+PSF1Kdh7fUlDkLknsGXypFg9gqiFo3gvqwB1KWaFqcd9eG7lwhFj9DUBjhn
	 tJwThxQ2mQk9fwLctYul6L8jjMRkhRJhnJFYhMtl2nFcFs+ggVTH9QXp9OUNOW4/EuQIj
	 cu2AZYgRKsI8+4fDGTxWN9oYaML0giMkSFPmr4Tt7D0sMn3LmXWdWgJDquFfSyjPzbM57
	 mdjuyPTailLLxIM5A6IYrHo4tXQnrekacAWvE7iTBNHW51+DRLfj3ZaaEl14EynbYxOwr
	 Ce6Vr2KJHRbAxZpehyKVhsfcvXFQyUtfhh2QjWosuXrIJCGp4h4cm3Kerk/WthnLmZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HM9ObIFk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EF9606A31A
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 04:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HM9ObIFk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B91C1F01825;
	Thu, 29 Oct 2026 04:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793248543;
	bh=rPfbq1TiAQLFj8h/W1Iup/PEYxyOKhXLMiS3vxWLmVQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HM9ObIFkl1JkVbr6EtMOtNQzcL+Os0kPKncDUs0ZeVZ1V1erLp5fecZDjBP1rte/F
	 8DXczF3ioq+hmDBjVUPA3h3Mm5WGe16ht1hvJCV4/Py8nxzmYo4wtQN1D3EzhHd2L4
	 sXC0BOue//s1Rjk/CMEBcC407/9kluiXq4WvwwtCe/XBjtHbsW0boVLt0bn1pMVJ+V
	 0k/wbdrsOSr3m8X1RcU3rgk1yx7eElys8IazNrPO4ZAcFVQU1RkbSW0kQBTrVaD2/H
	 +zUmZNOiGlrSURZI1YAh+tFCOVh5FU2GZkKmk8K0WEFUQL/5Gf14hx5fGeoeIGugMs
	 /t857qs++Fe1w==
Message-ID: <sashiko-outbox-188704@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] RDMA/rtrs-srv: Do not free the path on path file
 creation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuqiang Sun" <izaiahsun@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261029042719.75868-2-izaiahsun@gmail.com>
References: <20261029042719.75868-1-izaiahsun@gmail.com>
 <20261029042719.75868-2-izaiahsun@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 04:35:42 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When rtrs_srv_create_path_files() fails after kobject_init_and_add() of
> srv_path->kobj, its error path ends with kobject_put(&srv_path->kobj),
> and the release, rtrs_srv_release(), frees srv_path.  The caller does
> not expect that: process_info_req() goes on to free its tx IU through
> srv_path->s.dev, and rtrs_srv_info_req_done() then closes the path,
> whose close work tears down the connections, puts the session and
> finally frees srv_path again in free_path().
>=20
> Commit 5b7437339011 ("RDMA/rtrs: Fix use-after-free in path file
> creation cleanup") reordered the cleanup inside
> rtrs_srv_create_path_files() so that the helper runs before the put, but
> the final put still frees srv_path under the caller.  The same pattern
> exists one level down: rtrs_srv_create_stats_files() puts
> srv_path->stats->kobj_stats on failure, whose release frees
> srv_path->stats, which free_path() frees again.
> [ ... ]
>=20
> Fixes: 424774c9f3fa ("RDMA/rtrs: Call kobject_put in the failure path")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5-5 kbound
> Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029042719.7586=
8-1-izaiahsun@gmail.com?part=3D1

